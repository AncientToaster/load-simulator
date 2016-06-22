#!/bin/bash

# Creates several large temporary files to produce artificial disk load

# Creates the temp files
function makeFile {
    # Import the arguments as variables. $1 is job ID, $2 is file size, $3 is time to wait to delete file
    disk_job_id=$1
    make_file_size=$2
    sleep_timer=$3
    # Randomly assign filename
    make_file_name=$(shuf -i 1-1000000000 -n 1)
    # Create the file, then log that we created it
    head -c ${make_file_size}m </dev/zero >$base_directory/disk-files/$make_file_name.temp
    echo -e "$(date -u) >>> DJ$disk_job_id created $make_file_name.temp sized $make_file_size MB, will sleep $sleep_timer seconds" | tee -a $disk_log $verbose_log
    sleep $sleep_timer
    # Delete the file we created earlier
    rm "$base_directory"/disk-files/$make_file_name.temp
    echo -e "$(date -u) >>> DJ$disk_job_id removed $make_file_name.temp" | tee -a $disk_log $verbose_log
}

# Main loop
function diskStress {
    # Randomly assign an ID for this particular run
    disk_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: Disk run $disk_run_id" | tee -a $disk_log $master_log $verbose_log
    # Call both disk runs and run them at the same time
    # Make a file of 100 to 2000 MB and delete after 100 to 240 seconds
    makeFile 1 $(shuf -i 100-2000 -n 1) $(shuf -i 100-240 -n 1) &
    # Make a file of 100 to 400 MB and delete after 180 to 400 seconds
    makeFile 2 $(shuf -i 100-400 -n 1) $(shuf -i 180-400 -n 1) &
    # Make a file of 50 to 250 MB and delete after 241 to 479 seconds
    makeFile 3 $(shuf -i 50-250 -n 1) $(shuf -i 241-479 -n 1)
    echo -e "$(date -u) >> Finished: Disk run $disk_run_id" | tee -a $disk_log $master_log $verbose_log
}

diskStress