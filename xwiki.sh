#!/bin/bash
HOME_PATH="/home/sorinello/Desktop/XWiki"
APACHE_DIR_NAME="apache-tomcat-7.0.35"
while getopts "cs:gxh" OPT; do
case $OPT in
        c) # Clean
            echo "Prepare Postgres"
			psql -U postgres -c "DROP database xwiki;"
			psql -U postgres -c "create database xwiki owner xwiki;"
			echo "Clean Tomcat Work Dir"
			rm -rf $HOME_PATH/$APACHE_DIR_NAME/work/Catalina/localhost/xwiki
			echo "Remove Tomcat Logs"
			rm -rf $HOME_PATH/$APACHE_DIR_NAME/logs/catalina.out
            ;;
        s) # Switch
			rm $HOME_PATH/$APACHE_DIR_NAME/webapps/xwiki
    		ln -s $HOME_PATH/$OPTARG/xwiki $HOME_PATH/apache-tomcat-7.0.35/webapps/xwiki
    		ls -lah $HOME_PATH/apache-tomcat-7.0.35/webapps/ | grep xwiki
            ;;
        g) # Start Tomcat
            $HOME_PATH/$APACHE_DIR_NAME/bin/startup.sh
			tail -f /home/sorinello/Desktop/XWiki/$APACHE_DIR_NAME/logs/catalina.out
			;;
		x) # Stop Tomcat
            $HOME_PATH/$APACHE_DIR_NAME/bin/shutdown.sh
			sleep 5
			ps aux | grep java
			;;
        h) # Print Help
            echo "-c Clean Database, Tomcat Directory, Tomcat Logs"
            echo "-s Switch to give XWiki Instance (must be in the path)"
            echo "-g Start Tomcat"
            echo "-x Stop Tomcat"
            echo "-h Prints help commands"
            ;;
        \?)
      		echo "Invalid option: -$OPTARG" >&2
      		;;
    esac
done