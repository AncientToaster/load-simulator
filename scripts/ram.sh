#!/bin/bash

# Generates RAM load on the system

# Retrieve amount of RAM available on the system
available_ram=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
# Calculate a maximum amount of RAM to occupy
occupy_limit=$(echo "($maximum_ram_percentage*.01)*$available_ram" | bc | awk -F. '{ print $1 }' )

# Runs individual stress jobs
function ramJob {
    # Import the arguments as variables. $1 is ID of base job, $2 is amount of RAM to load, $3 is run time
    ram_base_id=$1
    ram_load_amount=$2
    ram_run_time=$3
    # Generate a random sub-ID for this RAM job
    ram_sub_id=$(shuf -i 1-1000000000 -n 1)
    # Log the ramjob run time and load amount
    echo -e "$(logDate) >>> RJ$ram_base_id/$ram_sub_id occupying $ram_load_amount KB RAM for $ram_run_time seconds" | tee -a $ram_log $verbose_log
    # Occupy $ram_load_amount MB for #ram_run_time seconds
    stress-ng --vm 1 --vm-bytes "$ram_load_amount"k --vm-hang $ram_run_time -t $ram_run_time
    echo -e "$(logDate) >>> RJ$ram_base_id/$ram_sub_id finished, freeing $ram_load_amount KB RAM" | tee -a $ram_log $verbose_log
}

# Main RAM stress loop
function ramStress {
    # Randomly assign an ID for this particular run
    ram_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(logDate) >> Started: RAM run $ram_run_id" | tee -a $ram_log $verbose_log
    # Call three RAM jobs and run at the same time
    # Occupy a large amount of RAM for a short time
    ram_1_timer=$(shuf -i $(echo "$maximum_run_time * .14285" | bc)-$(echo "$maximum_run_time * .33334" | bc) -n 1)
    ram_1_memory=$(shuf -i $(echo "$occupy_limit * .25" | bc)-$(echo "$occupy_limit * .50" | bc) -n 1)
    ramJob 1 $ram_1_memory $ram_1_timer &
    # Occupy a medium amount of RAM for a medium time
    ram_2_timer=$(shuf -i $(echo "$maximum_run_time * .25" | bc)-$(echo "$maximum_run_time * .5" | bc) -n 1)
    ram_2_memory=$(shuf -i $(echo "$occupy_limit * .10" | bc)-$(echo "$occupy_limit * .30" | bc) -n 1)
    ramJob 2 $ram_2_memory $ram_2_timer &
    # Occupy a small amount of RAM for a long time
    ram_3_timer=$(shuf -i $minimum_run_time-$maximum_run_time -n 1)
    ram_3_memory=$(shuf -i $(echo "$occupy_limit * .05" | bc)-$(echo "$occupy_limit * .20" | bc) -n 1)
    ramJob 3 $ram_3_memory $ram_3_timer
    wait
    echo -e "$(logDate) >> Finished: RAM run $ram_run_id" | tee -a $ram_log $verbose_log
}

ramStress