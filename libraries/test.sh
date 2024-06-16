#!/usr/bin/env bash

set -euo pipefail

SCHEME="PexelsLib-Package"
DESTINATION='platform=iOS Simulator,name=iPhone SE (3rd generation),OS=17.2'
xcodebuild test -scheme "$SCHEME" -destination "$DESTINATION" -sdk iphonesimulator
