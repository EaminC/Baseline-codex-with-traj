#!/bin/bash

# Simple script to analyze docker_test_results.json and show statistics

RESULTS_FILE="docker_test_results.json"

if [ ! -f "$RESULTS_FILE" ]; then
    echo "Error: $RESULTS_FILE not found!"
    exit 1
fi

# Use Python to parse JSON and calculate statistics
python3 <<EOF
import json
import sys

try:
    with open('$RESULTS_FILE', 'r') as f:
        data = json.load(f)
    
    total = len(data)
    build_success = sum(1 for item in data if item.get('build_success', False))
    run_success = sum(1 for item in data if item.get('run_success', False))
    no_dockerfile = sum(1 for item in data if item.get('status') == 'no_dockerfile')
    tested = total - no_dockerfile
    
    print("=" * 50)
    print("Docker Test Results Summary")
    print("=" * 50)
    print(f"Total repositories: {total}")
    print(f"No Dockerfile found: {no_dockerfile}")
    print(f"Tested repositories: {tested}")
    print()
    print("Build Statistics:")
    print(f"  Build successful: {build_success}")
    print(f"  Build failed: {tested - build_success}")
    if tested > 0:
        build_rate = (build_success / tested) * 100
        print(f"  Build success rate: {build_rate:.2f}%")
    print()
    print("Run Statistics:")
    print(f"  Run successful: {run_success}")
    print(f"  Run failed: {tested - run_success}")
    if tested > 0:
        run_rate = (run_success / tested) * 100
        print(f"  Run success rate: {run_rate:.2f}%")
    print()
    print("Overall Success:")
    if tested > 0:
        overall_rate = (run_success / tested) * 100
        print(f"  Both build and run successful: {run_success}/{tested} ({overall_rate:.2f}%)")
    print("=" * 50)
    
except Exception as e:
    print(f"Error reading JSON file: {e}", file=sys.stderr)
    sys.exit(1)
EOF

