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

# Import the main config file
set -a
source $base_directory/primary.config
set +a

# If no run count supplied, run forever
if [ -z "$1" ]
then
    echo -e "$(logDate) > initializer.sh invoked, running indefinitely" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > To run N times instead, invoke as 'bash initializer.sh N'"
    echo -e "$(logDate) > Components: CPU $cpu_enabled, RAM $ram_enabled, Network $network_enabled, Disk $disk_enabled" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > Run times: $time_between_runs seconds between runs, min run time $minimum_run_time seconds and max run time $maximum_run_time seconds" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > PID: $$ $BASHPID" | tee -a $master_log $verbose_log
    # Runs forever because this always evaluates to true
    while :
        do
            echo -e "$(logDate) > Starting another run, PID $$ $BASHPID" | tee -a $master_log $verbose_log
            #Invokes script and sends STDOUT from script to null
            /bin/bash "$base_directory"/scripts/core-loop.sh > /dev/null &
            # Simultaneously starts a timer before invoking script again
            sleep $time_between_runs
        done
# If run count supplied, run that many times
else
    # Store the maximum number of runs
    script_iterations=$1
    # Initialize run_count_start
    run_count_start=1
    echo -e "$(logDate) > initializer.sh invoked, running $script_iterations times" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > Components enabled: CPU $cpu_enabled, RAM $ram_enabled, Network $network_enabled, Disk $disk_enabled" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > Run times: $time_between_runs seconds between runs, min run time $minimum_run_time seconds and max run time $maximum_run_time seconds" | tee -a $master_log $verbose_log
    echo -e "$(logDate) > PID: $$ $BASHPID" | tee -a $master_log $verbose_log
    while [[ $run_count_start -le $script_iterations ]]
    do
        echo -e "$(logDate) > Running $run_count_start of $script_iterations iterations, PID $$ $BASHPID" | tee -a $master_log $verbose_log
        /bin/bash "$base_directory"/scripts/core-loop.sh > /dev/null &
        sleep $time_between_runs
        let ++run_count_start
    done
fi

wait
echo -e "$(logDate) > initializer.sh exited" | tee -a $master_log $verbose_log