#$repo = Read-Host
write-host "Repo name:"
$repo = Read-Host
write-host "Commit: "
$commit = Read-Host

$path = "E:\git\site\"

cd $path$repo

write-host "`n"
Write-Color -Text "Checkout to master" -Color Yellow
write-host "`n"

git checkout master

Start-Sleep -s 5

git add .
git commit -m "$commit"
git push 

Start-Sleep -s 5

write-host "`n"
Write-Color -Text  "Push index" -Color Yellow
write-host "`n"

cd $pathindex

git add .
git commit -m $repo": "$commit
git push 