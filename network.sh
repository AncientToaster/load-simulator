#!/bin/bash

function fetchFromNetwork {
    # Randomly decide how long to sleep before fetching image
    fetch_sleep=$(shuf -i 5-20 -n 1)
    # Assign a random filename to the image
    random_filename=$(shuf -i 1-1000000000 -n 1)
    # Select randomly from one of the possible images
    random_source=$(randArrayElement "possible_images[@]")
    sleep $fetch_sleep
    echo -e "$(date -u) >>> After $fetch_sleep seconds sleep, saved $random_filename.png from $random_source" | tee -a $network_files_log
    # Fetch the image and save with random file name
    wget -q "$random_source" -O $base_directory/network-files/$random_filename.png
}
 
function stressLoop {
    # Initialize $START
    START=1
    # Randomly decide how many iterations to do, and store that in $START
    network_iterations=$(shuf -i 6-24 -n 1)
    i=$START
    echo "$(date -u) >> Started: Network run $network_run_id" | tee -a $verbose_log $master_log $network_log
    # Main loop to download images
    while [[ $i -le $network_iterations ]]
    do
        fetchFromNetwork
        ((i = i + 1))
    done
}

function networkStress {
    # Randomly assign an ID to the run
    network_run_id=$(shuf -i 1-1000000000 -n 1)
    # Define a list of possible images
    declare -a possible_images=("https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-clr-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-clr-w.png")
    # Function to randomly select from those images
    randArrayElement(){ arr=("${!1}"); echo ${arr["$[RANDOM % ${#arr[@]}]"]}; }
    echo "$(date -u) >> Started: Network run $network_run_id" | tee -a $network_files_log $verbose_log $master_log $network_log
    # Call the main loop
    stressLoop
    # Log the filenames of all PNGs
    echo -e "$(date -u) >>> Removing pngs: $(ls -1 ./network-files/*.png | tr '\n' ' ')" |tee -a $network_files_log $verbose_log
    # Remove all files with a PNG extension
    cd network-files && rm *.png
    echo "$(date -u) >> Finished: Network run $network_run_id" | tee -a $network_files_log $verbose_log $master_log $network_log
}

networkStress