# Install go cd agent from http://www.go.cd/download/
class gocd::agent (
  $url               = $gocd::params::url,
  $version           = $gocd::params::version,
  $build             = $gocd::params::build,
  $source            = $gocd::params::source,
  $server            = $gocd::params::server,
  $port              = $gocd::params::port,
  $agent_work_dir    = $gocd::params::agent_work_dir,
  $java_home         = $gocd::params::java_home,
  $package_ensure    = $gocd::params::package_ensure,
  $package_provider  = $gocd::params::package_provider,
  $service_ensure    = $gocd::params::service_ensure,
  $auto_register_key = undef,
  $resources         = [],
  $environments      = undef,
) inherits gocd::params {

  validate_array($resources)

  $source_url = sprintf($source, $url, $version, $build)

  case $::osfamily {
    'Redhat': {
      require '::java'

      $package_name = 'go-agent'
      $package_source = $source_url
      $package_options = undef
      $service_name = 'go-agent'
      $owner = 'go'
      $group = 'go'

      file { '/etc/default/go-agent':
        ensure  => 'present',
        owner   => $owner,
        group   => $group,
        mode    => '0644',
        content => template('gocd/go-agent.erb'),
        require => Package[$package_name],
        notify  => Service[$service_name],
      }

      file { '/var/go':
        ensure  => directory,
        owner   => $owner,
        group   => $group,
        mode    => '0755',
        require => Package[$package_name],
      }
    }
    'Windows': {
      $archive_path = "C:/Windows/Temp/go-agent-${version}-${build}-setup.exe"

      $package_name = 'Go Agent'
      $package_source = $archive_path
      $package_options = [ '/S', "/SERVERIP=${server}", "/GO_AGENT_JAVA_HOME=${java_home}" ]
      $service_name = 'Go Agent'
      $owner = 'S-1-5-32-544'
      $group = 'S-1-5-18'

      archive { $archive_path:
        source => $source_url,
        before => Package[$package_name],
      }
    }
  }

  package { $package_name:
    ensure          => $package_ensure,
    provider        => $package_provider,
    source          => $package_source,
    install_options => $package_options,
  }

  file { "${agent_work_dir}/config":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    require => Package[$package_name],
  }

  # For additional information see:
  # http://www.thoughtworks.com/products/docs/go/current/help/agent_auto_register.html
  file { 'autoregister.properties':
    path    => "${agent_work_dir}/config/autoregister.properties",
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template('gocd/autoregister.properties.erb'),
  }

  service { $service_name:
    ensure    => $service_ensure,
    enable    => true,
    subscribe => File['autoregister.properties'],
  }
}
