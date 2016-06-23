#!/bin/bash

# Uses `stress-ng` to run two CPU workers, pegged together to produce 20% to 40$ load
function cpuStress {
    # Log the beginning of the run
    cpu_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: CPU run $cpu_run_id" | tee -a $master_log $verbose_log
    # Log time and load for CPUJ1
    stress_time=$(shuf -i 480-720 -n 1)
    stress_cpu_load=$(shuf -i 10-30 -n 1)
    cpuj1_sub_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >>> CPUJ1/"$cpuj1_sub_id" running for $stress_time seconds at $stress_cpu_load load" | tee -a $cpu_log $verbose_log
    # Log time and load for CPUJ2
    stress_timer_freq=$(shuf -i 1000-50000 -n 1)
    stress_timer_ops=$(shuf -i 3600000-7200000 -n 1)
    cpuj2_sub_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >>> CPUJ2/"$cpuj2_sub_id" running for $stress_timer_ops ops at $stress_timer_freq load" | tee -a $cpu_log $verbose_log
    # Run the test at the specified load and frequency
    stress-ng --cpu 1 --cpu-load $stress_cpu_load -t $stress_time --timer 1 --timer-freq $stress_timer_freq --timer-ops $stress_timer_ops
    echo -e "$(date -u) >> Finished: CPU run $cpu_run_id" | tee -a $cpu_log $master_log $verbose_log
}

cpuStress