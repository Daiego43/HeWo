HEWO_USER=daiego
HEWO_HOST=192.168.1.117
HEWO_PASS=daiego1234
sshpass -p "$HEWO_PASS" rsync -avz ./* $HEWO_USER@$HEWO_HOST:/home/$HEWO_USER/HeWo