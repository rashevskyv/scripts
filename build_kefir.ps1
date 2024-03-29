﻿#Install-Module PSWriteColor

#$repo = Read-Host
$version = Get-Content D:\git\dev\_kefir\version
$nxlinks_path = "D:\git\dev\nx-links\nx-links.json"
$nxlinks = Get-Content $nxlinks_path
$commit = "kefir" + $version

$repo = "switch"
$path = "D:\git\site\"
$links_folder = "D:\git\dev\nx-links"

cd $path$repo

write-host "`n"
write-host  "-------------------------------------------------------------"
Write-host "                     Checkout to master"
write-host  "-------------------------------------------------------------"
write-host "`n"

git checkout master

Start-Sleep -s 5

git add .
git commit -m "$commit"
git push 

write-host "`n"
write-host  "-------------------------------------------------------------"
Write-host "                         Build site"
write-host  "-------------------------------------------------------------"
write-host "`n"

bundle exec jekyll build

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                      Move site to temp"
write-host  "-------------------------------------------------------------"
write-host "`n"

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}
 
New-Item -ItemType "directory" -Path "$path\temp\$repo"

Copy-Item -Path "$path\$repo\_site\*" -Destination "$path\temp\$repo" -Recurse

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                 Checkout to gh-pages"
write-host  "-------------------------------------------------------------"
write-host "`n"

git checkout gh-pages

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "               Move site from temp to root"
write-host  "-------------------------------------------------------------"
write-host "`n"

Start-Sleep -s 5

Get-ChildItem -Recurse -exclude '.git' | Remove-Item -force -recurse

Start-Sleep -s 5

Copy-Item -Path "$path\temp\$repo\*" -Destination "$path\$repo\" -Recurse

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                Commit site to gh-pages"
write-host  "-------------------------------------------------------------"
write-host "`n"

git add .
git commit -m "$commit"
git push 

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                     Checkout to master"
write-host  "-------------------------------------------------------------"
write-host "`n"

git checkout master

Start-Sleep -s 5

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                        Remove temp"
write-host  "-------------------------------------------------------------"
write-host "`n"

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                        Push index"
write-host  "-------------------------------------------------------------"
write-host "`n"

cd $path"index"

git add .
git commit -m $repo": "$commit
git push 

write-host "`n"
write-host  "-------------------------------------------------------------"
write-host  "                        Push index"
write-host  "-------------------------------------------------------------"
write-host "`n"

$string = $nxlinks -replace '(?<!\d)(\d{3})(?!\d)', $version
$string | Set-Content $nxlinks_path

cd $links_folder
git add .
git commit -m $commit
git push 

pause