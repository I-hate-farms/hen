# Bundle version: 0.9
#
# File History:
#    - 0.1 : refactoring
#    - 0.2 : fix library with depending app

macro(elementary_plug)
    parse_arguments(ARGS "NAME;TITLE;VERSION;RELEASE_NAME;PLUG_CATEGORY;SOURCE_PATH;VALA_FILES;C_FILES;PACKAGES;C_DEFINES;VALA_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;AUTHOR;HOMEPAGE;LICENSE" "" ${ARGN})

    if( NOT ARGS_PLUG_CATEGORY)
        message( FATAL_ERROR "${FatalColor}You must specify a PLUG_CATEGORY${NC}: personal, hardware, network or system.")
    endif()

    set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
    set (PKGDATADIR "${DATADIR}/${ARGS_PLUG_CATEGORY}/${ARGS_NAME}")
    set (GETTEXT_PACKAGE "${ARGS_NAME}")

    set (PROJECT_TYPE "PLUG")
    set (BINARY_TYPE "LIBRARY")
    
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
        C_DEFINES
            ${ARGS_C_DEFINES}
        VALA_DEFINES
            ${ARGS_VALA_DEFINES}
        PACKAGES
            gtk+-3.0
            switchboard-2.0
            granite
            ${ARGS_PACKAGES}
        SCHEMA
             ${ARGS_SCHEMA}
        VALA_OPTIONS
             ${ARGS_VALA_OPTIONS}
        CONFIG_NAME
            config_plug.vala.cmake
        C_OPTIONS
             ${ARGS_C_OPTIONS}
        AUTHOR
             ${ARGS_AUTHOR}
        HOMEPAGE
             ${ARGS_HOMEPAGE}
        LICENSE
             ${ARGS_LICENSE}
    )

    # add_library (${ARGS_NAME} MODULE ${VALA_C} ${C_FILES})
    foreach( vala_local_pkg ${list_vala_local_packages})
        add_dependencies (${ARGS_NAME}  "${vala_local_pkg}")
    endforeach()
    target_link_libraries (${ARGS_NAME} ${DEPS_LIBRARIES})

    install_elementary_plug (${ARGS_NAME})
    create_uninstall_target ()
    # Support tasks 
    build_valadoc () 
    package_debian ()
    create_execution_tasks ()
endmacro()

macro(install_elementary_plug ELEM_NAME)
    install (TARGETS ${ELEM_NAME} DESTINATION ${PKGDATADIR} COMPONENT ${ELEM_NAME})
    add_custom_target(install_${ELEM_NAME}
      DEPENDS ${ELEM_NAME}
      COMMAND 
          "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=shared
          -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    )
endmacro()