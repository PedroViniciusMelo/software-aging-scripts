#!/bin/bash

disco=$(df | grep /dev/sda1)
usado=$(echo $disco | awk '{print $3}')

echo "$usado;$date_time" >>logs/monitoramento-disco.csv

