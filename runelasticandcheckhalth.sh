#!/bin/bash
#set -x
if [ $# -ne 1 ]; then
  echo 1>&2 "Usage: $0 run|checkstatus"
  exit 1
fi
checkcommand() {
  hash $1 >/dev/null 2>&1
}
throw_error() {
  echo $1 ' :: Unexpected error occured..'
  exit 1
}
checkpackage() {
  if ! checkcommand $1; then
#    echo " $1 exists .. continuing.. "
#  else
   if [ $1 == "docker" ]; then
    sudo apt install docker.io
    result="$?"
    throw_error result " cannot install docker engine .. exiting .."
    exit 1
   else
     sudo apt install $1
    result="$?"
    throw_error result " cannot install $1 .. exiting .."
    exit 1
  fi
  fi
}
checkcommandreturn() {
  if [ "$result" -ne 0 ]; then
    echo "$2"
fi
}
if [ $1 == "run" ]; then
echo "checking docker on machine."
checkpackage docker
echo "running elasticsearch in docker.."
 if  docker inspect -f '{{.State.Running}}' elastic >/dev/null; then
   docker stop elastic >/dev/null
   docker rm elastic >/dev/null
 fi
docker run -d  -p 9200:9200 --name elastic -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.7.0
result="$?"
checkcommandreturn result " cannot run elasticsearch container .. exiting .."
echo 'started elasticsearch container ..'

  elif [ $1 == "checkstatus" ]; then
     checkpackage jq
     Status=$(curl -XGET localhost:9200/_cluster/health 2>/dev/null|jq '.status' )
#     Status=$(docker inspect elastic | jq '.[0]|.State.Status' )
     echo "ElasticSearch Status : " $Status
 else
   throw_error "Illegal Arguments passed. valid values: run and checkstatus for executing elasticsearch container and monitoring health "
  fi

