#$repo = Read-Host
write-host "Repo name:"
$repo = Read-Host
write-host "Commit: "
$commit = Read-Host

$path = "F:\git\site\"

cd $path$repo

git checkout master

Start-Sleep -s 5

git add .
git commit -m "$commit"
git push 

jekyll build

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}
 
New-Item -ItemType "directory" -Path "$path\temp\$repo"

Copy-Item -Path "$path\$repo\_site\*" -Destination "$path\temp\$repo" -Recurse

git checkout gh-pages

Start-Sleep -s 5

Get-ChildItem -Path '$path\$repo\' -Recurse -exclude .git | Remove-Item -force -recurse

Copy-Item -Path "$path\temp\$repo\*" -Destination "$path\$repo\" -Recurse

git add .
git commit -m "$commit"
git push 

git checkout master

Start-Sleep -s 5

if (Test-Path "$path\temp\$repo") {
    Remove-Item "$path\temp\$repo" -Recurse
}

cd $pathindex

git add .
git commit -m "$repo: $commit"
git push 