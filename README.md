# Mongo Docker
Dockerfile and scripts to setup a production ready Mongo container with authentication and SSL configuration

> Inspired by http://blog.bejanalex.com/2017/03/running-mongodb-in-a-docker-container-with-authentication/

## Key features:
- Uses the official `mongo` docker image as the base
- Sets storage engine as the latest *wiredTiger*
- *Enables* journaling
- *Enables* authentication
- *Creates* default admin user, if it doesn't already exist
- Scripts to deploy this image to your own *AWS ECS* cluster

## Setup
- Define a `.env` file at the root of the project and set the MongoDB admin passowrd. Do NOT commit this file.
```Bash
MONGODB_ADMIN_PASS=your_password_goes_here
MONGODB_APPLICATION_DATABASE=app_db_name
MONGODB_APPLICATION_USER=app_user
MONGODB_APPLICATION_PASS=app_password
```

## Quick Start
- `npm install` to get dependencies
- `npm run docker:build` to build the Docker image
- `npm run docker:debug` to build and debug the Docker image

> **Note:** To persist data you must link `/data/db` to a location where the data will persist if this image is stopped. See the `yml` file below as an example.

- Use `npm run docker:runMount` to enable data persistance with this image

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

## Mounting to AWS EFS
If you're using AWS ECS as your container host, then your data needs to reside on AWS EFS. Setting this up correctly, so you can easily mount your '/data/db' volume to EFS can be complicated. Check out this [step-by-step guide](https://gist.github.com/duluca/ebcf98923f733a1fdb6682f111b1a832#file-awc-ecs-access-to-aws-efs-md) that will help you do just that, including how to create an AWS ECS Cluster from scratch.

## TODO
- [ ] Do not run `mongod` as root user
- [ ] Enabled `SSH` capability
