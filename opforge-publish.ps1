# opforge-publish.ps1

param (
    [string]$Message = "Update OPFORGE site content"
)

# Step 1: Build site
Write-Host "`n[BUILDING] Running Hugo build..."
hugo --cleanDestinationDir --minify

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] Hugo build failed. Resolve issues and try again." -ForegroundColor Red
    exit 1
}

# Step 2: Show current status
Write-Host "`n[GIT STATUS]"
git status

# Step 3: Dynamically add only existing folders
$pathsToAdd = @(
    "content", "static", "themes", "archetypes", ".github", "hugo.toml", "hugo.yaml", "hugo.json", "config.*", "opforge-publish.ps1"
)

foreach ($path in $pathsToAdd) {
    if (Test-Path $path) {
        git add $path
    }
}

# Step 4: Show staged files
Write-Host "`n[STAGED FILES]"
$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host "⚠️  Nothing is staged to commit." -ForegroundColor Yellow
    exit 1
} else {
    $staged
}

# Step 5: Confirm and commit
$confirmation = Read-Host "`nProceed with commit and push? (y/n)"
if ($confirmation -eq 'y') {
    git commit -m $Message
    git push
    Write-Host "`n✅ Changes pushed. GitHub Actions will deploy your Hugo site." -ForegroundColor Green
} else {
    Write-Host "`n❌ Commit aborted by user." -ForegroundColor Yellow
}
