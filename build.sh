#!/bin/bash

docker login

docker build -t adomenech73/azkaban-executor:3.84.15 azkaban-executor
docker push adomenech73/azkaban-executor:3.84.15
docker build -t adomenech73/azkaban-webserver:3.84.15 azkaban-webserver
docker push adomenech73/azkaban-webserver:3.84.15
docker build -t adomenech73/azkaban-mariadb:10 mariadb
docker push adomenech73/azkaban-mariadb:10