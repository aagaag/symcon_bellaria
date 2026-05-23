$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not available on PATH. Install Git for Windows, then rerun this script."
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$gitDir = Join-Path $repoRoot ".git"

if (-not (Test-Path $gitDir)) {
    git -C $repoRoot init
}

git -C $repoRoot config core.hooksPath .githooks

$remoteUrl = "https://github.com/aagaag/symcon_bellaria.git"
$hasOrigin = git -C $repoRoot remote | Where-Object { $_ -eq "origin" }

if ($hasOrigin) {
    git -C $repoRoot remote set-url origin $remoteUrl
} else {
    git -C $repoRoot remote add origin $remoteUrl
}

Write-Host "Auto-sync hook installed. Commits will push to $remoteUrl."
