#!/bin/bash
# File history 
#  - 0.1: update and help

OPERATION="build"

DEST_FOLDER=./cmake
TEMP_FOLDER=./hen-tmp
SOURCE_URL=https://github.com/I-hate-zoos/hen/raw/master/dist/
PACKAGE_NAME=hen-latest.zip
PACKAGE_URL=${SOURCE_URL}/${PACKAGE_NAME}
VERSION_URL=${SOURCE_URL}/Hen-VERSION.txt

PACKAGE_FILE=${TEMP_FOLDER}/${PACKAGE_NAME}
VERSION_FILE=${TEMP_FOLDER}/Hen-VERSION.txt


red='\033[0;31m'
white='\033[1;37m'
NC='\033[0m' # No Color

if [ -n "$1" ]; then
    OPERATION=$1
fi

do_update () {
    if [ -d ${TEMP_FOLDER} ] ; then
    	rm -rf ${TEMP_FOLDER}
    fi
    mkdir ${TEMP_FOLDER} 
    echo "Checking for newer version..."
    wget --quiet -P ${TEMP_FOLDER} ${VERSION_URL}
    SERVER_VERSION=`cat ${VERSION_FILE}`
    if [ -d ${DEST_FOLDER}/cmake ] ; then
    	LOCAL_VERSION=`cat ${DEST_FOLDER}/cmake/Hen-VERSION.txt`
    fi 
    echo " Local version : ${LOCAL_VERSION}"
    echo -e " Server version: ${white}${SERVER_VERSION}${NC}"

    # Is an update required?
	if [ "${SERVER_VERSION}" == "${LOCAL_VERSION}" ]; then
    	echo "Your version is up to date (${LOCAL_VERSION})"
	else
		echo "Newer version found!"
		echo "Getting the new files from server..."
	    wget --quiet -P ${TEMP_FOLDER} ${PACKAGE_URL}
	    if [ -d ${DEST_FOLDER} ] ; then
	    	rm -rf ${DEST_FOLDER}
	    fi 
	    unzip -q ${PACKAGE_FILE} -d ${DEST_FOLDER}

	    # Cleaning up
	    rm -rf ${TEMP_FOLDER}

	    echo -e "${white}Hen updated to ${SERVER_VERSION}${NC}"
    fi

}

do_prepare () {
	echo "This is prepare"
}

do_build () {
	echo "This is build"
}

do_help () {
	if [ -d ${DEST_FOLDER}/cmake ] ; then
    	LOCAL_VERSION=`cat ${DEST_FOLDER}/cmake/Hen-VERSION.txt`
    	echo -e "${white}Hen ${LOCAL_VERSION}${NC}"
    	echo ""
    fi 
	cat ./cmake/Hen-HELP.txt
}

case "$OPERATION" in
   "update") do_update  
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