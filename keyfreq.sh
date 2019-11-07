#!/bin/bash


# logs the key press frequency over 9 second window. Logs are written
# in logs/keyfreqX.txt every 9 seconds, where X is unix timestamp of 7am of the
# recording day.

LANG=en_US.utf8

helperfile='/dev/shm/keyfreqraw.txt'

mkdir -p logs

while true
do
  timeout 9 xinput test "${ULOGME_KEYBOARD_ID:-11}" | tr -d '0-9' > "$helperfile"

  ## In case you can not get `xinput` to work. Note that you will need to run `showkey` as root.
  # timeout 9 showkey | tr -d '0-9' > $helperfile

  # Count number of key release events
  num="$(grep --count release "$helperfile")"

  # Append unix time stamp and the number into file
  logfile="logs/keyfreq_$(python rewind7am.py).txt"
  echo "$(date +%s) $num" >> "$logfile"
  echo "logged key frequency: $(date) $num release events detected into $logfile"
done
