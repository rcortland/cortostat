#!/bin/bash

# Convert C to F.
celsius_to_fahrenheit()
{
    temp=$1
    echo "scale=5;($temp*9.000/5.000)+32" | bc
}

# Convert F to C.
fahrenheit_to_celsius()
{
    temp=$1
    echo "scale=5;($temp-32.000)*(5.000/9.000)" | bc
}
