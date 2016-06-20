#!/bin/bash

function fetchFromNetwork {
    # Randomly decide how long to sleep before fetching image
    FETCH_SLEEP=$(shuf -i 3-5 -n 1)
    # Assign a random filename to the image
    RANDOM_FILENAME=$(shuf -i 1-1000000000 -n 1)
    # Select randomly from one of the possible images
    RANDOM_SOURCE=$(randArrayElement "POSSIBLE_IMAGES[@]")
    sleep $FETCH_SLEEP
    echo -e "$(date -u) >>> After $FETCH_SLEEP seconds sleep, saved $RANDOM_FILENAME.png from $RANDOM_SOURCE" | tee -a network-filename-log
    # Fetch the image and save with random file name
    wget -q "$RANDOM_SOURCE" -O $RANDOM_FILENAME.png
}
 
function stressLoop {
    # Initialize $START
    START=1
    # Randomly decide how many iterations to do, and store that in $START
    NETWORK_ITERATIONS=$(shuf -i 1-3 -n 1)
    i=$START
    echo -e "Running $NETWORK_ITERATIONS iterations \n"
    # Main loop to download images
    while [[ $i -le $NETWORK_ITERATIONS ]]
    do
        fetchFromNetwork
        ((i = i + 1))
    done
}

function networkStress {
    # Randomly assign an ID to the run
    NETWORK_RUN_ID=$(shuf -i 1-1000000000 -n 1)
    # Define a list of possible images
    declare -a POSSIBLE_IMAGES=("https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-bug-clr-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-w.png" "https://newrelic.com/assets/newrelic/source/NewRelic-logo-square-clr-w.png")
    # Function to randomly select from those images
    randArrayElement(){ arr=("${!1}"); echo ${arr["$[RANDOM % ${#arr[@]}]"]}; }
    echo "$(date -u) >> Started: Network run $NETWORK_RUN_ID" | tee -a network-filename-log
    # Call the main loop
    stressLoop
    # Log the filenames of all PNGs
    echo -e "$(date -u) >>> Removing pngs: $(ls -1 *.png | tr '\n' ' ')" | tee -a network-filename-log
    # Remove all files with a PNG extension
    rm *.png
    echo "$(date -u) >> Finished: Network run $NETWORK_RUN_ID" | tee -a network-filename-log
}

networkStress