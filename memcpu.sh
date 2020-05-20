#!/bin/sh
if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 adminusername server"
  exit 1
fi
ssh $1@$2  free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'  && \
  df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'

ssh $1@$2  cat /proc/net/dev|grep eth0|sed s/.*://|awk '{printf "RECEIVED: (%.2f)MB \nTRANSMITTED: (%.2f)MB \n", $1/(1024*1024),$10/(1024*1024)}'

ssh $1@$2  top -bn1| grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'


