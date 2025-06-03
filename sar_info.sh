#!/bin/bash
# Author: [LX]
if [ -z "$1" ]; then
    echo "Alert: You have not passed the date i.e ./sar_memory_stat.sh 03"
    exit 1
fi

# Define the log file path
LOG_FILE="/var/log/sa/sa$1"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file $LOG_FILE does not exist."
    exit 1
fi

# Define the output file path
OUTPUT_FILE="/tmp/sar$1.txt"

# Collect system statistics and save to file
{
    echo "System Statistics from $LOG_FILE:"
    echo "-----------------------------------"

    # Use sar to extract memory statistics
    sar -r -f "$LOG_FILE" | awk 'NR > 3 {
    total_memory = ($3 + $4 + $5 + $7 + $8 + $9 + $10 + $11 + $12 + $13) / 1024 / 1024; # Sum all memory fields (kbmemfree, kbmemused, kbbuffers, kbcached) in GB
    free_memory = ($2 + $6 + $7) / 1024 / 1024;       # Free memory includes kbmemfree, buffers, and cached memory
    used_memory = ($4 - $6 - $7) / 1024 / 1024;       # Used memory excludes buffers and cached memory
    printf "Time: %s, Total Memory: %.2f GB, Free Memory: %.2f GB, Used Memory: %.2f GB\n",
    $1, total_memory, free_memory, used_memory
}'
    echo "-----------------------------------"
# Collect system statistics and save to file
{
    echo "System Statistics from $LOG_FILE:"
    echo "-----------------------------------"

    # Use sar to extract memory statistics
    sar -r -f "$LOG_FILE" | awk 'NR > 3 {
    total_memory = ($2 $3 + $4  $5+ $7 + $8 + $9 + $10 + $11 + $12 + $13) / 1024 / 1024; # Sum all memory fields (kbmemfree, kbmemused, kbbuffers, kbcached) in GB
    free_memory = ($2 + $6 + $7) / 1024 / 1024;       # Free memory includes kbmemfree, buffers, and cached memory
    used_memory = ($4 - $6 - $7) / 1024 / 1024;       # Used memory excludes buffers and cached memory
    printf "Time: %s, Total Memory: %.2f GB, Free Memory: %.2f GB, Used Memory: %.2f GB\n",
    $1, total_memory, free_memory, used_memory
}'
    echo "-----------------------------------"


    # CPU Usage Statistics
    echo "CPU Usage Statistics:"
    sar -u -f "$LOG_FILE" | awk 'NR > 3 {
        printf "Time: %s, User CPU: %.2f%%, System CPU: %.2f%%, Idle CPU: %.2f%%, I/O Wait: %.2f%%\n",
        $1, $3, $5, $8, $6
    }'
    echo "-----------------------------------"

    # I/O Wait Statistics
    echo "I/O Wait Statistics:"
    sar -b -f "$LOG_FILE" | awk 'NR > 3 {
        printf "Time: %s, TPS: %.2f, Read KB/s: %.2f, Write KB/s: %.2f\n",
        $1, $2, $3, $4
    }'
    echo "-----------------------------------"

    # Disk Utilization Statistics
    echo "Disk Utilization Statistics:"
    sar -d -f "$LOG_FILE" | awk 'NR > 3 {
        printf "Time: %s, Device: %s, Busy: %.2f%%, Read KB/s: %.2f, Write KB/s: %.2f\n",
        $1, $2, $9, $4, $5
    }'
    echo "-----------------------------------"
} > "$OUTPUT_FILE"

echo "Output saved to $OUTPUT_FILE"
