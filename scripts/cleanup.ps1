<#
Script Name: Cleanup Script for Windows AMI
OS: Windows Server 2012 R2
Purpose: Sysprep AMI
Date:  6/9/17
Created by: Max Charles Jr.
#>

Write-Host "Performing Cleanup"
Start-Sleep -Seconds 10

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
& "C:\Program Files\Amazon\Ec2ConfigService\Ec2WallpaperInfo.exe"
####################################################################################################################################################################################################
Write-Host "Enable Ec2DynamicBootVolumeSize"
Start-Sleep -Seconds 10

$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2DynamicBootVolumeSize")
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)

Write-Host "Ec2DynamicBootVolumeSize is now enabled"
Start-Sleep -Seconds 10

####################################################################################################################################################################################################
Write-Host "Updating BundleConfig"
Start-Sleep -Seconds 5

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

Write-Host "BundleConfig update completed"
Start-Sleep -Seconds 10

####################################################################################################################################################################################################
Write-Host "Updating EC2Config"
Start-Sleep -Seconds 5

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

Stop-Service -Name EC2Config -ErrorAction SilentlyContinue -Force
Write-Host "EC2Config update completed"
Start-Sleep -Seconds 10
####################################################################################################################################################################################################
