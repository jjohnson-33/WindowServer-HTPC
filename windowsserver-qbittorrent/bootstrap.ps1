$port = $env:qbittorrent_port
if (!$port) {$port="8080"}

$defaultConfigFile = "C:\ProgramData\qBittorrent\qBittorrent.ini"
$configPath = "C:\ProgramData\qBittorrent\config"
$configFile = join-path $configPath "qBittorrent.ini"
if (!(Test-Path $configPath))
{
    new-item $configPath -ItemType Directory -Force
}

if (!(Test-Path $configFile))
{
    copy-item $defaultConfigFile $configPath -Force
}

$qargs = @()
$qargs += "--webui-port=$port" 
$qargs += "--profile=C:\ProgramData\"
$qargs += "--save-path=C:\ProgramData\"
$qargs += "--skip-dialog=true"
$qargs += "--no-splash"

Start-Process -FilePath "C:\Program Files\qBittorrent\qbittorrent.exe" -ArgumentList $qargs -NoNewWindow -Wait
