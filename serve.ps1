# =========================================================
#  ローカルプレビュー用の簡易HTTPサーバー
#
#  このLPは /css/style.css のようなルート絶対パスを使うため、
#  index.html を直接ブラウザで開くとCSSが読み込まれません。
#  このスクリプト経由で開いてください。
#
#  使い方:  PowerShell でこのフォルダを開き
#      .\serve.ps1
#  ブラウザで http://localhost:5500/ を開く。停止は Ctrl+C。
# =========================================================
param([int]$Port = 5500)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

$mime = @{
  '.html' = 'text/html; charset=utf-8'
  '.css'  = 'text/css; charset=utf-8'
  '.js'   = 'text/javascript; charset=utf-8'
  '.json' = 'application/json; charset=utf-8'
  '.svg'  = 'image/svg+xml'
  '.png'  = 'image/png'
  '.jpg'  = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.webp' = 'image/webp'
  '.gif'  = 'image/gif'
  '.ico'  = 'image/x-icon'
  '.woff2'= 'font/woff2'
  '.txt'  = 'text/plain; charset=utf-8'
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

Write-Host ""
Write-Host "  LP preview -> http://localhost:$Port/" -ForegroundColor Cyan
Write-Host "  root: $root"
Write-Host "  stop: Ctrl+C"
Write-Host ""

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $res = $ctx.Response

    # URL -> ローカルパス（ディレクトリ外へのアクセスは拒否）
    $raw = $null
    if ($ctx.Request.Url) { $raw = $ctx.Request.Url.AbsolutePath }
    if (-not $raw) { $raw = $ctx.Request.RawUrl }
    if (-not $raw) { $raw = '/' }

    $rel = [Uri]::UnescapeDataString($raw)
    $rel = ($rel -split '\?')[0].TrimStart('/')
    if ([string]::IsNullOrEmpty($rel)) { $rel = 'index.html' }
    $path = Join-Path $root $rel.Replace('/', '\')

    if (Test-Path $path -PathType Container) { $path = Join-Path $path 'index.html' }
    # 拡張子なし（cleanUrls）は .html を補う
    elseif (-not (Test-Path $path) -and -not [IO.Path]::HasExtension($path)) { $path = "$path.html" }

    $full = [IO.Path]::GetFullPath($path)
    $ok = $full.StartsWith([IO.Path]::GetFullPath($root), 'OrdinalIgnoreCase') -and (Test-Path $full -PathType Leaf)

    if ($ok) {
      $bytes = [IO.File]::ReadAllBytes($full)
      $ext = [IO.Path]::GetExtension($full).ToLower()
      $type = 'application/octet-stream'
      if ($mime.ContainsKey($ext)) { $type = $mime[$ext] }
      $res.ContentType = $type
      $res.StatusCode = 200
    } else {
      $bytes = [Text.Encoding]::UTF8.GetBytes('404 Not Found')
      $res.ContentType = 'text/plain; charset=utf-8'
      $res.StatusCode = 404
    }

    Write-Host ("  {0}  /{1}" -f $res.StatusCode, $rel)
    $res.Headers.Add('Cache-Control', 'no-store')
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    $res.OutputStream.Close()
  }
}
finally {
  $listener.Stop()
  $listener.Close()
}
