#!/usr/bin/perl
# -----------------------------------------------------------------------------
# MANAGED BY PUPET (module: otrs)
# -----------------------------------------------------------------------------
#
# SetConfig Helper for OTRS 3.x

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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::SysConfig;
use Kernel::Language;

my $ConfigObject = Kernel::Config->new();
my $EncodeObject = Kernel::System::Encode->new(
    ConfigObject => $ConfigObject,
);
my $LogObject = Kernel::System::Log->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
);
my $MainObject = Kernel::System::Main->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
    LogObject    => $LogObject,
);
my $TimeObject = Kernel::System::Time->new(
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
);
my $DBObject = Kernel::System::DB->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
    LogObject    => $LogObject,
    MainObject   => $MainObject,
);

my $LanguageObject = Kernel::Language->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
    LogObject    => $LogObject,
    MainObject   => $MainObject,
);
my $SysConfigObject = Kernel::System::SysConfig->new(
    ConfigObject   => $ConfigObject,
    EncodeObject   => $EncodeObject,
    LogObject      => $LogObject,
    DBObject       => $DBObject,
    MainObject     => $MainObject,
    TimeObject     => $TimeObject,
    LanguageObject => $LanguageObject,
);



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

