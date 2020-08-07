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

Start-Sleep -s 5

cd $pathindex

git add .
git commit -m "$repo: $commit"
git push 