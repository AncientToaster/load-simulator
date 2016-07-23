#!/bin/bash

# Read a list of possible network resources from network.config
readarray possible_files < $base_directory/network.config

# Does fetches of individual network files
function fetchFromNetwork {
    # Randomly decide how long to sleep before fetching network file
    fetch_sleep=$(shuf -i 5-15 -n 1)
    sleep $fetch_sleep
    # Assign a random filename to the file
    random_filename=$(shuf -i 1-1000000000 -n 1)
    # Randomly select one of the files in network.config. Only works up to 32768 items.
    random_source=${possible_files[$RANDOM % ${#possible_files[@]} ]}
    # Fetch the network file and save with random file name, then log it
    wget -q "$random_source" -O $base_directory/network-files/$random_filename.png
    echo -e "$(logDate) >>> Network iteration $network_loop_start/$network_iterations: After $fetch_sleep seconds sleep, saved $random_filename.png from $random_source" | tee -a $network_files_log
}

# Runs fetchFromNetwork 6-24 times
function stressLoop {
    # Randomly decide how many iterations to do, and store that in $network_iterations
    network_iterations=$(shuf -i $(echo "$minimum_run_time / 15" | bc)-$(echo "$maximum_run_time / 15" | bc) -n 1)
    # Start the loop counter at 1
    network_loop_start=1
    echo -e "$(logDate) >> Started: Network run $network_run_id with $network_iterations iterations" | tee -a $verbose_log $network_log
    # Main loop to download network files. 
    # While the loop counter is less than or equal to $network_iterations, continue
    while [[ $network_loop_start -le $network_iterations ]]
    do
        fetchFromNetwork
        let ++network_loop_start
    done
}

# Logs the start and finish of network.sh, calls the main loop, and cleans up files afterward
function networkStress {
    # Randomly assign an ID to the run
    network_run_id=$(shuf -i 1-1000000000 -n 1)
    # Call the main loop
    stressLoop
    # Log the filenames of all files to be removed
    echo -e "$(logDate) >>> Removing files: $(cd "$base_directory/network-files/"; ls -1 | tr '\n' ' ')" | tee -a $network_files_log $verbose_log $network_log
    # Remove all files in the network-files subdirectory
    rm "$base_directory"/network-files/*
    echo "$(logDate) >> Finished: Network run $network_run_id" | tee -a $network_files_log $verbose_log $network_log
}

networkStress