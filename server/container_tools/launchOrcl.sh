#!/bin/bash

docker run -d --name oracle \
          --shm-size=2G \
          -p 1521:1521 -p 5500:5500 \
          -v /oracle/data:/oradata \
          -v /oracle/conf:/oraconf \
          -v ora_dbs:/opt/oracle/product/12.1.0/dbhome_1/dbs \
          -e ORACLE_SID=ORCL \
          -e PFILE=/oraconf/initORCL.ora \
          oracle
