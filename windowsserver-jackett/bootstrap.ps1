$app_args = @()
$app_args += "--DataFolder=C:\ProgramData\JackettConfig"

$app = "C:\ProgramData\Jackett\JackettConsole.exe"

Stop-Service jackett

Start-Process -FilePath $app -ArgumentList $app_args -NoNewWindow -Wait
#while ($true) { Start-Sleep -Seconds 3600 }