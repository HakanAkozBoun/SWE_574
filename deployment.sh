#!/bin/bash

git pull
cd backend
docker compose up --build -d
cd ..
