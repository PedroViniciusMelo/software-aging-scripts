#!/bin/bash

while true; do
  :
  date_time=$(date +%d-%m-%Y-%H:%M:%S)

  source monitoramento-cpu.sh
  source monitoramento-disco.sh
  source monitoramento-mem.sh
  source monitoramento-zumbis.sh

  sleep 1
done