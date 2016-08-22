# Oracle 12 c client

This container is designed to run oracle 12c sqlplus client.


## Oracle installation:

This image contain an oracle 12c instantclient the following rpm are installed:
  - basic
  - sqlplus
  - devel
  - precomp

## Image usage:

This image can be used as the base for custom container requiring an oracle database client or as a standalone sqlplus client.

## Container execution:

Example command to launch an oracle sqlplus client:

```
docker run -it --rm --link orasrv \
-e CONNECT_STR="scott/tiger2@oracle:1521/DEMO" oracli
```
