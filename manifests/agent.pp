# Install go cd agent from http://www.go.cd/download/
class gocd::agent (
  $server,
  $url     = $gocd::params::url,
  $version = $gocd::params::version,
  $build   = $gocd::params::build,
) inherits gocd::params {
  case $::osfamily {
    'Redhat': {
      $source = "${url}/gocd-rpm/go-agent-${version}-${build}.noarch.rpm"
      $ensure = 'present'
      $provider = 'rpm'
    }
    'Debian': {
      $remote_source = "${url}/gocd-deb/go-agent-${version}-${build}.deb"
      $source = "/opt/gocd/go-agent-${version}-${build}.deb"
      $ensure = 'present'
      $provider = 'dpkg'

      archive { $source:
        source => $remote_source,
        before => Package['go-agent'],
      }
    }
    'Windows': {
      $remote_source = "${url}/gocd/go-agent-${version}-${build}-setup.exe"
      $source = "C:/temp/go-agent-${version}-${build}-setup.exe"
      # A giant hack cause windows
      $ensure = undef
      $provider = undef

      archive { $source:
        source => $remote_source,
        before => Exec['install-agent'],
      }

      exec { 'install-agent':
        command     => "${source} /S /SERVERIP=${server}",
        subscribe   => Archive[$source],
        refreshonly => true,
      }
    }
    default: { fail("${::osfamily} not supported for go cd agent.") }
  }

  package { 'go-agent':
    ensure   => $ensure,
    provider => $provider,
    source   => $source,
  }

  file { '/etc/default/go-agent':
    ensure  => $ensure,
    owner   => go,
    group   => go,
    mode    => '0644',
    content => template('gocd/go-agent.erb'),
    require => Package['go-agent'],
  }

  service { 'go-agent':
    ensure    => $present,
    enable    => true,
    subscribe => File['/et/default/go-agent'],
  }
}
