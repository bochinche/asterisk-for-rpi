#!/bin/bash

# Place in /etc/profile.d

# Display kernel / userland bit-size
# Wait For Time Synchronization

if [[ $- == *i* ]]; then
  echo ""
  if [ "$(uname -m)" = "aarch64" ]; then
    echo -n "64"
  else
    echo -n "32"
  fi
  echo -n "-bit kernel / "
  if [ "$(dpkg --print-architecture)" = "arm64" ]; then
    echo -n "64"
  else
    echo -n "32"
  fi
  echo "-bit userland"

: <<'EOF'

  trap '{ stty sane; ABORT=TRUE; }' SIGINT SIGTERM
  echo -n "Waiting for time to be synchronized"
  ABORT=FALSE
  COUNT=35
  while [ ! -f "/run/systemd/timesync/synchronized" ]
  do
    if [ "${ABORT}" = "TRUE"  ]; then
    (( COUNT += 2 ))
      break
    fi
    echo -n "."
    (( COUNT += 1 ))
    sleep 1
  done
  while [ ${COUNT} -ne 0 ]
  do
    echo -n -e "\b \b"
    (( COUNT -= 1 ))
  done
  if [ "${ABORT}" = "TRUE"  ]; then
    echo "Time may not be synchronized!"
  fi

EOF

fi
