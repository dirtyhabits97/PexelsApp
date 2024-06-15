#!/usr/bin/env bash

set -euo pipefail

DESTINATION="platform=iOS Simulator,name=iPhone 14,OS=16.4"
xcodebuild test -scheme PexelsLib -destination "${DESTINATION}"
