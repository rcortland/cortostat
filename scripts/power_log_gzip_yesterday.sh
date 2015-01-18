#!/bin/bash

LOG_BASE=/home/cort/power_logs

YEAR=`date --date=yesterday +%Y`
MONTH=`date --date=yesterday +%m`
DAY=`date --date=yesterday +%d`
HOUR=`date --date=yesterday +%H`

LOG_DIR=$LOG_BASE/$YEAR/$MONTH/$DAY

gzip $LOG_DIR/*
