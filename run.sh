#!/bin/bash

set -e

ls -alh

cd github/$KOKORO_DIR/

source ./steps/hostsetup.sh
source ./steps/hostinfo.sh
source ./steps/git.sh

export GIT_CHECKOUT=$PWD
export GIT_DESCRIBE=$(git describe --match v*)
export GOOGLE_CLOUD_PROJECT=foss-fpga-tools-ext-antmicro
export GCLOUD_PROJECT=foss-fpga-tools-ext-antmicro

echo "$KOKORO_TYPE run"

cp example.xml sponge_log.xml

# run Renode

renode --disable-xwt -e "q"
find  /opt/renode/tests/platforms -name *robot -exec echo - {} >> ci_tests.yaml \; -quit

python3 test_and_publish.py -t ci_tests.yaml -j`nproc` -P 12000
