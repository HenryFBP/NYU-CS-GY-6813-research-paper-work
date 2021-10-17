$repoData = Import-Csv -Path .\projects.csv

if (!(Test-Path -Path repos)){
    mkdir repos
}

Push-Location repos

foreach($_ in $repoData) {

    # end of url
    $foldername = ([System.Uri]$_.remote).Segments[-1]

    # write-host "we want to clone $($_.remote) into $foldername"

    # if path exists...
    if(Test-Path -Path $foldername){
        Write-Host "[+] Folder '$foldername' `t already exists, not cloning..."
        continue;
    }

    git.exe clone $_.remote

    if($_.sha1){
        Write-Host " and checkout to commit/reference $($_.sha1)"
        
        # cd to the folder it was cloned to
        Push-Location $foldername

        git.exe checkout $_.sha1

        Pop-Location

        git checkout $_.sha1
    } else {
        Write-Host ""
    }
}

Pop-Location