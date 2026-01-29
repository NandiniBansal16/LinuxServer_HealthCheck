 #!/bin/bash

log="logs"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
filename="${log}/${timestamp}_health_file.txt"

mkdir -p "$log"

echo "=====================================================================================================================" > "$filename"
echo "                                                     LINUX HEALTH CHECKUP                                            " >> "$filename"
echo "=====================================================================================================================" >> "$filename"

echo "                                                 GENERATED ON DATE:                                                  " >> "$filename"
date >> "$filename"
echo "" >> "$filename"

echo "=====================================================================================================================" >> "$filename"
echo "                                                             UPTIME:                                                   " >> "$filename"
uptime >> "$filename"
echo "" >> "$filename"
echo "=====================================================================================================================" >> "$filename"
echo "                                                         CPU UTILISATION:                                            " >> "$filename"
top -bn1 | grep "Cpu(s)" >> "$filename"
echo "" >> "$filename"

echo "=====================================================================================================================" >> "$filename"
echo "                                                         DISK UTILISATION:                                           " >> "$filename"
df -h >> "$filename"
echo "" >> "$filename"

echo "=====================================================================================================================" >> "$filename"
echo "                                                  TOP 5 PROCESSES IN THE CPU                                         " >> "$filename"
ps aux --sort=-%cpu | head -6 >> "$filename"
echo "" >> "$filename"

echo "=====================================================================================================================" >> "$filename"
echo "                                                  TOP 5 PROCESSES IN THE MEMORY                                         " >> "$filename"
ps aux --sort=-%mem | head -6 >> "$filename"
echo "" >> "$filename"


echo "=====================================================================================================================" >> "$filename"
echo "                                                 NETWORK INFO(IP ADDRESSES):                                         " >> "$filename"
ip a | grep -A 2 "inet " >> "$filename"
echo "" >> "$filename"
echo "=====================================================================================================================" >> "$filename"
echo "                                                 LIST OF OPEN PORTS:                                         " >> "$filename"
ss -tuln >> "$filename"
echo "" >> "$filename"

echo "=====================================================================================================================" >> "$filename"
echo "                                                 IMPORTANT SERVICE STATUS:                                         " >> "$filename"
services=("httpd" "apache2" "docker" "sshd" "cron")

for service in "${services[@]}"
do
        systemctl is-active --quiet "$service"
        if [ $? -eq 0 ]; then
                echo "$service is running" >> "$filename"
        else
                echo "$service is not installed/not running" >> "$filename"
        fi
done

echo "" >> "$filename"
echo "=====================================================================================================================" >> "$filename"
echo "Report saved at :$filename" >> "$filename"
echo "=====================================================================================================================" >> "$filename"

