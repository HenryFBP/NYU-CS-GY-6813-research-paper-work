if (test-path 'reports') {
    Remove-Item 'reports' -Recurse -Force;
}

mkdir reports

$basedir = Resolve-Path "./reports"

Get-ChildItem "./repos" | 
Foreach-Object {

    $reportName = $_.BaseName + ".report"

    Push-Location $_.FullName

    $projectType = get-content (Join-Path -Path $_.FullName -ChildPath "TOOLTYPE.txt")
    write-host "Project type is $projectType"

    snyk.exe monitor > $(Join-Path -Path $basedir -ChildPath "$reportName.snyk.txt")

    bandit . -r > $(Join-Path -Path $basedir -ChildPath "$reportName.bandit.txt")

    Pop-Location
}
