#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
PID_FILE="/var/run/${PROCESS_NAME}_monitoring.pid"
# ----------------------------------------------------

log_message() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

CURRENT_PID=$(ps aux | grep "$PROCESS_NAME".service | awk '{print $2}')	#pgrep не получилось поэтому использую такую большую команду
if [ -n "$CURRENT_PID" ]; then
	if [ -f "$PID_FILE" ]; then
		LAST_PID=$(cat "$PID_FILE")
		if [ "$CURRENT_PID" != "$LAST_PID" ]; then
			log_message "INFO: Process '$PROCESS_NAME' was restarted."
		fi
	fi
	echo "$CURRENT_PID" > "$PID_FILE"

	HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$MONITORING_URL")
	CURL_EXIT_CODE=$?
	
	if [ $CURL_EXIT_CODE -ne 0 ]; then
		log_message "ERROR: Monitoring server is unavailable."
	elif [ "$HTTPS_STATUS" -ge 400 ]; then
		log_message "WARNING: Monitoring server returned error status code: $HTTPS_STATUS."
	fi
else
	if [ -f "$PID_FILE" ]; then
		rm "$PID_FILE"
	fi
fi
