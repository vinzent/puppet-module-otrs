#!/usr/bin/perl
# -----------------------------------------------------------------------------
# MANAGED BY PUPET (module: otrs)
# -----------------------------------------------------------------------------
#
# SetConfig Helper for OTRS 4

if (($#ARGV + 1) != 2) {
  print "Usage $0 <key> <value>\n";
  exit 1;
}

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;


# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-puppet.SetConfig',
    },
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

my $Key = $ARGV[0];
my $Value = $ARGV[1];


# write ConfigItem
my $Update = $SysConfigObject->ConfigItemUpdate(
    Key   => $Key,
    Value => $Value,
    Valid => 1,
);
if ( !$Update ) {
    $LogObject->Log( Message => "Can't write ConfigItem '$Key'" );
    exit 1;
}

