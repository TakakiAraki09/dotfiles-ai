# skills/

`npx skills add` で配布する Agent Skills を置くディレクトリ。
[vercel-labs/skills](https://github.com/vercel-labs/skills) の検出規約に準拠している。

## レイアウト（カタログ型）

```
skills/
└── <category>/          # 例: research, layout, docs, examples
    └── <skill-name>/     # 小文字・ハイフン区切り
        └── SKILL.md      # 必須
```

- CLI は `skills/<category>/<name>/SKILL.md` まで（2階層）を walk して検出する。
- `skills/` 直下に `SKILL.md` を直接置かないこと。浅い `SKILL.md` が深い階層のスキルを shadow する。

## 新しいスキルの追加手順

1. `skills/examples/example-skill/` を複製し、カテゴリ/スキル名にリネームする。
2. `SKILL.md` の frontmatter を書き換える。

   ```yaml
   ---
   name: my-skill            # 小文字・ハイフン。ディレクトリ名と揃える
   description: いつ発火すべきかを具体的なトリガー文で記述する（発火精度を左右する最重要項目）
   ---
   ```

3. 本文に目的・進め方・出力形式を記述する。
4. 補助ファイルが必要ならスキルディレクトリ内に追加し、本文から参照させる。

## frontmatter フィールド

| フィールド | 必須 | 説明 |
| --- | --- | --- |
| `name` | ✅ | スキルの一意識別子。小文字・ハイフン可 |
| `description` | ✅ | スキルの用途と発火条件。具体的なトリガー文を書く |
| `metadata.internal` | – | `true` で通常の検出から隠す（`INSTALL_INTERNAL_SKILLS=1` で表示） |

## インストール（利用者向け）

```bash
# 一覧表示
npx skills add TakakiAraki09/dotfiles-ai --list

# 特定スキルを Claude Code に追加
npx skills add TakakiAraki09/dotfiles-ai --skill example-skill --agent claude-code

# 全スキルを追加
npx skills add TakakiAraki09/dotfiles-ai --skill '*'
```
