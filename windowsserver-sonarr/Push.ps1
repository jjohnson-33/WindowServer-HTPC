$PSScriptRoot
$imageName = Split-Path $PSScriptRoot -Leaf
$imageName

& docker build .
& docker tag $imageName "jjohnson33/$($imageName):latest"
& docker push "jjohnson33/$($imageName):latest"
