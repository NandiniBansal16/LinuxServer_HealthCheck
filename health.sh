<<<<<<< HEAD
 #!/bin/bash

=======
#!/bin/bash

# ===============================
# Strict mode (Level 1 upgrade)
# ===============================
set -euo pipefail

# ===============================
# Variables
# ===============================
>>>>>>> 4070a8e (level 1 upgrade)
log="logs"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
filename="${log}/${timestamp}_health_file.txt"

mkdir -p "$log"

<<<<<<< HEAD
echo "=====================================================================================================================" > "$filename"
echo "                                                     LINUX HEALTH CHECKUP                                            " >> "$filename"
echo "=====================================================================================================================" >> "$filename"
=======
# ===============================
# Functions (Level 1 upgrade)
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
>>>>>>> 4070a8e (level 1 upgrade)

echo "                                                 GENERATED ON DATE:                                                  " >> "$filename"
date >> "$filename"
echo "" >> "$filename"

<<<<<<< HEAD
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
=======
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
top -bn1 | grep "Cpu(s)" >> "$filename"
echo "" >> "$filename"

# ===============================
# DISK UTILISATION
# ===============================
print_section "                                                         DISK UTILISATION:                                           "
df -h >> "$filename"
echo "" >> "$filename"

# ===============================
# TOP CPU PROCESSES
# ===============================
print_section "                                                  TOP 5 PROCESSES IN THE CPU                                         "
ps aux --sort=-%cpu | head -6 >> "$filename"
echo "" >> "$filename"

# ===============================
# TOP MEMORY PROCESSES
# ===============================
print_section "                                                  TOP 5 PROCESSES IN THE MEMORY                                      "
ps aux --sort=-%mem | head -6 >> "$filename"
echo "" >> "$filename"

# ===============================
# NETWORK INFO
# ===============================
print_section "                                                 NETWORK INFO (IP ADDRESSES):                                        "
ip a | grep -A 2 "inet " >> "$filename"
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
    systemctl is-active --quiet "$service"
    if [ $? -eq 0 ]; then
        echo "$service is running" >> "$filename"
    else
        echo "$service is not installed/not running" >> "$filename"
    fi
done

echo "" >> "$filename"
print_separator
echo "Report saved at: $filename" >> "$filename"
print_separator
>>>>>>> 4070a8e (level 1 upgrade)

