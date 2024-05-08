#!/bin/bash

git pull
cd backend
docker compose down
docker compose up --build -d
cd ..
