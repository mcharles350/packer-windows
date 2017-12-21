<#
Script Name: SysPrep Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Sysprep AMI
Date:  1/18/17
Created by: Max Charles Jr.
#>

###################################################################################################################################################################
#Delete Apps folder
Remove-Item -Path C:\apps\* -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path C:\apps

###################################################################################################################################################################
#Delete Puppet Cache Files
Remove-Item -Path %PROGRAMDATA%\PuppetLabs\puppet\cache\* -Force -Recurse -ErrorAction SilentlyContinue

####################################################################################################################################################################
#Set Puppet Agent Service to Manual
Write-Host "Set Puppet Agent to Manual Startup"
Set-Service -Name puppet -StartupType Manual

Write-Host "Puppet Agent Service Stopped"
Start-Sleep -Seconds 50

###################################################################################################################################################################
#Reset CEM Client Settings from registry
Write-Host "CEM Client Cleanup"

Stop-Service -Name AeXNSClient -Force
Start-Sleep -Seconds 50

Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress" /v MachineGuid /f}
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\eXpress\NS Client" /v MachineGuid /f}
Invoke-Command -ScriptBlock {cmd.exe /c reg.exe delete "HKLM\SOFTWARE\Altiris\Altiris Agent" /v MachineGuid /f}

#Cleanup SEP client GUID informtion
Write-Host "SEP Client Cleanup"

Invoke-Command -ScriptBlock {& "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\smc.exe" -stop}
Remove-Item -Path "C:\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Common Files\Symantec Shared\HWID\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\All Users\Symantec\Symantec Endpoint Protection\PersistedData\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\*\Local Settings\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\*\AppData\Local\Temp\sephwid.xml" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Common Files\Symantec Shared\HWID\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\CurrentVersion\Data\Config\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\All Users\Application Data\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\All Users\Symantec\Symantec Endpoint Protection\PersistedData\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Documents and Settings\*\Local Settings\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\*\AppData\Local\Temp\communicator.dat" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\ForceHardwareKey" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\HardwareID" -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\HostGUID" -Force -Confirm:$false -ErrorAction SilentlyContinue

#Sysprep - 1st Step
Write-Host "Preparing Sysprep"

$doc = [xml](Get-Content "C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml")
$doc.Ec2ConfigurationSettings.Plugins.Plugin[0].State = "Enabled"
$doc.save("C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml")
$doc1 = [xml](Get-Content "C:\Program Files\Amazon\Ec2ConfigService\sysprep2008.xml")
(($doc1.unattend.settings | Where-Object {$_.pass -eq "specialize"} | Select-Object -ExpandProperty component) | Where-Object{$_.name -eq "Microsoft-Windows-Shell-Setup"}).CopyProfile = "false"
$doc1.save("C:\Program Files\Amazon\Ec2ConfigService\sysprep2008.xml")
$fileName = "C:\Program Files\Amazon\Ec2ConfigService\Settings\WallpaperSettings.xml";
$xmlDoc = [System.Xml.XmlDocument](Get-Content $fileName);
$newXmlwp = $xmlDoc.WallpaperSettings.AppendChild($xmlDoc.CreateElement("WallpaperInformation","http://tempuri.org/WallpaperSettings.xsd"))
$newXmlNameElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("name","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlNameTextNode = $newXmlNameElement.AppendChild($xmlDoc.CreateTextNode("AMI-ID"));
$newXmlsoElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("source","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlsoTextNode = $newXmlsoElement.AppendChild($xmlDoc.CreateTextNode("metadata"));
$newXmlidElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("identifier","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlidTextNode = $newXmlidElement.AppendChild($xmlDoc.CreateTextNode("meta-data/ami-id"));
$xmlDoc.Save($fileName)
$fileName = "C:\Program Files\Amazon\Ec2ConfigService\Settings\WallpaperSettings.xml";
$xmlDoc = [System.Xml.XmlDocument](Get-Content $fileName);
$newXmlwp = $xmlDoc.WallpaperSettings.AppendChild($xmlDoc.CreateElement("WallpaperInformation","http://tempuri.org/WallpaperSettings.xsd"))
$newXmlNameElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("name","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlNameTextNode = $newXmlNameElement.AppendChild($xmlDoc.CreateTextNode("Security Group"));
$newXmlsoElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("source","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlsoTextNode = $newXmlsoElement.AppendChild($xmlDoc.CreateTextNode("metadata"));
$newXmlidElement = $newXmlwp.AppendChild($xmlDoc.CreateElement("identifier","http://tempuri.org/WallpaperSettings.xsd"));
$newXmlidTextNode = $newXmlidElement.AppendChild($xmlDoc.CreateTextNode("meta-data/security-groups"));
$xmlDoc.Save($fileName)

Invoke-Command -ScriptBlock {& "C:\Program Files\Amazon\Ec2ConfigService\Ec2WallpaperInfo.exe"}

Write-Host "Updating EC2Config"

$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\BundleConfig.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()

foreach ($element in $xmlElement.Property)
{
    if ($element.Name -eq "AutoSysprep")
    {
        $element.Value="Yes"
    }
}
$xml.Save($EC2SettingsFile)

$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)

Write-Host "Updated EC2Config"

#Sysprep - Final Step
Write-Host "Finalize Sysprep"

Start-Sleep -Seconds 120

$awssys = "$env:programFiles\Amazon\Ec2ConfigService\ec2config.exe"
$arguments = "-sysprep"
start-process $awssys $arguments
