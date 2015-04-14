# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
include (${VARIABLES_FILE})

if(NOT WIN32)
  string(ASCII 27 Esc)
  set(NC           "${Esc}[m")
  set(ColourBold   "${Esc}[1m")
  set(Red          "${Esc}[31m")
  set(Green        "${Esc}[32m")
  set(Yellow       "${Esc}[33m")
  set(Blue         "${Esc}[34m")
  set(Magenta      "${Esc}[35m")
  set(Cyan         "${Esc}[36m")
  set(White        "${Esc}[37m")
  set(BoldRed      "${Esc}[1;31m")
  set(BoldGreen    "${Esc}[1;32m")
  set(BoldYellow   "${Esc}[1;33m")
  set(BoldBlue     "${Esc}[1;34m")
  set(BoldMagenta  "${Esc}[1;35m")
  set(BoldCyan     "${Esc}[1;36m")
  set(BoldWhite    "${Esc}[1;37m")
  set(FatalColor   "${BoldRed}")
  set(MessageColor "${BoldWhite}")
  set(WarningColor "${BoldYellow}")  
endif()

	message ("${MessageColor}Building debian files...${NC}")
  
  # set up folder
  SET (DEBIAN_PATH "${CURRENT_BINARY_DIR}/debian")
  file(MAKE_DIRECTORY "${DEBIAN_PATH}")
  file(MAKE_DIRECTORY "${DEBIAN_PATH}/source")  
  
  # TODO Read license file
  file(STRINGS "${CURRENT_SOURCE_DIR}/LICENSE" LICENSE_TEXT)
  set (PACKAGING_DATE "Wed, 20 Aug 2014 11:00:00 -0500")
  set (PACKAGING_YEAR "2005")
  set (ARGS_COPYRIGHT "${ARGS_AUTHOR}")
  set (ARGS_PACKAGE_NAME "${ARGS_BINARY_NAME}")
  set (DOLLAR "$")
  
  # create control file 
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/control.cmake ${DEBIAN_PATH}/control)

  # create rule file
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/rules.cmake ${DEBIAN_PATH}/rules)

  # TODO create the changelog file
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/changelog.cmake ${DEBIAN_PATH}/changelog)

  #create a bunch of static files: compat, source/format
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/compat.cmake ${DEBIAN_PATH}/compat)
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/format.cmake ${DEBIAN_PATH}/source/compat)
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/copyright.cmake ${DEBIAN_PATH}/copyright)

  # TODO override files with debian folder
  # TODO copy README.md into README
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/README.cmake ${DEBIAN_PATH}/README)
  # TODO : library name 

  message ("  . Debian control files generated in ${DEBIAN_PATH}")
	# Running debuild
	message ("  . Running debuild. This may take a while...")
  EXEC_PROGRAM( debuild  
      ARGS
          -i -us -uc -b
      OUTPUT_VARIABLE 
          output
      RETURN_VALUE  
          result_code)
  
  if( NOT "${result_code}" STREQUAL "0")
  	message ("${FatalColor}debuild failed${NC}, returning ${result_code}")
  	message ("Debuild ouput: ${output}")
  endif()
	
	SET (DIST_PATH "${CURRENT_SOURCE_DIR}/dist/${ARGS_BINARY_NAME}")
	file (MAKE_DIRECTORY "${DIST_PATH}")

	SET (DEB_FILE "${ARGS_BINARY_NAME}_${ARGS_VERSION}_amd64")
	SET (DEB_DBG_FILE "${ARGS_BINARY_NAME}-dbg_${ARGS_VERSION}_amd64")

  # Move the created file to dist/
  file (RENAME "${CURRENT_SOURCE_DIR}/${DEB_FILE}.deb" "${DIST_PATH}/${DEB_FILE}.deb")
  file (RENAME "${CURRENT_SOURCE_DIR}/${DEB_FILE}.changes" "${DIST_PATH}/${DEB_FILE}.changes")
  file (RENAME "${CURRENT_SOURCE_DIR}/${DEB_FILE}.build" "${DIST_PATH}/${DEB_FILE}.build")
  file (RENAME "${CURRENT_SOURCE_DIR}/${DEB_DBG_FILE}.deb" "${DIST_PATH}/${DEB_DBG_FILE}.deb")


  message ("${MessageColor}Debian files ready${NC} in ${DIST_PATH}")