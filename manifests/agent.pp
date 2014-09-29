# Install go cd agent from http://www.go.cd/download/
class gocd::agent (
  $url              = $gocd::params::url,
  $version          = $gocd::params::version,
  $build            = $gocd::params::build,
  $source           = $gocd::params::source,
  $server           = $gocd::params::server,
  $port             = $gocd::params::port,
  $agent_work_dir   = $gocd::params::agent_work_dir,
  $java_home        = $gocd::params::java_home,
  $package_ensure   = $gocd::params::package_ensure,
  $package_provider = $gocd::params::package_provider,
  $service_ensure   = $gocd::params::service_ensure,
  $auto_register_key = undef,
  $resources = [],
  $environments = undef,
) inherits gocd::params {

  validate_array($resources)

  $source_url = sprintf($source, $url, $version, $build)

  case $::osfamily {
    'Redhat': {
      require '::java'

      $package_source = $source_url

      package { 'go-agent':
        ensure   => $package_ensure,
        provider => $package_provider,
        source   => $package_source,
      }

      file { '/etc/default/go-agent':
        ensure  => 'present',
        owner   => 'go',
        group   => 'go',
        mode    => '0644',
        content => template('gocd/go-agent.erb'),
        require => Package['go-agent'],
      }

      file { "${agent_work_dir}/config":
        ensure  => directory,
        owner   => 'go',
        group   => 'go',
        mode    => '0755',
        require => Package['go-agent'],
      }

      # For additional information see:
      # http://www.thoughtworks.com/products/docs/go/current/help/agent_auto_register.html
      file { 'autoregister.properties':
        path    => "${agent_dir}/config/autoregister.properties",
        owner   => 'go',
        group   => 'go',
        mode    => '0644',
        content => template('gocd/autoregister.properties.erb'),
      }

      service { 'go-agent':
        ensure    => $service_ensure,
        enable    => true,
        subscribe => File['/etc/default/go-agent', 'autoregister.properties'],
      }
    }
    'Windows': {
      $archive_path = "C:/temp/go-agent-${version}-${build}-setup.exe"

      archive { $archive_path:
        source => $source_url,
      }

      exec { 'install-agent':
        command     => "${archive_path} /S /SERVERIP=${server} /GO_AGENT_JAVA_HOME=${java_home}",
        subscribe   => Archive[$archive_path],
        refreshonly => true,
      }
    }
  }
}
