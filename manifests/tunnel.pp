# FIXME: $remote_port doesn't seem to be used
#
# Define an autossh tunnel.
#
# This is the main entry point for this module.
#
define autossh::tunnel (
  $ensure              = running,
  $enable              = true,
  $service             = "autossh-${title}",
  $user                = 'root',
  $group               = 'root',
  $ssh_id_file         = '~/.ssh/id_rsa',
  $bind_addr           = undef,
  $host                = 'localhost',
  $host_port           = 22,
  $remote_user         = undef,
  $remote_host,
  $remote_port,
  $monitor_port        = 0,
  $remote_forwarding   = true,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
) {

  include autossh::params

  $ssh_config = "${autossh::params::configdir}/${title}.conf"

  if $remote_forwarding == true {
    $template_path = 'autossh/remoteforward.config.erb'
  } else {
    $template_path = 'autossh/localforward.config.erb'
  }

  if (!$remote_user) {
    $real_remote_user = $user
  } else {
    $real_remote_user = $remote_user
  }


  # a generic config file used by all service systems
  file { $ssh_config:
    ensure  => file,
    path    => $ssh_config,
    owner   => $user,
    group   => $group,
    content => template($template_path),
    require => File[$autossh::params::configdir],
  }

  # service-specific config
  autossh::config { $service:
    user                => $user,
    ssh_config          => $ssh_config,
    remote_user         => $real_remote_user,
    remote_host         => $remote_host,
    remote_port         => $remote_port,        # FIXME: not used?
    ssh_id_file         => $ssh_id_file,
    monitor_port        => $monitor_port,
    autossh_background  => $autossh_background, # FIXME: not used?
    autossh_gatetime    => $autossh_gatetime,
    autossh_logfile     => $autossh_logfile,
    autossh_first_poll  => $autossh_first_poll,
    autossh_poll        => $autossh_poll,
    autossh_maxlifetime => $autossh_maxlifetime,
    autossh_maxstart    => $autossh_maxstart,
  }

  autossh::service { $service:
    ensure     => $ensure,
    enable     => $enable,
    ssh_config => $ssh_config,
  }
}
