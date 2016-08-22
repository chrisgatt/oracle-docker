#!/bin/bash

SID="SAMPLE"
PDB="MYPDB"
PWD="manager"

if [ -n "$ORACLE_SID" ]
then
  SID=$ORACLE_SID
fi

# Options parsing
TEMP=$(getopt --longoptions='passwd:,pdb:,sid:' 'p:P:s'  "$@")
if [ $? != 0 ] ; then
    echo "error retrieving options"
    exit 1
fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        --passwd|-p) shift ; PWD=$1 ; shift  ;;
        --pdb|-P) shift ; PDB=$1 ; shift  ;;
        --sid|-s) shift ; SID=$1 ; shift  ;;
        --) shift ; break ;;
        *) echo "Invalid ($1) option" >&2 ; exit 1;;
    esac
done

cp /opt/tools/sample/dbca.rsp /tmp && \
sed -i -e "s|###ORACLE_SID###|$SID|g" /tmp/dbca.rsp && \
sed -i -e "s|###ORACLE_PDB###|$PDB|g" /tmp/dbca.rsp && \
sed -i -e "s|###ORACLE_PWD###|$PWD|g" /tmp/dbca.rsp && \
dbca -silent -responseFile /tmp/dbca.rsp && \
rm -f /tmp/dbca.rsp
