#!/bin/bash
# Publish the landing page to GitHub Pages: commit any change and push main.
#
#   ./publish.sh              # commit any change and push
#   ./publish.sh "message"    # with your own commit message
set -euo pipefail
cd "$(dirname "$0")"

# The interest form is the page's whole job. Without the engine's URL it can
# only say "we couldn't send that", so a page like that never goes out.
ENGINE=$(sed -nE 's/^ *var BOOKING_ENGINE = "([^"]*)";.*/\1/p' index.html)
TEAM=$(sed -nE 's/^ *var TEAM_EMAIL = "([^"]*)";.*/\1/p' index.html)
case "$ENGINE" in
  https://script.google.com/macros/s/*/exec) ;;
  *) echo "refusing to publish: BOOKING_ENGINE in index.html is not the engine's web app URL"; exit 1 ;;
esac
[ -n "$TEAM" ] || { echo "refusing to publish: TEAM_EMAIL in index.html is empty"; exit 1; }

# The page is public. No address but the team inbox is allowed to ride along.
# URLs are stripped first: a Google Fonts href carries "wght@400", which is not
# an email but matches a naive pattern.
strays() {
  sed -E 's#https?://[^"'"'"' )]+##g' index.html \
    | grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
    | grep -vxF "$TEAM" | sort -u
}
if [ -n "$(strays)" ]; then
  echo "refusing to publish: an address other than $TEAM is on the page"
  strays
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "nothing changed"
else
  git commit -q -m "${1:-Update the landing page}"
fi
git push -q origin main
echo "published: https://ucf-eventops-research.github.io/"
