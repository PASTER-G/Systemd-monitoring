# Systemd Monitoring

Cкрипт на bash для мониторинга процесса test в среде linux.

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
Для удаления системы используйте `sudo bash ./uninstall.sh`

3. Проверка работоспособности:
```bash
# Проверьте статус службы
sudo systemctl status monitor-test.timer

# Просмотрите логи
sudo journalctl -u monitor-test.service -f
sudo cat /var/log/monitoring.log
```
*После установки конфигурационный файл находится по пути: `/etc/monitoring-test/.env`*

## Преимущество **systemd.timer**
- Не теряет задачи при перезагрузке системы
- Запуск с точностью до секунды
- Запуск только после загрузки сети

## Автор

[PASTER-G](https://github.com/PASTER-G)  