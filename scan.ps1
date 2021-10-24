if (test-path 'reports'){
    Remove-Item 'reports' -Recurse -Force;
}

mkdir reports

$basedir = Resolve-Path "./reports"

Get-ChildItem "./repos" | 
Foreach-Object {

    $reportName = $_.BaseName + ".report"

    Push-Location $_.FullName


    snyk.exe monitor > $(Join-Path -Path $basedir -ChildPath "$reportName.snyk.txt")

    bandit . -r > $(Join-Path -Path $basedir -ChildPath "$reportName.bandit.txt")

    Pop-Location
}
