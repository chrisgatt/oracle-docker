# Oracle 12 c server

This container is designed to run oracle 12c enterprise edition.
The processes management is achieved by using "chaperone" (http://garywiz.github.io/chaperone/ref/index.html).

## Processes management:

Oracle start a lot of processes:
 - the listener
 - oracle's background processes
 - oracle's user processes

To properly manage this processes, the image use chaperone as PID 1, providing a good management of signal and zombies. The managed services are:
 - initcontext:
    - type: oneshot
    - currently used to create the spfile from the pfile if specified via an environment variable in the docker run command line.
    - plan to add other functionalities
 - listener:
    - type: forking
    - start oracle's listener and monitor it by using a PID file
 - oracle:
    - type: forking
    - start oracle via sqlplus

### Remarks:
  - the use of a oneshot chaperone service to create the spfile from pfile wehn needed is not a so good idea. I plan to use these service for real context initialization in the fututre.
  - to make initcontext service you need to set a PFILE environment variable on the docker run command with the path to the PFILE.

## Oracle installation:

This image contain an oracle 12c enterprise edition (EE).
The environment variables are set as follow:

- ORACLE_BASE=/opt/oracle \
- ORACLE_HOME=/opt/oracle/product/12.1.0/dbhome_1

## Container execution:

### Volumes:

To make the configuration persistent across container restart you need to map a volume on "/opt/oracle/product/12.1.0/dbhome_1/dbs"
Depending on your database configuration, you also need to map one (or more) directories containing the database, diagnostic destination directory, etc...

### Exposed ports:

- 1521 oracle's listener
- 5500 em express

### Oracle SID:

You need to specify the Oracle SID at runtime via setting the ORACLE_SID environment variable in the docker run command with -e option.

### pfile/spfile

By default oracle search a spfile, then a pfile in the $ORACLE_HOME/dbs directory, based on $ORACLE_SID.
It is also possible to specify the location of the pfile at oracle's startup. This image has the following particularity: if you specify a pfile in the docker run command via the PFILE environment variable, the initcontext service generate a spfile for the corresponding SID in the dbs directory, and then start oracle.

### Example launch command:

The container_tools directory contain the docker run command I use. It should be adapted to your requirements.
The role of each parameters are as follow:

```
docker run -d --name orasrv \
          --shm-size=2G \                                        <--- to be able to use MEMORY_TARGET
          -p 1521:1521 -p 5500:5500 \
          -v /oracle/data:/oradata \                             <--- database files
          -v /oracle/conf:/oraconf \                             <--- pfile
          -v ora_dbs:/opt/oracle/product/12.1.0/dbhome_1/dbs \   <--- to make the dbs persistent
          -e ORACLE_SID=ORCL \
          -e PFILE=/oraconf/initORCL.ora \                       <--- path to pfile to let initcontext generate spfile
          oracle
```

### Warnings:

- Some oracle's directory are quite sensitive for example, the diagnostic destination directory cannot be place anywhere there can be issue with directory perms and selinux context. Check carefully the directories and volumes mapping.
