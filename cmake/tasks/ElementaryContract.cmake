macro(build_elementary_contract)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;ICON;DESKTOP;CONTRACT" "" ${ARGN})

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_BINARY_NAME}")

    if( NOT ARGS_ICON)
        #message( FATAL_ERROR "Your application must have an ICON. Example: data/${ARGS_BINARY_NAME}.svg")
        set(ARGS_ICON "data/${ARGS_BINARY_NAME}.svg")
        message ("${MessageColor}Using ICON=data/${ARGS_BINARY_NAME}.svg${NC}")
    endif()

    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON})
        message( FATAL_ERROR "${FatalColor}The ICON file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON}")
    endif()

    # DESKTOP is not mandatory for apps
    if( ARGS_DESKTOP)
        if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP})
            message( FATAL_ERROR "${FatalColor}The DESKTOP file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP}")
        endif()
    endif()

    if( NOT ARGS_CONTRACT)
        message( FATAL_ERROR "${FatalColor}You must specify an CONTRACT file for your contract${NC}. Example: data/my_contract.contract")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT})
        message( FATAL_ERROR "${FatalColor}The CONTRACT file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT}")
    endif()

    hen_build (
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

    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON} DESTINATION share/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/contractor)

endmacro()

macro(install_elementary_contract)
    parse_arguments(ARGS "CONTRACT;ICON" "" ${ARGN})

    if( NOT ARGS_ICON)
        message( FATAL_ERROR "${FatalColor}You must specify an ICON for your contract${NC}. Example: data/contract_icon.svg")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON})
        message( FATAL_ERROR "${FatalColor}The ICON file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON}")
    endif()
    message("CON: ${ARGS_CONTRACT}")
    if( NOT ARGS_CONTRACT)
        message( FATAL_ERROR "${FatalColor}You must specify an CONTRACT file for your contract${NC}. Example: data/my_contract.contract")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT})
        message( FATAL_ERROR "${FatalColor}The CONTRACT file doesn't exist${NC}. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT}")
    endif()

    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON} DESTINATION share/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/contractor)

    create_uninstall_target ()
endmacro()