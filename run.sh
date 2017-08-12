#!/bin/bash
set -m

mongodb_cmd="mongod --storageEngine $STORAGE_ENGINE"
cmd="$mongodb_cmd --httpinterface --rest --master"
if [ "$AUTH" == "yes" ] ; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "no" ] ; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ] ; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

$cmd &

if [ ! -f /data/db/.mongodb_password_set ] ; then
    echo "=> No users found. Setting up users..."
    usr/local/bin/set_mongodb_password.sh
fi
    echo "=> Found users. Good to go!"
fg