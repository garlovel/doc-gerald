#!/bin/bash
# program to deploy .rst text file to user directory: public_html (Linux Zentyal) Sites (Apple Server)

PUBLIC_DIR=/mnt/officeserver/glovel/Sites/
DEST_DIR=internal-personal

# change permissions on files to deploy so webserver can read them
chmod -R o+r ./_build/html/*

# copy local project built html to server deploy folder
# rm -rf "$PUBLIC_DIR""$DEST_DIR"
# cp -rf ./_build/html/* "$PUBLIC_DIR""$DEST_DIR"
rsync -aHAXE --delete ./_build/html/* "$PUBLIC_DIR""$DEST_DIR" 
