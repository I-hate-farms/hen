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
#    - 0.17: refactor

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

include (tasks/ElementaryApp)
include (tasks/ElementaryPlug)
include (tasks/ElementaryCli)
include (tasks/ElementaryContract)
include (tasks/ElementaryLibrary)

# Comment this out to enable C compiler warnings
add_definitions (-w)

if( NOT DIR_ELEMENTARY_CMAKE )
    set(DIR_ELEMENTARY_TEMPLATES ${CMAKE_CURRENT_LIST_DIR}/templates)
endif()

if( NOT DIR_ELEMENTARY_TEMPLATES )
    set(DIR_ELEMENTARY_TEMPLATES ${DIR_ELEMENTARY_CMAKE}/templates)
endif()

set (SOURCE_PATHS "")

#project(elementary_build)

macro(create_uninstall_target )
    # uninstall target
    configure_file(
        "${DIR_ELEMENTARY_TEMPLATES}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    # TODO handle uninstall
    #add_custom_target(uninstall
    #    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
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
        configure_file (${DIR_ELEMENTARY_TEMPLATES}/${ARGS_CONFIG_NAME} ${CONFIG_FILE})
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

