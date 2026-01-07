#!/bin/bash

# 创建必要的目录和文件
mkdir -p ~/.aria2
touch ~/.aria2/{aria2.log,aria2.session,cookies.txt,dht.dat}

# 使用完整的命令行参数启动 aria2c
# 基本下载设置: --dir(下载目录) --file-allocation(不预分配空间) -c(断点续传)
# 并发设置: --max-concurrent-downloads(最大同时下载数) --split(文件分割数)
#           --min-split-size(最小分割大小) --max-connection-per-server(单服务器最大连接数)
# 会话管理: --input-file(读取会话) --save-session(保存会话) --save-session-interval(保存间隔)
# 速度限制: --max-overall-upload-limit(总上传限制) --max-upload-limit(单任务上传限制)
# 网络设置: --connect-timeout(连接超时) --timeout(读取超时) --retry-wait(重试等待) --max-tries(最大重试)
# 性能优化: --disk-cache(磁盘缓存) --check-integrity(完整性检查)
# RPC设置: --enable-rpc --rpc-listen-port=6800 --rpc-secret=finalserver
# BT设置: --enable-dht --enable-dht6 --listen-port=51413 --seed-ratio=1.0 --seed-time=6000
# 日志: --log(日志文件) --log-level=notice -D(后台运行)

aria2c \
  --dir="${HOME}/download" \
  --file-allocation=falloc \
  --continue \
  --check-integrity=true \
  --max-concurrent-downloads=26 \
  --split=128 \
  --min-split-size=1M \
  --max-connection-per-server=16 \
  --input-file="${HOME}/.aria2/aria2.session" \
  --save-session="${HOME}/.aria2/aria2.session" \
  --save-session-interval=60 \
  --max-overall-download-limit=0 \
  --max-download-limit=0 \
  --max-overall-upload-limit=10M \
  --max-upload-limit=384K \
  --always-resume=true \
  --auto-file-renaming=true \
  --remove-control-file=true \
  --content-disposition-default-utf8=true \
  --parameterized-uri=true \
  --follow-metalink=true \
  --connect-timeout=60 \
  --timeout=600 \
  --retry-wait=30 \
  --max-tries=10 \
  --disk-cache=64M \
  --check-integrity=true \
  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0" \
  --enable-rpc=true \
  --rpc-allow-origin-all=true \
  --rpc-listen-all=true \
  --rpc-listen-port=6800 \
  --rpc-secret=finalserver \
  --rpc-save-upload-metadata=false \
  --http-accept-gzip=true \
  --http-no-cache=true \
  --bt-detach-seed-only=true \
  --bt-save-metadata=true \
  --bt-load-saved-metadata=true \
  --bt-enable-lpd=true \
  --bt-hash-check-seed=true \
  --bt-seed-unverified=true \
  --bt-max-peers=0 \
  --bt-request-peer-speed-limit=75K \
  --enable-dht=true \
  --enable-dht6=true \
  --dht-listen-port=6871-7009 \
  --dht-file-path="${HOME}/.aria2/dht.dat" \
  --enable-peer-exchange=true \
  --listen-port=51413 \
  --seed-ratio=1.0 \
  --seed-time=6000 \
  --peer-agent="qBittorrent v4.6.5" \
  --peer-id-prefix="-qB4650-" \
  --bt-tracker-interval=120 \
  --log="${HOME}/.aria2/aria2.log" \
  --log-level=notice \
  -D

# 启动 RPC 跟踪脚本
bash ./rpc_track.sh
