#!/bin/bash
set -e

if [ -z "$REPO_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
    echo "REPO_URL and RUNNER_TOKEN must be set"
    exit 1
fi

cd /home/runner/actions-runner

./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --name "${RUNNER_NAME:-quickbite-runner}" --work "${RUNNER_WORKDIR:-/tmp/runner}" --unattended --replace

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token "$RUNNER_TOKEN"
}
trap cleanup EXIT

./run.sh