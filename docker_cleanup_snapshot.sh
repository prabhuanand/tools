#!/bin/sh

# This will have the last 2 built images for every docker image.

docker images | awk '{print $1}' | sort | uniq > /tmp/_snapshot

for i in `cat /tmp/_snapshot`
do
	echo "Cleaning up Docker image: $i"
	docker images | grep -i $i  | tail -n +3 | xargs docker rmi -f
done
