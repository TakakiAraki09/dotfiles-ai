---
description: スラッシュコマンドの雛形。/example-command で起動する。複製して使う。
argument-hint: "[対象]"
---

# /example-command

このコマンドが実行する手順を記述する。

ユーザー引数は `$ARGUMENTS` で受け取れる（個別には `$1`, `$2` ...）。

## 手順

1. `$ARGUMENTS` を解釈する。
2. 必要な処理を実行する。
3. 結果を報告する。
