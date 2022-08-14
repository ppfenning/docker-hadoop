#!/bin/bash


if [ ! -f examples/data/Chicago_Crimes.csv ]; then
    python scripts/get_crime_data.py
fi
