#!/usr/bin/env bash
#
# preview.sh — see your undeployed changes before pushing them live.
#
#   Run it from the repo root:   ./preview.sh
#
# It does two things:
#   1) Prints what's changed but NOT yet on the live site (marklyda.com):
#        - files you've edited but not committed
#        - commits you've made but not pushed
#   2) Starts a local preview server and opens it in your browser so you can
#      eyeball those changes. Press Ctrl+C to stop it when you're done.

set -e
cd "$(dirname "$0")"

PORT=8000
URL="http://localhost:${PORT}/"

echo ""
echo "=================================================="
echo "  UNDEPLOYED CHANGES (not yet live on marklyda.com)"
echo "=================================================="

# Make sure our view of the live site is current (ignore network hiccups).
git fetch --quiet origin main 2>/dev/null || true

echo ""
echo "-- Edited but not committed --------------------------------"
if [ -n "$(git status --porcelain)" ]; then
  git status --short
else
  echo "  (nothing — working tree is clean)"
fi

echo ""
echo "-- Committed but not pushed --------------------------------"
if [ -n "$(git log origin/main..HEAD --oneline 2>/dev/null)" ]; then
  git log origin/main..HEAD --oneline
else
  echo "  (nothing — everything committed is already live)"
fi

echo ""
echo "=================================================="
echo "  LOCAL PREVIEW"
echo "=================================================="
echo "  Opening: ${URL}"
echo "  Press Ctrl+C to stop the server when you're done."
echo ""

# Open the browser a moment after the server starts.
( sleep 1; open "${URL}" 2>/dev/null || true ) &

# Start the server (this blocks until you press Ctrl+C).
python3 -m http.server "${PORT}"
