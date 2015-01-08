#!/bin/bash

# Convert C to F.
celsius_to_fahrenheit()
{
    temp=$1
    echo "scale=1;($temp*9/5)+32" | bc
}

# Convert F to C.
fahrenheit_to_celsius()
{
    temp=$1
    echo "scale=1;($temp-32)*(5/9)" | bc
}
