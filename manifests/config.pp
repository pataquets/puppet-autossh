define autossh::config (
  $user         = 'root',
  $monitor_port = 0,
  $remote_user  = undef,
  $remote_host,
  $remote_port,
  $ssh_config,
  $ssh_id_file,
  $remote_user,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
) {
  $service = $title

  include autossh::params

  if (!$remote_user) {
    $real_remote_user = $user
  } else {
    $real_remote_user = $remote_user
  }

  if $autossh::params::service =~ /^upstart/ {
    autossh::tunnel::config::upstart { $service:
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
  }

  if $autossh::params::service == 'systemd' {
      autossh::tunnel::config::systemd { $service:
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
  }
}
