#!/bin/bash

cd /home/cort/cortostat

source inc/cortostat_config.sh
source inc/cortostat_get_url.sh
source inc/cortostat_conversions.sh

usage()
{
    echo "Usage: $0 <id> <mode> [<temperature>]"
    echo
    echo "Set the thermostat mode and, optionally, the desired temperature for the Z-Wave"
    echo "thermostat with ID <id>. The mode may be one of: heat, cool, or off.  For modes "
    echo "other than off, the temperature is specified in degrees fahrenheit."
    echo
    exit 1
}

# There may be one or two arguments, and the first must be a valid mode.  If the mode is off, there
# may be only one argument.
if [[ $# -lt 2 || $# -gt 3 || ($2 != "cool" && $2 != "heat" && $2 != "off" ) || ($2 == "off" && $# -gt 2) ]]; then
    usage
fi

tstat_id=$1
mode=$2

declare -A mode_map
mode_map[off]=0
mode_map[heat]=1
mode_map[cool]=2

RET=0

# Set the mode.
get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${tstat_id}].instances[0].commandClasses[64].Set(${mode_map[$mode]})" > /dev/null ; let "RET += $?"

# Z-Way needs few hundred usec here.
sleep 2s

# Set the temp.
if [[ mode != "off" ]]; then
    #temp=`fahrenheit_to_celsius $3`
    #temp=`echo "(${temp}+0.5)/1" | bc`
    temp=$3
    #echo get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${tstat_id}].instances[0].commandClasses[67].Set(${mode_map[$mode]},%20$temp)"
    get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${tstat_id}].instances[0].commandClasses[67].Set(${mode_map[$mode]},%20$temp)" > /dev/null ; let "RET += $?"
fi

exit $RET
