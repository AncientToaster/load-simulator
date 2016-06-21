#!/bin/bash

# Get the base directory for the app
export base_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If no run count supplied, run forever
if [ -z "$1" ]
then
    echo "No run count supplied, running indefinitely"
    echo "To supply run count, invoke as: bash initializer.sh ###"
    # Runs forever because this always evaluates to true
    while :
        do
            echo "Starting a new run, press [CTRL+C] to stop..."
            echo -e "$(date -u) PID: $$ $BASHPID"
            Invokes script and sends STDOUT from script to null
            /bin/bash "$base_directory"/core-loop.sh > /dev/null &
            # Simultaneously starts 8 minute timer before invoking script again
            sleep 8m
        done
# If run count supplied, run that many times
else
    # Store the maximum number of runs
    script_iterations=$1
    # Initialize run_count_start
    run_count_start=1
    echo "Running $script_iterations times"
    while [[ $run_count_start -le $script_iterations ]]
    do
        echo "Running $run_count_start of $script_iterations iterations"
        echo -e "$(date -u) PID: $$ $BASHPID"
        /bin/bash "$base_directory"/core-loop.sh > /dev/null &
        sleep 8m
        let ++run_count_start
    done
    echo "Completed all $script_iterations iterations"
fi