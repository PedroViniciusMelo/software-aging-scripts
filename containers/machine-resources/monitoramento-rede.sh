ip -s link 
echo "Inform the network interface you would like to monitor: "
read -r interface

if ! ip -s link show dev "$interface" > /dev/null 2>&1 ; then
    echo "Invalid interface"
    exit 1
fi

echo "bytes_recived;packet_received;errors_received;missed_received;date_time" > monitoramento-rede-envio.csv
echo "bytes_sent;packet_sent;errors_sent;missed_sent;date_time" >> monitoramento-rede-download.csv

while true; do
  :

  date_time=$(date +%d-%m-%Y-%H:%M:%S)
  result=$(ip -s link show dev "$interface")
  received=$(echo "$result" | awk 'NR==4') 
  sent=$(echo "$result" | awk 'NR==6') 

  bytes_sent=$(echo "$sent" | awk '{print $1}')
  packet_sent=$(echo "$sent" | awk '{print $2}')
  errors_sent=$(echo "$sent" | awk '{print $3}')
  missed_sent=$(echo "$sent" | awk '{print $4}')

  bytes_received=$(echo "$received" | awk '{print $1}')
  packet_received=$(echo "$received" | awk '{print $2}')
  errors_received=$(echo "$received" | awk '{print $3}')
  missed_received=$(echo "$received" | awk '{print $4}')

  echo "$bytes_sent;$packet_sent;$errors_sent;$missed_sent;$date_time" >> monitoramento-rede-envio.csv
  echo "$bytes_received;$packet_received;$errors_received;$missed_received;$date_time" >> monitoramento-rede-download.csv

  sleep 1
done

