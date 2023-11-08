echo "bytes_received;packet_received;errors_received;missed_received;date_time" > log-download.csv
echo "bytes_sent;packet_sent;errors_sent;missed_sent;date_time" > log-upload.csv

./download-multiple-files &

ultimo_pid=$!

while ps -p "$ultimo_pid" > /dev/null; do
  :

  date_time=$(date +%d-%m-%Y-%H:%M:%S)

  # Obter a primeira amostra
  rede1=$(cat /proc/net/dev | grep enp0s3)

  sleep 1

  rede2=$(cat /proc/net/dev | grep enp0s3)

  # Extrair os valores de bytes e pacotes enviados e recebidos das duas amostras
  bytes_sent_1=$(echo "$rede1" | awk '{print $10}')  # bytes enviados na primeira amostra
  packet_sent_1=$(echo "$rede1" | awk '{print $11}') # pacotes enviados na primeira amostra
  errors_sent_1=$(echo "$rede1" | awk '{print $12}')  # erros de transmissão na primeira amostra
  missed_sent_1=$(echo "$rede1" | awk '{print $13}')  # pacotes perdidos na primeira amostra

  bytes_received_1=$(echo "$rede1" | awk '{print $2}')  # bytes recebidos na primeira amostra
  packet_received_1=$(echo "$rede1" | awk '{print $3}') # pacotes recebidos na primeira amostra
  errors_received_1=$(echo "$rede1" | awk '{print $4}') # erros de recepção na primeira amostra
  missed_received_1=$(echo "$rede1" | awk '{print $5}') # pacotes perdidos na recepção na primeira amostra

  bytes_sent_2=$(echo "$rede2" | awk '{print $10}')  # bytes enviados na segunda amostra
  packet_sent_2=$(echo "$rede2" | awk '{print $11}') # pacotes enviados na segunda amostra
  errors_sent_2=$(echo "$rede2" | awk '{print $12}')  # erros de transmissão na segunda amostra
  missed_sent_2=$(echo "$rede2" | awk '{print $13}')  # pacotes perdidos na segunda amostra

  bytes_received_2=$(echo "$rede2" | awk '{print $2}')  # bytes recebidos na segunda amostra
  packet_received_2=$(echo "$rede2" | awk '{print $3}') # pacotes recebidos na segunda amostra
  errors_received_2=$(echo "$rede2" | awk '{print $4}') # erros de recepção na segunda amostra
  missed_received_2=$(echo "$rede2" | awk '{print $5}') # pacotes perdidos na recepção na segunda amostra

  echo "bytes_sent_1: $bytes_sent_1"
  echo "packet_sent_1: $packet_sent_1"
  echo "errors_sent_1: $errors_sent_1"
  echo "missed_sent_1: $missed_sent_1"

  echo "bytes_received_1: $bytes_received_1"
  echo "packet_received_1: $packet_received_1"
  echo "errors_received_1: $errors_received_1"
  echo "missed_received_1: $missed_received_1"

  # Calcular as diferenças entre a primeira e a segunda amostra
  diff_bytes_sent=$((bytes_sent_2 - bytes_sent_1))
  diff_packet_sent=$((packet_sent_2 - packet_sent_1))
  diff_errors_sent=$((errors_sent_2 - errors_sent_1))
  diff_missed_sent=$((missed_sent_2 - missed_sent_1))

  diff_bytes_received=$((bytes_received_2 - bytes_received_1))
  diff_packet_received=$((packet_received_2 - packet_received_1))
  diff_errors_received=$((errors_received_2 - errors_received_1))
  diff_missed_received=$((missed_received_2 - missed_received_1))

  # Salvar os valores no arquivo CSV
  echo "$diff_bytes_sent;$diff_packet_sent;$diff_errors_sent;$diff_missed_sent;$date_time" >> log-download.csv
  echo "$diff_bytes_received;$diff_packet_received;$diff_errors_received;$diff_missed_received;$date_time" >> log-upload.csv
done
