$repoData = Import-Csv -Path .\projects.csv

if (!(Test-Path -Path repos)) {
    mkdir repos
}

Push-Location repos

foreach ($csvItem in $repoData) {

    # end of url
    $foldername = ([System.Uri]$csvItem.remote).Segments[-1]

    # write-host "we want to clone $($csvItem.remote) into $foldername"

    # if path exists...
    if (Test-Path -Path $foldername) {
        Write-Host "[+] Folder '$foldername' `t already exists, not cloning, but we will stash to clean the working tree."
        Push-Location $foldername
        git stash
        Pop-Location
    }
    else {
        git clone $csvItem.remote
    }


    if ($csvItem.sha1) {
        Write-Host "Going to checkout to commit/reference $($csvItem.sha1)"
        
        # cd to the folder it was cloned to
        Push-Location $foldername

        git checkout $csvItem.sha1

        Pop-Location

    }
    else {
        Write-Host ""
    }

    if (!($csvItem.tooltype)) {
        write-host "[x] Project tooltype is not set! This should be fixed!"
        exit;
    } 

    Push-Location $foldername
    switch ($csvItem.tooltype) {
        "java_gradle" { 
            write-host "[x] TODO setup gradle xd"
        }
        "python_pipenv" {
            pipenv install
        }
        "python_requirements" {
            pipenv install -r .\requirements.txt
        }
        "c_make" {
            write-host "[x] TODO setup make"
        }
        "java_maven" {
            mvn install
        }
        "php" {
            write-host "[-] Nothing to do for PHP type projects."
        }
        Default {
            write-host "unknown tooltype '$($csvItem.tooltype)'! Halting!"
            exit;
        }
    }
    Pop-Location

    # store tool type inside repo
    Push-Location $foldername
    echo $csvItem.tooltype > TOOLTYPE.txt
    Pop-Location

}

Pop-Location