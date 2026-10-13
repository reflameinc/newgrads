#!/usr/bin/env bash
# ============================================================
# state.sh — 作業の現在地を Claude に知らせる
#   start  … Claude Code を開いた時（GitHub の最新を取り込む）
#   prompt … 担当が何か頼むたび（通信しない）
# 出力はそのまま Claude の文脈に入る。担当の画面には出ない。
# 決まり: 変数のすぐ後ろに日本語を書かない（Mac の古い bash が変数名を読み違える）。必ず ${名前} と書く。
# ============================================================
mode="${1:-prompt}"
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

[ "$mode" = "start" ] && git fetch --quiet --prune origin 2>/dev/null

branch="$(git branch --show-current 2>/dev/null)"
changed="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

echo "[LPの現在地]"

if [ "$branch" = "main" ] || [ -z "$branch" ]; then
  if [ "$changed" = "0" ]; then
    [ "$mode" = "start" ] && git pull --ff-only --quiet origin main 2>/dev/null
    echo "- いまは main（本番と同じ内容）。直しの依頼が来たら、聞かずに作業用ブランチを作ってから直す。"
  else
    echo "- main の上に、保存していない変更が ${changed} 件ある。直しを続ける前に作業用ブランチを作る（git switch -c で変更はそのまま持ち越せる）。"
  fi
  exit 0
fi

echo "- 作業用ブランチ: ${branch}"

if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  unpushed="$(git rev-list --count '@{u}..HEAD' 2>/dev/null)"
  sent=1
else
  unpushed="$(git rev-list --count 'origin/main..HEAD' 2>/dev/null)"
  sent=0
fi
ahead="$(git rev-list --count 'origin/main..HEAD' 2>/dev/null)"

if [ "$changed" != "0" ]; then
  echo "- コミットしていない変更: ${changed} 件 → 直しの区切りで「コミットしますか」と聞く。"
elif [ "${ahead:-0}" = "0" ]; then
  echo "- このブランチの内容は、もう main に入っている。main に戻って最新にしてから、次の作業を始める。"
elif [ "$sent" = "0" ] || [ "${unpushed:-0}" != "0" ]; then
  echo "- コミット済みで、まだ GitHub に送っていないものが ${unpushed} 件 → 「GitHub に送って検品にかけますか」と聞く。"
else
  echo "- コミットも GitHub への送信も済み → プルリクエストと検品の状態を確かめ、緑なら「公開しますか」と聞く。"
fi

if [ "$mode" = "start" ] && command -v gh >/dev/null 2>&1; then
  pr="$(gh pr view --json state,url --jq '.state + " " + .url' 2>/dev/null)"
  [ -n "$pr" ] && echo "- このブランチのプルリクエスト: ${pr}"
fi
exit 0
