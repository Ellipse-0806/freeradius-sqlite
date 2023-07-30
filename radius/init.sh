#!/bin/sh

username=${USERNAME}
password=${PASSWORD}

DB_PATH="/var/lib/data/freeradius.db"
RD_2FA_PATH="/home/$username/.google_authenticator"

set -x

if [ ! -f "$DB_PATH" ]; then
    mkdir /var/lib/data
    sqlite3 "$DB_PATH" < /etc/freeradius/3.0/mods-config/sql/main/sqlite/schema.sql
fi

user_exists=$(sqlite3 "$DB_PATH" "SELECT username FROM radcheck WHERE username='$username';")

if [ -z "$user_exists" ]; then
    hashed_password=$(echo $password | mkpasswd -m sha-512 -s)
    echo "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$username', 'Crypt-Password', ':=', '$hashed_password');" | sqlite3 "$DB_PATH"
else
    echo "User '$username' already exists."
fi

if [ ! -f "$RD_2FA_PATH" ]; then
    mkdir /root/image
    su - $username -c "google-authenticator -t -d -f -r 3 -R 30 -w 17 -q"
    secret_key=$(head -n 1 $RD_2FA_PATH | awk '{print $1}')
    qrencode -o /root/image/qrcode.png "otpauth://totp/radius:$username?secret=$secret_key&issuer=radius"
else
    echo "2FA Account already exists."
fi

exec "$@"