# = Define autossh::tunnel::service::systemd
#
# This define manages the service for this tunnel through systemd
#
define autossh::tunnel::service::systemd (
  $ensure     = running,
  $enable     = true,
  $service    = $title,
  $ssh_config,
) {

  include autossh::params

  service { $service:
    ensure  => $ensure,
    enable  => $enable,
    require => File[
      $ssh_config,
      "/lib/systemd/system/${service}.service"
    ],
  }

}
