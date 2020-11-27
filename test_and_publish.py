#!/usr/bin/env python3

import subprocess
import sys
import os
import tempfile
from distantrs import Invocation


# required to find listener.py
this_path = os.path.abspath(os.path.dirname(__file__))

# create a connection

remote = Invocation()
remote.open()

print(f"https://source.cloud.google.com/results/invocations/{remote.invocation_id}")

remote.announce_target("Test Summary")

tmp = tempfile.NamedTemporaryFile()
with open(tmp.name, 'w') as log:
    # run the actual testing procedure
    log.write("Running Renode tests...\n")

    process = subprocess.Popen(["/usr/bin/renode-test", "--listener", os.path.join(this_path, f"results_listener.py:{remote.invocation_id}--{remote.auth_token}")] + sys.argv[1:], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=os.environ.copy())
    ret = 0

    while True:
        line = process.stdout.readline().decode('utf-8').rstrip()
        ret = process.poll()
        if ret is not None:
            break
        if line:
            log.write(line+'\n')
            print(line)


expected_summary_paths = [
        'nunit_output.xml',
        'robot_output.xml',
        'log.html',
        'report.html',
        ]

existing_summary_paths = [x for x in expected_summary_paths if os.path.isfile(x)]

for path in existing_summary_paths:
    remote.send_file(os.path.basename(path), path)


remote.finalize_target("Test Summary", not(ret))

remote.send_file("build.log", tmp.name)

# What are these codes?
remote.update_status(5 if ret == 0 else 6)
remote.close()
sys.exit(ret)
