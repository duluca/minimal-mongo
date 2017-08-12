# Mongo Docker
Dockerfile and scripts to setup a production ready Mongo container

> Inspired by http://blog.bejanalex.com/2017/03/running-mongodb-in-a-docker-container-with-authentication/

## Key features:
- Uses the official `mongo` docker image as the base
- Sets storage engine as the latest *wiredTiger*
- *Enables* journaling
- *Enables* authentication
- *Creates* default admin user, if it doesn't already exist
- Scripts to deploy this image to your own *AWS ECS* cluster

## Quick Start
- `npm install` to get dependencies
- `npm run docker:build` to build the Docker image
- `npm run docker:debug` to build and debug the Docker image

> **Note:** To persist data you must link `/data/db` to a location where the data will persist if this image is stopped. See the `yml` file below as an example.

## Sample Usage with docker-compose
Full source code: https://github.com/excellalabs/minimal-mean

docker-compose.yml
```yml
version: '3'

services:
  web-app:
    build: web-app
    ports:
      - '8080:3000'

  server:
    build: server
    environment:
      - MONGO_URI=mongodb://database/minimal-mean
    ports:
      - '3000:3000'
    depends_on:
      - database
    links:
      - database

  database:
    image: excellalabs/mongo
    env_file: .env
    ports:
      - '27017:27017'
    volumes:
      - '/my/own/datadir:/data/db'
```

## TODO
- [ ] Do not run `mongod` as root user
- [ ] Enabled `SSH` capability