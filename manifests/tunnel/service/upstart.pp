# = Define autossh::tunnel::service::upstart
#
# This define manages the service for this tunnel through upstart
#
define autossh::tunnel::service::upstart (
  $ensure     = running,
  $enable     = true,
  $service    = $title,
  $ssh_config,
) {

  include autossh::params

  if ($autossh::params::init == 'upstart') {
    $native = true
  } else {
    $native = false
  }

  if ($native == true) {
    service { $service:
      ensure  => $ensure,
      enable  => true,
      require => File[$ssh_config, "/etc/init/${service}.conf"],
    }
  } else {
    service { $service:
      ensure     => $ensure,
      require    => File[$ssh_config, "/etc/init/${service}.conf"],
      hasrestart => false,
      hasstatus  => false,
      start      => "/sbin/initctl start ${service}",
      stop       => "/sbin/initctl stop ${service}",
      status     => "/sbin/initctl status ${service} | grep ^'${service} start/running' 1>/dev/null 2>&1",

    }
  }

}
