class autossh {
  include stdlib

  include autossh::params

  file { $autossh::params::configdir:
    ensure  => directory,
    recurse => true,
  } ->

  package { 'autossh':
    ensure => present,
  }
}
