#!/bin/bash

su - oracle -c "lsnrctl stop" && \
rm -f /var/run/listener.pid
