#!/bin/bash

# Admin User
MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-"admin"}
MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-""}

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]] ; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

if [[ $MONGODB_ADMIN_PASS == "" ]] ; then
  echo "=> You must specifity MONGODB_ADMIN_PASS environment variable in your .env file."
  exit 1
fi

# Create the admin user
echo "=> Creating admin user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"
sleep 3
echo "=> Done!"
touch /data/db/.mongodb_password_set

echo "========================================================================"
echo "$MONGODB_ADMIN_USER user created! PROTECT the password found in the .env file."
echo "========================================================================"