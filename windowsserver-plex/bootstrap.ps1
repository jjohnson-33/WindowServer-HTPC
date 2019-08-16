
$app = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"

Start-Process -FilePath $app -NoNewWindow -Wait
while ($true) { Start-Sleep -Seconds 3600 }