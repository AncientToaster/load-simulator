#!/bin/bash
# A script to produce interesting fake load on a server
# Requires: stress-ng

# Paths to various log files
export disk_log="$base_directory"/logs/disk.log
export cpu_log="$base_directory"/logs/cpu.log
export network_log="$base_directory"/logs/network.log
export network_files_log="$base_directory"/logs/network-files.log
export ram_log="$base_directory"/logs/ram.log

# Randomly assign an ID for this particular run
script_run_id=$(shuf -i 1-1000000000 -n 1)
echo -e "$(logDate) > Started: Script run $script_run_id" | tee -a $master_log $verbose_log

# Call all stress tests and run them at the same time
if [ "$disk_enabled" = true ] ; then
    /bin/bash "$base_directory"/disk.sh > /dev/null &
elif [ "$disk_enabled" = false ] ; then
    echo -e "$(logDate) >> Disabled: Disk for $script_run_id" | tee -a $master_log $verbose_log
fi
if [ "$network_enabled" = true ] ; then
    /bin/bash "$base_directory"/network.sh > /dev/null &
elif [ "$network_enabled" = false ] ; then
    echo -e "$(logDate) >> Disabled: Network for $script_run_id" | tee -a $master_log $verbose_log
fi
if [ "$ram_enabled" = true ] ; then
    /bin/bash "$base_directory"/ram.sh > /dev/null &
elif [ "$ram_enabled" = false ] ; then
    echo -e "$(logDate) >> Disabled: RAM for $script_run_id" | tee -a $master_log $verbose_log
fi
if [ "$cpu_enabled" = true ] ; then
    /bin/bash "$base_directory"/cpu.sh > /dev/null
elif [ "$cpu_enabled" = false ] ; then
    echo -e "$(logDate) >> Disabled: CPU for $script_run_id" | tee -a $master_log $verbose_log
fi
wait
echo -e "$(logDate) > Finished: Script run $script_run_id" | tee -a $master_log $verbose_log

exit