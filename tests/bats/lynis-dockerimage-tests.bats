#!/usr/bin/env bats

LYNIS_VERSION=2.1.0
@test "The installed version of lynis is ${LYNIS_VERSION}" {
	FOUND_VERSION=$(docker run "${DOCKER_IMAGE_NAME}" --version)
	[ "${FOUND_VERSION}" == "${LYNIS_VERSION}" ]
}

ALPINE_VERSION=3.2
@test "We use the alpine linux version ${ALPINE_VERSION}" {
	[ $(docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "grep VERSION_ID /etc/os-release | grep -e \"=${ALPINE_VERSION}.\" | wc -l") -eq 1 ]
}
