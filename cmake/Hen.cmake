# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#    - 0.2 : support schemas
#    - 0.3 : support app
#    - 0.4 : misc fixes
#    - 0.5 : support shared libraries
#    - 0.6 : support cli apps. Support C_OPTIONS
#    - 0.7 : add full dependencies support
#    - 0.8 : fix hard coded vapi and add local ./vapi folder
#    - 0.9 : support VALA_DEFINES
#    - 0.10: add RELEASE_NAME
#    - 0.11: adding support for desktop and icon files
#    - 0.12: setting a default for CMAKE_INSTALL_PREFIX if left empty
#    - 0.13: use BUILD_TYPE for the build and set vala define BUILD_IS_DEBUG
#            and BUILD_IS_RELEASE
#    - 0.14: support and install contracts
#    - 0.15: implement *.vala and *.c files
#    - 0.16: support uninstall

# RELEASE
# TODO * fix po file generation
# . test libs/apps/cli with fo files
# . many app with the same po folder...
# handle --experimental
# TODO * deal with thread library
# generate file in build/src
# END

# TODO support dependencies min version
#   OPTIONAL_DEPS
#      libmutter>=3.12 HAVE_MUTTER312
#      libmutter>=3.10 HAVE_MUTTER310

# TODO add glib if needed (for very basic cli app)
# TODO generate README and INSTALL
#

# TODO compute .h folder from .c paths (ASSUMED)
#
# TODO is SOURCE_PATH required?
# TODO PKGDATADIR and DATADIR always needed?
# TODO generate debian files?

# TODO support make dist ?
#    Add 'make dist' command for creating release tarball
#    set (CPACK_PACKAGE_VERSION ${VERSION})
#    set (CPACK_SOURCE_GENERATOR "TGZ")
#    set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
#    set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")
#    include (CPack)
#    add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

find_package (PkgConfig)

include (ParseArguments)
include (ValaPrecompile)
include (Translations)
include (GNUInstallDirs)
include (GSettings)
include (Dependencies)

# Comment this out to enable C compiler warnings
add_definitions (-w)

if( NOT DIR_ELEMENTARY_CMAKE )
    set(DIR_ELEMENTARY_CMAKE ${CMAKE_CURRENT_LIST_DIR})
endif()

set (SOURCE_PATHS "")

#project(elementary_build)

macro(build_elementary_plug)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;PLUG_CATEGORY;SOURCE_PATH;VALA_FILES;C_FILES;PACKAGES;C_DEFINES;VALA_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS" "" ${ARGN})

    if( NOT ARGS_PLUG_CATEGORY)
        message( FATAL_ERROR "You must specify a PLUG_CATEGORY: personal, hardware, network or system.")
    endif()

    set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
    set (PKGDATADIR "${DATADIR}/${ARGS_PLUG_CATEGORY}/${ARGS_BINARY_NAME}")
    set (GETTEXT_PACKAGE "${ARGS_BINARY_NAME}")

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
    )

    add_library (${ARGS_BINARY_NAME} MODULE ${VALA_C} ${C_FILES})
    target_link_libraries (${ARGS_BINARY_NAME} ${DEPS_LIBRARIES})

    install_elementary_plug (${ARGS_BINARY_NAME})
    create_uninstall_target ()
endmacro()

macro(install_elementary_plug ELEM_NAME)
    install (TARGETS ${ELEM_NAME} DESTINATION ${PKGDATADIR})
endmacro()

macro(create_uninstall_target )
    # uninstall target
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endmacro()

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

macro(build_elementary_contract)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS;ICON;DESKTOP;CONTRACT" "" ${ARGN})

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
    if( ARGS_DESKTOP)
        if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP})
            message( FATAL_ERROR "The DESKTOP file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_DESKTOP}")
        endif()
    endif()

    if( NOT ARGS_CONTRACT)
        message( FATAL_ERROR "You must specify an CONTRACT file for your contract. Example: data/my_contract.contract")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT})
        message( FATAL_ERROR "The CONTRACT file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT}")
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

    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON} DESTINATION share/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/contractor)

endmacro()

macro(install_elementary_contract)
    parse_arguments(ARGS "CONTRACT;ICON" "" ${ARGN})

    if( NOT ARGS_ICON)
        message( FATAL_ERROR "You must specify an ICON for your contract. Example: data/contract_icon.svg")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON})
        message( FATAL_ERROR "The ICON file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON}")
    endif()
    message("CON: ${ARGS_CONTRACT}")
    if( NOT ARGS_CONTRACT)
        message( FATAL_ERROR "You must specify an CONTRACT file for your contract. Example: data/my_contract.contract")
    endif()
    if( NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT})
        message( FATAL_ERROR "The CONTRACT file doesn't exist. File: ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT}")
    endif()

    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_ICON} DESTINATION share/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ARGS_CONTRACT} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/contractor)

    create_uninstall_target ()
