require 'serverspec'

#Specify server running Windows with cmd
set :backend, :cmd
set :os, :family => 'windows'

#Test Packages
describe package('AWS Command Line Interface') do
  it { should be_installed}
end

describe package('AWS Tools for Windows') do
  it { should be_installed}
end

describe package('aws-cfn-bootstrap') do
  it { should be_installed}
end

describe package('EC2ConfigService') do
  it { should be_installed}
end

describe package('NetTime') do
  it { should be_installed}
end

describe package('Notepad++') do
  it { should be_installed}
end

describe package('Puppet Agent (64-bit)') do
  it { should be_installed}
end

describe package('Sensu') do
  it { should be_installed}
end

describe package('Symantec Endpoint Protection') do
  it { should be_installed}
end

#Test Services
describe service('Puppet Agent') do
  it { should have_start_mode("Manual")}
end

describe service('EC2Config') do
  it { should be_installed}
end

describe service('Symantec Management Agent') do
  it { should have_start_mode("Automatic")}
end

#Test Ports
describe port(3389) do
  it { should be_listening }
end

describe port(5985) do
  it { should be_listening }
end

describe port(5986) do
  it { should be_listening }
end
