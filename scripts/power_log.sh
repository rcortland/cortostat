#!/bin/bash

LOG_BASE=/home/cort/power_logs

YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOUR=`date +%H`

LOG_DIR=$LOG_BASE/$YEAR/$MONTH/$DAY
LOG_FILE=$LOG_DIR/$HOUR

mkdir -p $LOG_DIR
/home/cort/cortostat/get.sh 5 >> $LOG_FILE
