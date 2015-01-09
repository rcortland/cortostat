#!/bin/bash

cd ~/cortostat

source inc/cortostat_config.sh          # IP address of server.
source inc/cortostat_get_url.sh         # Method for retrieving HTTP URLs.
source inc/cortostat_conversions.sh     # Fahrenheit <-> Celsius conversions.

# Structure defining where device data is in Z-Way's JSON response.
declare -A device_attributes;

source inc/thermostat_attributes.sh     # CT100 thermostat attributes.
source inc/power_meter_attributes.sh    # Aeotec Home Energy Monitor attributes.

# Show how to use the script and exit with an error.
usage()
{
    echo "Usage: $0 <id> [attribute-list]"
    echo "Usage: $0 <id> show-atributes"
    echo 
    echo "Retrieve the status of a device specified by id <id>.  The list of available"
    echo "attributes may be shown using the parameter show-attributes, as above. If "
    echo "attribute-list is empty, all available attributes are retrieved and shown."
    echo
    exit 1
}

# Verify that a plausible number of parameters have been passed, and the device ID is valid.
# Sets: device_id
verify_parameters()
{
    # Verify parameter count.
    if [[ $# -lt 1 ]]; then
        usage
    fi

    device_id=$1

    # Verify device_list.json exists.
    if [[ ! -f device_list.json ]]; then
        echo "Error: device_list.json cannot be found.  Have you run identify.sh?"
        echo
        usage
    fi

    # Verify that the specified device ID is in device_list.json.
    if [[ `cat device_list.json | jq ". | select (.id == $device_id )" 2> /dev/null | wc -l` -eq 0 ]]; then
        echo "Error: device $device_id is not listed in device_list.json.  Have you run identify.sh recently?"
        echo
        usage
    fi
}

# Show available attributes for a given device ID.
show_attributes()
{
    echo "Available attributes for device ${device_id} (${device_type}):"
    echo
    for attr in $all_attributes; do
        echo "    $attr"
    done
}

# Tell Z-Way to request a new value from the thermostat.
refresh_value()
{
    instance_id=$1
    command_class=$2

    get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${device_id}].instances[${instance_id}].commandClasses[$command_class].Get()"  > /dev/null
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

    get_url "http://${cortostat_server}/ZWaveAPI/Run/devices[${device_id}].instances[${instance_id}].commandClasses[${command_class}].${data_segment}.${value_name}.value"
}

build_attribute_list()
{
    if [[ $# -eq 0 ]]; then
        # Put all the attributes in the list to retrieve if none are specified on the command line
        attributes=$all_attributes
    else
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
}

refresh_and_get_values()
{
    # Iterate through sensors on the thermostat
    for attribute in $attributes
    do
        set `echo ${device_attributes[$device_type]} | jq  ". | select(.attribute == \"$attribute\") | .instance_id, .data_id, .command_class, .value_name"`
        instance_id=$1
        data_id=$2
        command_class=$3
        value_name=`echo $4 | sed s%\"%%g`

        refresh_value $instance_id $command_class
        value_map[$attribute]=`fetch_sensor_value $instance_id $data_id $command_class $value_name`
    done
}


###########################################################3

verify_parameters $@
device_type=`cat device_list.json | jq -r ". | select (.id == $device_id ) | .device_type"`
all_attributes=`echo ${device_attributes[$device_type]} | jq -r .attribute`

if [[ $# -eq 2 && $2 == "show-attributes" ]]; then
    show_attributes
    exit 0
fi

# Build the attribute list from all arguments after the first.
shift 
build_attribute_list $@

declare -A value_map
refresh_and_get_values

map_thermostat_values


# Build results JSON.
tstat_name=`cat device_list.json | jq "select(.id == $device_id) | .name"`
result="{ \"id\": $device_id, \"name\": $tstat_name "
for attribute in $attributes
do
    result="${result}, \"$attribute\": ${value_map[${attribute}]}"
done
result="${result} }"

echo $result  | jq
