#!/bin/sh

set I_REALLY_WANT_VOLATILE_STORAGE=true

echo "Copy backuped state to /data ..."
cp -r ./data_back/current/* ./data || :
echo "Copy backuped state to /data ... [done]"

if [ -r /etc/vaultwarden.sh ]; then
    . /etc/vaultwarden.sh
elif [ -r /etc/bitwarden_rs.sh ]; then
    echo "### You are using the old /etc/bitwarden_rs.sh script, please migrate to /etc/vaultwarden.sh ###"
    . /etc/bitwarden_rs.sh
fi

if [ -d /etc/vaultwarden.d ]; then
    for f in /etc/vaultwarden.d/*.sh; do
        if [ -r "${f}" ]; then
            . "${f}"
        fi
    done
elif [ -d /etc/bitwarden_rs.d ]; then
    echo "### You are using the old /etc/bitwarden_rs.d script directory, please migrate to /etc/vaultwarden.d ###"
    for f in /etc/bitwarden_rs.d/*.sh; do
        if [ -r "${f}" ]; then
            . "${f}"
        fi
    done
fi

function gracefulShutdown {
    echo "Save backup to /data_back/current ..."
    dir = date +'back_%Y%m%d_%H%M'
    mv ./data_back/current ./data_back/$dir
    mkdir ./data_back/current  # create if not exists
    cp -r ./data/* ./data_back/current
    echo "Save backup to /data_back ... [done]"
}
trap gracefulShutdown SIGTERM

exec /vaultwarden "${@}"
wait
