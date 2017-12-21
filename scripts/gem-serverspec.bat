@ECHO OFF

call "C:\Program Files\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

REM Install AWS-SDK
gem install serverspec
