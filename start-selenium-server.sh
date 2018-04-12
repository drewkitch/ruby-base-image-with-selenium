#!/bin/bash

set -e

java -jar /selenium-server.jar -port $SELENIUM_PORT 2>&1 &
sleep 5

eval "$@"
