#!/bin/sh
#more trackers list, see https://github.com/ngosang/trackerslist

tracker_url='https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt'
path='http://localhost:6800/jsonrpc'
passwd='finalserver'

tracker=$(echo -n  $(curl -s -L $tracker_url | sed 'N;s/\n//g') | tr ' ' ',')
[ -n "$tracker" ] && curl $path -d '{"jsonrpc":"2.0","method":"aria2.changeGlobalOption","id":"cron","params":["token:'$passwd'",{"bt-tracker":"'$tracker'"}]}'


aria2c --conf-path=./aria2.conf
