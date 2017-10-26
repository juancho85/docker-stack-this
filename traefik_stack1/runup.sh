#!/usr/bin/env bash

set -o errexit
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -o errtrace
set -o nounset

###############################################################################
# Functions
###############################################################################

# Stop
echo; echo "If existing, remove stacks: "
./rundown.sh

# Create Network
echo; echo "If not existing, create our network: "

if [ ! "$(docker network ls --filter name=ntw_front -q)" ];then
  docker network create --driver overlay --subnet 10.11.10.0/24 --opt encrypted ntw_front
  sleep 2
fi

echo; echo "Show network..."
docker network ls | grep "ntw_"
echo; echo; sleep 2

# The Stack
echo "Start the stacks ..."; echo; echo;

# traefik
docker stack deploy toolproxy -c toolproxy.yml
echo; echo; sleep 2

# webapps
docker stack deploy toolweb -c toolweb.yml
echo; echo; sleep 2

# portainer
docker stack deploy toolmonitor -c toolportainer.yml
echo; echo; sleep 2

# wordpress
#docker stack deploy proxpress -c toolwordpress.yml
#echo; echo; sleep 2


# List
echo; echo "docker stack ls ..."
docker stack ls;
echo; echo ; sleep 2


# Follow deployment in real time
#watch docker service ls
echo; echo;

MIN=1
MAX=8
for ACTION in $(seq $MIN $MAX); do
  echo
  echo "docker service ls | Check $ACTION" of $MAX; echo;
  docker service ls && echo && sleep 2;
done
echo; echo ; sleep 2

# See Traefik logs
echo "To see Traefik logs type: "; sleep 1;
echo "  docker service logs -f toolproxy_traefik"; echo; sleep 1;

# by Pascal Andy | # https://twitter.com/askpascalandy
# https://github.com/pascalandy/docker-stack-this
#