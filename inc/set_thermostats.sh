#!/bin/bash

CORTOSTAT_BASE=/home/cort/cortostat
MAX_TRIES=10

# Returns true if two given temperatures are the same (or nearly)
function temps_equal()
{
    local int_diff=`echo "($1 - $2)/1" | bc`
    if [[ $int_diff -lt 0 ]]; then
        int_diff=$(($int_diff * -1))
    fi
    
    [[ $int_diff -eq 0 ]]
}

function set_thermostats()
{
    local setpoints="$1"
    local saveIFS="$IFS"
    IFS=$'\n'

    # Try to set the thermostats up to $MAX_TRIES times before giving up.
    for i in `seq 1 10`
    do
        all_clear=1
        
        for val in $setpoints
        do
            set `echo $val | jq -r '.temp, .mode, .id'`
            local desired_temp=$1
            local desired_mode=$2
            local desired_id=$3

            device_name=`cat ${CORTOSTAT_BASE}/device_list.json | jq -r ". | select(.id == $desired_id) | .name"`

            # Get the current setpoint value
            case "$desired_mode" in
                cool)
                    set `${CORTOSTAT_BASE}/get.sh $desired_id | jq -r '.cool_setpoint, .mode'`
                    local set_temp=$1
                    local set_mode=$2
                    ;;
                heat)
                    set `${CORTOSTAT_BASE}/get.sh $desired_id | jq -r '.heat_setpoint, .mode'`
                    local set_temp=$1
                    local set_mode=$2
                    ;;
                off)
                    ;;
                *)
                    echo "Thermostat mode \"$desired_mode\" is not valid." >&2
            esac

            # Set the current setpoint value
            if [[ $set_mode != $desired_mode ]] || ! temps_equal $set_temp $desired_temp ; then
                echo "SETTING: \"$device_name\" (${desired_id}): $set_mode $set_temp => $desired_mode $desired_temp"
                all_clear=0
                ${CORTOSTAT_BASE}/set.sh $desired_id $desired_mode $desired_temp
            else
                echo "    SKIPPING: \"$device_name\" (${desired_id}): $set_mode $set_temp => $desired_mode $desired_temp"
            fi
        done

        if [[ $all_clear -eq 1 ]]; then
            break
        fi
    done

    IFS="$saveIFS"
}
