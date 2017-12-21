Param(
	[string]$patch
	)

#Runs the EC2Config Service and bundles Instance into new AMI
function EC2ConfigPackage
{
	#Determine OS Version so appropriate cleanup tasks can be performed:
	switch -wildcard ((Get-WmiObject Win32_OperatingSystem).Caption)
	{
		"*2008*"	#Windows 2008
		{
			write-log "Windows 2008 Detected -- running cleanup"
			$OS = "2008"
			#Cleanup Profile Usage Information
			remove-item -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Recent\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
			remove-item -Path "C:\Users\Administrator\AppData\Local\Temp\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
			remove-item -path "C:\Windows\System32\sysprep\Panther\setupact.log" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
			remove-item -path "C:\Windows\System32\sysprep\Panther\setuperr.log" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
			Remove-Item -Path "C:\Windows\System32\sysprep\Panther\IE\setupact.log" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

			#Checks License status before continuing; required for Sysprep to be successful
			foreach ($item in (gwmi SoftwareLicensingProduct))
			{
				if ($item.LicenseStatus -eq 1)
				{
					 write-log "Windows is Licensed"
					 $licensed = $true
				}
			}

		}
		"*Server 2003*"	#Windows 2003
		{
			write-log "Windows 2003 Detected -- running cleanup"
			$OS = "2003"
			###Run Disk Cleanup
			cleanmgr.exe /VERYLOWDISK
			Wait-Process -Name cleanmgr

			#Cleanup Profile Usage Information
			remove-item -Path "C:\Documents and Settings\Administrator\Recent\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
			remove-item -Path "C:\Documents and Settings\Administrator\Local Settings\Temp\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

			#Checks License status before continuing; required for Sysprep to be successful
			foreach ($item in (gwmi Win32_WindowsProductActivation))
			{
				if ($item.ActivationRequired -eq 0)
				{
					 write-log "Windows is Licensed"
					 $licensed = $true
				}
			}
		}
		default
		{
			write-log "No OS Match found -- using default"
			$OS = "Unknown"
			#Cleanup Profile Usage Information
			remove-item -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Recent\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

			#Checks License status before continuing; required for Sysprep to be successful
			foreach ($item in (gwmi SoftwareLicensingProduct))
			{
				if ($item.LicenseStatus -eq 1)
				{
					 write-log "Windows is Licensed"
					 $licensed = $true
				}
			}
		}
	}

	#Ensures that the service is started
	start-service ec2config

	#Removes Temporary Files
	remove-item -Path "C:\Windows\Temp\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

	#Removes old EC2Config Log
	remove-item -Path "C:\Program Files\Amazon\Ec2ConfigService\Logs\Ec2ConfigLog.txt" -Force -Confirm:$false -ErrorAction SilentlyContinue

	#Clears Start Menu Run History
	foreach ($item in (Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist)){Clear-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\$($item.PSChildName)\Count}

	#Clears Explorer Run History
	Clear-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU	#Returns error if no entries exist to clear

	#Removes any previous Memory Dump files
	remove-item -Path "C:\Windows\*.DMP" -Force -Confirm:$false -ErrorAction SilentlyContinue
	remove-item -Path "C:\Windows\Minidump" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

	#Clear IE history
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
	RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32

	#Pre-Compiles Queued .net Assemblies prior to Sysprep
	start -wait C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\ngen.exe -ArgumentList 'executequeueditems'

	#Defragments the Drive
	defrag c:

	#Securely deletes files
	write-log "Permanently erasing deleted files"
	& 'C:\Program Files\Amazon\Ec2ConfigService\Scripts\sdelete.exe' -c -accepteula
	del 'C:\Program Files\Amazon\Ec2ConfigService\Scripts\sdelete.exe'

	write-log "Removing any mapped drives"
	net use \\$RemoteIPAddress\C$ /delete /Y

	#Removes any UserData Scripts
	Remove-Item -Path "C:\Program Files\Amazon\Ec2ConfigService\Scripts\UserScript.bat" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "C:\Program Files\Amazon\Ec2ConfigService\Scripts\UserScript.ps1" -Force -ErrorAction SilentlyContinue

	#Resets desktop wallpaper
	Start-Process "C:\Program Files\Amazon\Ec2ConfigService\Ec2ConfigServiceSettings.exe" -ArgumentList -resetwallpaper

	#############################
	### Run EC2Config Service ###

	#Gets the content of EC2Config Config.xml and enables Password Generation, UserData and DynamicVolumeSize for next boot
	$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"

	$xml = [xml](get-content $EC2SettingsFile)
	$xmlElement = $xml.get_DocumentElement()
	$xmlElementToModify = $xmlElement.Plugins

	write-log "Setting Config.xml"
	foreach ($element in $xmlElementToModify.Plugin)
	{
		write-log " $($element.name)"
		if ($element.name -eq "Ec2SetPassword")
		{
			$element.State="Enabled"
		}
		elseif ($element.name -eq "Ec2HandleUserData")
		{
			$element.State="Enabled"
		}
		elseif ($element.name -eq "Ec2DynamicBootVolumeSize")
		{
			#Except for Windows 2003, enable dynamic Root Volume Sizing
			if ($OS -ne "2003")
			{
				$element.State="Enabled"
			}
		}
		write-log "  $($element.State)"
	}
	$xml.Save($EC2SettingsFile)


	#Gets the content of EC2Config BundleConfig.xml and enables the RDP Cert element so new cert is generated
	$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\BundleConfig.xml"

	$xml = [xml](get-content $EC2SettingsFile)
	$xmlElement = $xml.get_DocumentElement()
	$xmlElementToModify = $xmlElement.Property

	write-log "Setting BundleConfig.xml"
	foreach ($element in $xmlElementToModify)
	{
		write-log " $($element.name)"
		if ($element.name -eq "SetRDPCertificate")
		{
			#For Windows 2003 OS, generates a new RDP Certificate
			if ($OS -eq "2003")
			{
				$element.Value="Yes"
			}
		}
		elseif ($element.name -eq "SetPasswordAfterSysprep")
		{
			$element.Value="Yes"
		}
		write-log "  $($element.Value)"
	}
	$xml.Save($EC2SettingsFile)

	#Clear event logs
	write-log "Clearing Event Logs"
	Clear-EventLog Application
	Clear-EventLog System
	Clear-EventLog Security

	#Checks licensed status prior to running Sysprep
	if ($licensed -eq $true)
	{
		write-log "Starting Sysprep"
		Set-ExecutionPolicy Restricted
		Start-Process "C:\Program Files\Amazon\Ec2ConfigService\ec2config.exe" -ArgumentList -sysprep
	}
	else{write-log "Windows is NOT Licensed, unable to run Sysprep"}
}

