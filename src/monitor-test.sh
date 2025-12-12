#!/bin/bash

CONFIG_DIR="/etc/monitoring-test"
CONFIG_FILE="$CONFIG_DIR/.env"
PROCESS_NAME="${PROCESS_NAME:-test}"
MONITORING_URL="${MONITORING_URL:-https://test.com/monitoring/test/api}"
LOG_FILE="${LOG_FILE:-/var/log/monitoring.log}"
STATE_FILE="${STATE_FILE:-/var/run/monitoring-test.state}"
DEBUG_MODE="${DEBUG_MODE:-0}"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

if [ -f "$CONFIG_FILE" ]; then
    set -o allexport
    source <(grep -v '^#' "$CONFIG_FILE" | grep -v '^$')
    set +o allexport
else
    logger -t "monitoring-test" "ERROR: Конфигурационный файл не найден: $CONFIG_FILE, используются значения по умолчанию"
fi

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    CURRENT_PID=$(pgrep -x "$PROCESS_NAME")
    
    if [ -f "$STATE_FILE" ]; then
        PREVIOUS_PID=$(cat "$STATE_FILE")
        if [ "$CURRENT_PID" != "$PREVIOUS_PID" ]; then
            log_message "Процесс $PROCESS_NAME перезапущен. Старый PID: $PREVIOUS_PID, Новый PID: $CURRENT_PID"
        fi
    fi
    
    echo "$CURRENT_PID" > "$STATE_FILE"
    
    if ! curl --fail-with-body -s -f --retry 3 --retry-delay 1 "$MONITORING_URL" > /dev/null 2>&1; then
        log_message "Сервер мониторинга недоступен: $MONITORING_URL"
    fi
else
    [ -f "$STATE_FILE" ] && rm -f "$STATE_FILE"
fi

exit 0