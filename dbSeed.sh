#!/bin/bash
curl -X POST -d "{\"name\":\"Tim\"}" -H "Content-Type: application/json" localhost:8080/api/users/create
curl -X POST -d "{\"name\":\"Rob\"}" -H "Content-Type: application/json" localhost:8080/api/users/create
curl -X POST -d "{\"description\":\"Washing up liquid, tuna\", \"title\": \"Shopping List\", \"user_id\": 1, \"categories\": [\"Shopping\", \"Family\"]}" -H "Content-Type: application/json" localhost:8080/api/reminders/create
curl -X POST -d "{\"description\":\"Buy new printer ink cartridges\", \"title\": \"Printer cartridges\", \"user_id\": 1, \"categories\": [\"Shopping\"]}" -H "Content-Type: application/json" localhost:8080/api/reminders/create
