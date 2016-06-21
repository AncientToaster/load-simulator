#!/bin/bash

function fetchFromNetwork {
    # Randomly decide how long to sleep before fetching network file
    fetch_sleep=$(shuf -i 5-20 -n 1)
    # Assign a random filename to the file
    random_filename=$(shuf -i 1-1000000000 -n 1)
    # Select randomly from one of the possible network files
    random_source=$(randArrayElement "possible_files[@]")
    sleep $fetch_sleep
    echo -e "$(date -u) >>> After $fetch_sleep seconds sleep, saved $random_filename.png from $random_source" | tee -a $network_files_log
    # Fetch the network file and save with random file name
    wget -q "$random_source" -O $base_directory/network-files/$random_filename.png
}
 
function stressLoop {
    # Randomly decide how many iterations to do, and store that in $network_iterations
    network_iterations=$(shuf -i 6-24 -n 1)
    # Start the loop counter at 1
    network_loop_start=1
    echo -e "$(date -u) >> Started: Network run $network_run_id with $network_iterations iterations" | tee -a $verbose_log $master_log $network_log
    # Main loop to download network files. 
    # While the loop counter is less than or equal to $network_iterations, continue
    while [[ $network_loop_start -le $network_iterations ]]
    do
        fetchFromNetwork
        let ++network_loop_start
    done
}

function networkStress {
    # Randomly assign an ID to the run
    network_run_id=$(shuf -i 1-1000000000 -n 1)
    # Define a list of possible network files
    declare -a possible_files=("https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-clr-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-clr-w.png")
    # Function to randomly select from those network files
    randArrayElement(){ arr=("${!1}"); echo ${arr["$[RANDOM % ${#arr[@]}]"]}; }
    # Call the main loop
    stressLoop
    # Log the filenames of all files to be removed
    echo -e "$(date -u) >>> Removing files: $(ls -1 "$base_directory"/network-files/* | tr '\n' ' ')" | tee -a $network_files_log $verbose_log $network_log
    # Remove all files in the network-files subdirectory
    rm "$base_directory"/network-files/*
    echo "$(date -u) >> Finished: Network run $network_run_id" | tee -a $network_files_log $verbose_log $master_log $network_log
}

networkStress