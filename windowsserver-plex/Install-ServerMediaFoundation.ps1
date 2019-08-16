Get-ChildItem "$Env:SystemRoot\Servicing\Packages\*Media*.mum" | ForEach-Object { (Get-Content $_) -replace 'required','no' | Set-Content $_};
#Install-WindowsFeature Server-Media-Foundation
& Dism /online /enable-feature /FeatureName:ServerMediaFoundation /NoRestart