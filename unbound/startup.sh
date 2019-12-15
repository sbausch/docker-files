#!/bin/bash
set -e

## Check if config file is present
## copy sample files if not in /etc/unbound
if [ ! -f /etc/unbound/unbound.conf ]; then
	cp -R /home/unbound/* /etc/unbound/
	chmod -R a+r /etc/unbound
fi
## Check if config file is valid

unbound-checkconf

## Start nsd
exec "$@"