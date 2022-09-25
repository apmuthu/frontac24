#!/bin/sh

# This should be at the top of the script to get the start time of the script
start=$(date +%s.%N)

# Here you can place your function
sh $1

# bc not there in Git Bash
# duration=$(echo "$(date +%s.%N) - $start" | bc)
fin=$(date +%s.%N)
duration=$(awk '{print $1-$2}' <<<"${fin} ${start}")
execution_time=`printf "%.2f seconds" $duration`

echo "Script $1 Execution Time: $execution_time"