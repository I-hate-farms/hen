#!/bin/bash
# File history 
#  - 0.1: update and help
#  - 0.2: build and prepare
#  - 0.3: list

OPERATION="build"

DEST_FOLDER=./cmake
TEMP_FOLDER=./hen-tmp
SOURCE_URL=https://github.com/I-hate-zoos/hen/raw/master/dist/
PACKAGE_NAME=hen-latest.zip
PACKAGE_URL=${SOURCE_URL}/${PACKAGE_NAME}
VERSION_URL=${SOURCE_URL}/Hen-VERSION.txt

PACKAGE_FILE=${TEMP_FOLDER}/${PACKAGE_NAME}
VERSION_FILE=${TEMP_FOLDER}/Hen-VERSION.txt

BUILD_FOLDER=./build

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
    if [ -d ${DEST_FOLDER} ] ; then
    	LOCAL_VERSION=`cat ${DEST_FOLDER}/Hen-VERSION.txt`
    	echo " Local version : ${LOCAL_VERSION}"
    fi 

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
      echo -e "${white}Preparing your build ...${NC}"
      if [ -d ${BUILD_FOLDER} ] ; then
        rm -rf ${BUILD_FOLDER}
      fi 
      mkdir ${BUILD_FOLDER}
      cd ${BUILD_FOLDER}
      cmake .. 
}

do_build () {
      if [ ! -d ${BUILD_FOLDER} ] ; then
        do_prepare 
      fi 
      echo -e "${white}Building your application ...${NC}"
      cd ${BUILD_FOLDER}
      make 
      cd ..        
}

do_help () {
	if [ -d ${DEST_FOLDER} ] ; then
    	LOCAL_VERSION=`cat ${DEST_FOLDER}/Hen-VERSION.txt`
    	echo -e "${white}Hen ${LOCAL_VERSION}${NC}"
    	echo ""
      cat ./cmake/Hen-HELP.txt
  else
    echo -e "${white}No help is available${NC}. Please update hen with: $0 update"
  fi 
}

do_list () {
  echo -e "${white}Hen${NC} defines the following make tasks"
  echo -e "  - ${white}[default]${NC} : build your application along with extra files if applicable (desktop, vapi, pc, deps...)"
  echo -e "  - ${white}install${NC} : install your application to the previously defined PREFIX (./usr by default)"
  echo -e "  - ${white}pot${NC} : generates the translation files in the po folder"
  echo "" 
  echo "You can invoke those tasks in the ./build folder: "
  echo "  cd build"
  echo "  make pot"
}


case "$OPERATION" in
   "update") do_update  
   ;;
   "prepare") do_prepare
   ;;
   "build")do_build
   ;;   
   "list")do_list
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