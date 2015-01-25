#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_hall } 
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_master_closet } 
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_guest_bath } 
 { \"temp\": 40, \"mode\": \"heat\", \"id\": $tstat_dining } "

set_thermostats "$setpoints"
