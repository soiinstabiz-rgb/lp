# LP（ランディングページ）

静的HTML/CSS/JSのみで構成されたランディングページです。
ビルド不要・依存ライブラリなしで、Vercelにそのままデプロイできます。

---

## ファイル構成

```
LP作成/
├── index.html          ← 【本番】note導線LP。1ファイル完結（CSS/JSを内蔵）
├── assets/
│   └── favicon.svg     ← ファビコン（画像はここに置きます）
├── robots.txt
├── vercel.json         ← Vercelの設定（キャッシュ・セキュリティヘッダー）
├── serve.ps1           ← ローカルプレビュー用の簡易サーバー（公開には影響しません）
├── .gitignore
│
│  ── 以下は使っていない汎用テンプレート（不要なら削除して構いません）──
├── template.html       ← 汎用LP雛形（料金・FAQ・フォーム入り）
├── privacy.html        ← プライバシーポリシー
├── tokushoho.html      ← 特定商取引法に基づく表記
├── css/style.css       ← template.html 専用のスタイル
└── js/main.js          ← template.html 専用のスクリプト
```

`index.html` は外部ファイルを一切読み込まない**単体で完結したページ**です。
`css/` `js/` は `template.html` からしか使われていません。

---

## ローカルで確認する

`index.html`（note導線LP）は単体完結なので、ダブルクリックで開いても表示されます。
ただし `template.html` はルート絶対パスでCSSを読むため、
そちらを見るときは簡易サーバー経由が必要です（Node.js も Python も不要です）。

このフォルダで PowerShell を開き:

```powershell
.\serve.ps1
```

→ ブラウザで http://localhost:5500/ を開く。停止は `Ctrl+C`。

> エクスプローラーからこのフォルダを開き、アドレスバーに `powershell` と入力して
> Enter を押すと、このフォルダで PowerShell が開きます。

VS Code の拡張「Live Server」を使っても構いません。

---

## 編集のしかた

### 色を変える
`css/style.css` の先頭にある `:root` の `--brand` 系を書き換えるだけで、
ボタン・見出し・アクセントの色が一括で変わります。

```css
--brand:      #1f6feb;   /* メインカラー */
--brand-dark: #1553bb;   /* ホバー時（メインより少し暗く） */
--brand-tint: #eef4ff;   /* 薄い背景（メインをごく薄めた色） */
```

### 文言を変える
`index.html` の中身を上から順に書き換えてください。セクションは
`<!-- ============ ○○ ============ -->` のコメントで区切ってあります。

構成は「ヒーロー → 実績 → 課題提起 → 特徴 → 流れ → お客様の声 → 料金 → FAQ → CTA」の
王道パターンです。不要なセクションは `<section>` ごと削除して構いません。

### 画像を入れる
1. 画像を `assets/` に置く
2. `index.html` の `<div class="placeholder ...">...</div>` を
   `<img src="/assets/hero.webp" alt="説明文" width="1200" height="900">` に置き換える

画像は WebP 形式・横幅1600px以下に圧縮すると表示が速くなります。

### 公開前に必ず差し替える箇所（index.html）
- 本文中の `href="#"` を、実際の note のURLとお問い合わせ先に差し替える（全7か所）
- `og:url` を公開後の実際のURLに書き換える
- フッターの「これはデザイン確認用のサンプルです」の注意書きを削除する
- 書き手名・記事タイトル・日付を実際のものにする

> 現在の内容（「ことばの温度」の書き手・記事・日付）はすべて架空です。
> そのまま公開すると、実在しない人物のページを公開することになります。

---

## GitHub に公開する

> ここからは認証情報を扱うため、ご自身の環境で実行してください。

### 1. GitHub でリポジトリを作成
https://github.com/new を開き、

- Repository name: `lp`（任意）
- Public / Private: どちらでも可（Vercelは無料枠でPrivateも扱えます）
- **「Add a README file」等はすべてチェックを外す**（空のリポジトリで作成）

作成後に表示される URL を控えます:
`https://github.com/soiinstabiz-rgb/lp.git`

### 2. ローカルから push

このフォルダで PowerShell を開き、以下を実行します。

```powershell
git remote add origin https://github.com/soiinstabiz-rgb/lp.git
git push -u origin main
```

初回は GitHub のログイン画面（ブラウザ）が出るので、認証してください。

> **やり直したいとき**：リポジトリ名を間違えた等でリモートを付け替えるには
> `git remote set-url origin 新しいURL` を実行します（`add` は2回目でエラーになります）。

---

## Vercel にデプロイする

1. https://vercel.com/new を開く（アカウント: `soiinstabiz-7611`）
2. GitHub と連携し、作成した `lp` リポジトリを **Import**
3. 設定はすべてデフォルトのままで OK
   - Framework Preset: **Other**
   - Build Command: 空欄
   - Output Directory: 空欄（リポジトリのルートがそのまま公開されます）
4. **Deploy** をクリック

1〜2分で `https://lp-xxxx.vercel.app` のようなURLが発行されます。

### 以降の更新
`git push` するたびに Vercel が自動でデプロイします。

```powershell
git add .
git commit -m "コピーを修正"
git push
```

### 独自ドメインを設定する
Vercel のプロジェクト → **Settings** → **Domains** → ドメインを追加 →
表示された DNS レコードを、ドメインを取得した業者（お名前.com、ムームードメイン等）の
管理画面で設定します。反映まで数分〜数時間かかります。

---

## 公開後にやっておきたいこと

- [ ] Google Analytics / Search Console を設定する
- [ ] OGP画像（`assets/ogp.png`、1200×630px）を用意する
- [ ] スマホ実機で表示崩れがないか確認する
- [ ] PageSpeed Insights でスコアを確認する
- [ ] フォームのテスト送信を行い、通知が届くか確認する
