require 'spec_helper'
require 'shared_contexts'

describe 'gocd::params' do
  # add these two lines in a single test to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  describe 'Windows' do
    include_context :hiera
    let(:facts) do
      { osfamily: 'Windows', operatingsystem: 'windows' }
    end
    let(:params) do
      {

      }
    end
    it do
      should compile
    end

  end

  describe 'Linux' do
    include_context :hiera
    let(:facts) do
      { osfamily: 'RedHat', kernel: 'Linux' }
    end

    let(:params) do
      {

      }
    end
    it { should compile }

  end
end
