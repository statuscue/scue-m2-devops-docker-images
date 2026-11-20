#!/usr/bin/env bash

set -eox pipefail

# Configure xdebug via environment variables
# https://xdebug.org/docs/upgrade_guide
# https://xdebug.org/docs/all_settings
# https://regex101.com/r/e98qsU/1
# https://youtrack.jetbrains.com/issue/IDEA-65879
tee /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini > /dev/null <<XDEBUG
zend_extension = xdebug.so
xdebug.mode = ${XDEBUG_MODE:-debug}
xdebug.idekey = ${XDEBUG_IDEKEY:-PHPSTORM}
xdebug.cli_color = ${XDEBUG_CLI_COLOR:-0}
xdebug.client_discovery_header = "${XDEBUG_CLIENT_DISCOVERY_HEADER:-}"
xdebug.client_host = ${XDEBUG_CLIENT_HOST:-localhost}
xdebug.client_port = ${XDEBUG_CLIENT_PORT:-9003}
xdebug.collect_assignments = ${XDEBUG_COLLECT_ASSIGNMENTS:-0}
xdebug.collect_return = ${XDEBUG_COLLECT_RETURN:-0}
xdebug.discover_client_host = ${XDEBUG_DISCOVER_CLIENT_HOST:-0}
xdebug.dump_globals = ${XDEBUG_DUMP_GLOBALS:-1}
xdebug.dump_once = ${XDEBUG_DUMP_ONCE:-1}
xdebug.dump_undefined = ${XDEBUG_DUMP_UNDEFINED:-0}
xdebug.file_link_format = "${XDEBUG_FILE_LINK_FORMAT:-}"
xdebug.force_display_errors = ${XDEBUG_FORCE_DISPLAY_ERRORS:-0}
xdebug.force_error_reporting = ${XDEBUG_FORCE_ERROR_REPORTING:-0}
xdebug.halt_level = ${XDEBUG_HALT_LEVEL:-0}
xdebug.log = ${XDEBUG_LOG:-/proc/self/fd/2}
xdebug.log_level = ${XDEBUG_LOG_LEVEL:-7}
xdebug.manual_url = ${XDEBUG_MANUAL_URL:-http://www.php.net}
xdebug.max_nesting_level = ${XDEBUG_MAX_NESTING_LEVEL:-512}
xdebug.max_stack_frames = ${XDEBUG_MAX_STACK_FRAMES:--1}
xdebug.output_dir = /mnt/files/xdebug
xdebug.profiler_aggregate = ${XDEBUG_PROFILER_AGGREGATE:-0}
xdebug.profiler_append = ${XDEBUG_PROFILER_APPEND:-0}
xdebug.profiler_output_name = ${XDEBUG_PROFILER_OUTPUT_NAME:-cachegrind.out.%p}
xdebug.scream = ${XDEBUG_SCREAM:-0}
xdebug.show_error_trace = ${XDEBUG_SHOW_ERROR_TRACE:-0}
xdebug.show_exception_trace = ${XDEBUG_SHOW_EXCEPTION_TRACE:-0}
xdebug.show_local_vars = ${XDEBUG_SHOW_LOCAL_VARS:-0}
xdebug.start_with_request = ${XDEBUG_START_WITH_REQUEST:-default}
xdebug.trace_format = ${XDEBUG_TRACE_FORMAT:-0}
xdebug.trace_options = ${XDEBUG_TRACE_OPTIONS:-0}
xdebug.trace_output_name = ${XDEBUG_TRACE_OUTPUT_NAME:-trace.%c}
xdebug.trigger_value = "${XDEBUG_TRIGGER_VALUE:-}"
xdebug.var_display_max_children = ${XDEBUG_VAR_DISPLAY_MAX_CHILDREN:-128}
xdebug.var_display_max_data = ${XDEBUG_VAR_DISPLAY_MAX_DATA:-512}
xdebug.var_display_max_depth = ${XDEBUG_VAR_DISPLAY_MAX_DEPTH:-3}
XDEBUG

exec docker-php-entrypoint "${@}"
