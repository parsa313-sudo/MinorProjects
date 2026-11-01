#!/bin/bash

read_cpu() {
    read -r cpu user nice system idle iowait irq softirq steal rest < /proc/stat

    idle_time=$((idle + iowait))
    total_time=$((user + nice + system + idle + iowait + irq + softirq + steal))
}

read_cpu
idle1=$idle_time
total1=$total_time

sleep 1

read_cpu
idle2=$idle_time
total2=$total_time

idle_diff=$((idle2 - idle1))
total_diff=$((total2 - total1))

cpu_usage=$(awk -v idle="$idle_diff" -v total="$total_diff" \
    'BEGIN { if (total > 0) printf "%.2f", 100 * (1 - idle / total); else print "0.00" }')

echo "Total CPU Usage: ${cpu_usage}%"
