#!/bin/bash

# Function used across all scripts to log dates
function logDate {
   date -u +%Y-%m-%d" @ "%H:%M:%S" UTC"
}
export -f logDate

# Get the base directory for the app
export base_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Define name and path to master and verbose logs; other log paths defined in core-loop.sh
export master_log="$base_directory"/logs/master.log
export verbose_log="$base_directory"/logs/verbose.log

# If no run count supplied, run forever
if [ -z "$1" ]
then
    echo -e "$(logDate) > initializer.sh invoked, running indefinitely" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > To run N times instead, invoke as 'bash initializer.sh N'"
    echo -e "$(logDate) > PID: $$ $BASHPID"
    # Runs forever because this always evaluates to true
    while :
        do
            echo -e "$(logDate) > Starting another run, press [CTRL+C] to stop..." | tee -a $master_log $verbose_log
            #Invokes script and sends STDOUT from script to null
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
    echo -e "$(logDate) > initializer.sh invoked, running $script_iterations times" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > PID: $$ $BASHPID"
    while [[ $run_count_start -le $script_iterations ]]
    do
        echo -e "$(logDate) > Running $run_count_start of $script_iterations iterations" | tee -a $master_log $verbose_log
        /bin/bash "$base_directory"/core-loop.sh > /dev/null &
        sleep 8m
        let ++run_count_start
    done
fi