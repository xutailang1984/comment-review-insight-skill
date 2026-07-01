#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${HOME}/.codex/skills/comment-review-insight"

mkdir -p "${HOME}/.codex/skills"
rm -rf "${TARGET_DIR}"
cp -R "${ROOT_DIR}/skill/comment-review-insight" "${TARGET_DIR}"

echo "Installed comment-review-insight skill to ${TARGET_DIR}"
echo "Restart Codex and invoke: \$comment-review-insight"

