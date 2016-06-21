#!/bin/bash

# Creates several large temporary files to produce artificial disk load

# Create the first temp file
function makeFile1 {
    # Randomly assign filename, and size between 100 and 2000 MB
    file_1_name=$(shuf -i 1-1000000000 -n 1)
    file_1_size=$(shuf -i 100-2000 -n 1)
    echo -e "$(date -u) >>> Creating $file_1_name.temp with size: $file_1_size megabytes" | tee -a $disk_log $verbose_log
    # Create the file
    head -c ${file_1_size}m </dev/zero >$base_directory/disk-files/$file_1_name.temp
    # Random timer of 100 to 240 seconds
    file_1_delete_timer=$(shuf -i 100-240 -n 1)
    echo -e "$(date -u) >>> Sleep timer for $file_1_name.temp: $file_1_delete_timer" | tee -a $disk_log $verbose_log
    # Sleep for timer before delting file
    sleep $file_1_delete_timer
    # Delete the file we created earlier
    rm $base_directory/disk-files/$file_1_name.temp
    echo -e "$(date -u) >>> Removing $file_1_name.temp" | tee -a $disk_log $verbose_log
}

# Create the second temp file; see `function makeFile1` for comments
function makeFile2 {
    file_2_name=$(shuf -i 1-1000000000 -n 1)
    file_2_size=$(shuf -i 50-250 -n 1)
    echo -e "$(date -u) >>> Creating $file_2_name.temp with size: $file_2_size megabytes" | tee -a $disk_log $verbose_log
    head -c ${file_2_size}m </dev/zero >$base_directory/disk-files/$file_2_name.temp
    file_2_delete_timer=$(shuf -i 241-479 -n 1)
    echo -e "$(date -u) >>> Sleep timer for $file_2_name.temp: $file_2_delete_timer" | tee -a $disk_log $verbose_log
    sleep $file_2_delete_timer
    rm $base_directory/disk-files/$file_2_name.temp
    echo -e "$(date -u) >>> Removing $file_2_name.temp" | tee -a $disk_log $verbose_log
}

function diskStress {
    # Randomly assign an ID for this particular run
    disk_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: Disk run $disk_run_id" | tee -a $disk_log $master_log $verbose_log
    # Call both disk runs and run them at the same time
    makeFile1 &
    makeFile2
    echo -e "$(date -u) >> Finished: Disk run $disk_run_id" | tee -a $disk_log $master_log $verbose_log
}

diskStress