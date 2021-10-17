Get-ChildItem "./repos" | 
Foreach-Object {
    pushd $_.FullName

    snyk.exe monitor

    popd
}
