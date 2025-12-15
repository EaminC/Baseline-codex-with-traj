#!/bin/bash

# Quick statistics script for docker_test_results.json

RESULTS_FILE="temp.json"

if [ ! -f "$RESULTS_FILE" ]; then
    echo "Error: $RESULTS_FILE not found!"
    exit 1
fi

python3 <<EOF
import json

with open('$RESULTS_FILE', 'r') as f:
    data = json.load(f)

total = len(data)
build_success = sum(1 for item in data if item.get('build_success', False))
run_success = sum(1 for item in data if item.get('run_success', False))
tested = total - sum(1 for item in data if item.get('status') == 'no_dockerfile')

if tested > 0:
    build_rate = (build_success / tested) * 100
    run_rate = (run_success / tested) * 100
    print(f"Build Success: {build_success}/{tested} ({build_rate:.1f}%)")
    print(f"Run Success:  {run_success}/{tested} ({run_rate:.1f}%)")
    print(f"Overall:      {run_success}/{tested} ({run_rate:.1f}%)")
else:
    print("No tested repositories found")
EOF

