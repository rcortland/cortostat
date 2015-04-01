#!/bin/bash

source /home/cort/cortostat/inc/set_thermostats.sh
source /home/cort/cortostat/scripts/aliases.sh

# These must be newline-delimited JSON values
setpoints=\
"{ \"temp\": 63, \"mode\": \"heat\", \"id\": $tstat_mbr }
 { \"temp\": 63, \"mode\": \"heat\", \"id\": $tstat_master_closet } 
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_den }
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_kitchen }
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_hall } 
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_guest_bath } 
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_office } 
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_parlor } 
 { \"temp\": 45, \"mode\": \"heat\", \"id\": $tstat_fbr } 
 { \"temp\": 50, \"mode\": \"heat\", \"id\": $tstat_dining } "

set_thermostats "$setpoints"
