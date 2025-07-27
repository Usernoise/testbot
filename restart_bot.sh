#!/bin/bash
set -e

LOG_FILE="/root/testbot/restart.log"
BOT_DIR="/root/testbot"
VENV_PYTHON="$BOT_DIR/venv/bin/python"
BOT_SCRIPT="$BOT_DIR/testbot.py"
BOT_LOG="$BOT_DIR/log.txt"

cd "$BOT_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S'): Начинаем обновление бота..." >> "$LOG_FILE"

echo "$(date '+%Y-%m-%d %H:%M:%S'): Сброс локальных изменений и очистка..." >> "$LOG_FILE"
git reset --hard origin/main >> "$LOG_FILE" 2>&1
git clean -fd >> "$LOG_FILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S'): Обновление кода..." >> "$LOG_FILE"
git pull origin main >> "$LOG_FILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S'): Остановка старого процесса..." >> "$LOG_FILE"
pkill -f testbot.py >> "$LOG_FILE" 2>&1 || true
sleep 3

echo "$(date '+%Y-%m-%d %H:%M:%S'): Запуск нового процесса..." >> "$LOG_FILE"
nohup "$VENV_PYTHON" "$BOT_SCRIPT" > "$BOT_LOG" 2>&1 &
NEW_PID=$!
echo "$(date '+%Y-%m-%d %H:%M:%S'): Бот запущен с PID: $NEW_PID" >> "$LOG_FILE"

sleep 2
if kill -0 $NEW_PID 2>/dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Бот успешно запущен" >> "$LOG_FILE"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Ошибка запуска бота" >> "$LOG_FILE"
fi
