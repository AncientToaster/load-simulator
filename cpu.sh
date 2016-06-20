#!/bin/bash

function cpuStress {
    cpu_run_id=$(shuf -i 1-1000000000 -n 1)
    echo -e "$(date -u) >> Started: CPU run $cpu_run_id" | tee -a $master_log $verbose_log
    stress_time=$(shuf -i 480-720 -n 1)
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

cpuStress