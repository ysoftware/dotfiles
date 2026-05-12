#!/usr/bin/env bash
set -euo pipefail

files="$(git diff --cached --name-only --diff-filter=ACM)"

[ -z "$files" ] && exit 0

bad=0
while IFS= read -r f; do
  [ -f "$f" ] || continue

  if git grep -I -n --cached -- "nocheckin" -- "$f" >/dev/null 2>&1; then
    echo "nocheckin detected"
    git grep -I -n --cached -- "nocheckin" -- "$f" || true
    bad=1
  fi
done <<< "$files"

exit $bad
