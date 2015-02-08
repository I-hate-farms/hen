#!/bin/sh
# 
OPERATION="build"

if [ -n "$1" ]; then
    OPERATION=$1
fi

do_update () {
	echo "This is udpdate"
}

do_prepare () {
	echo "This is prepare"
}

do_build () {
	echo "This is build"
}

do_help () {
	cat ./cmake/Hen-HELP.txt
}

case "$OPERATION" in
   "update") do_udpdate  
   ;;
   "prepare") do_prepare
   ;;
   "build")do_build
   ;;
   "help")do_help
   ;;
   "--help")do_help
   ;;     
   "--?")do_help
   ;;   
   "/?")do_help
   ;;  
   "-h")do_help
   ;;     
esac