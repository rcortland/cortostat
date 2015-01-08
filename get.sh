#!/bin/bash

source inc/cortostat_config.sh
source inc/cortostat_get_url.sh
source inc/cortostat_conversions.sh

# Data structure defining attributes we can retrieve for a thermostat.
attributes_cfg='{
    "attribute": "temperature",
    "instance_id": 1,
    "data_id": 1,
    "command_class": 49,
    "value_name": "val"
}
{
    "attribute": "humidity",
    "instance_id": 2,
    "data_id": 5,
    "command_class": 49,
    "value_name": "val"
}
{
    "attribute": "mode",
    "instance_id": 0,
    "data_id": "",
    "command_class": 64,
    "value_name": "mode"
}
{
    "attribute": "heat_setpoint",
    "instance_id": 0,
    "data_id": 1,
    "command_class": 67,
    "value_name": "val"
}
{
    "attribute": "status",
    "instance_id": 0,
    "data_id": "",
    "command_class": 66,
    "value_name": "state"
}'

# Map from raw mode result to human-readable mode result.
declare -A mode_map
mode_map[0]="off"
mode_map[1]="heat"
mode_map[2]="cool"
mode_map[3]="auto"

# Map from raw status result to human-readable status result.
declare -A status_map
status_map[0]="off"
status_map[1]="on"

usage()
{
    echo "Usage: $0 <id> [attribute-list]"
    echo
    echo "Retrieve the status of a thermostat specified by id <id>.  The attribute list "
    echo "may contain any of the following (if no attributes are specified, all are"
    echo "retrieved):"
    echo
    for attr in `echo $attributes_cfg | jq -r .attribute`; do
        echo "     $attr"
    done
    echo
    exit 1
}

# Tell Z-Way to request a new value from the thermostat.
refresh_value()
{
    instance_id=$1
    command_class=$2

    get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${tstat_id}].instances[${instance_id}].commandClasses[$command_class].Get()"  > /dev/null
}

# Request a value from Z-Way.
fetch_sensor_value()
{
    instance_id=$1
    data_id=$2
    command_class=$3
    value_name=$4

    # Some values are in an area index under the data member, some are directly under the data member.
    if [[ $data_id == '""' ]]; then
        data_segment="data"
    else
        data_segment="data[${data_id}]"
    fi

    get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${tstat_id}].instances[${instance_id}].commandClasses[${command_class}].${data_segment}.${value_name}.value"
}

# Verify parameter count.
if [[ $# -lt 1 ]]; then
    usage
fi

# Verify thermostat_list.json exists.
if [[ ! -f thermostat_list.json ]]; then
    echo "Error: thermostat_list.json cannot be found.  Have you run identify.sh?"
    echo
    usage
fi

tstat_id=$1
declare -A value_map

# All valid attributes:
all_attributes=`echo $attributes_cfg | jq -r .attribute`

# Put all the attributes in the list to retrieve if none are specified on the command line
if [[ $# -eq 1 ]]; then
    attributes=$all_attributes
else
    # Ignore the first argument (tstat ID)
    shift

    # Iterate through all remaining arguments.
    for attr in $@; do
        # If argument is not in the attribute list, error and die.
        if ! echo $attr | grep "$all_attributes" &> /dev/null; then
            echo Error: $attr is not a valid attribute.
            echo
            usage
        fi
        
        # Build list of specified attributes.
        attributes="$attributes $attr" 
    done
fi

# Iterate through sensors on the thermostat
for attribute in $attributes
do
    set `echo $attributes_cfg | jq  ". | select(.attribute == \"$attribute\") | .instance_id, .data_id, .command_class, .value_name"`
    instance_id=$1
    data_id=$2
    command_class=$3
    value_name=`echo $4 | sed s%\"%%g`

    refresh_value $instance_id $command_class
    value_map[$attribute]=`fetch_sensor_value $instance_id $data_id $command_class $value_name`

done

# Convert raw values to formatted values.
if [[ ! -z ${value_map[heat_setpoint]} ]]; then
    value_map[heat_setpoint]=`celsius_to_fahrenheit ${value_map[heat_setpoint]}`
fi

if [[ ! -z ${value_map[temperature]} ]]; then
    value_map[temperature]=`celsius_to_fahrenheit ${value_map[temperature]}`
fi

if [[ ! -z ${value_map[mode]} ]]; then
    value_map[mode]="\"${mode_map[${value_map[mode]}]}\""
fi

if [[ ! -z ${value_map[status]} ]]; then
    value_map[status]="\"${status_map[${value_map[status]}]}\""
fi


# Build results JSON.
tstat_name=`cat thermostat_list.json | jq "select(.id == $tstat_id) | .name"`
result="{ \"id\": $tstat_id, \"name\": $tstat_name "
for attribute in $attributes
do
    result="${result}, \"$attribute\": ${value_map[${attribute}]}"
done
result="${result} }"

echo $result  | jq
