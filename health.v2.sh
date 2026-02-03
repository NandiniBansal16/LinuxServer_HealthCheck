#!/bin/bash

# ===============================
# LEVEL 2: Threshold Monitoring
# ===============================

set -euo pipefail

# ===============================
# Variables
# ===============================
log="logs"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
filename="${log}/${timestamp}_health_file.txt"

mkdir -p "$log"

# ===============================
# Thresholds
# ===============================
CPU_THRESHOLD=75
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# ===============================
# Functions
# ===============================
print_separator() {
    echo "=====================================================================================================================" >> "$filename"
}

print_section() {
    print_separator
    echo "$1" >> "$filename"
}

# ===============================
# Report Header
# ===============================
print_separator
echo "                                                     LINUX HEALTH CHECKUP                                            " >> "$filename"
print_separator

echo "                                                 GENERATED ON DATE:                                                  " >> "$filename"
date >> "$filename"
echo "" >> "$filename"

# ===============================
# UPTIME
# ===============================
print_section "                                                             UPTIME:                                                 "
uptime >> "$filename"
echo "" >> "$filename"

# ===============================
# CPU UTILISATION
# ===============================
print_section "                                                         CPU UTILISATION:                                            "

cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | sed 's/,//')
cpu_usage=$(awk "BEGIN {print 100 - $cpu_idle}")

echo "CPU Usage: $cpu_usage %" >> "$filename"

if (( ${cpu_usage%.*} > CPU_THRESHOLD )); then
    echo "WARNING: CPU usage above ${CPU_THRESHOLD}%" >> "$filename"
fi

echo "" >> "$filename"

# ===============================
# MEMORY UTILISATION
# ===============================
print_section "                                                         MEMORY UTILISATION:                                         "

mem_usage=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

echo "Memory Usage: $mem_usage %" >> "$filename"

if [ "$mem_usage" -gt "$MEM_THRESHOLD" ]; then
    echo "WARNING: Memory usage above ${MEM_THRESHOLD}%" >> "$filename"
fi

echo "" >> "$filename"

# ===============================
# DISK UTILISATION
# ===============================
print_section "                                                         DISK UTILISATION:                                           "

disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

df -h >> "$filename"
echo "" >> "$filename"
echo "Disk Usage (/): $disk_usage %" >> "$filename"

if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo "WARNING: Disk usage above ${DISK_THRESHOLD}%" >> "$filename"
fi

echo "" >> "$filename"

# ===============================
# TOP CPU PROCESSES
# ===============================
print_section "                                                  TOP 5 PROCESSES BY CPU                                            "
ps aux --sort=-%cpu | head -6 >> "$filename"
echo "" >> "$filename"

# ===============================
# TOP MEMORY PROCESSES
# ===============================
print_section "                                                  TOP 5 PROCESSES BY MEMORY                                         "
ps aux --sort=-%mem | head -6 >> "$filename"
echo "" >> "$filename"

# ===============================
# NETWORK INFO
# ===============================
print_section "                                                 NETWORK INFO (IP ADDRESSES):                                        "
ip a | grep -A 2 "inet " >> "$filename" || true
echo "" >> "$filename"

# ===============================
# OPEN PORTS
# ===============================
print_section "                                                 LIST OF OPEN PORTS:                                                 "
ss -tuln >> "$filename"
echo "" >> "$filename"

# ===============================
# SERVICE STATUS
# ===============================
print_section "                                                 IMPORTANT SERVICE STATUS:                                          "

services=("httpd" "apache2" "docker" "sshd" "cron")

for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "$service is running" >> "$filename"
    else
        echo "$service is not running or not installed" >> "$filename"
    fi
done

echo "" >> "$filename"
print_separator
echo "Report saved at: $filename" >> "$filename"
print_separator

