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
export GOOGLE_APPLICATION_CREDENTIALS=$KOKORO_KEYSTORE_DIR/tflite.json
export GOOGLE_PROJECT_ID=292154118698
export DISTANT_RS_BUCKET=tflite-tests-artifacts

echo "$KOKORO_TYPE run"

cp example.xml sponge_log.xml
gsutil cp gs://tflite-tests-priv-bucket/secrets/tflite.json $GOOGLE_APPLICATION_CREDENTIALS

# run Renode

renode --disable-xwt -e "q"
find  /opt/renode/tests/platforms -name *robot -exec echo - {} >> ci_tests.yaml.tmp \;
grep -vi icicle ci_tests.yaml.tmp | grep -v FU540 > ci_tests.yaml

python3 test_and_publish.py -t ci_tests.yaml -j`nproc` -P 12000

rm $GOOGLE_APPLICATION_CREDENTIALS
