#! /bin/sh
chown -R $PUID:$PGID /config

GROUPNAME=$(getent group $PGID | cut -d: -f1)
USERNAME=$(getent passwd $PUID | cut -d: -f1)

if [ ! $GROUPNAME ]
then
        addgroup -g $PGID radarr
        GROUPNAME=radarr
fi

if [ ! $USERNAME ]
then
        adduser -G $GROUPNAME -u $PUID -D radarr
        USERNAME=radarr
fi

su $USERNAME -c '/opt/radarr/Radarr -nobrowser -data=/config'
