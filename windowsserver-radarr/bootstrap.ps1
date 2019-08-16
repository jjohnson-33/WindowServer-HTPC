$app_args = @()
$app_args += "/nobrowser" 
$app_args += "/data=C:\ProgramData\RadarrConfig"

$app = "C:\ProgramData\Radarr\bin\radarr.console.exe"

Start-Process -FilePath $app -ArgumentList $app_args -NoNewWindow -Wait
while ($true) { Start-Sleep -Seconds 3600 }