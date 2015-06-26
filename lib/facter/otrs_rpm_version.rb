Facter.add('otrs_rpm_version') do
  setcode do
    Facter::Core::Execution.exec('rpm -q --queryformat "%{version}" otrs | grep -v "package otrs is not installed"')
  end
end
