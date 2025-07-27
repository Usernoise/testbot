#!/bin/bash
cd /***/testbot

echo "$(date): Обновление кода..." >> restart.log
git reset --hard >> restart.log 2>&1
git pull origin main >> restart.log 2>&1

echo "$(date): Остановка старого процесса..." >> restart.log
pkill -f testbot.py >> restart.log 2>&1 || true
sleep 3

echo "$(date): Запуск нового процесса..." >> restart.log
nohup /***/testbot/venv/bin/python /***/testbot/testbot.py > /***/testbot/log.txt 2>&1 &
NEW_PID=$!
echo "$(date): Бот запущен с PID: $NEW_PID" >> restart.log

sleep 2
if kill -0 $NEW_PID 2>/dev/null; then
    echo "$(date): Бот успешно запущен" >> restart.log
else
    echo "$(date): Ошибка запуска бота" >> restart.log
fi