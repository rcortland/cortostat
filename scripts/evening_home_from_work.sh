#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 72, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 68, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 68, \"mode\": \"heat\", \"id\": $tstat_hall } 
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_guest_bath } 
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_dining } 
 { \"temp\": 55, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 55, \"mode\": \"heat\", \"id\": $tstat_master_closet } "

set_thermostats "$setpoints"
