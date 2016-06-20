#!/bin/bash
# A script to produce interesting fake load on a server
# Requires: stress-ng

# Paths to various log files
export master_log="$base_directory/logs/master.log"

export verbose_log="$base_directory/logs/verbose.log"

export disk_log="$base_directory/logs/disk.log"

export cpu_log="$base_directory/logs/cpu.log"

#export network_log="$base_directory/logs/network.log"
#export network_files_log="$base_directory/logs/network_files.log"
#export ram_log="$base_directory/logs/ram.log"

# Create the first temp file
function makeFile1 {
    # Randomly assign filename, and size between 100 and 2000 MB
    file_1_name=$(shuf -i 1-1000000000 -n 1)
    file_1_size=$(shuf -i 100-2000 -n 1)
    echo -e "$(date -u) >>> Creating $file_1_name.file with size: $file_1_size megabytes" | tee -a $disk_log $verbose_log
    # Create the file
    head -c ${file_1_size}m </dev/zero >$file_1_name.file
    # Random timer of 100 to 240 seconds
    file_1_delete_timer=$(shuf -i 100-240 -n 1)
    echo -e "$(date -u) >>> Sleep timer for $file_1_name.file: $file_1_delete_timer" | tee -a $disk_log $verbose_log
    # Sleep for timer before delting file
    sleep $file_1_delete_timer
    # Delete the file we created earlier
    rm $file_1_name.file
    echo -e "$(date -u) >>> Removing $file_1_name.file" | tee -a $disk_log $verbose_log
}

# Create the second temp file; see `function makeFile1` for comments
function makeFile2 {
    file_2_name=$(shuf -i 1-1000000000 -n 1)
    file_2_size=$(shuf -i 50-250 -n 1)
    echo -e "$(date -u) >>> Creating $file_2_name.file with size: $file_2_size megabytes" | tee -a $disk_log $verbose_log
    head -c ${file_2_size}m </dev/zero >$file_2_name.file
    file_2_delete_timer=$(shuf -i 241-479 -n 1)
    echo -e "$(date -u) >>> Sleep timer for $file_2_name.file: $file_2_delete_timer" | tee -a $disk_log $verbose_log
    sleep $file_2_delete_timer
    rm $file_2_name.file
    echo -e "$(date -u) >>> Removing $file_2_name.file" | tee -a $disk_log $verbose_log
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

# Initiate CPU stress
function cpuStress {
    cpu_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: CPU run $cpu_run_id" | tee -a $master_log $verbose_log
    STRESS_TIME=$(shuf -i 480-720 -n 1)
    echo -e "$(date -u) >>> Stress time: $stress_time seconds" | tee -a $cpu_log $verbose_log
    stress_cpu_load=$(shuf -i 10-30 -n 1)
    echo -e "$(date -u) >>> CPU load: $stress_cpu_load percent" | tee -a $cpu_log $verbose_log
    stress_timer_freq=$(shuf -i 1000-50000 -n 1)
    echo -e "$(date -u) >>> Additional stress level: $stress_timer_freq" | tee -a $cpu_log $verbose_log
    stress_timer_ops=$(shuf -i 3600000-7200000 -n 1)
    echo -e "$(date -u) >>> Additional stress time: $stress_timer_ops" | tee -a $cpu_log $verbose_log
    stress-ng --timer 1 --timer-freq $stress_timer_freq --timer-ops $stress_timer_ops --cpu 1 --cpu-load $stress_cpu_load -t $stress_time
    echo -e "$(date -u) >> Finished: CPU run $cpu_run_id" | tee -a $cpu_log $master_log $verbose_log
}


# Randomly assign an ID for this particular run
script_run_id=$(shuf -i 1-1000000000 -n 1)
echo -e "$(date -u) > Started: Script run $script_run_id" | tee -a $master_log $verbose_log
# Call both stress tests and run them at the same time
diskStress &
cpuStress
echo -e "$(date -u) > Finished: Script run $script_run_id" | tee -a $master_log $verbose_log

exit