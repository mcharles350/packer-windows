package { 'git':
  ensure          =>  installed,
  source          =>  'C:\apps\Git-2.11.0.3-64-bit.exe',
  install_options =>  [ '/SP-', '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/LOG=C:\git_log.txt' ],
}

package { 'awscli':
  ensure          =>  installed,
  source          =>  'C:\apps\AWSCLI64.msi',
  provider        =>  windows,
}

package { 'aws-agent':
  ensure          =>  installed,
  source          =>  'C:\apps\AWSAgentInstall.exe',
  install_options =>  [ '/install', '/quiet', '/norestart', '/log C:\aws_inspector.txt' ],
}

package { 'altiris':
  ensure          =>  installed,
  source          =>  'C:\apps\CEMInstall.exe',
  install_options =>  [ '/s', '/pass:Password123!' ],
}

package { 'notepad++':
  ensure          =>  installed,
  source          =>  'C:\apps\npp.7.5.1.Installer.x64.exe',
  install_options =>  [ '/S' ],
}

package { 'sep':
  ensure          =>  installed,
  source          =>  'C:\apps\setup.exe',
}

package { 'nettime':
  ensure          =>  installed,
  source          =>  'C:\apps\NetTimeSetup-314.exe',
  install_options =>  [ '/silent' ],
}

package { 'sensu':
  ensure          =>  installed,
  source          =>  'C:\apps\sensu-0.29.0-7-x64.msi',
  provider        =>  windows,  
}

package { 'aws-sdk':
  ensure          => '2.2.36',
  source          => 'http://artifactory.ap.org/api/gems/rubygems',
  provider        => 'gem',
}

package { 'deep_merge':
  ensure          => '1.1.1',
  source          => 'http://artifactory.ap.org/api/gems/rubygems',
  provider        => 'gem',
}

package { 'r10k':
  ensure          => '2.2.2',
  source          => 'http://artifactory.ap.org/api/gems/rubygems',
  provider        => 'gem',
}

package { 'macaddr':
  ensure          => '1.7.1',
  source          => 'http://artifactory.ap.org/api/gems/rubygems',
  provider        => 'gem',
}