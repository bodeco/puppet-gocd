require 'spec_helper'
require 'shared_contexts'
require 'benchmark'
describe 'gocd::agent' do
  describe 'Windows' do
    include_context :hiera
    let(:facts) do
      { osfamily: 'Windows', operatingsystem: 'windows', staging_windir: 'C:\\ProgramData\\staging' }
    end
    let(:params) do
      {
        build: '50', version: '1.0', java_home: 'C:/Program Files/Java/jre7'
      }
    end
    it { should contain_archive('C:/Windows/Temp/go-agent-1.0-50-setup.exe') }
    it { should contain_package('Go Agent')  }
    it { should contain_file('autoregister.properties').with_path("C:/Program Files (x86)/Go Agent/config/autoregister.properties") }
    it { should contain_file('C:/Program Files (x86)/Go Agent/config') }
  end
  describe 'Linux' do
    include_context :hiera
    let(:facts) do
      { osfamily: 'RedHat', kernel: 'Linux' }
    end

    let(:params) do
      {
        build: '50', version: '1.0'
      }
    end
    it { should contain_file('/etc/default/go-agent') }
    it { should contain_file('/var/go') }
    it { should contain_package('go-agent')   }
    it { should contain_file('autoregister.properties') }
    it { should contain_file('/var/go/.bashrc').with({:ensure => 'link',
                                                      :target => '/etc/default/go-agent',
                                                     :require => '[File[/etc/default/go-agent]{:path=>"/etc/default/go-agent"}, File[/var/go]{:path=>"/var/go"}]',
                                                     :notify  => 'Service[go-agent]'
                                                     })}

  end
end
