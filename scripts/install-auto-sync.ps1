$ErrorActionPreference = "Stop"

$gitCommand = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitCommand) {
    $knownGitPath = "C:\Program Files\Git\cmd\git.exe"

    if (Test-Path $knownGitPath) {
        $gitCommand = Get-Item $knownGitPath
    }
}

if (-not $gitCommand) {
    throw "Git is not available. Install Git for Windows, then rerun this script."
}

$git = if ($gitCommand.Source) { $gitCommand.Source } else { $gitCommand.FullName }

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$gitDir = Join-Path $repoRoot ".git"
$repoPath = $repoRoot.Path

if (-not (Test-Path $gitDir)) {
    & $git -c "safe.directory=$repoPath" -C $repoPath init
}

& $git -c "safe.directory=$repoPath" -C $repoPath config core.hooksPath .githooks

$remoteUrl = "https://github.com/aagaag/symcon_bellaria.git"
$hasOrigin = & $git -c "safe.directory=$repoPath" -C $repoPath remote | Where-Object { $_ -eq "origin" }

if ($hasOrigin) {
    & $git -c "safe.directory=$repoPath" -C $repoPath remote set-url origin $remoteUrl
} else {
    & $git -c "safe.directory=$repoPath" -C $repoPath remote add origin $remoteUrl
}

Write-Host "Auto-sync hook installed. Commits will push to $remoteUrl."
