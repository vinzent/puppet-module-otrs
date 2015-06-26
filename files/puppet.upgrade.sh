#!/bin/bash
# -----------------------------------------------------------------------------
# MANAGED BY PUPPET (module: otrs)
# -----------------------------------------------------------------------------
# Author: Thomas Mueller <thomas@chaschperli.ch>
# License: Apache 2.0
# 
# USE AT YOUR VERY OWN RISK !
#
# Script needs to reside in the otrs/bin folder

set -e

otrs_rootdir=$( cd $(dirname $0)/..; pwd )
script_name=$(basename $0)

export PATH="${otrs_rootdir}/bin:$PATH"

database_dsn=$(otrs.GetConfig.pl DatabaseDSN)
database_user=$(otrs.GetConfig.pl DatabaseUser)
database_pw=$(otrs.GetConfig.pl DatabasePw)
database_host=$(otrs.GetConfig.pl DatabaseHost)
database=$(otrs.GetConfig.pl Database)

temp_mycnf=$(mktemp /tmp/${script_name}.XXXXXX)
logfile="/var/log/${script_name}.$(date +%Y%m%d%H%M%S).log"

cleanup() {
  RC=$?
  if [ "$RC" != "0" ]; then
    cat $logfile
  fi
  rm -f "$temp_mycnf" 
}

trap cleanup EXIT

if ! echo "$database_dsn" | grep -q '^DBI:mysql'; then
  echo "ERROR: Only DBI:mysql is supported. DatabaseDSN does not start with DBI:mysql"
  exit 1
fi


sql_upgrade_script=$(find "${otrs_rootdir}/scripts" -name "DBUpdate-to-*.mysql.sql")
upgrade_script=$(find "${otrs_rootdir}/scripts" -name "DBUpdate-to-*.pl")

for i in database_dsn database_user database_pw database_host database sql_upgrade_script upgrade_script; do
  if [ -z $(eval echo \$$i) ]; then
    echo "ERROR: Parameter $i not found with otrs.GetConfig.pl"
    exit 1
  fi
done

for i in  "$upgrade_script" otrs.CheckDB.pl otrs.RebuildConfig.pl otrs.RebuildTicketIndex.pl sudo mysql otrs.DeleteCache.pl; do
  if ! which $i >/dev/null 2>&1; then
    echo "ERROR: executable $i not found"
    exit 1
  fi
done

for i in "$sql_upgrade_script"; do
  if ! test -f "$i"; then
    echo "ERROR: required file '$i' not found"
    exit 1
  fi
done

if otrs.CheckDB.pl 2>&1 | grep -q 'These tables use a different storage engine'; then
  otrs.MySQLInnoDBSwitch.pl -f >>$logfile 2>&1
fi


otrs.CheckDB.pl >>$logfile 2>&1

cat >$temp_mycnf <<EOS

[client]
user=$database_user
password="$database_pw"
host=$database_host
database=$database

EOS

cat "$sql_upgrade_script" | mysql --defaults-extra-file="$temp_mycnf" -f >>$logfile 2>&1

su -s /bin/bash -c "$upgrade_script" - otrs >>$logfile 2>&1
su -s /bin/bash -c "${otrs_rootdir}/bin/otrs.RebuildConfig.pl" - otrs >>$logfile 2>&1
su -s /bin/bash -c "${otrs_rootdir}/bin/otrs.DeleteCache.pl" - otrs  >>$logfile 2>&1
su -s /bin/bash -c "${otrs_rootdir}/bin/otrs.RebuildTicketIndex.pl" - otrs >>$logfile 2>&1

if service httpd status >/dev/null 2>&1; then
  service httpd restart
fi
