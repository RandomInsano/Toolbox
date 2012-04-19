#!/bin/bash

# Autostart applications on *nix hosts using the init daemon.
# This is as generic as possible. 

INSTALL_DIR="/usr/local/Thinkbox/Deadline/"
LOGFILE="/var/log/deadline-launcher.log"
PIDFILE="/var/run/deadline-launcher.pid"

APP_PATH=$INSTALL_DIR/bin/deadlinelauncher	# `deadlinelauncher` is a wrapper script for starting DeadlineLauncher.exe
APP_NAME="Deadline Launcher"

USER="nobody"

touch $PIDFILE

start(){
	pid=`cat $PIDFILE`
	
	if [ -n "$pid" ]; then
		echo "Launcher already running"
		echo
		exit 4
	else
		if [ -x $APP_PATH ]; then
			echo "Starting $APP_NAME on `date`" >> $LOGFILE
		
			# Run the app, logging all of its output to the specified file
			su -l $USER -s $APP_PATH -nogui >> $LOGFILE 2>&1 < /dev/null & 
			echo $! > $PIDFILE # Keep track of the PID we're using
			success "$APP_NAME Started"
		else
			echo "Could not find $APP_NAME"
			exit 2
		fi
	fi
}

stop(){
	pid=`cat $PIDFILE`
	
	if [ -n "$pid" ]; then
		kill -QUIT $pid
		rm $PIDFILE
		success "$APP_NAME Stopped. Note that the slave may still be running."
		echo "Stopped $APP_NAME on `date`" >> $LOGFILE
	else
		echo "$APP_NAME is not running"
		exit 3
	fi
}

# See how we were called.
case "$1" in 
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac