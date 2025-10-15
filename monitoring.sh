#!/bin/bash

PROCESS_NAME="test"
MONITORING_URL="http://192.168.11.154"
# ----------------------------------------------------


CURRENT_PID=$(ps aux | grep "$PROCESS_NAME".service | awk '{print $2}') #pgrep не получилось поэтому использую такую большую команду
if [ -n "$CURRENT_PID" ]; then

        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$MONITORING_URL")
        CURL_EXIT_CODE=$?

        if [ $CURL_EXIT_CODE -ne 0 ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') CRITICAL: Сервер мониторинга недоступен (curl exit code $CURL_EXIT_CODE)." >&2
        elif [ "$HTTP_STATUS" -ge 400 ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: API вернул код ошибки $HTTP_STATUS." >&2
        fi
else
        echo "$(date '+%Y-%m-%d %H:%M:%S') INFO: Процесс $PROCESS_NAME не запущен. Проверка API пропущена."
fi
