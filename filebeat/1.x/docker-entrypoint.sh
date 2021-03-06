#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
# echo $@
if [ "${1#-}" != "$1" ]; then
	set -- filebeat "$@"
fi

# allow the container to be started with `--user`
# TODO
if [ "$1" = 'filebeat' -a "$(id -u)" = '0' ]; then
	chown -R filebeat:filebeat /opt/filebeat/logs
	chown -R filebeat:filebeat /opt/filebeat/data
	chown -R filebeat:filebeat /opt/filebeat/config
	chown -R filebeat:filebeat /opt/filebeat/logfile
	set -- gosu filebeat "$@"
fi

exec "$@"
