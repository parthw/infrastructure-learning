

#!/bin/sh

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 2)
   `date +"%A, %e %B %Y, %r"`
   `uname -srmo`
   $(tput setaf 1)
   Uptime.............: ${UPTIME}
   Memory.............: `awk '/MemFree/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo`GB (Free) / `awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo
   `GB (Total)
   Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
   Running Processes..: `ps ax | wc -l | tr -d " "`
   IP Address.......: {{ grains['custom_grains']['ipv4'] }}
   Users Logged in....: `users`
$(tput sgr0)"
