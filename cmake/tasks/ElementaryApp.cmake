macro(build_elementary_app)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;ICON;DESKTOP" "" ${ARGN})

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_BINARY_NAME}")

    if( NOT ARGS_ICON)
        #message( FATAL_ERROR "Your application must have an ICON. Example: data/${ARGS_BINARY_NAME}.svg")
        set(ARGS_ICON "data/${ARGS_BINARY_NAME}.svg")
        message ("Using ICON=data/${ARGS_BINARY_NAME}.svg")
    endif()

    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON})
        message( FATAL_ERROR "The ICON file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON}")
    endif()

    # DESKTOP is not mandatory for apps
    if( NOT ARGS_DESKTOP)
        #message( FATAL_ERROR "Your application must have an DESKTOP file. Example: data/${ARGS_BINARY_NAME}.desktop")
        set(ARGS_DESKTOP "data/${ARGS_BINARY_NAME}.desktop")
        message ("Using DESKTOP=data/${ARGS_BINARY_NAME}.desktop")
        #message ("Warning no DESKTOP defined: your application won't be displayed in slingshot")
    else()

    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP})
        message( FATAL_ERROR "The DESKTOP file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP}")
    endif()

    prepare_elementary (
        BINARY_NAME
            ${ARGS_BINARY_NAME}
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
    )

    add_executable (${ARGS_BINARY_NAME} ${VALA_C} ${C_FILES})
    target_link_libraries (${ARGS_BINARY_NAME} ${DEPS_LIBRARIES})

    install_elementary_app (${ARGS_BINARY_NAME} ${ARGS_ICON} "${ARGS_DESKTOP}")
endmacro()

macro(install_elementary_app ELEM_NAME ELEM_ICON ELEM_DESKTOP)
    #install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION bin)
    install (TARGETS ${ELEM_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})
    if(ELEM_DESKTOP)
        install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ELEM_DESKTOP} DESTINATION share/applications)
    endif()
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ELEM_ICON} DESTINATION share/icons/hicolor/48x48/apps)

    create_uninstall_target ()
endmacro()