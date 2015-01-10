#!/bin/bash

cd /home/pi/cortostat

source inc/cortostat_config.sh
source inc/cortostat_get_url.sh

usage()
{
    echo "Usage: $0"
    echo
    echo "Retrieve a list of supported devices from the configured Z-Wave server and print"
    echo "it to stdout and \"device_list.json\".  Supported devices include those with "
    echo "device string \"General Thermostat V2\" (CT100 thermostats) and \"Routing "
    echo "Multilevel Sensor\" (Aeotec Home Energy Meter)."
    echo
    exit 1
}

identify_devices()
{
    get_url "http://192.168.40.10:8083/ZWaveAPI/Run/devices" | \
        jq -C \
            ".[] | \
            select(.data.deviceTypeString.value == \"General Thermostat V2\" or .data.deviceTypeString.value == \"Routing Multilevel Sensor\") | \
            { id: .id, name: .data.givenName.value, device_type: .data.deviceTypeString.value }"
}

if [[ $# -eq 1 && $1 == "--cached" ]]; then
    cat device_list.json | jq
    exit 0
elif [[ $# -ne 0 && ! ( $# -eq 1 && $1 == "--cached" ) ]]; then
    usage
fi

identify_devices | tee device_list.json
sed -r -i "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" device_list.json
