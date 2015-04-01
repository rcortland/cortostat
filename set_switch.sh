#!/bin/bash

cd /home/cort/cortostat

source inc/cortostat_config.sh
source inc/cortostat_get_url.sh
source inc/cortostat_conversions.sh

usage()
{
    echo "Usage: $0 <id> <mode>"
    echo
    echo "Set the switch mode (on or off)."
    echo
    exit 1
}

# There may be one or two arguments, and the first must be a valid mode.  If the mode is off, there
# may be only one argument.
if [[ $# -lt 2 || $# -gt 3 || ($2 != "off" && $2 != "on" ) ]]; then
    usage
fi

switch_id=$1
mode=$2

declare -A mode_map
mode_map[on]='true'
mode_map[off]='false'

RET=0

# Set the mode.
get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${switch_id}].instances[0].commandClasses[37].Set(${mode_map[$mode]})" > /dev/null ; let "RET += $?"

exit $RET
