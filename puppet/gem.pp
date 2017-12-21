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