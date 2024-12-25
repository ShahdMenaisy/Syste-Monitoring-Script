#!/bin/bash
read -p "Enter the disk usage warning threshold:" THRESHOLD
echo
read -p "Enter the Output file name :" log_file
echo
echo "System Monitorting Report `date "+%Y-%m-%d %H:%M:%S"`" | tee -a $log_file
echo ======================================================= | tee -a $log_file

#THRESHOLD=2

echo "Disk Usage:" | tee -a $log_file

df -h | tee -a $log_file

echo | tee -a $log_file

df -h --output=pcent,target | awk 'NR > 1' | while read -r usage mount; do
  usage=${usage%\%}
  if [ "$usage" -gt "$THRESHOLD" ]; then

     echo -e "\033[31mWarning: $mount is ${usage}% which exceeds ${THRESHOLD}%!\033[0m" | tee -a $log_file
  fi
done
echo | tee -a $log_file

echo "CPU Usage:" | tee -a $log_file


top -b -n 1 | awk 'NR>7 {sum += $9} END {print "Total CPU Usage: " sum "%"}' | tee -a $log_file


echo | tee -a $log_file

echo "Memory Usage:" | tee -a $log_file


free -h -g | awk 'NR==2 {print "Total Memory: " $2 "\nUsed Memory: " $3 "\nFree Memory: " $4}'| tee -a $log_file


echo | tee -a $log_file


echo "Top 5 Memory-Consuming Processes:" | tee -a $log_file


ps -eo pid,user,%mem,cmd --sort=-%mem | head -n 6 | tee -a $log_file

