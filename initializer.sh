#!/bin/bash

# Get the base directory for the app
export base_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Define name and path to master and verbose logs; other log paths defined in core-loop.sh
export master_log="$base_directory"/logs/master.log
export verbose_log="$base_directory"/logs/verbose.log

# If no run count supplied, run forever
if [ -z "$1" ]
then
    echo -e "$(date -u) > initializer.sh invoked, running indefinitely" | tee -a $master_log $verbose_log
    echo -e "$(date -u) > To run N times instead, invoke as 'bash initializer.sh N'"
    echo -e "$(date -u) PID: $$ $BASHPID"
    # Runs forever because this always evaluates to true
    while :
        do
            echo -e "$(date -u) > Starting another run, press [CTRL+C] to stop..." | tee -a $master_log $verbose_log
            #Invokes script and sends STDOUT from script to null
            /bin/bash "$base_directory"/core-loop.sh > /dev/null &
            # Simultaneously starts 8 minute timer before invoking script again
            sleep 8m
        done
    echo -e "$(date -u) > Run stopped, but you might need to cleanup stray files or processes" | tee -a $master_log $verbose_log
# If run count supplied, run that many times
else
    # Store the maximum number of runs
    script_iterations=$1
    # Initialize run_count_start
    run_count_start=1
    echo -e "$(date -u) > initializer.sh invoked, running $script_iterations times" | tee -a $master_log $verbose_log
    echo -e "$(date -u) PID: $$ $BASHPID"
    while [[ $run_count_start -le $script_iterations ]]
    do
        echo -e "$(date -u) > Running $run_count_start of $script_iterations iterations" | tee -a $master_log $verbose_log
        /bin/bash "$base_directory"/core-loop.sh > /dev/null &
        sleep 8m
        let ++run_count_start
    done
    echo -e "$(date -u) > Completed all $script_iterations iterations" | tee -a $master_log $verbose_log
fi