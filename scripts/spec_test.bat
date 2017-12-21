@ECHO OFF

call "C:\Program Files\Puppet Labs\Puppet\bin\environment.bat" %0 %*

REM Display Ruby version
ruby.exe -v

cd /
cp C:\spec\win_spec.rb C:\spec\spec\localhost
rm C:\spec\spec\localhost\sample_spec.rb
cd C:\spec
rake spec 'TARGET_HOST=localhost
