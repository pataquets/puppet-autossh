# = Define: autossh::tunnel::config::upstart
#
# This define deploys the config for managing this tunnel service through
# upstart
#
define autossh::tunnel::config::upstart (
  $service             = $title,
  $user                = 'root',
  $group               = 'root',
  $ssh_id_file         = '~/.ssh/id_rsa',
  $remote_user         = undef,
  $remote_host,
  $remote_port         = 0,        # FIXME: not used?
  $monitor_port        = 0,
  $autossh_background  = false,
  $autossh_gatetime    = undef,
  $autossh_logfile     = undef,
  $autossh_first_poll  = undef,
  $autossh_poll        = undef,
  $autossh_maxlifetime = undef,
  $autossh_maxstart    = undef,
  $ssh_config,
) {

  file { "/etc/init/${service}.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
    content => template('autossh/service/upstart'),
  }

}
