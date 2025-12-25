param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("free", "pro")]
    $type = "free",

    [Parameter(Mandatory=$false)]
    $year = "24",

    [Parameter(Mandatory=$false)]
    [switch]$install
)

$flavor = "fc$($year)$($type.substring(0,1).ToUpper())$($type.substring(1))"

if ($install) {
    Write-Host "Installing Player Stats $year ($type version)..." -ForegroundColor Cyan
    flutter install --flavor $flavor
} else {
    Write-Host "Running Player Stats $year ($type version)..." -ForegroundColor Cyan
    if ($type -eq "pro") {
        flutter run --flavor $flavor --dart-define=FLAVOR=pro --dart-define=YEAR=$year
    } else {
        flutter run --flavor $flavor --dart-define=YEAR=$year
    }
}
