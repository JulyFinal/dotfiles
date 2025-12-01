#!/bin/sh
#more trackers list, see https://github.com/ngosang/trackerslist# 
# 
# aria2c --conf-path=./aria2.conf

tracker_url='https://cf.trackerslist.com/best_aria2.txt'
path='http://localhost:6800/jsonrpc'
passwd='finalserver'

tracker=$(curl -s -L $tracker_url)


[ -n "$tracker" ] && curl $path -d '{"jsonrpc":"2.0","method":"aria2.changeGlobalOption","id":"cron","params":["token:'$passwd'",{"bt-tracker":"'$tracker'"}]}'
