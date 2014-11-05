require 'spec_helper'
require 'shared_contexts'
require 'benchmark'
describe 'gocd::agent' do
  describe 'Windows' do
    include_context :hiera
    let(:facts) do
      { osfamily: 'Windows', operatingsystem: 'windows' }
    end
    let(:params) do
      {
        build: '50', version: '1.0'
      }
    end
    it { should contain_archive('C:/Windows/Temp/go-agent-1.0-50-setup.exe') }
    it { should contain_package('Go Agent')  }
    it { should contain_file('autoregister.properties') }

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
  end
end
