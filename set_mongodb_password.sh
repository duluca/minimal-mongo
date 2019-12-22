#!/bin/bash

# Admin User
MONGODB_ADMIN_USER=${MONGO_INITDB_ROOT_USERNAME:-"admin"}
MONGODB_ADMIN_PASS=${MONGO_INITDB_ROOT_PASSWORD:-""}

# Application Database User
MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-""}
MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_USER:-""}
MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-""}

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
  echo "=> Waiting for confirmation of MongoDB service startup..."
  sleep 5
  mongo admin --eval "help" >/dev/null 2>&1
  RET=$?
done

if [ "$MONGODB_APPLICATION_DATABASE" != "admin" ]; then
  echo "=> Creating an ${MONGODB_APPLICATION_DATABASE} user with a password in MongoDB"
  mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS <<EOF
use $MONGODB_APPLICATION_DATABASE
db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'dbOwner', db:'$MONGODB_APPLICATION_DATABASE'}]})
EOF

  echo "========================================================================"
  echo "$MONGODB_APPLICATION_USER user created in $MONGODB_APPLICATION_DATABASE! PROTECT the password found in the .env file."
  echo "========================================================================"
else
  echo "=> Skipping App database and user creation."
fi

sleep 1

echo "=> Done!"
