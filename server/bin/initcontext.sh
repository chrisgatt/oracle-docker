#!/bin/bash

. ~/.bashrc

echo "Starting context initialisation..."

if [ -n "$PFILE" ]
then
  echo "creating spfile from pfile ($PFILE)"
  sqlplus / as sysdba <<EOF
  create spfile from pfile='$PFILE';
EOF
fi

echo "finished context initialisation."
