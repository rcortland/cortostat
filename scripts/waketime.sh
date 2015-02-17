#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 74, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 74, \"mode\": \"heat\", \"id\": $tstat_master_closet } 
 { \"temp\": 72, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 72, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 72, \"mode\": \"heat\", \"id\": $tstat_hall } 
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_dining } 
 { \"temp\": 65, \"mode\": \"heat\", \"id\": $tstat_parlor } 
 { \"temp\": 60, \"mode\": \"heat\", \"id\": $tstat_office } 
 { \"temp\": 45, \"mode\": \"heat\", \"id\": $tstat_guest_bath } "

set_thermostats "$setpoints"
