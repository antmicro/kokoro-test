#!/bin/bash

set -e

ls -alh

cd github/$KOKORO_DIR/

source ./steps/hostsetup.sh
source ./steps/hostinfo.sh
source ./steps/git.sh

export GIT_CHECKOUT=$PWD
export GIT_DESCRIBE=$(git describe --match v*)

echo "$KOKORO_TYPE run"

gcloud config list

wget https://raw.githubusercontent.com/antmicro/distant-rs/master/examples/get_inv.py

python3 get_inv.py a69ce84c-54dd-46a5-a2d3-3ec29ea445e2
