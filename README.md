# Systemd Monitoring

Cкрипт на bash для мониторинга процесса test в среде Linux. Проект использует logrotate для ротации логов, архивируя логи при достижении критического размера log файла (10Mb).

## Структура проекта
```
.
├── .env.example             # Пример конфигурации (скопировать в .env)
├── test.sh                  # Скрипт создания тестового процесса
├── install.sh               # Скрипт установки
├── uninstall.sh             # Скрипт удаления
├── README.md                # Документация
└── src/
    ├── monitor-test.sh      # Основной скрипт мониторинга
    ├── monitor-test.service # Systemd service файл
    └── monitor-test.timer   # Systemd timer файл (запуск каждую минуту)
```

## Установка и удаление
1. Клонирование и настройка:
```bash
# Клонируйте репозиторий
git clone https://github.com/PASTER-G/Systemd-monitoring.git
cd Systemd-monitoring

# Создайте конфигурационный файл на основе примера
cp .env.example .env

# Настройте параметры
nano .env
```
2. Установка:
```bash
# Запустите скрипт для создания тестового процесса, затем запустите установочный скрипт
sudo ./test.sh

sudo bash ./install.sh
```
*Для полного удаления проекта с хоста используйте `sudo bash ./uninstall.sh`*

*После установки конфигурационный файл находится по пути: `/etc/monitoring-test/.env`*

3. Проверка работоспособности:
```bash
# Проверьте статус службы
sudo systemctl status monitor-test.timer

# Просмотрите логи
sudo journalctl -u monitor-test.service -f
sudo cat /var/log/monitoring.log

# Ротацию логов можно вызвать принудительно
sudo logrotate -f /etc/logrotate.d/monitoring
```

## Преимущество **systemd.timer**
- Не теряет задачи при перезагрузке системы
- Запуск с точностью до секунды
- Запуск только после загрузки сети

## Автор

[PASTER-G](https://github.com/PASTER-G)  