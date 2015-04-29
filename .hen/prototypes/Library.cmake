# Bundle version: 0.9
#
# File History:
#    - 0.1 : refactoring
#    - 0.2 : fix glib.h: No such file or directory (vala-stacktrace working)
#    - 0.3 : fix library with depending app
#    - 0.4 : add valadoc 
#    - 0.5 : improve valadoc 

macro(library)
    parse_arguments(ARGS "NAME;TITLE;VERSION;RELEASE_NAME;SOVERSION;LINKING;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;AUTHOR;HOMEPAGE;LICENSE" "" ${ARGN})

    if( NOT ARGS_LINKING)
        message( FATAL_ERROR "${FatalColor}You must specify a LINKING: static or shared${NC}.")
    endif()

    if( NOT ARGS_LINKING STREQUAL "shared" AND NOT ARGS_LINKING STREQUAL "static")
        message( FATAL_ERROR "${FatalColor}The value LINKING must be either static or shared${NC}.")
    endif()

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_NAME}")

    set (PROJECT_TYPE "LIBRARY")
    set (BINARY_TYPE "LIBRARY")
    
    set (ARGS_PACKAGE_NAME "lib${ARGS_NAME}-dev")

    hen_build (
        NAME
            ${ARGS_NAME}
        TITLE
            ${ARGS_TITLE}
        VERSION
            ${ARGS_VERSION}
        RELEASE_NAME
            ${ARGS_RELEASE_NAME}
        SOURCE_PATH
            ${ARGS_SOURCE_PATH}
        VALA_FILES
            ${ARGS_VALA_FILES}
        C_FILES
            ${ARGS_C_FILES}
        VALA_DEFINES
            ${ARGS_VALA_DEFINES}
        C_DEFINES
            ${ARGS_C_DEFINES}
        PACKAGES
            ${ARGS_PACKAGES}
        SCHEMA
             ${ARGS_SCHEMA}
        VALA_OPTIONS
             ${ARGS_VALA_OPTIONS}
        CONFIG_NAME
            config_lib.vala.cmake
        LINKING
            ${ARGS_LINKING}
        C_OPTIONS
             ${ARGS_C_OPTIONS}
        AUTHOR
             ${ARGS_AUTHOR}
        HOMEPAGE
             ${ARGS_HOMEPAGE}
        LICENSE
             ${ARGS_LICENSE}
    )

    # Set for the variables substitution in the pc file
    set (DOLLAR "$")
    # TODO fix the output path
    configure_file (${DIR_ELEMENTARY_TEMPLATES}/lib.pc.cmake ${CMAKE_BINARY_DIR}/${ARGS_NAME}.pc)
    configure_file (${DIR_ELEMENTARY_TEMPLATES}/lib.deps.cmake ${CMAKE_BINARY_DIR}/${ARGS_NAME}.deps)
    add_local_package (${ARGS_NAME} ${COMPLETE_DIST_PC_PACKAGES} )

    target_link_libraries (${ARGS_NAME} ${DEPS_LIBRARIES})

    install_elementary_library (${ARGS_NAME} ${ARGS_LINKING})
    # Support tasks 
    build_valadoc () 
    package_debian ()
    create_execution_tasks ()
endmacro()

macro(install_elementary_library ELEM_NAME BUILD_TYPE)
    if (${BUILD_TYPE} STREQUAL "shared" )
        # Notes: 
        # the DESTINATION in an install() statement is relative to the INSTALL_PREFIX 
        # install (TARGETS ${ELEM_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR}) could work ?
        # +ngladitz
        # "${CMAKE_INSTALL_LIBDIR}" expands to e.g. "lib/x86_64-linux-gnu" if your prefix is "/usr" but to lib if you prefix is "/usr/local" 
        # List all vars with cmake -LAH in build/ 
        message( "Install prefix is ${MessageColor}${CMAKE_INSTALL_PREFIX}${NC}")
        message( "Install destination is ${MessageColor}${CMAKE_INSTALL_LIBDIR}${NC}")
        install (TARGETS ${ELEM_NAME} DESTINATION ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}    COMPONENT ${ELEM_NAME})
        # Install lib stuffs
        install (FILES ${CMAKE_BINARY_DIR}/${ELEM_NAME}.pc              DESTINATION lib/pkgconfig/        COMPONENT ${ELEM_NAME})
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.vapi    DESTINATION share/vala/vapi/  COMPONENT ${ELEM_NAME})
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.deps    DESTINATION share/vala/vapi/  COMPONENT ${ELEM_NAME})
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.h       DESTINATION lib/${ELEM_NAME}/     COMPONENT ${ELEM_NAME})

        add_custom_target(install_${ELEM_NAME}
              DEPENDS ${ELEM_NAME}
              COMMAND 
                  "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=shared
                  -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
            )
    endif ()
    create_uninstall_target ()
endmacro()