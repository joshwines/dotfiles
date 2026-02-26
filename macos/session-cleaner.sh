#!/bin/bash
LOG=~/Library/Logs/cloudsessioncleaner.log
echo "[`date`] Starting cleanup" >> $LOG
SIZE_BEFORE=$(du -sh ~/Library/Application\ Support/CloudDocs/session 2>/dev/null | awk '{print $1}')
if [ $(du -sk ~/Library/Application\ Support/CloudDocs/session 2>/dev/null | awk '{print $1}') -gt 5000000 ]; then
  rm -rf ~/Library/Application\ Support/CloudDocs/session
  echo "[`date`] Deleted session cache. Freed $SIZE_BEFORE" >> $LOG
  osascript -e 'display notification "Deleted iCloud session cache >5GB" with title "Auto Cleanup"'
else
  echo "[`date`] No cleanup needed. Size was $SIZE_BEFORE" >> $LOG
fi
