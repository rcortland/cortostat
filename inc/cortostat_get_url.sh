#!/bin/bash

# Wrapper for cURL
get_url()
{

    if [ ! -z "$CORTOSTAT_DEBUG" ]; then
        echo wget -qO- "$1" 1>&2
    fi

    wget -qO- "$1"
}
