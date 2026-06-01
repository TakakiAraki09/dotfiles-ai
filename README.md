# dotfiles-ai

AI コーディングエージェント（Claude Code 等）向けの **dotfiles + 配布可能なスキル集**。

このリポジトリは2つの役割を持つ。

1. **配布可能なスキル集** — `npx skills add` で他環境・他ユーザーが Agent Skills をインストールできる
2. **AI dotfiles ハブ** — Claude Code の agents / commands / settings をバージョン管理し、新環境へ展開できる

## 構成

```
dotfiles-ai/
├── skills/                 # npx skills add の検出対象（カタログ型）
│   └── <category>/<name>/SKILL.md
├── claude/                 # Claude Code dotfiles 本体（~/.claude へ展開）
│   ├── agents/             # subagent 定義
│   ├── commands/           # スラッシュコマンド
│   └── settings/           # settings.json サンプル
└── scripts/install.sh      # claude/ を ~/.claude/ へシンボリックリンク
```

## スキルを使う（利用者向け）

[vercel-labs/skills](https://github.com/vercel-labs/skills) の `npx skills` CLI でインストールする。

```bash
# 収録スキルを一覧表示
npx skills add TakakiAraki09/dotfiles-ai --list

# 特定スキルを Claude Code に追加
npx skills add TakakiAraki09/dotfiles-ai --skill example-skill --agent claude-code

# すべてのスキルを追加
npx skills add TakakiAraki09/dotfiles-ai --skill '*'
```

スキルの追加・作成方法は [`skills/README.md`](./skills/README.md) を参照。

## dotfiles を導入する（自分の環境向け）

```bash
git clone https://github.com/TakakiAraki09/dotfiles-ai.git
cd dotfiles-ai

# claude/agents, claude/commands を ~/.claude/ へリンク（冪等）
./scripts/install.sh

# 変更内容だけ確認したい場合
DRY_RUN=1 ./scripts/install.sh
```

`settings` は秘匿情報を含みうるため自動リンクしない。
[`claude/settings/settings.example.json`](./claude/settings/settings.example.json) を参考に手動で `~/.claude/settings.json` を作成すること。

## スキルを追加・貢献する

カタログ型レイアウト `skills/<category>/<skill-name>/SKILL.md` で追加する。
詳細は [`skills/README.md`](./skills/README.md)。雛形は [`skills/examples/example-skill/`](./skills/examples/example-skill/)。
