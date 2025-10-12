# Скрипт мониторинга

Решение для тестового задания по мониторингу процесса 'test' в среде Linux. Скрипт запускается по расписанию через systemd.timer.

## Выполнены требования:
1. **Автозапуск и расписание:** Скрипт запускается каждую минуту с помощью systemd.timer.
2.  **Проверка процесса и API:** Скрипт проверяет запуск процесса `test` и обращается к API-серверу (`https://test.com/...`).
3.  **Логирование перезапуска:** Смена PID процесса 'test' фиксируется как перезапуск.
4.  **Логирование ошибок:** Ошибки curl (недоступность сервера) и HTTP-ошибки (статусы >= 400) записываются в лог.

## Установка и запуск
Решение протестировано на Ubuntu (systemd).

### 1. Подготовка файлов
Скопируйте скрипт и юниты в соответствующие системные директории:

```bash
sudo cp monitoring.sh /usr/local/bin/
sudo cp test.service /etc/systemd/system/
sudo cp test.timer /etc/systemd/system/
```
### 2. Права и логи
Убедитесь, что скрипт имеет права на выполнение, и создайте пустой лог-файл:
```bash
sudo chmod +x /usr/local/bin/monitoring.sh
sudo touch /var/log/monitoring.log
# Установите права, чтобы systemd мог писать в лог
sudo chmod 664 /var/log/monitoring.log
```

### 3. Активация systemd
Перезагрузите конфигурацию, включите и запустите таймер:
```bash
sudo systemctl daemon-reload
sudo systemctl enable test.timer
sudo systemctl start test.timer
```

## Проверка статуса
**Проверка статуса таймера:** `systemctl status test.timer`
**Проверка лога:** `sudo cat /var/log/monitoring.log`

# Совет по улучшению кода
В строке, где логируем предупреждение, переменная `MONITORING_URL` не выводится(если тестируете несколько серверов, то стоит добавить).
```bash
log_message "WARNING: Monitoring server returned error status code: $HTTP_STATUS. URL: $MONITORING_URL"
```
