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
  #SET (DEBIAN_PATH "${CURRENT_BINARY_DIR}/${ARGS_NAME}/debian")
  SET (DEBIAN_PATH "${CURRENT_BINARY_DIR}/debian")
  file(MAKE_DIRECTORY "${DEBIAN_PATH}")
  file(MAKE_DIRECTORY "${DEBIAN_PATH}/source")

  # TODO do something smart with the license
  if(EXISTS "${CURRENT_SOURCE_DIR}/LICENSE")
    file(STRINGS "${CURRENT_SOURCE_DIR}/LICENSE" LICENSE_TEXT)
  endif()

  # The date has the following format[19] (compatible and
  # with the same semantics of RFC 2822 and RFC 5322):
  #
  #   day-of-week, dd month yyyy hh:mm:ss +zzzz
  # More on https://www.debian.org/doc/debian-policy/ch-source.html

  # sample set (PACKAGING_DATE "Wed, 20 Aug 2014 11:00:00 -0500")
  # Because cmake misses features here we use the date program.
  # **Not portable**
  EXEC_PROGRAM(
      date
    ARGS
        --rfc-2822
    OUTPUT_VARIABLE
        PACKAGING_DATE
    RETURN_VALUE
        result_code)

  string(TIMESTAMP PACKAGING_YEAR "%Y")

  if( NOT ARGS_COPYRIGHT)
    set (ARGS_COPYRIGHT "${ARGS_AUTHOR}")
  endif()
  if( NOT ARGS_PACKAGE_NAME)
    set (ARGS_PACKAGE_NAME "${ARGS_NAME}")
  endif()

  set (DOLLAR "$")

  # create control file
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/control.cmake ${DEBIAN_PATH}/control)

  # create rule file
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/rules.cmake ${DEBIAN_PATH}/rules)
  if( PROJECT_TYPE STREQUAL "LIBRARY")
    configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/install.cmake ${DEBIAN_PATH}/${ARGS_NAME}.install)
  endif()
  if(EXISTS "${CURRENT_SOURCE_DIR}/CHANGELOG.md")
    # Extract the first paragraph body of the changelog
    SET (CHANGE_LOG_BODY "")
    file(STRINGS "${CURRENT_SOURCE_DIR}/CHANGELOG.md" FILE_BODY)
    SET (DONE "FALSE")
    foreach(line IN LISTS FILE_BODY)
    if( line)
      if (DONE STREQUAL "FALSE")
        string( SUBSTRING ${line} 0 1 line_start)
        if( NOT line_start STREQUAL " ")
          if( IN_PARAGRAPH STREQUAL "TRUE")
            SET (DONE "TRUE")
          endif()
          SET (IN_PARAGRAPH "TRUE")
        endif()
        if( IN_PARAGRAPH AND line_start STREQUAL " ")
          SET (CHANGE_LOG_BODY "${CHANGE_LOG_BODY}\n${line}")
        endif()
      endif()
    endif()
    endforeach()
    # message ("CHANGE : ${CHANGE_LOG_BODY}")
    # Replace the list markers with * and ensure proper spacing
    # More https://www.debian.org/doc/debian-policy/ch-source.html
  else()
    SET (CHANGE_LOG_BODY "  * changes")
  endif()

  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/changelog.cmake ${DEBIAN_PATH}/changelog)

  #create a bunch of static files: compat, source/format
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/compat.cmake ${DEBIAN_PATH}/compat)
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/format.cmake ${DEBIAN_PATH}/source/compat)
  configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/copyright.cmake ${DEBIAN_PATH}/copyright)

  # TODO override files with debian folder
  if(EXISTS "${CURRENT_SOURCE_DIR}/README.md")
    file (COPY "${CURRENT_SOURCE_DIR}/README.md" DESTINATION "${DEBIAN_PATH}/README")
  else()
    configure_file (${DIR_ELEMENTARY_TEMPLATES}/debian/README.cmake ${DEBIAN_PATH}/README)
  endif()

  message ("  . Debian control files generated in ${DEBIAN_PATH}")
  # Running debuild
  message ("  . Running debuild. This may take a while...")
  EXECUTE_PROCESS(
      COMMAND
        debuild -i -us -uc -b
      OUTPUT_VARIABLE
          output
      WORKING_DIRECTORY
#        ${CURRENT_BINARY_DIR}/${ARGS_NAME}
        ${CURRENT_BINARY_DIR}
      RESULT_VARIABLE
          result_code)
  message ("Debuild ouput: ${output}")
  if( NOT "${result_code}" STREQUAL "0")
    message ("${FatalColor}debuild failed${NC}, returning ${result_code}")
    message ("Debuild ouput: ${output}")
  endif()

  SET (DIST_PATH "${CURRENT_SOURCE_DIR}/dist/${ARGS_NAME}")
  file (MAKE_DIRECTORY "${DIST_PATH}")

  SET (DEB_FILE "${ARGS_PACKAGE_NAME}_${ARGS_VERSION}_amd64")
  SET (DEB_DBG_FILE "${ARGS_PACKAGE_NAME}-dbg_${ARGS_VERSION}_amd64")

  # Move the created file to dist/
  #SET (DEB_DEST "${CURRENT_BINARY_DIR}")
  SET (DEB_DEST "${CURRENT_SOURCE_DIR}")
  if(EXISTS "${DEB_DEST}/${DEB_FILE}.deb")
    file (RENAME "${DEB_DEST}/${DEB_FILE}.deb" "${DIST_PATH}/${DEB_FILE}.deb")
    file (RENAME "${DEB_DEST}/${DEB_FILE}.changes" "${DIST_PATH}/${DEB_FILE}.changes")
    file (RENAME "${DEB_DEST}/${DEB_FILE}.build" "${DIST_PATH}/${DEB_FILE}.build")
    file (RENAME "${DEB_DEST}/${DEB_DBG_FILE}.deb" "${DIST_PATH}/${DEB_DBG_FILE}.deb")
  else ()
    message ("${FatalColor}The packaging failed${NC}.")
  endif ()

  EXECUTE_PROCESS(
      COMMAND
        debuild clean
      OUTPUT_VARIABLE
          output
      WORKING_DIRECTORY
        ${CURRENT_BINARY_DIR}/${ARGS_NAME}
      RESULT_VARIABLE
          result_code)
  # Delete folder because it was created with root permissions
  file(REMOVE_RECURSE ${DEBIAN_PATH})

  message ("${MessageColor}Debian files ready${NC} in ${DIST_PATH}")