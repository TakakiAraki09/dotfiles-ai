#!/usr/bin/env bash
#
# install.sh — claude/ 配下の dotfiles を ~/.claude/ へシンボリックリンクする。
# 冪等。既存の実体ファイル/ディレクトリは .bak へ退避してからリンクを張る。
#
# Usage:
#   ./scripts/install.sh            # 実行
#   DRY_RUN=1 ./scripts/install.sh  # 実際には変更せず実行内容を表示

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/claude"
DEST_DIR="${CLAUDE_HOME:-$HOME/.claude}"

# リンク対象: claude/ 配下のサブディレクトリ -> ~/.claude/<name>
LINK_TARGETS=(agents commands)

log() { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    printf '  (dry-run) %s\n' "$*"
  else
    eval "$*"
  fi
}

main() {
  log "source : $SRC_DIR"
  log "dest   : $DEST_DIR"
  run "mkdir -p \"$DEST_DIR\""

  for name in "${LINK_TARGETS[@]}"; do
    local src="$SRC_DIR/$name"
    local dest="$DEST_DIR/$name"

    if [[ ! -e "$src" ]]; then
      log "skip (not in repo): $name"
      continue
    fi

    # 既に正しいリンクなら何もしない（冪等）
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      log "ok (already linked): $name"
      continue
    fi

    # 既存の実体/別リンクは退避
    if [[ -e "$dest" || -L "$dest" ]]; then
      local backup="$dest.bak.$$"
      log "backup existing: $dest -> $backup"
      run "mv \"$dest\" \"$backup\""
    fi

    log "link: $dest -> $src"
    run "ln -s \"$src\" \"$dest\""
  done

  log "done."
  log "note: settings は claude/settings/settings.example.json を参考に手動で配置してください（秘匿情報を含むため自動リンクしません）。"
}

main "$@"
