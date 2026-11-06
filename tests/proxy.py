#!/usr/bin/env python3
"""Exercise both isolated proxy profiles without subscriptions or downloads."""

import json
import os
from pathlib import Path
import shutil
import signal
import socket
import subprocess
import sys
import tempfile
import time

REPO = Path(__file__).resolve().parent.parent
PORTS = {'dproxy': 10818, 'nproxy': 10809}
PROXY_KEYS = ('HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'http_proxy', 'https_proxy', 'all_proxy')


def wait_until(check):
    deadline = time.monotonic() + 6
    while time.monotonic() < deadline:
        if check():
            return
        time.sleep(0.05)
    raise AssertionError('proxy did not become ready or clean up within six seconds')


def main():
    for port in PORTS.values():
        with socket.socket() as probe:
            try:
                probe.bind(('127.0.0.1', port))
            except OSError:
                print(f'proxy lifecycle checks skipped ({port} already in use)')
                return
    with tempfile.TemporaryDirectory(prefix='proxy-check-') as tmp:
        home = Path(tmp)
        (home / '.local/bin').mkdir(parents=True)
        (home / '.local/libexec').mkdir()
        (home / '.local/libexec/shell-proxy').symlink_to(REPO / 'home/local/libexec/shell-proxy')
        for profile in PORTS:
            config = home / '.config' / profile
            config.mkdir(parents=True)
            (config / 'config.yaml').symlink_to(REPO / 'home/config' / profile / 'config.yaml')
            (home / '.local/bin' / profile).symlink_to(REPO / 'home/local/bin' / profile)
        # A fresh private cache avoids network access in the lifecycle tests.
        (home / '.config/nproxy/subscription.url').write_text('https://example.invalid/sub\n')
        cache = home / '.local/state/nproxy/data'
        cache.mkdir(parents=True)
        (cache / 'subscription.yaml').write_text(json.dumps({'proxies': [{'name': 'fixture', 'type': 'http', 'server': '192.0.2.1', 'port': 9}]}))
        fake = home / '.local/bin/mihomo'
        fake.write_text(f'''#!{sys.executable}
import http.server, json, os, re, socket, socketserver, sys, threading
from pathlib import Path
if '-t' in sys.argv:
    sys.exit(0)
config = Path(sys.argv[sys.argv.index('-f')+1])
if config.suffix == '.json':
    effective = json.loads(config.read_text())
    port = effective['mixed-port']
else:
    port = int(re.search(r'^mixed-port: (\\d+)', config.read_text(), re.M).group(1))
profile = 'nproxy' if port == 10809 else 'dproxy'
Path(os.environ['HOME'], profile+'-child-env.json').write_text(json.dumps(dict(os.environ)))
if '-ext-ctl-unix' in sys.argv:
    api = Path(sys.argv[sys.argv.index('-ext-ctl-unix')+1])
    api.unlink(missing_ok=True)
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            node = effective['proxy-groups'][0]['proxies'][0]
            test_url = effective['proxy-groups'][0]['url']
            info = {{'history': [{{'delay': 1}}], 'extra': {{test_url: {{'alive': True}}}}}}
            if '/delay?' in self.path:
                value = {{'delay': 1}}
            elif self.path == '/proxies':
                value = {{'proxies': {{'NPROXY': {{'all': [node], 'now': node}}, node: info}}}}
            else:
                value = info
            data = json.dumps(value).encode()
            self.send_response(200)
            self.send_header('Content-Length', str(len(data)))
            self.end_headers()
            self.wfile.write(data)
        def do_PUT(self):
            self.rfile.read(int(self.headers.get('Content-Length', '0')))
            self.send_response(204)
            self.end_headers()
        def log_message(self, *args): pass
    api_server = socketserver.UnixStreamServer(str(api), Handler)
    threading.Thread(target=api_server.serve_forever, daemon=True).start()
with socket.socket() as server:
    server.bind(('127.0.0.1', port))
    server.listen()
    print(f'Mixed(http+socks) proxy listening at: 127.0.0.1:{{port}}', flush=True)
    while True:
        connection, _ = server.accept()
        connection.close()
''')
        fake.chmod(0o755)
        fake_curl = home / '.local/bin/curl'
        fake_curl.write_text('#!/bin/sh\nprintf \'200 0.001\\n\'\n')
        fake_curl.chmod(0o755)
        env = {**os.environ, 'HOME': str(home), 'PATH': str(fake.parent) + os.pathsep + os.environ['PATH']}
        env.update({key: 'socks5h://127.0.0.1:10808' for key in PROXY_KEYS})

        def control(profile):
            return home / '.local/state' / profile / 'control.sock'

        def run(profile, op, owner=None, expected=0):
            args = [str(home / '.local/bin' / profile), op]
            if owner is not None:
                args.append(str(owner))
            p = subprocess.run(args, env=env, capture_output=True, text=True, timeout=20)
            assert p.returncode == expected, (profile, op, p.stderr)
            return p.stdout

        owner = os.getpid()
        children = []
        try:
            for profile, port in PORTS.items():
                with socket.socket() as occupied:
                    occupied.bind(('127.0.0.1', port))
                    occupied.listen()
                    run(profile, 'start', owner, expected=1)
                    assert occupied.getsockname()[1] == port
                run(profile, 'start', owner)
                initial = json.loads(run(profile, 'status'))
                assert initial['owners'] == 1
                run(profile, 'start', owner)
                assert json.loads(run(profile, 'status')) == initial
                child_env = json.loads((home / (profile+'-child-env.json')).read_text())
                assert not any(key in child_env for key in PROXY_KEYS)
                second = subprocess.Popen([sys.executable, '-c', 'import time;time.sleep(30)'], start_new_session=True)
                children.append(second)
                run(profile, 'start', second.pid)
                assert json.loads(run(profile, 'status')) == {'pid': initial['pid'], 'owners': 2}
                run(profile, 'stop', owner)
                assert json.loads(run(profile, 'status')) == {'pid': initial['pid'], 'owners': 1}
                second.terminate()
                second.wait()
                wait_until(lambda: not control(profile).exists())
                print(f'{profile}: occupied port, idempotent start, clean environment and multiple owners passed')

            for shell in ('bash', 'zsh'):
                if not shutil.which(shell):
                    continue
                code = '''set -e
. "$TEST_ALIASES"
dproxy >/dev/null
test "$HTTP_PROXY" = socks5h://127.0.0.1:10818
# Failed activation must preserve the current profile and variables.
mv "$HOME/.config/nproxy/subscription.url" "$HOME/.config/nproxy/source.saved"
if nproxy >/dev/null 2>&1; then exit 1; fi
test "$HTTP_PROXY" = socks5h://127.0.0.1:10818
mv "$HOME/.config/nproxy/source.saved" "$HOME/.config/nproxy/subscription.url"
nproxy >/dev/null
test "$HTTP_PROXY" = socks5h://127.0.0.1:10809
test "$HTTPS_PROXY" = "$HTTP_PROXY"
test "$ALL_PROXY" = "$HTTP_PROXY"
test "$http_proxy" = "$HTTP_PROXY"
test "$https_proxy" = "$HTTP_PROXY"
test "$all_proxy" = "$HTTP_PROXY"
dproxy >/dev/null
test "$HTTP_PROXY" = socks5h://127.0.0.1:10818
eproxy >/dev/null
test "$HTTP_PROXY" = socks5h://127.0.0.1:10808
nproxy >/dev/null
unproxy >/dev/null
test "${HTTP_PROXY+x}${HTTPS_PROXY+x}${ALL_PROXY+x}${http_proxy+x}${https_proxy+x}${all_proxy+x}" = ''
'''
                p = subprocess.run([shell, '-c', code], env={**env, 'TEST_ALIASES': str(REPO / 'home/config/shell/aliases.sh')}, capture_output=True, text=True, timeout=40)
                assert p.returncode == 0, (shell, p.stdout, p.stderr)
                for profile in PORTS:
                    wait_until(lambda: not control(profile).exists())
                    p = subprocess.Popen([shell, '-c', '. "$TEST_ALIASES"; '+profile+' >/dev/null; sleep 30'],
                                         env={**env, 'TEST_ALIASES': str(REPO / 'home/config/shell/aliases.sh')}, start_new_session=True)
                    children.append(p)
                    wait_until(lambda: control(profile).exists())
                    os.killpg(p.pid, signal.SIGTERM)
                    p.wait(timeout=5)
                    wait_until(lambda: not control(profile).exists())
                print(f'proxy: {shell} switching, failed startup rollback, unproxy and shell termination passed')
        finally:
            for process in children:
                if process.poll() is None:
                    os.killpg(process.pid, signal.SIGTERM)
                    process.wait()
            for profile in PORTS:
                run(profile, 'stop', owner)


if __name__ == '__main__':
    main()
