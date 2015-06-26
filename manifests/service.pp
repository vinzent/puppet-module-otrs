# == Class: otrs::service
#
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Thomas Mueller <thomas@chaschperli.ch>
#
# === Copyright
#
# Copyright 2015 Thomas Mueller
#
class otrs::service {

  if str2bool($::otrs::manage_service) {
    service { 'otrs':
      ensure => 'running',
    }
  } else {
    debug('otrs::service disabled by param ::otrs::manage_service')
  }

}
