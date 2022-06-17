FROM mongo:4.2.18

ENV MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD}

ENV MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE}
ENV MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_DATABASE}
ENV MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_DATABASE}

ADD set_mongodb_password.sh docker-entrypoint-initdb.d/
