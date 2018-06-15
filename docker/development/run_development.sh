#!/usr/bin/env bash
# # API Star Development Environment Runner
# Runs a minimal Debian based image with latest selected python image.
#
# ## Requires:
# * Docker
# * A Debian based Python Image (https://hub.docker.com/_/python/)
#
# ## Features:
# * Change PYTHON_TAG to change python version
# * Every run creates a new clean container with a different name
# * Every run stops and removes the container when exited automatically
# * You can have several containers running at once (different branches, different pythons...)
#
# ## Parameters
# It accepts one parameter or none and it defaults Latest py36: python:slim-stretch
# e.g. for Py35
# ./docker/development/run_development.sh "python:3.5-slim"
# e.g. for Pypy3 (https://hub.docker.com/_/pypy/)
# ./docker/development/run_development.sh "pypy:3-slimm"
#
# Any Debian based with proper py3 or pypy installed can be used

# Init image
if [ -z ${1+x} ]; then
    PYTHON_IMAGE='python:3.6-alpine';
  else
      echo "PYTHON_IMAGE is set to '$1'";
      PYTHON_IMAGE="$1";
fi
now=`date +%Y-%m-%d%H%M%S`
name="apistar_development_runner_${PYTHON_IMAGE//:}_${now}"
echo "Launching container with name: ${name}"
docker run --name apistar-dev \
    -v $(pwd):/uvicorn -v ~/.ssh:/root/.ssh -v ~/.pip:/root/.pip -v ~/.pypirc:/root/.pypirc \
    --name ${name} \
    --rm -it ${PYTHON_IMAGE} \
    sh -c "cd /uvicorn && apk add --update build-base bash && bash scripts/setup && venv/bin/pip install twine && bash"

