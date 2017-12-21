#Install Windows Update KB3134758
#########################################################################################################
Write-Host "Installing Windows Mgmt Framework 5.1"
$WU = {Start-Process dism.exe -ArgumentList "/online /add-package /PackagePath:C:\apps\win2012r2\WindowsBlue-KB3134758-x64.cab /quiet /norestart" -Wait -PassThru}
Invoke-Command -ScriptBlock $WU | Out-Null


Write-Host "ExitCode is " $a.ExitCode
Write-Host "KB3134758 is installed." -ForegroundColor Green

Start-Sleep -Seconds 30
#########################################################################################################