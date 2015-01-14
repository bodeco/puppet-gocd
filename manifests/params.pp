# gocd parameters
class gocd::params {
  $url     = 'http://download.go.cd'
  $version = '14.2.0'
  $build   = '377'
  $server  = '127.0.0.1'
  $port    = 8153

  case $::osfamily {
    'Redhat': {
      $agent_work_dir   = '/var/lib/go-agent'
      $java_home        = '/usr/java/latest'
      $source           = '%s/gocd-rpm/go-agent-%s-%s.noarch.rpm'
      $package_ensure   = 'present'
      $package_provider = 'rpm'
      $service_ensure   = 'running'
    }

    'Windows': {
      $agent_work_dir   = 'C:/Program Files (x86)/Go Agent'
      # please be sure and quote any spaces if required
      $java_home        = undef
      $source           = '%s/gocd/go-agent-%s-%s-setup.exe'
      $package_ensure   = undef
      $package_provider = undef
      $service_ensure   = 'running'
    }
    default: { fail("${::osfamily} not supported for gocd module.") }
  }
}
