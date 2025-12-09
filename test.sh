#!/bin/bash
# Тестовый процесс для проверки системы мониторинга

LOG_FILE="/var/log/test-process.log"
PID_FILE="/var/run/test.pid"

cleanup() {
    echo "$(date) - Процесс test завершен" >> "$LOG_FILE"
    rm -f "$PID_FILE"
    exit 0
}

trap cleanup SIGTERM SIGINT

if [ "$EUID" -ne 0 ]; then 
    echo "Пожалуйста, запустите процесс с правами root: sudo $0"
    exit 0
fi

echo $$ > "$PID_FILE"

echo "$(date) - Процесс test запущен с PID $$" >> "$LOG_FILE"
echo "Процесс test запущен с PID $$"

counter=0
while true; do
    counter=$((counter + 1))
    echo "$(date) - Процесс test работает, итерация $counter" >> "$LOG_FILE"
    sleep 10
done