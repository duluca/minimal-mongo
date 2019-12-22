# Mongo Docker

Dockerfile and scripts to setup a production ready Mongo container with user authentication and SSL configuration

> Example project https://github.com/duluca/lemon-mart-server

## Key features:

* Uses the official `mongo` docker image as the base
* _Enables_ configuring an application database and user/password
* _Creates_ default admin user, if it doesn't already exist
* Scripts to deploy this image to your own _AWS ECS_ cluster

## Setup

* Define a `.env` file at the root of the project and set the MongoDB admin passowrd. Do NOT commit this file.

```Bash
MONGO_INITDB_ROOT_USERNAME=admin_user
MONGO_INITDB_ROOT_PASSWORD=admin_password
MONGODB_APPLICATION_DATABASE=app_db_name
MONGODB_APPLICATION_USER=app_user
MONGODB_APPLICATION_PASS=app_password
```

## Quick Start

* `npm install` to get dependencies
* `npm run docker:build` to build the Docker image
* `npm run docker:debug` to build and debug the Docker image

> **Note:** To persist data you must link `/data/db` to a location where the data will persist if this image is stopped. See the `yml` file below as an example.

* Use `npm run docker:runMount` to enable data persistance with this image

## Sample Usage with docker-compose

Full source code: https://github.com/duluca/lemon-mart-server

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
    image: duluca/mongo
    env_file: .env
    ports:
      - '27017:27017'
    volumes:
      - '/my/own/datadir:/data/db'
```

## Mounting to AWS EFS

If you're using AWS ECS as your container host, then your data needs to reside on AWS EFS. Setting this up correctly, so you can easily mount your '/data/db' volume to EFS can be complicated. Check out this [step-by-step guide](https://gist.github.com/duluca/ebcf98923f733a1fdb6682f111b1a832#file-awc-ecs-access-to-aws-efs-md) that will help you do just that, including how to create an AWS ECS Cluster from scratch.

## TODO

* [ ] Enable `SSH` capability: https://docs.mongodb.com/manual/tutorial/configure-ssl/
* [ ] Switch to Alpine-based OS https://hub.docker.com/r/mvertes/alpine-mongo 
* [ ] Alpine-only:  For AWS ECS use install  nfs-utils in the container per https://gist.github.com/duluca/ebcf98923f733a1fdb6682f111b1a832#gistcomment-3083340

> Inspired by http://blog.bejanalex.com/2017/03/running-mongodb-in-a-docker-container-with-authentication/
