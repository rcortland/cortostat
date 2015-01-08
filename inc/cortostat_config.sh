#!/bin/bash

cortostat_server="192.168.40.10:8083"

# Map ZWave IDs to readable names.
declare -A cortostat_names
cortostat_names[2]="Den Thermostat"
