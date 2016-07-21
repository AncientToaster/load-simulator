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
    echo -e "$(logDate) >>> RJ$ram_base_id/$ram_sub_id occupying $ram_load_amount MB RAM for $ram_run_time seconds" | tee -a $ram_log $verbose_log
    # Occupy $ram_load_amount MB for #ram_run_time seconds
    stress-ng --vm 1 --vm-bytes "$ram_load_amount"M --vm-hang $ram_run_time -t $ram_run_time
    echo -e "$(logDate) >>> RJ$ram_base_id/$ram_sub_id finished, freeing $ram_load_amount MB RAM" | tee -a $ram_log $verbose_log
}

# Main RAM stress loop
function ramStress {
    # Randomly assign an ID for this particular run
    ram_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(logDate) >> Started: RAM run $ram_run_id" | tee -a $ram_log $verbose_log
    # Call three RAM jobs and run at the same time
    # Occupy 35 to 100 MB of ram for 100 to 240 seconds
    ramJob 1 $(shuf -i 35-100 -n 1) $(shuf -i 100-240 -n 1) &
    # Occupy 20 to 40 MB of ram for 180 to 355 seconds
    ramJob 2 $(shuf -i 20-40 -n 1) $(shuf -i 180-355 -n 1) &
    # Occupy 10 to 20 MB of ram after 361 to 470 seconds
    # The third job MUST run longer than others to prevent concurrency issues
    ramJob 3 $(shuf -i 10-20 -n 1) $(shuf -i 361-470 -n 1)
    echo -e "$(logDate) >> Finished: RAM run $ram_run_id" | tee -a $ram_log $verbose_log
}

ramStress