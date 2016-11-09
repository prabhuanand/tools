#!/bin/sh

# This will have the last 2 built images.

docker images | grep -i SNAPSHOT | awk '{print $1}' | sort | uniq > /tmp/_snapshot

for i in `cat /tmp/_snapshot`
do
	echo "Cleaning up Docker image: $i"
	docker images | grep -i SNAPSHOT | grep -i $i  | tail -n +3 | xargs docker rmi -f
done
