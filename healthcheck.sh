#!/bin/bash

LOG_FILE="healthlog.txt"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

{
  echo "============================================="
  echo "System Health Check - $TIMESTAMP"
  echo "============================================="

  echo "System Date and Time: $(date)"
  echo

  echo "System Uptime:"
  uptime
  echo

  echo "CPU Load:"
  uptime | awk -F'load average:' '{ print $2 }'
  echo

  echo "Memory Usage (in MB):"
  free -m
  echo

  echo "Disk Usage:"
  df -h
  echo

  echo "Top 5 Memory Consuming Processes:"
  ps aux --sort=-%mem | head -n 6
  echo

  echo "Service Status Check (nginx, ssh):"
  for service in nginx ssh; do
    if command -v systemctl >/dev/null 2>&1; then
      systemctl is-active --quiet $service && echo "$service: Running" || echo "$service: Not Running"
    else
      pgrep -x $service >/dev/null 2>&1 && echo "$service: Running" || echo "$service: Not Running"
    fi
  done
  echo

  echo "Health check completed at: $TIMESTAMP"
  echo "============================================="

} | tee "$LOG_FILE"
