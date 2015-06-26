# == Class: otrs::install
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
class otrs::install {

  if str2bool($::otrs::manage_package) {
    package { $::otrs::package_name:
      ensure => $::otrs::package_ensure,
    }
  } else {
    debug("otrs::manage_package is false. Package not managed by otrs::install")
  }
 
  if $::otrs::target_version == undef {
    debug('otrs version unknown so far - needs a second puppet run')
  } elsif versioncmp($::otrs::target_version, '3.99.9') > 0 {
    file { "${::otrs::install_root}/bin/puppet.SetConfig.pl":
      source => "puppet:///modules/${module_name}/puppet.SetConfig.pl",
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { "${::otrs::install_root}/bin/puppet.GetConfigItem.pl":
      source => "puppet:///modules/${module_name}/puppet.GetConfigItem.pl",
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  } else {
    file { "${::otrs::install_root}/bin/puppet.SetConfig.pl":
      source => "puppet:///modules/${module_name}/puppet.SetConfig.3.pl",
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

  }

  file { "${::otrs::install_root}/bin/puppet.upgrade.sh":
    source => "puppet:///modules/${module_name}/puppet.upgrade.sh",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
