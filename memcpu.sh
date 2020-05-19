#!/bin/sh
if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 adminusername server"
  exit 1
fi
ssh $1@$2  free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'  && \
  df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
#LINE=`ssh $1@$2 cat /prod/net/dev`
#echo $LINE
##| grep $1 /proc/net/dev | sed s/.*://`;
#RECEIVED=`echo $LINE | awk '{print $1}'`
#TRANSMITTED=`echo $LINE | awk '{print $9}'`
#TOTAL=$(($RECEIVED+$TRANSMITTED))
#
#echo "Transmitted: `human_readable $TRANSMITTED`"
#echo "Received: `human_readable $RECEIVED`"
#echo "Total: `human_readable $TOTAL`"
ssh $1@$2  cat /proc/net/dev|grep eth0|sed s/.*://|awk '{printf "RECEIVED: (%.2f%%)MB TRANSMITTED: (%.2f%%)MB ", $1/(1024*1024),$10/(1024*1024)}'
#| awk 'NR==2{printf "RECEIVED: %sB   TRANSMITTED: %sB \n " :  $1, $9}'

#ssh $1@$2 << EOF
#LINE=`grep eth0 /proc/net/dev | sed s/.*://`;
#RECEIVED=`echo $LINE | awk '{print $1}'`
#TRANSMITTED=`echo $LINE | awk '{print $9}'`
#TOTAL=$(($RECEIVED+$TRANSMITTED))
#
#echo "Transmitted: `human_readable $TRANSMITTED`"
#echo "Received: `human_readable $RECEIVED`"
#echo "Total: `human_readable $TOTAL`"
#
#EOF
ssh $1@$2  top -bn1| grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'


