# == Define: otrs::configitem
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
define otrs::configitem(
  $value,
  $key = $title,
) {


  if $::otrs::target_version == undef {
    debug('puppet.SetConfig.pl script only available with target_version - needs a second puppet run')
  } else {

    $get_config_script = $::otrs::target_version ? {
      /^3\./  => 'otrs.GetConfig.pl',
      default => 'puppet.GetConfigItem.pl',
    }

    exec { "configitem ${key}":
      command => "${::otrs::install_root}/bin/puppet.SetConfig.pl '${key}' '${value}'",
      unless  => "${::otrs::install_root}/bin/${get_config_script} '${key}' | grep -q '^${value}\$'"
    }
  }

}
