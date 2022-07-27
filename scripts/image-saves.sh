#!/bin/bash

img_lst=$(docker images "${IMAGE_FAMILY}*" --format "{{.Repository}}:{{.Tag}}" | grep ${TAG} | awk 1 ORS=' ')
docker save "$img_lst" | gzip > "${IMAGE_FAMILY}.tar.gz"