dump -f - / | ssh edwin@file-server -i /root/.ssh/private_key "cat > /path/root-`date '+%Y-%m-%d'`.dump"
