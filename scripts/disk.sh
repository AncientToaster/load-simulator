#!/bin/bash

# Creates several large temporary files to produce artificial disk load

# Creates the temp files
function makeFile {
    # Import the arguments as variables. $1 is job ID, $2 is file size, $3 is time to wait to delete file
    disk_base_id=$1
    make_file_size=$2
    sleep_timer=$3
    # Generate a random sub-ID for this disk job
    disk_sub_id=$(shuf -i 1-1000000000 -n 1)
    # Randomly assign filename
    make_file_name=$(shuf -i 1-1000000000 -n 1)
    # Create the file, then log that we created it
    head -c ${make_file_size}m </dev/zero >$base_directory/disk-files/$make_file_name.temp
    echo -e "$(logDate) >>> DJ$disk_base_id/$disk_sub_id created $make_file_name.temp sized $make_file_size MB, will sleep $sleep_timer seconds" | tee -a $disk_log $verbose_log
    sleep $sleep_timer
    # Delete the file we created earlier
    rm "$base_directory"/disk-files/$make_file_name.temp
    echo -e "$(logDate) >>> DJ$disk_base_id/$disk_sub_id removed $make_file_name.temp, freeing $make_file_size MB" | tee -a $disk_log $verbose_log
}

# Main loop
function diskStress {
    # Randomly assign an ID for this particular run
    disk_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(logDate) >> Started: Disk run $disk_run_id" | tee -a $disk_log $verbose_log
    # Call all three disk runs and run them at the same time
    # Make a large file and keep it for a short time
    file_1_timer=$(shuf -i $(echo "$maximum_run_time * .14285" | bc)-$(echo "$maximum_run_time * .33334" | bc) -n 1)
    makeFile 1 $(shuf -i 100-2000 -n 1) $file_1_timer &
    # Make a medium file and keep it for a medium amount of time
    file_2_timer=$(shuf -i $(echo "$maximum_run_time * .25" | bc)-$(echo "$maximum_run_time * .5" | bc) -n 1)
    makeFile 2 $(shuf -i 100-400 -n 1) $file_2_timer &
    # Make a small file and keep it for a long time
    file_3_timer=$(shuf -i $minimum_run_time-$maximum_run_time -n 1)
    makeFile 3 $(shuf -i 50-250 -n 1) $file_3_timer
    wait
    echo -e "$(logDate) >> Finished: Disk run $disk_run_id" | tee -a $disk_log $verbose_log
}

diskStress