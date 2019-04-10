#!/bin/sh
set -e

docker build -t unregistry .
docker run -p 8000:80 unregistry
