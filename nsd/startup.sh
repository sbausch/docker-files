!#/bin/bash

## Check if config file is present
## copy sample files if not in /etc/nsd
if [ ! -f /etc/nsd/nsd.conf]; then
	cp /home/nsd/*.* /etc/nsd/
fi
## Check if config file is valid

nsd-checkconf /etc/nsd/nsd.conf

## Start nsd
nsd
