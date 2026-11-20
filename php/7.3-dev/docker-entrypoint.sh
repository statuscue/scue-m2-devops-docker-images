#!/usr/bin/env bash

set -ex

# Configure xdebug via environment variables
tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null <<XDEBUG
xdebug.idekey=${XDEBUG_IDEKEY:-PHPSTORM}
xdebug.remote_enable=${XDEBUG_REMOTE_ENABLE:-0}
xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK:-0}
xdebug.remote_host=${XDEBUG_REMOTE_HOST:-localhost}
xdebug.profiler_output_dir=/mnt/files/xdebug/profiler
xdebug.trace_output_dir=/mnt/files/xdebug/traces
XDEBUG

exec docker-php-entrypoint "${@}"
