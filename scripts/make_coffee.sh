#!/bin/bash

# You can specify how long to leave the coffee pot on in the first
# parameter.  If that's empty, default to 1 1/2 hours.
duration='90m'
if [ $# -ge 1 ]; then
    duration="$1"
fi

if [ -f /home/cort/make_coffee ] ; then
    rm /home/cort/make_coffee
    /home/cort/cortostat/set_switch.sh 14 on
    sleep "$duration"
    /home/cort/cortostat/set_switch.sh 14 off
fi
