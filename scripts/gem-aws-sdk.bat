@ECHO OFF

call "C:\Program Files\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

REM Install AWS-SDK and other tools
gem install aws-sdk -v 2.2.36 --no-ri --no-rdoc --source http://artifactory.ap.org/api/gems/rubygems
gem install deep_merge -v 1.0.1 --no-ri --no-rdoc --source http://artifactory.ap.org/api/gems/rubygems
gem install r10k -v 2.2.2 --no-ri --no-rdoc --source http://artifactory.ap.org/api/gems/rubygems
gem install macaddr -v 1.7.1 --no-ri --no-rdoc --source http://artifactory.ap.org/api/gems/rubygems
