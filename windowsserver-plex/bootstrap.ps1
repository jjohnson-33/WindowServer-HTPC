# thanks to AwesomeContainer for this script bit about managing the plex machine ID!!!
# https://github.com/AwesomeContainer/wdocker-plexmediaserver/blob/master/Bootstrap.ps1

$plexRegistryPath = "HKCU:\Software\Plex, Inc.\Plex Media Server"
$plexCMDRegistryPath = "HKCU\Software\Plex, Inc.\Plex Media Server"
$configPath = "c:\ProgramData\PlexConfig"
$regFile = Join-Path $configPath "regbackup.reg"

function Test-RegistryKeyProperty([string] $keyPath, [string] $propertyName)
{
    [bool] $exists = (Get-Item $keyPath -ErrorAction Ignore).Property -contains $propertyName
    return $exists
}

function Set-RegistryKey([string] $keyPath, [string] $propertyName, [string] $propertyType, [object] $value)
{
    if (!(Test-Path $keyPath))
    {
        New-Item -Path $keyPath -Force | Out-Null
        New-ItemProperty -Path $keyPath -Name $propertyName -Value $value -PropertyType $propertyType -Force | Out-Null
    }
    else
    {
        #if the path exists, and the property exists, delete the property and re-create
        #dont update, incase the type changed
        if (Test-RegistryKeyProperty $keyPath $propertyName)
        {
            Remove-ItemProperty -Path $keyPath -Name $propertyName -Force | Out-Null
        }
        New-ItemProperty -Path $keyPath -Name $propertyName -Value $value -PropertyType $propertyType -Force | Out-Null
    }
}

function SaveMachineKeyToVolume()
{
    if (!(Test-Path $regFile))
    {
        #if there is no config file, but we have a valid machine id,
        #then lets save that out to the config file for next time
        $machineId = (Get-ItemProperty $plexRegistryPath).MachineIdentifier
        if ($null -ne $machineId)
        {
            Write-Host "Saving Registry Settings To Volume..."
            REG export $plexCMDRegistryPath $regFile
        }
    }    
}

function LoadMachineKeyFromVolume()
{
    if (Test-Path $regFile)
    {
        Write-Host "Loading Registry Settings From Volume..."
        Remove-Item $plexRegistryPath -Force
        REG import $regFile
    }
}

function SetPlexRegistrySettingsForDocker()
{
    $property = "LocalAppDataPath"
    Set-RegistryKey $plexRegistryPath $property "String" $configPath
}


LoadMachineKeyFromVolume #Load the machine key backup if it exists
SetPlexRegistrySettingsForDocker #set the path for data files
SaveMachineKeyToVolume #Save the machine key backup if it doesnt exist, and we have a valid machine key

#read the environment
$warmupScript = $env:warmup_script

#warmup
if ($warmupScript -and (Test-Path $warmupScript))
{
    & $warmupScript
}

$app = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"
Start-Process -FilePath $app -NoNewWindow
while ($true) { 
    Start-Sleep -Seconds 60 
    if (Get-Process "Plex Media Server" -ErrorAction SilentlyContinue)
    {
        Write-Host "Plex Still Alive"
        SaveMachineKeyToVolume #Save the machine key backup if it doesnt exist, and we have a valid machine key
    }
    else {
        Write-Host "Plex Dead"
        Exit
    }
}