endmacro()

macro(build_elementary_cli)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS" "" ${ARGN})

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_BINARY_NAME}")

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
            config_cli.vala.cmake
        C_OPTIONS
             ${ARGS_C_OPTIONS}
    )

    add_executable (${ARGS_BINARY_NAME} ${VALA_C} ${C_FILES})
    target_link_libraries (${ARGS_BINARY_NAME} ${DEPS_LIBRARIES})

    install_elementary_cli (${ARGS_BINARY_NAME})
endmacro()

macro(install_elementary_cli ELEM_NAME)
    install (TARGETS ${ELEM_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})

    create_uninstall_target ()
endmacro()

macro(build_elementary_library)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOVERSION;LINKING;SOURCE_PATH;VALA_FILES;C_FILES;VALA_DEFINES;PACKAGES;C_DEFINES;SCHEMA;VALA_OPTIONS;C_OPTIONS" "" ${ARGN})

    if( NOT ARGS_LINKING)
        message( FATAL_ERROR "You must specify a LINKING: static or shared.")
    endif()

    if( NOT ARGS_LINKING STREQUAL "shared" AND NOT ARGS_LINKING STREQUAL "static")
        message( FATAL_ERROR "The value LINKING must be either static or shared.")
    endif()

    set (DATADIR "")
    set (PKGDATADIR "")
    set (GETTEXT_PACKAGE "${ARGS_BINARY_NAME}")

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
            config_lib.vala.cmake
        LINKING
            ${ARGS_LINKING}
        C_OPTIONS
             ${ARGS_C_OPTIONS}
    )

    # Set for the variables substitution in the pc file
    set (DOLLAR "$")
    # TODO fix the output path
    configure_file (${DIR_ELEMENTARY_CMAKE}/lib.pc.cmake ${CMAKE_BINARY_DIR}/${ARGS_BINARY_NAME}.pc)
    configure_file (${DIR_ELEMENTARY_CMAKE}/lib.deps.cmake ${CMAKE_BINARY_DIR}/${ARGS_BINARY_NAME}.deps)

    if( ARGS_LINKING STREQUAL "static")
        add_library (${ARGS_BINARY_NAME} STATIC ${VALA_C} ${C_FILES})
    else()
        add_library (${ARGS_BINARY_NAME} SHARED ${VALA_C} ${C_FILES})
        if( NOT ARGS_SOVERSION)
            message ("The parameter SO_VERSION is not specified so '0' is used.")
            set( ARGS_SOVERSION "0")
        endif()

        set_target_properties (${ARGS_BINARY_NAME} PROPERTIES
            OUTPUT_NAME ${ARGS_BINARY_NAME}
            VERSION ${ARGS_VERSION}
            SOVERSION ${ARGS_SOVERSION}
        )
    endif()

    target_link_libraries (${ARGS_BINARY_NAME} ${DEPS_LIBRARIES})

    install_elementary_library (${ARGS_BINARY_NAME} ${ARGS_LINKING})
endmacro()

macro(install_elementary_library ELEM_NAME BUILD_TYPE)
    if (${BUILD_TYPE} STREQUAL "shared" )
        install (TARGETS ${ELEM_NAME} DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR})
        # Install lib stuffs
        install (FILES ${CMAKE_BINARY_DIR}/${ELEM_NAME}.pc              DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/pkgconfig/)
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.vapi    DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/vala/vapi/)
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.deps    DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/vala/vapi/)
        install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${ELEM_NAME}.h       DESTINATION ${CMAKE_INSTALL_FULL_INCLUDEDIR}/${ELEM_NAME}/)
    endif ()
    create_uninstall_target ()
endmacro()

