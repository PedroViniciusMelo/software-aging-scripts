#!/bin/bash



while true; do
  :

  pidXPCO=$(pidof -s VBoxXPCOMIPCD)
  date_time=$(date +%d-%m-%Y-%H:%M:%S)

  if [ -n "$pidXPCO" ]; then
    dados=$(pidstat -u -h -p $pidXPCO -T ALL -r 1 1 | sed -n '4p')
    thread=$(cat /proc/"$pidXPCO"/status | grep Threads | awk '{print $2}')
    cpu=$(echo "$dados" | awk '{print $8}')
    mem=$(echo "$dados" | awk '{print $14}')
    vmrss=$(echo "$dados" | awk '{print $13}')
    vsz=$(echo "$dados" | awk '{print $12}')
    swap=$(cat /proc/"$pidXPCO"/status | grep Swap | awk '{print $2}')

    echo "$cpu;$mem;$vmrss;$vsz;$thread;$swap;$date_time" >> logs/monitoramento-VBoxXPCOMIPCD.csv
  else
    sleep 1
    echo "0;0;0;0;0;0;0" >> logs/monitoramento-VBoxXPCOMIPCD.csv
  fi

done
