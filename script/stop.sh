#!/bin/sh
# ./stop.sh

docker stop -t 1 hscore
docker rm hscore
