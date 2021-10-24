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
    } else {
        git.exe clone $_.remote
    }


    if($_.sha1){
        Write-Host "Going to checkout to commit/reference $($_.sha1)"
        
        # cd to the folder it was cloned to
        Push-Location $foldername

        git.exe checkout $_.sha1

        Pop-Location

    } else {
        Write-Host ""
    }

    if(!($_.tooltype)){
        write-host "[x] Project tooltype is not set! This should be fixed!"
        exit;
    } 

    switch ($_.tooltype) {
        "gradle" { 

         }
        Default {
            write-host "unknown project type "
        }
    }

}

Pop-Location