#!/bin/sh
# 
OPERATION="build"

DEST_FOLDER=cmake-test
TEMP_FOLDER=./hen-tmp
SOURCE_URL=https://github.com/I-hate-zoos/hen/raw/master/dist/
PACKAGE_NAME=hen-latest.zip
PACKAGE_URL=${SOURCE_URL}/${PACKAGE_NAME}
VERSION_URL=${SOURCE_URL}/Hen-VERSION

PACKAGE_FILE=${TEMP_FOLDER}/${PACKAGE_NAME}

if [ -n "$1" ]; then
    OPERATION=$1
fi

do_update () {
	echo "This is udpdate"
    if [ -d ${TEMP_FOLDER} ] ; then
    	rm -rf ${TEMP_FOLDER}
    fi
    mkdir ${TEMP_FOLDER} 
    wget -P ${TEMP_FOLDER} ${PACKAGE_URL}
    if [ -d ${DEST_FOLDER} ] ; then
    	rm -rf ${DEST_FOLDER}
    fi 
    unzip ${PACKAGE_FILE} -d ${DEST_FOLDER}
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