#read the environment
$heartBeatScript = $env:heartbeat_script
$warmupScript = $env:warmup_script
$app = $env:bootstrap_process
$appName = Split-Path $app -Leaf
$argString = $env:bootstrap_args

#warmup
if ($warmupScript -and (Test-Path $warmupScript))
{
    & $warmupScript
}

#launch the process
if ($argString) {
    $args = ( $argString -split "|" )
    Start-Process -FilePath $app -ArgumentList $args -NoNewWindow    
}
else {
    Start-Process -FilePath $app -NoNewWindow    
}

#watchdog and heartbeat loop
while ($true) { 
    Start-Sleep -Seconds 60
    if ((Get-Process | Select-Object -ExpandProperty Path) -contains $app)
    {
        Write-Host "$appName is alive."
        if ($heartBeatScript -and (Test-Path $heartBeatScript))
        {
            & $heartBeatScript
        }
    }
    else {
        Write-Host "$appName is dead!"
        exit
    }
}