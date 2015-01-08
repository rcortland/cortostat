#!/bin/bash

# Wrapper for cURL
get_url()
{
    wget -qO- "$1"
}
