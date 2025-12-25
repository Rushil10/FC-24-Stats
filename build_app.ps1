param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("free", "pro")]
    $type = "free",

    [Parameter(Mandatory=$false)]
    $year = "24"
)

$ErrorActionPreference = "Stop"

$flavor = "fc$($year)$($type.substring(0,1).ToUpper())$($type.substring(1))"
$game = "fc$year"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Building Player Stats $year ($type version)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# ============================================
# ASSET OPTIMIZATION: Only include the CSV for this game version
# This saves ~24MB by excluding unused player databases
# ============================================

$ProjectRoot = $PSScriptRoot
$DataDir = Join-Path $ProjectRoot "assets\data"
$TempBackupDir = Join-Path $ProjectRoot ".build_temp"

# All game flavors
$AllGames = @("fc23", "fc24", "fc26")
$GamesToHide = $AllGames | Where-Object { $_ -ne $game }

Write-Host ""
Write-Host "[1/4] Optimizing assets (hiding unused CSVs)..." -ForegroundColor Yellow

# Create temp backup folder
if (Test-Path $TempBackupDir) {
    Remove-Item -Path $TempBackupDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempBackupDir -Force | Out-Null

# Move the CSVs we DON'T want to include to the temp folder
foreach ($g in $GamesToHide) {
    $SourcePath = Join-Path $DataDir "$g\players.csv"
    $BackupPath = Join-Path $TempBackupDir "$g-players.csv"
    
    if (Test-Path $SourcePath) {
        Move-Item -Path $SourcePath -Destination $BackupPath -Force
        Write-Host "       Hiding: $g/players.csv" -ForegroundColor Gray
    }
}

# Show which CSV will be included
$IncludedCsv = Join-Path $DataDir "$game\players.csv"
if (Test-Path $IncludedCsv) {
    $FileSize = [math]::Round((Get-Item $IncludedCsv).Length / 1MB, 2)
    Write-Host "       Including: $game/players.csv ($FileSize MB)" -ForegroundColor Green
}

# ============================================
# BUILD THE APP
# ============================================

Write-Host ""
Write-Host "[2/4] Running flutter pub get..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "[3/4] Building APK..." -ForegroundColor Yellow

if ($type -eq "pro") {
    flutter build apk --release --flavor $flavor --dart-define=FLAVOR=pro --dart-define=YEAR=$year
} else {
    flutter build apk --release --flavor $flavor --dart-define=YEAR=$year
}

$BuildResult = $LASTEXITCODE

# ============================================
# RESTORE ASSETS
# ============================================

Write-Host ""
Write-Host "[4/4] Restoring assets..." -ForegroundColor Yellow

foreach ($g in $GamesToHide) {
    $BackupPath = Join-Path $TempBackupDir "$g-players.csv"
    $DestPath = Join-Path $DataDir "$g\players.csv"
    
    if (Test-Path $BackupPath) {
        Move-Item -Path $BackupPath -Destination $DestPath -Force
        Write-Host "       Restored: $g/players.csv" -ForegroundColor Gray
    }
}

# Clean up temp folder
Remove-Item -Path $TempBackupDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================
# REPORT RESULT
# ============================================

Write-Host ""
if ($BuildResult -eq 0) {
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "  BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK: build\app\outputs\flutter-apk\app-$flavor-release.apk" -ForegroundColor White
    Write-Host "Only $game player data included (saved ~24MB!)" -ForegroundColor White
} else {
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "  BUILD FAILED!" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    exit $BuildResult
}
