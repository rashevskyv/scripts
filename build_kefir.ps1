#Install-Module PSWriteColor

#$repo = Read-Host
$repo = "switch"
$version = Get-Content E:\Switch\_kefir\version
$commit = "kefir" + $version

$path = "F:\git\site\"

cd $path$repo

write-host "`n"
Write-Color -Text "Checkout to master" -Color Yellow
write-host "`n"

git checkout master

Start-Sleep -s 5

git add .
git commit -m "$commit"
git push 

write-host "`n"
Write-Color -Text  "Build site" -Color Yellow
write-host "`n"

jekyll build

write-host "`n"
Write-Color -Text  "Move site to temp" -Color Yellow
write-host "`n"

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}
 
New-Item -ItemType "directory" -Path "$path\temp\$repo"

Copy-Item -Path "$path\$repo\_site\*" -Destination "$path\temp\$repo" -Recurse

write-host "`n"
Write-Color -Text  "Checkout to gh-pages" -Color Yellow
write-host "`n"

git checkout gh-pages

write-host "`n"
Write-Color -Text  "Move site from temp to root" -Color Yellow
write-host "`n"

Start-Sleep -s 5

Get-ChildItem -Recurse -exclude '.git' | Remove-Item -force -recurse

Start-Sleep -s 5

Copy-Item -Path "$path\temp\$repo\*" -Destination "$path\$repo\" -Recurse

write-host "`n"
Write-Color -Text  "Commit site to gh-pages" -Color Yellow
write-host "`n"

git add .
git commit -m "$commit"
git push 

write-host "`n"
Write-Color -Text  "Checkout to master" -Color Yellow
write-host "`n"

git checkout master

Start-Sleep -s 5

write-host "`n"
Write-Color -Text  "Remove temp" -Color Yellow
write-host "`n"

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}

write-host "`n"
Write-Color -Text  "Push index" -Color Yellow
write-host "`n"

cd $path"index"

git add .
git commit -m $repo": "$commit
git push 