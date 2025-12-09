#!/bin/bash

set -e
echo "Установка системы мониторинга..."

if [ "$EUID" -ne 0 ]; then 
    echo "Пожалуйста, запустите скрипт с правами root: sudo $0"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "Установка curl..."
    apt-get update && apt-get install -y curl || yum install -y curl || dnf install -y curl
fi

echo "Создание директорий..."
mkdir -p /usr/local/bin
mkdir -p /etc/systemd/system

echo "Создание директории для конфигурации..."
mkdir -p /etc/monitoring-test

if [ ! -f /etc/monitoring-test/.env ]; then
    echo "Копирование конфигурационного файла..."
    if [ -f .env ]; then
        cp .env /etc/monitoring-test/.env
    else
        cp .env.example /etc/monitoring-test/.env
    fi
    echo "Создан конфигурационный файл: /etc/monitoring-test/.env"
    echo "Отредактируйте его при необходимости: sudo nano /etc/monitoring-test/.env"
else
    echo "Конфигурационный файл уже существует, оставляем без изменений."
fi

echo "Копирование скрипта мониторинга..."
cp src/monitor-test.sh /usr/local/bin/
chmod +x /usr/local/bin/monitor-test.sh

echo "Копирование файлов systemd..."
cp src/monitor-test.service /etc/systemd/system/
cp src/monitor-test.timer /etc/systemd/system/

echo "Создание файла лога..."
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log

echo "Перезагрузка systemd..."
systemctl daemon-reload

echo "Запуск службы мониторинга..."
systemctl enable monitor-test.timer
systemctl start monitor-test.timer

echo "Установка завершена!"
echo ""
echo "Полезные команды:"
echo "  Статус службы:    sudo systemctl status monitor-test.timer"
echo "  Просмотр логов:   sudo tail -f /var/log/monitoring.log"
echo "  Конфигурация:     sudo nano /etc/monitoring-test/.env"
echo ""
echo "Для изменения конфигурации отредактируйте /etc/monitoring-test/.env"