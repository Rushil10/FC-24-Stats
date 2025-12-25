param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("free", "pro")]
    $type = "free",

    [Parameter(Mandatory=$false)]
    $year = "24"
)

$flavor = "fc$($year)$($type.substring(0,1).ToUpper())$($type.substring(1))"

Write-Host "Building Player Stats $year ($type version)..." -ForegroundColor Cyan

if ($type -eq "pro") {
    flutter build apk --release --flavor $flavor --dart-define=FLAVOR=pro --dart-define=YEAR=$year
} else {
    flutter build apk --release --flavor $flavor --dart-define=YEAR=$year
}

Write-Host "`nBuild Complete!" -ForegroundColor Green
Write-Host "Your APK is at: build\app\outputs\flutter-apk\app-$flavor-release.apk"
