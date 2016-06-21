#!/bin/bash

# Get the base directory for the app
export base_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Define path to master and verbose logs; other paths defined in core-loop.sh
export master_log="$base_directory"/logs/master.log
export verbose_log="$base_directory"/logs/verbose.log

# If no run count supplied, run forever
if [ -z "$1" ]
then
    echo "$(date -u) > initializer.sh invoked, running indefinitely" | tee -a $master_log $verbose_log
    echo "To run ### times instead, invoke as bash initializer.sh ###"
    # Runs forever because this always evaluates to true
    while :
        do
            echo "$(date -u) > Starting another run, press [CTRL+C] to stop..." | tee -a $master_log $verbose_log
            echo -e "$(date -u) PID: $$ $BASHPID"
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
    echo "$(date -u) > initializer.sh invoked, running $script_iterations times" | tee -a $master_log $verbose_log
    while [[ $run_count_start -le $script_iterations ]]
    do
        echo "$(date -u) > Running $run_count_start of $script_iterations iterations" | tee -a $master_log $verbose_log
        echo -e "$(date -u) PID: $$ $BASHPID"
        /bin/bash "$base_directory"/core-loop.sh > /dev/null &
        sleep 8m
        let ++run_count_start
    done
    echo "$(date -u) > Completed all $script_iterations iterations" | tee -a $master_log $verbose_log
fi