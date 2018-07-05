download_file { 'Download Sensu 1.4.2-3' :
  url                   => 'https://sensu.global.ssl.fastly.net/msi/2012r2/sensu-1.4.2-3-x64.msi',
  destination_directory => 'c:\\apps'
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

package { 'sensu':
  ensure          =>  'installed',
  source          =>  'C:\\apps\\sensu-1.4.2-3-x64.msi',
  install_options =>  ['INSTALLDIR=C:\\opt'],
  provider        =>  windows  
}
