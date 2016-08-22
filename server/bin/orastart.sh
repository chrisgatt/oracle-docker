#!/bin/bash

. ~/.bashrc
MODE=NOARCHIVELOG
SID=$ORACLE_SID

# Options parsing
TEMP=$(getopt --longoptions='archivelog,noarchivelog,sid:' 'ans:'  "$@")
if [ $? != 0 ] ; then
    echo "error retrieving options"
    exit 1
fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        --archivelog|-a) shift ; MODE=ARCHIVELOG  ;;
        --noarchivelog|-n) shift ; MODE=NOARCHIVELOG  ;;
        --sid|-s) shift ; SID=$1 ; shift  ;;
        --) shift ; break ;;
        *) echo "Invalid ($1) option" >&2 ; exit 1;;
    esac
done

export ORACLE_SID=$SID

sqlplus / as sysdba <<EOF
startup mount
alter database $MODE;
alter database open;
EOF
