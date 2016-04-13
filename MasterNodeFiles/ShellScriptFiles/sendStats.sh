#! /bin/bash

#while true
#do

#Check Date
inpdate=`date +%Y%m%d`

#Check Time
inptime=`date +%H:%M:%S`

# Check if connected to Internet or not
internetstate="Disconnected"
ping -c 1 google.com &> /dev/null && internetstate="Connected" || internetstate="Disconnected"

# Check DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')

# Check hostname
inphostname=`echo $HOSTNAME`

# Check Internal IP
internalip=$(hostname -I)

# Check External IP
externalip=$(curl -s ipecho.net/plain;echo)

# Check RAM Usages
totalram=`awk '/^Mem/ {print $2}' <(free -m)`
usedram=`awk '/^Mem/ {print $3}' <(free -m)`
freeram=`awk '/^Mem/ {print $4}' <(free -m)`

# Check Disk Usages
disktotal=`df -h| grep 'Filesystem\|/dev/xvda*' | awk '/^\/dev/ {print $2}'`
diskused=`df -h| grep 'Filesystem\|/dev/xvda*' | awk '/^\/dev/ {print $3}'`
diskfree=`df -h| grep 'Filesystem\|/dev/xvda*' | awk '/^\/dev/ {print $4}'`

# Check Load Average
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')

# Check System Uptime
sysuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)

#CPU Utilization
cpuutilization=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`

#Insert System State in Database
mysql --host=dbuser281.ce33w8tbbsot.us-west-2.rds.amazonaws.com --port=3306 --user=dbuser281 --password=dbuser281 dbuser281 << EOF
insert into instance_stats (date, time, internet_state, name_server, host_name, Internal_IP, External_IP, ram_total, ram_used, ram_free, disk_total, disk_used, disk_free, load_avg, sys_up_time,cpu_utilization) values('$inpdate','$inptime','$internetstate','$nameservers','$inphostname','$internalip','$externalip','$totalram','$usedram','$freeram','$disktotal','$diskused','$diskfree','$loadaverage','$sysuptime','$cpuutilization');
EOF

#echo "=====================================Statistics Sent=========================================="
#sleep 300
#done
