# == Class: otrs::upgrade
#
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
class otrs::upgrade(
) {

  # 
  if ! empty($::otrs_rpm_version) {
    
    # we care about first 2 numbers
    # the ::otrs_rpm_version still contains the old rpm version
    $old_array = split($::otrs_rpm_version, '[.]')
    $target_array = split($::otrs::package_ensure, '[.]')
   
    $old_version="${old_array[0]}.${old_array[1]}"
    $target_version="${target_array[0]}.${target_array[1]}"

    if versioncmp($target_version, $old_version) > 0 {
      exec { 'otrs-upgrade-script':
	command => "${::otrs::install_root}/bin/puppet.upgrade.sh",
      }
    } else {
      debug("${old_version} is not smaller than ${target_version}")
    }
  } else {
    debug("::otrs_rpm_version is empty. Seems to be a new install.")
  } 
}
