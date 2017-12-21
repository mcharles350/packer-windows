#Install Puppet Agent 64-bit
###############################################################################################################################################
Write-Host "Downloading Puppet Agent Installer"
$url = "https://downloads.puppetlabs.com/windows/puppet-agent-1.10.1-x64.msi"
$path = "C:\temp\puppet-agent-1.10.1-x64.msi"

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile( $url, $path )

Write-Host "Puppet Agent Installer download complete"
Start-Sleep -Seconds 15

<#
Write-Host "Install Puppet Agent"
Start-Sleep -Seconds 15
Start-Process msiexec.exe -ArgumentList "/qn /i C:\apps\puppet-agent-x64.msi PUPPET_MASTER_SERVER=badhost.ap.org /log C:\puppet_logs.txt" -Wait -PassThru
#>
################################################################################################################################################
