$BashScript = @'
# 1. Setup Naming and Timing
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"
START_TIME=$SECONDS

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE

# 2. Run Updates (Logging everything to the file)
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1

# 3. Calculate Duration
DURATION=$((SECONDS - START_TIME))
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE
echo "--- Total Time: $((DURATION / 60))m $((DURATION % 60))s ---" >> $LOG_FILE

# 4. Housekeeping: Delete logs older than 30 days
# This keeps the /var/log/ directory from getting cluttered
sudo find /var/log/ -name "apt-maintenance-*.log" -mtime +30 -delete

# 5. Output the FULL log for PowerShell to capture and upload to Storage
cat $LOG_FILE
'@