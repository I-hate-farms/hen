# Bundle version: 0.9
#
# File History:
#    - 0.1 : refactoring
#    - 0.2 : fix library with depending app

macro(console_application)
    parse_arguments(ARGS "NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;AUTHOR;HOMEPAGE;LICENSE" "" ${ARGN})

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_NAME}")

    set (PROJECT_TYPE "CONSOLE")
    set (BINARY_TYPE "APPLICATION")

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
            config_cli.vala.cmake
        C_OPTIONS
             ${ARGS_C_OPTIONS}
        AUTHOR
             ${ARGS_AUTHOR}
        HOMEPAGE
             ${ARGS_HOMEPAGE}
        LICENSE
             ${ARGS_LICENSE}
    )

    #add_executable (${ARGS_NAME} ${VALA_C} ${C_FILES})
    #foreach( vala_local_pkg ${list_vala_local_packages})
    #    add_dependencies (${ARGS_NAME}  "${vala_local_pkg}")
    #endforeach()
    target_link_libraries (${ARGS_NAME} ${DEPS_LIBRARIES})

    install_elementary_cli (${ARGS_NAME})
    # Support tasks 
    #build_valadoc () 
    package_debian ()
    create_execution_tasks ()
endmacro()

macro(install_elementary_cli ELEM_NAME)
    install (TARGETS ${ELEM_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR} COMPONENT ${ELEM_NAME})
    
    add_custom_target(install_${ELEM_NAME}
          DEPENDS ${ELEM_NAME}
          COMMAND 
              "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=shared
              -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
        )

    create_uninstall_target ()
endmacro()