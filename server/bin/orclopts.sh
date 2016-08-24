#! /bin/bash

OPTFILE=/opt/tools/etc/orclopts.json

# Options parsing
TEMP=$(getopt --longoptions='file:' 'f:'  "$@")
if [ $? != 0 ] ; then
    echo "error retrieving options"
    exit 1
fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        --file|-f) shift ; OPTFILE=$1 ; shift  ;;
        --) shift ; break ;;
        *) echo "Invalid ($1) option" >&2 ; exit 1;;
    esac
done

for opt in $(jq '.options' $OPTFILE | jq -r 'keys []')
do
  echo "Processing option $opt"
  st=$(jq -r ".options .$opt" $OPTFILE)
  $ORACLE_HOME/bin/chopt $st $opt
  if [ $? -ne 0 ]
  then
    echo "error setting option $opt to $st"
    exit 1
  fi
  echo "option $opt set to $st"
done
exit 0
