#!/bin/bash

# Runs an individual CPU job
function cpuJob {
    # Import the arguments as variables. $1 is job ID, $2 is load level, $3 is run time
    cpu_base_id=$1
    load_level=$2
    run_time=$3
    # Generate a random sub-ID for this CPU job
    cpu_sub_id=$(shuf -i 1-1000000000 -n 1)
    # Log time and load level for this CPU job
    echo -e "$(logDate) >>> CJ$cpu_base_id/"$cpu_sub_id" running for $run_time seconds at $load_level percent load" #| tee -a $cpu_log $verbose_log
    # Start the job
    stress-ng --cpu 1 --cpu-load $load_level -t $run_time
    echo -e "$(logDate) >>> CJ$cpu_base_id/"$cpu_sub_id" finished" #| tee -a $cpu_log $verbose_log
}

# Main function
function cpuStress {
    # Log the beginning of the run
    cpu_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(logDate) >> Started: CPU run $cpu_run_id" #| tee -a $verbose_log $cpu_log
    # Call both CPU jobs and run them at the same time
    # Run the higher CPU job
    long_job_time=$(shuf -i $minimum_run_time-$maximum_run_time -n 1)
    cpuJob 1 $(shuf -i 20-30 -n 1) $long_job_time &
    # Run the shorter CPU job
    short_job_time=$(shuf -i $(echo "$maximum_run_time * .0625" | bc)-$(echo "$maximum_run_time * .6667" | bc) -n 1)
    cpuJob 2 $(shuf -i 5-20 -n 1) $short_job_time
    wait
    echo -e "$(logDate) >> Finished: CPU run $cpu_run_id" #| tee -a $verbose_log $cpu_log
}

cpuStress