#!/bin/sh
if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 adminusername server"
  exit 1
fi
ssh $1@$2  free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'  && \
  df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
ssh $1@$2  top -bn1| grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'


