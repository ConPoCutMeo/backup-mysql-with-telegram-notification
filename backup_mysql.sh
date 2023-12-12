#!/bin/bash

# FUNCTION SEND ALERT TO TELEGRAM =====================================================================================
function send_alert() {
MESSAGE=$(cat << message
- Message : BACKUP DATABASE ERROR
- Host : $db_host
- Database : $db
- Status : 🔴 Dump Error
- Timestamp : $time
- Result : $1
message
)

# Telegram Bot ID
BOT_TOKEN=""
# Telegram Chat ID
CHAT_ID=""
# Send message
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" &> /dev/null
}

# DECLARE VARIABLES ====================================================================================================
# Get timestamp
time=$(date +"%d-%m-%Y %H:%M:%S")

# Go to backup folder
backup_path="/home/backup_db"
cd $backup_path

# Get database hostname
db_host="$(mysql -Bse "select @@hostname;")"

# Get database list
db_list="$(mysql -Bse 'show databases' | grep -v 'performance_schema\|information_schema\|mysql\|sys\|Database')"

# Variables to summary dump process
success=0
error=0

# MAIN PART: DUMP DATABASE AND LOGGING =================================================================================
for db in ${db_list[@]};
do 
    # Dump command
    mysqldump --single-transaction --quick $db 2> "$db"_error.log | gzip > "$db".sqld.gz
    
    # If error happen, send to telegram
    if [ -s "$db"_error.log ]; then
        send_alert "$(cat "$db"_error.log)"
        ((error+=1))
    else    
	    ((success+=1))
    fi

done

# SEND SUMMARY TO TELEGRAM & WRITE SUMMARY TO FILE: summary.log ==========================================================
 SEND SUMMARY TO TELEGRAM
MESSAGE=$(cat << message
========================                          
Date: $time                                
- Total DB : $(echo "$db_list" | wc -l)       
- Dump success : $success                            
- Dump error : $error                           
message
)

# Write summary to file summary.log
echo -e "$MESSAGE" >> summary.log

# Telegram Bot ID
BOT_TOKEN=""
# Telegram Chat ID
CHAT_ID=""
# Send message
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" &> /dev/null