#Adds the date/timestamp to write-log for logging
function write-log
{	param([string]$data)

	$date = get-date -format "yyyyMMdd_hhmm:ss"
	write-host "$date $data"
	Out-File -InputObject "$date $data" -FilePath $LoggingFile -Append
}


#Determines the Status of Windows Updates that are being installed
function Get-WIAStatusValue($value)
{
   switch -exact ($value)
   {
      0   {"NotStarted"}
      1   {"InProgress"}
      2   {"Succeeded"}
      3   {"SucceededWithErrors"}
      4   {"Failed"}
      5   {"Aborted"}
   }
}

#Patches the instance then Shuts Down
function patchInstance
{	Param([string]$Option)

	$needsReboot = $false
	$UpdateSession = New-Object -ComObject Microsoft.Update.Session
	$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()


	write-log " - Searching for Updates"
	switch ($Option)
	{
		0	#Finds all Updates
		  {
			$SearchResult = $UpdateSearcher.Search("IsHidden=0 and IsInstalled=0")
		  }
		1		#Finds only Required Updates
		  {
			$SearchResult = $UpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")
		  }
		default	#Finds all Updates}
		  {
		  	$SearchResult = $UpdateSearcher.Search("IsHidden=0 and IsInstalled=0")
			}
	}



	write-log " - Found [$($SearchResult.Updates.count)] Updates to Download and install"
	$i=0	#Initializes counter -- used to track number of update
	foreach($Update in $SearchResult.Updates)
	{
	   $i++	#Increments counter
	   # Add Update to Collection
	   $UpdatesCollection = New-Object -ComObject Microsoft.Update.UpdateColl
	   if ( $Update.EulaAccepted -eq 0 ) { $Update.AcceptEula() }
	   $UpdatesCollection.Add($Update) | out-null

	   # Download
	   write-log " + Downloading [$i of $($SearchResult.Updates.count)] $($Update.Title)"
	   $UpdatesDownloader = $UpdateSession.CreateUpdateDownloader()
	   $UpdatesDownloader.Updates = $UpdatesCollection
	   $DownloadResult = $UpdatesDownloader.Download()
	   $Message = "   - Download {0}" -f (Get-WIAStatusValue $DownloadResult.ResultCode)
	   write-log $message

	   # Install
	   write-log "   - Installing Update"
	   $UpdatesInstaller = $UpdateSession.CreateUpdateInstaller()
	   $UpdatesInstaller.Updates = $UpdatesCollection
	   $InstallResult = $UpdatesInstaller.Install()
	   $Message = "   - Install {0}" -f (Get-WIAStatusValue $DownloadResult.ResultCode)
	   write-log $message
	   write-log
	}
}

##################################
#START OF SCRIPT
##################################
# Starts log File
$LoggingFile = "C:\Program Files\Amazon\Ec2ConfigService\Logs\InstallUpdates_" + $patch + ".txt"
del $LoggingFile -Confirm:$false -ErrorAction SilentlyContinue #Removes previous log file

$CurrentTime = Get-Date
write-log "STARTING: $CurrentTime"


#Validates parameters
switch ($patch)
{
	0 {
		write-log "########################"
		write-log "###PACKAGING INSTANCE###"
		write-log "########################"
		EC2ConfigPackage
	  }	#Prepares the instance for bundling into an AMI -- will shut down as part of EC2Config
	1	#Patch the Instance, then Shut down
	 {
		write-log "############################"
		write-log "###INSTALLING ALL UPDATES###"
		write-log "############################"
		Start-Process "C:\Program Files\Amazon\Ec2ConfigService\Ec2ConfigServiceSettings.exe" -ArgumentList -resetwallpaper

		#Clears any User Pinned Start Menu items
		#$remove-item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

		patchInstance 0	#Installs Required and Recommended Updates
		#Restart-Computer -Force	#Turns off when done
	 }
	2	#Patch the Instance, then Shut down
	 {
		write-log "########################"
		write-log "###INSTALLING UPDATES###"
		write-log "########################"
		Start-Process "C:\Program Files\Amazon\Ec2ConfigService\Ec2ConfigServiceSettings.exe" -ArgumentList -resetwallpaper

		#Clears any User Pinned Start Menu items
		remove-item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

		patchInstance 1	#Installs only Required Updates
		#Restart-Computer -Force	#Turns off when done
	 }
	default
	 {
		write-log "Must specify an valid option -- exiting"
		write-log " 0 = Bundle"
		write-log " 1 = Patch (Including Recommended Updates)"
		write-log " 2 = Patch (Only Required Updates)"
		return -1
	 }
}
