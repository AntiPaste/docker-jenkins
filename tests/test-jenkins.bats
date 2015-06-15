#! /usr/bin/env bats

setup() {
  # Setup environment
  SLEEP=30
  host=$(echo $DOCKER_HOST|cut -d":" -f2|sed -e 's/\/\///')

  # Launch container
  docker run -d --name ${IMAGE} -P ${IMAGE}:${TAG}
  port=$(docker port ${IMAGE} | grep 8080 | cut -d":" -f2)
  url="http://${host}:${port}"
}

teardown () {
  # Cleanup
  docker stop ${IMAGE} >/dev/null
  docker rm ${IMAGE} >/dev/null
}

@test "Check Jenkins status" {
  sleep $SLEEP
  run curl --retry 10 --retry-delay 5 --silent --output /dev/null --location --head --write-out "%{http_code}" $url
  [[ "$output" =~ "200" ]]
}
