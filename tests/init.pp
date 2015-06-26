# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#
#

Exec {
  path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
}

class { ::otrs:
  package_ensure => "3.3.14-01",
  manage_upgrade => true,
}

::otrs::configitem { 'TimeZone::Calendar8Name':
  value => "Name of calendar 8",
}

