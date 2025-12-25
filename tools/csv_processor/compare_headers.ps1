
$c24 = (Get-Content 'assets/images/players_24.csv' -TotalCount 1).Split(',')
$c23 = (Get-Content 'assets/images/players_23.csv' -TotalCount 1).Split(',')

function PrintCol($i) {
    if ($i -lt 110) {
        $v24 = if ($i -lt $c24.Count) { $c24[$i] } else { "[MISSING]" }
        $v23 = if ($i -lt $c23.Count) { $c23[$i] } else { "[MISSING]" }
        Write-Host "COL $i : FC24='$v24' | FIFA23='$v23'"
    }
}

for ($i=100; $i -lt 110; $i++) {
    PrintCol($i)
}
