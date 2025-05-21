# opforge-publish.ps1

param (
    [string]$Message = "Update OPFORGE site content",
    [switch]$Force
)

# Optional: Handle CRLF line ending issues on Windows
git config core.autocrlf true

# Step 1: Build the site
Write-Host "`n[BUILDING] Running Hugo build..."
hugo --cleanDestinationDir --minify

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] Hugo build failed. Resolve issues and try again." -ForegroundColor Red
    exit 1
}

# Step 2: Show Git status
Write-Host "`n[GIT STATUS]"
git status

# Step 3: Stage key files and folders
$pathsToAdd = @(
    "content", "static", "themes", "archetypes", ".github",
    "hugo.toml", "hugo.yaml", "hugo.json", "config.*", "opforge-publish.ps1"
)

foreach ($path in $pathsToAdd) {
    if (Test-Path $path) {
        git add $path
    }
}

# Step 4: Show what’s staged
Write-Host "`n[STAGED FILES]"
$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host "`n Nothing is staged to commit." -ForegroundColor Yellow
    exit 1
} else {
    $staged
}

# Step 5: Confirm and commit
if ($Force -or (Read-Host "`nProceed with commit and push? (y/n)") -eq 'y') {
    git commit -m $Message
    git push origin main
    Write-Host "`nChanges pushed. GitHub Actions will deploy your Hugo site." -ForegroundColor Green
} else {
    Write-Host "`nCommit aborted by user." -ForegroundColor Yellow
}
