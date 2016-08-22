#!/bin/bash

. ~/.bashrc
MODE=immediate
SID=$ORACLE_SID

# Options parsing
TEMP=$(getopt --longoptions='mode:,force,sid:' 'm:fs:'  "$@")
if [ $? != 0 ] ; then
    echo "error retrieving options"
    exit 1
fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        --force|-f) shift ; MODE=abort  ;;
        --mode|-m) shift ; MODE=$1 ; shift  ;;
        --sid|-s) shift ; SID=$1 ; shift  ;;
        --) shift ; break ;;
        *) echo "Invalid ($1) option" >&2 ; exit 1;;
    esac
done

export ORACLE_SID=$SID

sqlplus / as sysdba <<EOF
shutdown $MODE
EOF
