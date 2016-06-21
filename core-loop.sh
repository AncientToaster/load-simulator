#!/bin/bash
# A script to produce interesting fake load on a server
# Requires: stress-ng

# Paths to various log files
export master_log="$base_directory"/logs/master.log
export verbose_log="$base_directory"/logs/verbose.log
export disk_log="$base_directory"/logs/disk.log
export cpu_log="$base_directory"/logs/cpu.log
export network_log="$base_directory"/logs/network.log
export network_files_log="$base_directory"/logs/network-files.log
#export ram_log="$base_directory/logs/ram.log"

# Randomly assign an ID for this particular run
script_run_id=$(shuf -i 1-1000000000 -n 1)
echo -e "$(date -u) > Started: Script run $script_run_id" | tee -a $master_log $verbose_log

# Call both stress tests and run them at the same time
/bin/bash "$base_directory"/disk.sh > /dev/null &
/bin/bash "$base_directory"/network.sh > /dev/null &
/bin/bash "$base_directory"/cpu.sh > /dev/null
echo -e "$(date -u) > Finished: Script run $script_run_id" | tee -a $master_log $verbose_log

exit