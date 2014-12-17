define autossh::tunnel (
  $service     = "autossh-${title}",
  $ensure      = 'running',
  $user        = "root",
  $group       = "root",
  $ssh_id_file = "~/.ssh/id_rsa",
  $bind_addr   = undef,
  $host        = "localhost",
  $host_port   = 22,
  $remote_user = undef,
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

  if (!$remote_user) {
    $real_remote_user = $user
  } else {
    $real_remote_user = $remote_user
  }

  $ssh_config = "/opt/autossh/${service}"

  if $remote_forwarding == true {
    file { $ssh_config:
      ensure  => file,
      path    => $ssh_config,
      owner   => $user,
      group   => $group,
      content => template('autossh/remoteforward.config.erb'),
      require => File["/opt/autossh/"],
    }
  } else {
    file { $ssh_config:
      ensure  => file,
      path    => $ssh_config,
      owner   => $user,
      group   => $group,
      content => template('autossh/localforward.config.erb'),
      require => File["/opt/autossh/"],
    }
  }

  autossh::service { $service:
    user             => $user,
    monitor_port     => $monitor_port,
    remote_user      => $remote_user,
    remote_host      => $remote_host,
    remote_port      => $remote_port,
    ssh_config       => $ssh_config,
    ssh_id_file      => $ssh_id_file,
    real_remote_user => $real_remote_user
  }

}
