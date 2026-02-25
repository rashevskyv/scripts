#$repo = Read-Host
write-host "Repo name:"
$repo = Read-Host

$path = "D:\git\site\"

cd $path$repo

bundle exec jekyll serve --trace

pause