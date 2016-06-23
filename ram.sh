#!/bin/bash

# Generates RAM load on the system

# Runs individual stress jobs
function ramJob {
    # Import the arguments as variables. $1 is ID of base job, $2 is amount of RAM to load, $3 is run time
    ram_base_id=$1
    ram_load_amount=$2
    ram_run_time=$3
    # Generate a random sub-ID for this RAM job
    ram_sub_id=$(shuf -i 1-1000000000 -n 1)
    # Log the ramjob run time and load amount
    echo -e "$(date -u) >>> RJ$ram_base_id/$ram_sub_id occupying $ram_load_amount MB for $ram_run_time seconds" | tee -a $ram_log $verbose_log
    # Occupy $ram_load_amount MB for #ram_run_time seconds
    stress-ng --vm 1 --vm-bytes "$ram_load_amount"M --vm-hang $ram_run_time -t $ram_run_time
    echo -e "$(date -u) >>> RJ$ram_base_id/$ram_sub_id finished, freeing $ram_load_amount MB" | tee -a $ram_log $verbose_log
}

# Main RAM stress loop
function ramStress {
    # Randomly assign an ID for this particular run
    ram_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: RAM run $ram_run_id" | tee -a $ram_log $master_log $verbose_log
    # Call both RAM jobs and run at the same time
    # Occupy 100 to 200 MB of ram for 360 to 480 seconds
    ramJob 1 $(shuf -i 100-200 -n 1) $(shuf -i 360-480 -n 1) &
    # Occupy 25 to 75 MB of ram for 60 to 480 seconds
    ramJob 2 $(shuf -i 25-75 -n 1) $(shuf -i 360-480 -n 1)
    echo -e "$(date -u) >> Finished: RAM run $ram_run_id" | tee -a $ram_log $master_log $verbose_log
}

ramStress