#!/bin/bash

su - oracle -c "lsnrctl start" && \
pgrep tnslsnr > /var/run/listener.pid
