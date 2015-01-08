#!/bin/bash

source inc/cortostat_config.sh
source inc/cortostat_get_url.sh

usage()
{
    echo "Usage: $0"
    echo
    echo "Retrieve a list of thermostats from the configured Z-Wave server and print it"
    echo "to stdout and \"thermostat_list.json\"."
    echo
    exit 1
}

identify_thermostats()
{
    get_url "http://192.168.40.10:8083/ZWaveAPI/Run/devices" | \
        jq -C \
            ".[] | \
            select(.data.deviceTypeString.value == \"General Thermostat V2\") | \
            { name: .data.givenName.value, id: .id }"
}

if [[ $# -ne 0 ]]; then
    usage
fi

identify_thermostats | tee thermostat_list.json
sed -r -i "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" thermostat_list.json