macro(build_translations)

    # Add po folder if present
    # TODO fix if no po folder is found
    # TODO recurse folders??
    #if( NOT DISABLE_PO)
        set( PO_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/po")
        #message("build_translations!! ${PO_FOLDER}")
        if(EXISTS ${PO_FOLDER} )
            add_translations_directory (${PO_FOLDER} ${GETTEXT_PACKAGE})
            # TODO remove src here
            #message ("SOURCE PATHS: ${SOURCE_PATHS}")
            add_translations_catalog (${PO_FOLDER} ${GETTEXT_PACKAGE} ${SOURCE_PATHS})
            add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
        endif ()
        # PO files are only computed once
        #set (DISABLE_PO "true")
    #endif()
endmacro()

macro(prepare_elementary)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;PACKAGES;C_DEFINES;VALA_DEFINES;SCHEMA;VALA_OPTIONS;CONFIG_NAME;LINKING;C_OPTIONS" "" ${ARGN})

    if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        message( "CMAKE_INSTALL_PREFIX is not set. '/usr' is used by default")
        set (CMAKE_INSTALL_PREFIX "/usr")
    endif()

    if( NOT CMAKE_BUILD_TYPE)
        if( BUILD_TYPE)
            set (CMAKE_BUILD_TYPE ${BUILD_TYPE})
        endif()
    else()
        if(NOT CMAKE_BUILD_TYPE STREQUAL BUILD_TYPE)
            message( "CMAKE_BUILD_TYPE is set to ${CMAKE_BUILD_TYPE}. The value of BUILD_TYPE (${BUILD_TYPE}) is ignored.")
        endif()
    endif()

    if(ARGS_BINARY_NAME)
        project (${ARGS_BINARY_NAME})
    else()
        message( FATAL_ERROR "You must specify a BINARY_NAME")
    endif()

    # TODO handle the case where the source is not precised
    if(ARGS_SOURCE_PATH)
        list(APPEND SOURCE_PATHS ${ARGS_SOURCE_PATH})
        list(REMOVE_DUPLICATES SOURCE_PATHS)
    else()
        message ("Error, you must provide a SOURCE_PATH argument")
    endif()

    # Add the source path to the vala files
    set (VALA_FILES "")
    if( ARGS_VALA_FILES AND ARGS_SOURCE_PATH)
        foreach(source_file ${ARGS_VALA_FILES})
           list(APPEND VALA_FILES ${ARGS_SOURCE_PATH}/${source_file})
        endforeach()
    endif()

    # If no file list is provided use the *.vala files in ARGS_SOURCE_PATH
    # recursively
    if( NOT ARGS_VALA_FILES)
        file(GLOB_RECURSE VALA_FILES "${ARGS_SOURCE_PATH}/*.vala")
    endif()

    # Add the source path to the c files and add the path
    # to the matching .h files
    set (C_FILES "")
    if( ARGS_C_FILES AND ARGS_SOURCE_PATH)
        foreach(source_file ${ARGS_C_FILES})
           list(APPEND C_FILES ${ARGS_SOURCE_PATH}/${source_file})
        endforeach()
        # TODO: extract the include dirs from the folder above
        include_directories (${ARGS_SOURCE_PATH})
    endif()

    # If no file list is provided use the *.vala files in ARGS_SOURCE_PATH
    # recursively
    if( NOT ARGS_C_FILES)
        file(GLOB_RECURSE C_FILES "${ARGS_SOURCE_PATH}/*.c")
    endif()
    #add_subdirectory (${ARGS_SOURCE_PATH} ${CMAKE_BINARY_DIR}/${ARGS_BINARY_NAME})

    if(ARGS_VERSION)
        set (ELEM_VERSION ${ARGS_VERSION})
    else()
        message( FATAL_ERROR "You must specify a VERSION. Example: 1.0")
    endif()

    if(ARGS_TITLE)
        set (ELEM_TITLE ${ARGS_TITLE})
    else()
        message( FATAL_ERROR "You must specify a TITLE. Example: \"My application\"")
    endif()

    # Add schema
    if(ARGS_SCHEMA)
        add_schema (${ARGS_SCHEMA})
    endif()

    # Checking vala version
    if(NOT VALA_VERSION_MIN)
        message ("Using Vala 0.26.0 as minimum")
        SET(VALA_VERSION_MIN "0.26.0" )
    endif()
    find_package (Vala REQUIRED)
    include (ValaVersion)
    ensure_vala_version (VALA_VERSION_MIN MINIMUM)


    # Check packages that are not provided in the vapi folder
    set(checked_pc_packages "")
    set(vapi_packages "")

    set(VALA_DEFINES "")
    # Add the C defines
    foreach(def ${ARGS_VALA_DEFINES})
        set( VALA_DEFINES ${VALA_DEFINES} "--define=${def}")
    endforeach()
    if( CMAKE_BUILD_TYPE STREQUAL "Debug")
        set( VALA_DEFINES ${VALA_DEFINES} "--define=BUILD_IS_DEBUG")
    endif()
    if( CMAKE_BUILD_TYPE STREQUAL "Release")
        set( VALA_DEFINES ${VALA_DEFINES} "--define=BUILD_IS_RELEASE")
    endif()
    # Add the C defines
    foreach(def ${ARGS_C_DEFINES})
        add_definitions ("-D${def}")
    endforeach()

    # Add the C options
    foreach(opt ${ARGS_C_OPTIONS})
        add_definitions ("${opt}")
    endforeach()

    # Handle the packges
    set (VALA_PACKAGES "")
    # Used in libs.pc.make
    set (COMPLETE_DIST_PC_PACKAGES "")
    # Used in libs.deps.make
    set (ELEM_DEPS_PC_PACKAGES "")
    foreach(vala_package ${ARGS_PACKAGES})

        set (pc_package "")
        get_pc_package (${vala_package} pc_package)
        set (in_debian "")
        # return "true" if package is in debian repo
        is_vala_package_in_debian (${vala_package} in_debian)

        #message ("DEP ${vala_package} ${pc_package}")

        if(vala_package STREQUAL "posix" OR NOT in_debian STREQUAL "true" OR vala_package STREQUAL "linux")
            # message ("Ignoring checking for ${pkg}")
            list(APPEND vapi_packages "${vala_package}")
        else()
            # message ("Adding checked pkg ${pkg}")
            list(APPEND checked_pc_packages "${pc_package}")
        endif()

        # Posix and linux are vala only packages without
        # c libraries -> they should be excluded from the pc and
        # deps files
        if(in_debian STREQUAL "true" AND NOT vala_package STREQUAL "linux" AND NOT vala_package STREQUAL "posix")
            set(COMPLETE_DIST_PC_PACKAGES " ${COMPLETE_DIST_PC_PACKAGES} ${pc_package}")
            set(ELEM_DEPS_PC_PACKAGES  "${ELEM_DEPS_PC_PACKAGES}${pc_package}\n")
        endif()

        # TODO Handle threading better with the options etc
        # TODO test this
        if( NOT vala_package STREQUAL "gthread-2.0")
            set(VALA_PACKAGES ${VALA_PACKAGES} ${vala_package})
        endif()
    endforeach()

    set (DEPS_CFLAGS "")
    set (DEPS_LIBRARIES "")
    set (DEPS_LIBRARY_DIRS "")

    #message ("Checked ${checked_pc_packages}")
    if( checked_pc_packages )
        pkg_check_modules (DEPS REQUIRED ${checked_pc_packages})
        add_definitions (${DEPS_CFLAGS})
        link_libraries (${DEPS_LIBRARIES})
        link_directories (${DEPS_LIBRARY_DIRS})
    endif()
    # TOOD Add vapi folder if present
    #message (" DEPS_CFLAGS : ${DEPS_CFLAGS}")
    #message (" DEPS_LIBRARIES: ${DEPS_LIBRARIES}")
    #message (" DEPS_LIBRARY_DIRS: ${DEPS_LIBRARY_DIRS}")

    # Generate config file
    set (ELEM_RELEASE_NAME ${ARGS_RELEASE_NAME})
    if( ARGS_CONFIG_NAME)
        set (CONFIG_FILE /tmp/config-${ARGS_BINARY_NAME}.vala)
        configure_file (${DIR_ELEMENTARY_CMAKE}/${ARGS_CONFIG_NAME} ${CONFIG_FILE})
    endif()

    if (ARGS_LINKING)
        set( LIBRARY_NAME  ${ARGS_BINARY_NAME})

        # Precompile vala files for library
        vala_precompile (VALA_C ${ARGS_BINARY_NAME}
            ${VALA_FILES}
            ${CONFIG_FILE}
        PACKAGES
            ${VALA_PACKAGES}
        OPTIONS
            # TODO : deprecated ??
            --thread
            # TODO
            --vapidir=${CMAKE_BINARY_DIR}
            --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi
            --vapi-comments
            ${VALA_DEFINES}
            ${ARGS_VALA_OPTIONS}
        # For libraries
        GENERATE_VAPI
            ${LIBRARY_NAME}
        GENERATE_HEADER
            ${LIBRARY_NAME}
        )
        set( ELEM_VAPI_DIR ${CMAKE_BINARY_DIR})

    else()
        # Precompile vala files for app
        vala_precompile (VALA_C ${ARGS_BINARY_NAME}
            ${VALA_FILES}
            ${CONFIG_FILE}
        PACKAGES
            ${VALA_PACKAGES}
        OPTIONS
            # TODO : deprecated ??
            --thread
            # TODO
            --vapidir=${CMAKE_BINARY_DIR}
            --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi
            ${VALA_DEFINES}
            ${ARGS_VALA_OPTIONS}
        )
    endif()
    #message ( "VALA_FILES:  ${VALA_FILES}")
    # message ("VALA_C: ${VALA_C}")
    # Build files ${ARGS_SOURCE_PATH}
    include_directories (${CMAKE_CURRENT_SOURCE_DIR})
    #include_directories (${ARGS_SOURCE_PATH})
endmacro()

