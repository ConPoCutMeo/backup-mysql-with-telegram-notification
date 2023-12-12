# Backup MySQL

Use this script to backup MySQL database and send error notification to Telegram

*NOTE: This script require root permission on MySQL to run.

## Getting started

Fill in your telegram bot ID and chat ID:
```
# Telegram Bot ID
BOT_TOKEN=""
# Telegram Chat ID
CHAT_ID=""
```

If you want to change backup directory:
```
# Go to backup folder
backup_path="/home/backup_db"
cd $backup_path
```