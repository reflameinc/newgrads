# newgrads — 新卒｜メイン

- 公開URL: https://reflame.co.jp/lp/newgrads/
- 担当: 未確定（有川が確認中）
- 仕組みの元: [reflameinc/justdoito](https://github.com/reflameinc/justdoito)（プルリクエストをマージすると本番に反映される仕組み）
- 困ったとき: 有川へ。画面に出た文をそのまま貼ってください

## いまの状態（2026-10-06 時点）

| 項目 | 状態 | やる人 |
|---|---|---|
| 自動反映の設定ファイル（`.github/`・`scripts/`） | 済み。justdoito と同じ内容で、転送先だけこのLP用 | — |
| main を守るルール・production 環境・サーバーの指紋（`DEPLOY_KNOWN_HOSTS`） | 済み | — |
| サーバーに入る鍵（`DEPLOY_SSH_KEY`） | **未** | 中山さん（作業A） |
| LPのファイル（`index.html`・`assets/`） | **未**。このリポジトリにはまだLPが入っていない | 担当（作業B） |
| 本番へ反映するスイッチ（`DEPLOY_ENABLED`） | オフ | 有川（作業C） |

スイッチがオフの間は、マージしても本番のLPは変わりません。AとBの両方が済んだら、Cに進みます。AとBはどちらが先でもかまいません。

## 作業A: サーバーに入る鍵を登録する（中山さんのPC・12本まとめて1回）

9/29 に justdoito へ登録したのと同じ鍵を、新しい12本にも登録します。鍵は GitHub から取り出せないため、鍵のあるPCでしかできません。1回の作業で12本すべてに登録されます（この README は12本とも同じ内容なので、どれを見て行ってもかまいません）。

1. 中山さんのPCで Claude Code を開く（フォルダはどこでもよい）。
2. 下の文をそのまま貼る。

```
reflameinc の LP リポジトリ12本に、本番サーバーの SSH 鍵を登録してください。

- 鍵は、9/29 に reflameinc/justdoito の production 環境へ DEPLOY_SSH_KEY として登録したのと同じ秘密鍵です。このPCの中から探してください（~/.ssh/ など）。
- 見つけた鍵が正しいことを、次のコマンドが ok を返すことで確かめてください。
  ssh -i <鍵のパス> -p 8022 -o BatchMode=yes r1300591@www1151.onamae.ne.jp "echo ok"
- 鍵の中身は、画面にもファイルにも出さないでください。
- 確かめられたら、次の12本それぞれに登録してください。
  gh secret set DEPLOY_SSH_KEY --env production -R reflameinc/<名前> < <鍵のパス>
  midcareer aff aff-highclass newgrads newgrads-aff newgrads-kaneto newgrads-kamakura kensetsu kensetsu-step kensetsu-pro kensetsu-aff-01 kensetsu-aff-02
- 最後に gh secret list --env production -R reflameinc/<名前> を12本に実行し、どれにも DEPLOY_SSH_KEY と DEPLOY_KNOWN_HOSTS の2つが並んでいることを表で見せてください。
```

3. うまくいったとき: 12行の表が出て、全部の行に `DEPLOY_SSH_KEY` と `DEPLOY_KNOWN_HOSTS` が並ぶ。
4. うまくいかないとき: 「鍵が見つからない」「Permission denied」「HTTP 403」などの文を、そのまま有川へ送る。

## 作業B: LPのファイルを入れる（担当のPC）

いま本番に出ているLPと同じものを、このリポジトリに入れます。この作業では見た目や文言を変えません。

1. 自分のPCで Claude Code を開く。
2. 下の文の `<　>` を、LPの元ファイルが入っているフォルダの場所に書き換えて貼る。元ファイルが手元に無いときは、`<　>` の行を「元ファイルが手元に無いので、公開URLから取得してください」に書き換える。

```
reflameinc/newgrads をこのPCにクローンして、新卒｜メイン のLP（https://reflame.co.jp/lp/newgrads/）のファイルを入れ、プルリクエストを作ってください。
進め方と決まりは、そのリポジトリの README.md の「作業B」に書いてあります。先に読んでから始めてください。
LPの元ファイルは <このPCのフォルダの場所> にあります。
```

3. Claude Code がプルリクエストを作ったら、表示されたURLをブラウザで開く。
4. 画面の下のほうに、緑のチェックと「check」の文字が出るまで待つ（1〜2分）。
5. 緑になったら「Merge pull request」→「Confirm merge」を押す。
6. 有川へ「newgrads にLPを入れてマージしました」と連絡する（作業Cへ）。

赤い × が出たときは、×の横の「Details」を開き、🛑 が付いた行を Claude Code に貼って「これを直して」と頼みます。直らなければ、その行を有川へ送ってください。

### 決まり（Claude Code はここを読んで作業する）

- **置き方**: `index.html` はいちばん上の階層に置く。画像・CSS・JS・フォント・動画は、すべて `assets/` の中に置く。
- **`img/` を `assets/` に変える**: いまの本番は画像が `img/` に入っている。フォルダ名を `assets/` に変え、`index.html` の中の参照（`src`・`href`・`srcset`・CSS の `url()`・OGP画像のURL）も全部書き換える。本番へ送られるのは `index.html` と `assets/` だけなので、`img/` のままだと検品は通るのに画像が本番に届かない。
- **`assets/` に置ける種類**: png・jpg・jpeg・webp・gif・avif・ico・css・js・woff・woff2・mp4・webm。ファイル名は英数字と `_` `-` `.` だけ、拡張子は小文字。
- **svg は置けない**: このLPは次の svg を使っている。png か webp に変換して参照を書き換えるか、`index.html` の中に直接書く（インラインSVG）。見た目が変わらないことを確かめる。
  - `img/star.svg`
- **中身は本番と同じにする**: 元ファイルと本番（公開URL）に違いがあれば、勝手にどちらかへ寄せず、違いを担当に見せて決めてもらう。
- **main に直接は入れられない**: ブランチを作る → プルリクエストを作る → 検品（check）が緑 → マージ、の順。
- **`.github/` と `scripts/` は触らない**: 変えると中山さんのレビューが必要になる。
- **検品は GitHub の画面で見る**: Mac に最初から入っている bash では `scripts/check.sh` がエラーで止まる（2026-10-06 に有川のMacで確認）。手元で動かなくても、プルリクエストの check が緑なら問題ない。

### 本番の現物を検品にかけた結果（2026-10-06・有川側で実施）

- ✓ メインLPのため noindex なしで通る設定にしてある／GTM あり／`dataLayer.push` あり／参照している画像は全部そろっている／`../` 参照なし／localhost の残りなし
- 直す必要があるのは、上の決まりにある `img/` → `assets/` と svg（`img/star.svg`） だけ
- 文字サイズ（14px未満）の注意が出ることがあるが、注意だけで止まらない

## 作業C: 本番へ反映するスイッチを入れる（有川）

1. 作業Bのマージ後、Actions の `deploy` が「▶ 予行演習モード」で動き、「転送予定 N 件」の一覧が出ていることを有川が確かめる（作業Aが済んでいないと、ここで「Secret DEPLOY_SSH_KEY が未登録」と出て止まる）。
2. 有川がリポジトリ変数 `DEPLOY_ENABLED` を `true` にして、`deploy` をやり直す。
3. 本番へ転送され、「✓ 本番の index.html がリポジトリと一致」「✓ assets 全て HTTP 200」が出れば完了。
4. 有川から担当へ「公開できる状態になりました」と連絡する。

最初の転送で、本番の `index.html` は `assets/` を見る形に置き換わります。サーバーに残る古い `img/` は自動では消えません（消すなら手作業）。

## 作業A〜Cが終わったあとの、ふだんの直し方

justdoito と同じです。ブランチを作る → 直す → プルリクエスト → check が緑 → 自分でマージ。マージした時点で本番に反映されます。戻すときは、マージ済みプルリクエストの「Revert」を押し、できたプルリクエストをマージします。

## justdoito との違い（中山さん向け）

このLPは `/lp/<事業部>/` の直下にあるメインLPのため、`deploy.yml` を2か所だけ変えています。

- 検品を `IS_MAIN=1` で実行（noindex を要求しない）
- 「転送先の検査」を、`/lp/*/*/` の形の照合から、このLPの転送先（`/lp/newgrads/`）との完全一致に変更（元の形のままだと、1階層のこのLPは必ず止まるため）

転送先の `/lp/newgrads/` の下には、ほかのLPのフォルダもあります。送るのは `index.html` と `assets/` だけで、削除同期もしないため、ほかのLPには触れません。
