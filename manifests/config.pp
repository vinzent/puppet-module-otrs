# == Class: otrs::config
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
class otrs::config(
  $database               = $::otrs::database,
  $database_host          = $::otrs::database_host,
  $database_user          = $::otrs::database_user,
  $database_pw            = $::otrs::database_pw,
  $sysconfig_http_running = $::otrs::sysconfig_http_running,
  $sysconfig_cron_running = $::otrs::sysconfig_cron_running,
  $config_pm_template     = $::otrs::config_pm_template,
  $sysconfig_template     = $::otrs::sysconfig_template,
) {

  file { "$::otrs::install_root/Kernel/Config.pm":
    content   => template($config_pm_template),
    owner     => 'otrs',
    group     => 'apache',
    mode      => '0640',
    show_diff => false, # contains passwords
  }

  file { '/etc/sysconfig/otrs':
    content   => template($sysconfig_template),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
  }
}
