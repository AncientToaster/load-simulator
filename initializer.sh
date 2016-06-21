#!/bin/bash

# Get the base directory for the app
export base_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# `starts a new copy of the performance script every eight minutes
while :
do
    echo "Starting a new run, press [CTRL+C] to stop..."
    echo -e "$(date -u) PID: $$ $BASHPID"
    /bin/bash $base_directory/core-loop.sh > /dev/null &
    sleep 8m
done