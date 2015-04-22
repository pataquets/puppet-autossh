# = Class: autossh::params
#
# This class detects operating system dependent variables for the autossh
# module.
#
class autossh::params {
  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {
      $configdir = '/etc/autossh'
      if $::operatingsystemmajrelease >= 7 {
        $service = 'systemd'
      } elsif $::operatingsystemmajrelease == 6 {
        $service = 'upstart-notnative'
      } else {
        fail('Unsupported RedHat/CentOS version')
      }
    }
    /^(Fedora)$/: {
      $configdir = '/etc/autossh'
      if $::operatingsystemmajrelease >= 15 {
        $service = 'systemd'
      } elsif $::operatingsystemmajrelease >= 9 {
        # http://fedoraproject.org/wiki/Upstart
        $service = 'upstart'
      } else {
        fail('Unsupported Fedora version')
      }
    }
    /^(Ubuntu)$/: {
      $service = 'upstart'
      # FIXME: for some reason this module created config in /opt/ssh
      $configdir = '/opt/autossh'
    }
    default: {
      # FIXME: can we detect systemd and use it?
      fail("Unsupported operating system ${::operatingsystem}")
    }
  }
}
