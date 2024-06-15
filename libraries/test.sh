#!/usr/bin/env bash

set -euo pipefail

DESTINATION='platform=iOS Simulator,name=iPhone SE (3rd generation),OS=17.2'
xcodebuild test -scheme PexelsLib -destination "${DESTINATION}" -sdk iphonesimulator
