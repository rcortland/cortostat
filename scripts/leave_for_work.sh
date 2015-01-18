#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_hall } "

set_thermostats "$setpoints"
