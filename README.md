# newgrads — 新卒｜メイン

- 公開URL: https://reflame.co.jp/lp/newgrads/
- 担当: 中山さん
- プルリクエストを main にマージすると、そのまま本番に出る
- 困ったとき: 有川へ。画面に出た文をそのまま貼ってください

## LPを直すとき

1. このフォルダで Claude Code を開く。
2. 直したい内容を、ふつうの言葉で伝える（例:「FVの見出しを〇〇に変えて」）。
3. Claude Code の質問に答える。出る質問は「コミットしますか」「GitHub に送って検品にかけますか」「公開しますか」の3つ。
4. 「公開しますか」に「はい」と答えると、本番が置き換わる。直前に、許可の画面が1回出るので Yes を押す。

git の操作は Claude Code が行う。作業用ブランチも自動で作る。

## 公開したものを戻すとき

Claude Code に「さっきの公開を戻して」と頼む。戻るのは `index.html` と中身が変わったファイルで、足した画像は本番のサーバーから消えない（消したい時は有川へ）。

## ファイルの決まり

- 本番に送られるのは `index.html` と `assets/` の中だけ。
- `assets/` に置ける種類: png・jpg・jpeg・webp・gif・avif・ico・css・js・woff・woff2・mp4・webm。ファイル名は英数字と `_` `-` `.` だけ、拡張子は小文字。svg は置けない（HTMLの中に直接書くのは可）。
- 鍵・パスワード・個人情報を入れない（このリポジトリは誰でも見られる）。

## 仕組み（中山さん・有川向け）

- [reflameinc/justdoito](https://github.com/reflameinc/justdoito) と同じ構成。`scripts/` は justdoito と同一、`deploy.yml` は転送先・公開URLがこのLP用。転送先の検査は、このLPの転送先との完全一致。メインLPのため、検品を `IS_MAIN=1`（noindex を求めない）で実行する。
- `.github/`・`scripts/`・`.claude/`・`CLAUDE.md` の変更は、中山さんのレビューが必要（CODEOWNERS）。
- サーバーの鍵（`DEPLOY_SSH_KEY`）は production 環境にあり、main でしか使えない。**登録する鍵はパスフレーズなしであること。** 中山さんのPCの鍵にはパスフレーズが付いているので、登録する時はパスフレーズを外した一時コピーを使い、登録後すぐ消す。
- 反映のスイッチはリポジトリ変数 `DEPLOY_ENABLED`。`true` 以外の間は、マージしても予行演習で止まり、本番は変わらない。
- サーバーに残っている古い `img/` フォルダは、もう使っていない（消すなら手作業）。
