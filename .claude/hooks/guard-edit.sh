#!/usr/bin/env bash
# ============================================================
# guard-edit.sh — ファイルを直す直前の関門（Edit / Write）
#   1) main のままなら止める → Claude が作業用ブランチを作ってやり直す
#   2) 仕組みのファイル（.github/ scripts/ .claude/ CLAUDE.md）なら、担当に確認の画面を出す
# このリポジトリの外のファイルには何もしない。
# 決まり: 変数のすぐ後ろに日本語を書かない。必ず ${名前} と書く。
# ============================================================
input="$(cat)"
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0

fp="$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -n "$fp" ] || exit 0
fp="$(printf '%s' "$fp" | sed 's|\\\\|/|g')"          # Windows の \\ を / にそろえる

low_fp="$(printf '%s' "$fp" | tr 'A-Z' 'a-z')"
low_root="$(printf '%s' "$root" | tr 'A-Z' 'a-z')"
case "$low_fp" in
  "$low_root"/*) rel="${fp:$(( ${#root} + 1 ))}" ;;
  /*|[a-z]:/*)   exit 0 ;;                               # リポジトリの外
  *)             rel="$fp" ;;                            # 相対パス
esac

branch="$(git branch --show-current 2>/dev/null)"
if [ "$branch" = "main" ] || [ -z "$branch" ]; then
  today="$(date +%Y%m%d)"
  {
    echo "main のままでは直さない決まりです。"
    echo "先に作業用ブランチを作ってから、同じ編集をやり直してください:"
    echo "  git switch -c work/${today}-<直す内容を英小文字とハイフンで>"
    echo "担当への確認は要りません。作業用ブランチを作ったことを一言伝えるだけにしてください。"
  } >&2
  exit 2
fi

case "$rel" in
  .github/*|scripts/*|.claude/*|CLAUDE.md)
    printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"公開の仕組みのファイルです。変えると中山さんのレビューが必要になり、LPの直しでは通常さわりません。本当に変えますか？"}}'
    exit 0 ;;
esac
exit 0
