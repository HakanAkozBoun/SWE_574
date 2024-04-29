#!/bin/bash

git pull
cd SWE_574
cd backend
docker compose up --build -d
cd ..