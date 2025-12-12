#!/bin/bash

set -e

echo "Удаление системы мониторинга..."

if [ "$EUID" -ne 0 ]; then 
    echo "Пожалуйста, запустите скрипт с правами root: sudo $0"
    exit 1
fi

echo "Остановка служб..."
systemctl stop monitor-test.timer 2>/dev/null || true
systemctl disable monitor-test.timer 2>/dev/null || true

echo "Удаление файлов systemd..."
rm -f /etc/systemd/system/monitor-test.service
rm -f /etc/systemd/system/monitor-test.timer

echo "Удаление скрипта..."
rm -f /usr/local/bin/monitor-test.sh

echo "Удаление временных файлов..."
rm -f /var/run/monitoring-test.state

echo "Перезагрузка systemd..."
systemctl daemon-reload

echo "Удаление завершено!"
echo ""
echo "Оставшиеся файлы (удалите вручную при необходимости):"
echo "  Конфигурация: /etc/monitoring-test/.env"
echo "  Логи: /var/log/monitoring.log"
echo ""
read -p "Удалить конфигурацию и логи? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f /etc/logrotate.d/monitoring
    rm -f /etc/logrotate.d/test-process
    rm -rf /etc/monitoring-test
    rm -f /var/log/monitoring.log*
    echo "Конфигурация и логи удалены."
fi