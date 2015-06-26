# == Class: otrs
#
# Full description of class otrs here.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#
# === Authors
#
# Thomas Mueller <thomas@chaschperli.ch>
#
# === Copyright
#
# Copyright 2015 Thomas Mueller
#
class otrs(
  $install_root           = '/opt/otrs',
  $manage_upgrade         = false,
  $manage_package         = true,
  $manage_service         = true,
  $package_name           = 'otrs',
  $package_ensure         = 'installed',
  $database               = 'otrs',
  $database_host          = '127.0.0.1',
  $database_user          = 'otrs',
  $database_pw            = 'some-pass',
  $sysconfig_http_running = '1',
  $sysconfig_cron_running = '1',
  $config_pm_template     = "${module_name}/Config.pm.erb",
  $sysconfig_template     = "${module_name}/sysconfig.erb",
) {

  if $package_ensure =~ /^[0-9]+/ {
    $target_version = $package_ensure
  } elsif  $::otrs_rpm_version =~ /^[0-9]+/ {
    $target_version = $::otrs_rpm_version
  } else {
    $target_version = undef
  }

  class { '::otrs::install': } ->
  class { '::otrs::config': } ->
  class { '::otrs::service': }

  if ($manage_upgrade) {
    validate_re($package_ensure, '^[0-9\.]+-[0-9]+', '$manage_upgrade=true requires $package_ensure to be a version number') 

    Class['::otrs::config'] ->
    class { '::otrs::upgrade': } ->
    Class['::otrs::service']
  }

}
