#!/bin/bash

# Data structure defining attributes we can retrieve for a thermostat.
device_attributes["General Thermostat V2"]='{
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
    "attribute": "cool_setpoint",
    "instance_id": 0,
    "data_id": 2,
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

function map_thermostat_values()
{
    # Convert raw values to formatted values.
    if [[ ! -z ${value_map[heat_setpoint]} ]]; then
        #value_map[heat_setpoint]=`celsius_to_fahrenheit ${value_map[heat_setpoint]}`
        value_map[heat_setpoint]=${value_map[heat_setpoint]}
    fi

    if [[ ! -z ${value_map[cool_setpoint]} ]]; then
        #value_map[cool_setpoint]=`celsius_to_fahrenheit ${value_map[cool_setpoint]}`
        value_map[cool_setpoint]=${value_map[cool_setpoint]}
    fi

    if [[ ! -z ${value_map[temperature]} ]]; then
        #value_map[temperature]=`celsius_to_fahrenheit ${value_map[temperature]}`
        value_map[temperature]=${value_map[temperature]}
    fi

    if [[ ! -z ${value_map[mode]} ]]; then
        value_map[mode]="\"${mode_map[${value_map[mode]}]}\""
    fi

    if [[ ! -z ${value_map[status]} ]]; then
        value_map[status]="\"${status_map[${value_map[status]}]}\""
    fi
}
