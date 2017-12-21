download_file { 'Download Git' :
  url                   => 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.3/Git-2.11.0.3-64-bit.exe',
  destination_directory => 'c:\\apps'
}

download_file { 'Download AWS CLI' :
  url                   => 'https://s3.amazonaws.com/aws-cli/AWSCLI64.msi',
  destination_directory => 'c:\\apps'
}

download_file { 'Download AWS Agent for Amazon Inspector' :
  url                   => 'https://d1wk0tztpsntt1.cloudfront.net/windows/installer/latest/AWSAgentInstall.exe',
  destination_directory => 'c:\\apps'
}

download_file { 'Download Sensu 0.29.0-7' :
  url                   => 'https://sensu.global.ssl.fastly.net/msi/2012r2/sensu-0.29.0-7-x64.msi',
  destination_directory => 'c:\\apps'
}

download_file { 'Download Notepad++ 7.5.1' :
  url                   => 'https://notepad-plus-plus.org/repository/7.x/7.5.1/npp.7.5.1.Installer.x64.exe',
  destination_directory => 'c:\\apps'
}

download_file { 'Download NetTime 3.14' :
  url                   => 'http://www.timesynctool.com/NetTimeSetup-314.exe',
  destination_directory => 'c:\\apps'
}