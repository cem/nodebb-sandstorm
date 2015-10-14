#!/bin/bash
set -euo pipefail
# This script is run every time an instance of our app - aka grain - starts up.
# This is the entry point for your application both when a grain is first launched
# and when a grain resumes after being previously shut down.
#
# This script is responsible for launching everything your app needs to run.  The
# thing it should do *last* is:
#
#   * Start a process in the foreground listening on port 8000 for HTTP requests.
#
# This is how you indicate to the platform that your application is up and
# ready to receive requests.  Often, this will be something like nginx serving
# static files and reverse proxying for some other dynamic backend service.
#
# Other things you probably want to do in this script include:
#
#   * Building folder structures in /var.  /var is the only non-tmpfs folder
#     mounted read-write in the sandbox, and when a grain is first launched, it
#     will start out empty.  It will persist between runs of the same grain, but
#     be unique per app instance.  That is, two instances of the same app have
#     separate instances of /var.
#   * Preparing a database and running migrations.  As your package changes
#     over time and you release updates, you will need to deal with migrating
#     data from previous schema versions to new ones, since users should not have
#     to think about such things.
#   * Launching other daemons your app needs (e.g. mysqld, redis-server, etc.)

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
cd /opt/app

if [ ! -d "/var/nodebb" ]
then
	echo "First time running. Preparing the working directory."
	
	if [ ! -d "public_copyme" ]
	then
		echo "ERROR: public_copyme/ not found! Build the app using the Makefile before deploying."
		exit -1
	fi

	mkdir -p /var/nodebb
	find `pwd` -mindepth 1 -maxdepth 1 \
		! -name public \
		! -name public_copyme \
		! -name .git \
		! -name .sandstorm \
		-exec ln -s {} /var/nodebb/ \;
	cp -R public_copyme /var/nodebb/public
	touch /var/nodebb/output.log
else
	echo "Re-launching."
fi

cd /var/nodebb
redis-server &
nodejs app.js #./nodebb start
exit 0
