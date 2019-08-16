$app_args = @()
$app_args += "/data=C:\ProgramData\SonarrConfig"

$app = "C:\ProgramData\NzbDrone\bin\NzbDrone.console.exe"

Start-Process -FilePath $app -ArgumentList $app_args -NoNewWindow -Wait
#while ($true) { Start-Sleep -Seconds 3600 }