# Bundle version: 0.9
#
# File History:
#    - 0.1 : refactoring
#    - 0.2 : fix library with depending app
#    - 0.3 : generate icon and desktop if missing

macro(application)
    parse_arguments(ARGS "NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;ICON;DESKTOP;AUTHOR;HOMEPAGE;LICENSE" "" ${ARGN})

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_NAME}")
    
    set (PROJECT_TYPE "APPLICATION")
    set (BINARY_TYPE "APPLICATION")
    
    # Copy the default icon if the image is missing and not defined in the project file
    if( NOT ARGS_ICON )
        set( ICON_FILE "data/${ARGS_NAME}.svg")
        if( NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/${ARGS_NAME}.svg" AND NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${ICON_FILE}" )
            file( COPY "${DIR_ELEMENTARY_TEMPLATES}/happy-swine.svg"  DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/data")
            file( RENAME "${CMAKE_CURRENT_SOURCE_DIR}/data/happy-swine.svg" "${CMAKE_CURRENT_SOURCE_DIR}/data/${ARGS_NAME}.svg")
            set(ARGS_ICON "${ICON_FILE}")
            message ("${MessageColor}Generating default icon${NC}: ${ICON_FILE}.")
        endif()
    endif()
    if( NOT ARGS_ICON)
        #message( FATAL_ERROR "Your application must have an ICON. Example: data/${ARGS_NAME}.svg")
        if( EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/${ARGS_NAME}.svg")
            set(ARGS_ICON "data/${ARGS_NAME}.svg")
            message ("${MessageColor}Using ICON=${ARGS_ICON}${NC}")
        endif()
         if( EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/${ARGS_NAME}.png")
            set(ARGS_ICON "data/${ARGS_NAME}.png")
            message ("${MessageColor}Using ICON=${ARGS_ICON}${NC}")
        endif()       
    endif()
    set( TEMPLATE_ICON_NAME )
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON})
        message( FATAL_ERROR "${FatalColor}The ICON file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON}")
    endif()
    get_filename_component(TEMPLATE_ICON_NAME "${ARGS_ICON}" NAME)

    # Generate a desktop file if the desktop file missing and not defined in the project file
    if( NOT ARGS_DESKTOP)
        set( DESKTOP_FILE "data/${ARGS_NAME}.desktop")
        if( NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${DESKTOP_FILE}")
            configure_file ("${DIR_ELEMENTARY_TEMPLATES}/desktop.cmake" "${CMAKE_CURRENT_SOURCE_DIR}/${DESKTOP_FILE}")
            set(ARGS_DESKTOP "${DESKTOP_FILE}")
            message ("${MessageColor}Generating default dekstop${NC}: ${DESKTOP_FILE}.")
        endif()
    endif()
    # DESKTOP is not mandatory for apps
    if( NOT ARGS_DESKTOP)
        #message( FATAL_ERROR "Your application must have an DESKTOP file. Example: data/${ARGS_NAME}.desktop")
        set(ARGS_DESKTOP "data/${ARGS_NAME}.desktop")
        # For more info on desktop files, see 
        #   https://linuxcritic.wordpress.com/2010/04/07/anatomy-of-a-desktop-file/
        # and 
        #  https://wiki.archlinux.org/index.php/Desktop_entries
        message ("${MessageColor}Using DESKTOP=data/${ARGS_NAME}.desktop${NC}")
        #message ("Warning no DESKTOP defined: your application won't be displayed in slingshot")
    else()

    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP})
        message( FATAL_ERROR "${FatalColor}The DESKTOP file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP}")
    endif()

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
            config_app.vala.cmake
        C_OPTIONS
             ${ARGS_C_OPTIONS}
        AUTHOR
             ${ARGS_AUTHOR}
        HOMEPAGE
             ${ARGS_HOMEPAGE}
        LICENSE
             ${ARGS_LICENSE}
    )

    #foreach( vala_local_pkg ${list_vala_local_packages})
    #    add_dependencies (${ARGS_NAME}  "${vala_local_pkg}")
    #endforeach()
    target_link_libraries (${ARGS_NAME} ${DEPS_LIBRARIES})

    install_elementary_app (${ARGS_NAME} ${ARGS_ICON} "${ARGS_DESKTOP}")
    # Support tasks 
    build_valadoc () 
    package_debian ()
    create_execution_tasks ()
endmacro()

macro(install_elementary_app ELEM_NAME ELEM_ICON ELEM_DESKTOP)
    #install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION bin)
    install (TARGETS ${ELEM_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR} COMPONENT ${ELEM_NAME} )
    # Needed for elementary contract
    if(ELEM_DESKTOP)
        install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ELEM_DESKTOP} DESTINATION share/applications COMPONENT ${ELEM_NAME})
    endif()  
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ELEM_ICON} DESTINATION share/icons/hicolor/48x48/apps COMPONENT ${ELEM_NAME})

    add_custom_target(install_${ELEM_NAME}
      DEPENDS ${ELEM_NAME}
      COMMAND 
          "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=shared
          -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    )
    create_uninstall_target ()
endmacro()