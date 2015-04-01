#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 68, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 68, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_hall } 
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_guest_bath } 
 { \"temp\": 62, \"mode\": \"heat\", \"id\": $tstat_dining } 
 { \"temp\": 62, \"mode\": \"heat\", \"id\": $tstat_parlor }
 { \"temp\": 55, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 45, \"mode\": \"heat\", \"id\": $tstat_fbr }
 { \"temp\": 73, \"mode\": \"heat\", \"id\": $tstat_office }
 { \"temp\": 55, \"mode\": \"heat\", \"id\": $tstat_master_closet } "

set_thermostats "$setpoints"
