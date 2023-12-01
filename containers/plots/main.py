import pandas as pd
import matplotlib.pyplot as plt

# Leitura dos arquivos CSV
download_data = pd.read_csv('/home/pedro/projetos/software-aging-scripts/containers/plots/log-download.csv', delimiter=';')
upload_data = pd.read_csv('/home/pedro/projetos/software-aging-scripts/containers/plots/log-upload.csv', delimiter=';')

# Converter a coluna date_time para o formato datetime
download_data['date_time'] = pd.to_datetime(download_data['date_time'], format='%d-%m-%Y-%H:%M:%S')
upload_data['date_time'] = pd.to_datetime(upload_data['date_time'], format='%d-%m-%Y-%H:%M:%S')

# Calcular a diferença em segundos a partir do primeiro ponto
download_data['time_seconds'] = (download_data['date_time'] - download_data['date_time'].iloc[0]).dt.total_seconds()
upload_data['time_seconds'] = (upload_data['date_time'] - upload_data['date_time'].iloc[0]).dt.total_seconds()

# Plotagem dos gráficos para os dados de bytes
plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.plot(download_data['time_seconds'], download_data['bytes_received'], label='Download - Bytes Received', color='orange')
plt.xlabel('Time (seconds)')
plt.ylabel('Bytes')
plt.title('Download - Bytes Received')
plt.legend()
plt.tight_layout()

plt.subplot(1, 2, 2)
plt.plot(upload_data['time_seconds'], upload_data['bytes_sent'], label='Upload - Bytes Sent', color='blue')
plt.xlabel('Time (seconds)')
plt.ylabel('Bytes')
plt.title('Upload - Bytes Sent')
plt.legend()
plt.tight_layout()

plt.show()

# Plotagem dos gráficos para os dados de pacotes
plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.plot(download_data['time_seconds'], download_data['packet_received'], label='Download - Packets Received', color='orange')
plt.xlabel('Time (seconds)')
plt.ylabel('Packets')
plt.title('Download - Packets Received')
plt.legend()
plt.tight_layout()

plt.subplot(1, 2, 2)
plt.plot(upload_data['time_seconds'], upload_data['packet_sent'], label='Upload - Packets Sent', color='blue')
plt.xlabel('Time (seconds)')
plt.ylabel('Packets')
plt.title('Upload - Packets Sent')
plt.legend()
plt.tight_layout()

plt.show()

# Gráfico para erros e pacotes perdidos
if download_data['errors_received'].sum() > 0 or upload_data['errors_sent'].sum() > 0 or download_data['missed_received'].sum() > 0 or upload_data['missed_sent'].sum() > 0:
    plt.figure(figsize=(8, 5))

    plt.plot(download_data['time_seconds'], download_data['errors_received'], label='Download - Errors Received', color='orange')
    plt.plot(upload_data['time_seconds'], upload_data['errors_sent'], label='Upload - Errors Sent', color='blue')
    plt.plot(download_data['time_seconds'], download_data['missed_received'], label='Download - Missed Received', color='orange', linestyle='dashed')
    plt.plot(upload_data['time_seconds'], upload_data['missed_sent'], label='Upload - Missed Sent', color='blue', linestyle='dashed')
    plt.xlabel('Time (seconds)')
    plt.ylabel('Values')
    plt.title('Errors and Missed Packets')
    plt.legend()
    plt.tight_layout()
    plt.show()
else:
    print("Não houve erros ou pacotes perdidos nos dados.")

