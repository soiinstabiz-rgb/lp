# LP（ランディングページ）

静的HTML/CSS/JSのみで構成されたランディングページです。
ビルド不要・依存ライブラリなしで、Vercelにそのままデプロイできます。

---

## ファイル構成

```
LP作成/
├── index.html          ← LP本体（ここを編集するのがメイン）
├── privacy.html        ← プライバシーポリシー
├── tokushoho.html      ← 特定商取引法に基づく表記
├── css/
│   └── style.css       ← デザイン。冒頭の :root で色をまとめて変更できます
├── js/
│   └── main.js         ← スクロール演出・FAQ・フォーム送信
├── assets/
│   └── favicon.svg     ← ファビコン（画像はここに置きます）
├── robots.txt
├── vercel.json         ← Vercelの設定（キャッシュ・セキュリティヘッダー）
└── .gitignore
```

---

## ローカルで確認する

`index.html` をダブルクリックしてブラウザで開くだけでも表示されますが、
`/css/style.css` のようなルート絶対パスを使っているため、
**簡易サーバー経由で開くことを推奨**します。

いずれか手軽な方法で:

- **VS Code の拡張「Live Server」** を入れて、`index.html` を右クリック →「Open with Live Server」
- Python がある場合: フォルダ内で `python -m http.server 8000` → http://localhost:8000

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

### 公開前に必ず差し替える箇所
- `index.html` の `<title>` / `description` / OGP（`og:url` は公開後のURLに）
- 「サービス名」「運営会社名」「example.com」などのダミー文言
- `robots.txt` の Sitemap URL
- `privacy.html` / `tokushoho.html` の会社情報（**特商法表記は有料サービスを販売する場合は法律上必須**）

---

## フォームの接続

現状、お問い合わせフォームは**送信先が未設定**で、送信するとエラーメッセージが出ます。
サーバー不要で動かすなら、外部フォームサービスの利用が簡単です。

1. [Formspree](https://formspree.io/) などでフォームを作成し、送信先URLを取得
2. `js/main.js` の以下の行にURLを設定

```js
var ENDPOINT = 'https://formspree.io/f/xxxxxxx';
```

これだけで、ページ遷移なしの送信が動きます。

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
