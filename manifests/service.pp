define autossh::service (
  $ensure       = running,
  $enable       = true,
  $ssh_config,
) {
  $service = $title

  include autossh::params

  if $autossh::params::service =~ /^upstart/ {
    autossh::tunnel::service::upstart { $service:
      ensure     => $ensure,
      enable     => $enable,
      ssh_config => $ssh_config,
    }
  }
 
  if $autossh::params::service == 'systemd' {
    autossh::tunnel::service::systemd { $service:
      ensure     => $ensure,
      enable     => $enable,
      ssh_config => $ssh_config,
    }
  }
}
