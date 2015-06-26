#!/usr/bin/perl
# -----------------------------------------------------------------------------
# MANAGED BY PUPPET
# class: otrs
# -----------------------------------------------------------------------------
# --
# bin/puppet.GetConfigItem.pl - get OTRS sysconfig vars
# Copyright (C) Thomas Mueller <thomas@chaschperli.ch>
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';
use Data::Dumper;

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-puppet.GetConfigItem',
    },
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# print wanted var
my $Key = shift;
chomp $Key;

my %Item = $SysConfigObject->ConfigItemGet(Name => $Key);

my $Value; 

if (defined $Item{Setting}->[1]->{Option}->[1]->{SelectedID}) {
  $Value = $Item{Setting}->[1]->{Option}->[1]->{SelectedID};
} elsif (defined $Item{Setting}->[1]->{String}->[1]->{Content}) {
  $Value = $Item{Setting}->[1]->{String}->[1]->{Content};
} else {
  $Value = undef;
}

if (defined $Value and length $Value) { 
  print $Value . "\n";
} else {
  print STDERR "undefined\n";
  exit 1
}


