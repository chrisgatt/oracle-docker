# Oracle 12 c in docker container

This 2 containers are designed to run oracle 12c:
 - client: Instant client with basic, sqlplus, devel and precomp packages installed.
 - server: Oracle 12c enterprise edition.

Both containers are based on centos 7.

## Image construction

 - You need to download the installers from Oracle technical network.
 - You need to adapt the docker files to reflect the way you want to pass the installers to docker build context.

The solution I like to use is to put the installers in a directory served by an http server and to get them with wget or by passing the URL to "yum" in case of RPM.
This method avoid the copy of big files and the creation of unnecessary big layers. The URL is stored in the "ORCL_URL" environment variable.
Please refer to README in the corresponding subdirectory to get details on the build and use of each images.
