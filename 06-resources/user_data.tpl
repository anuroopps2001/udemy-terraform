#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "==== User data started ===="

${docker_install}

${jenkins_install}

echo "===== User data completed ===="
