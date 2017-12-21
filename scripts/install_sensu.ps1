Write-Host "Installing Sensu client"

$source = "https://sensu.global.ssl.fastly.net/msi/sensu-0.26.5-1.msi"
$destination = "C:\apps\sensu-0.26.5-1.msi"

Invoke-WebRequest -Uri $source -OutFile $destination

Start-Process msiexec.exe -ArgumentList "/i C:\apps\sensu-0.26.5-1.msi /qn /norestart /log C:\sensu_log.txt" -Wait -PassThru

#Create New Folder
#New-Item -Path 'C:\opt\' - ItemType Directory -Force
#New-Item -Path 'C:\opt\sensu\' - ItemType Directory -Force
New-Item -Path 'C:\opt\sensu\conf.d\' - ItemType Directory -Force
