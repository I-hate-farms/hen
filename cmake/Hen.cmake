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
#    - 0.18: color, glib 2.23 by default
#    - 0.19: support library with depending app (vala-stacktrace)
#    - 0.20: support library with depending app (vala-stacktrace+ox)

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
# TODO generate debian files

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

include (tasks/Application)
include (tasks/ConsoleApplication)
include (tasks/Library)

include (tasks/ElementaryPlug)
include (tasks/ElementaryContract)
# Comment this out to enable C compiler warnings
add_definitions (-w)

if( NOT DIR_ELEMENTARY_CMAKE )
    set(DIR_ELEMENTARY_TEMPLATES ${CMAKE_CURRENT_LIST_DIR}/templates)
endif()

if( NOT DIR_ELEMENTARY_TEMPLATES )
    set(DIR_ELEMENTARY_TEMPLATES ${DIR_ELEMENTARY_CMAKE}/templates)
endif()

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

set (SOURCE_PATHS "")

# project(hen_build)

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

macro(hen_build)
    parse_arguments(ARGS "BINARY_NAME;TITLE;VERSION;RELEASE_NAME;SOURCE_PATH;VALA_FILES;C_FILES;PACKAGES;C_DEFINES;VALA_DEFINES;SCHEMA;VALA_OPTIONS;CONFIG_NAME;LINKING;C_OPTIONS" "" ${ARGN})

    if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        message( "${MessageColor}CMAKE_INSTALL_PREFIX is not set${NC}. '/usr' is used by default")
        set (CMAKE_INSTALL_PREFIX "/usr")
    endif()

    if( NOT CMAKE_BUILD_TYPE)
        if( BUILD_TYPE)
            set (CMAKE_BUILD_TYPE ${BUILD_TYPE})
        endif()
    else()
        if(NOT CMAKE_BUILD_TYPE STREQUAL BUILD_TYPE)
            message( "${MessageColor}CMAKE_BUILD_TYPE is set to ${CMAKE_BUILD_TYPE}${NC}. The value of BUILD_TYPE (${BUILD_TYPE}) is ignored.")
        endif()
    endif()

    if(ARGS_BINARY_NAME)
        message ("")
        message( "${MessageColor}Creating build for ${ARGS_BINARY_NAME}...${NC}")
        message ("----------")
        project (${ARGS_BINARY_NAME})
    else()
        message( FATAL_ERROR "${FatalColor}You must specify a BINARY_NAME${NC}")
    endif()

    # TODO handle the case where the source is not precised
    if(ARGS_SOURCE_PATH)
        list(APPEND SOURCE_PATHS ${ARGS_SOURCE_PATH})
        list(REMOVE_DUPLICATES SOURCE_PATHS)
    else()
        message( FATAL_ERROR "${FatalColor}Error, you must provide a SOURCE_PATH argument${NC}")
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
        message( FATAL_ERROR "${FatalColor}You must specify a VERSION${NC}. Example: 1.0")
    endif()

    if(ARGS_TITLE)
        set (ELEM_TITLE ${ARGS_TITLE})
    else()
        message( FATAL_ERROR "${FatalColor}You must specify a TITLE${NC}. Example: \"My application\"")
    endif()

    # Add schema
    if(ARGS_SCHEMA)
        add_schema (${ARGS_SCHEMA})
    endif()

    # Checking vala version
    if(NOT VALA_VERSION_MIN)
        message ("${MessageColor}Using Vala 0.26.0 as minimum${NC}")
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

    # Sometimes glib is missing. We're adding it each time to be on the safe side
    # Is this still useful?
    #list( APPEND ARGS_PACKAGES "glib-2.0")

    # If the options already have the option ...
    set (EXTRA_VALA_OPTIONS "")
    string(FIND "${ARGS_VALA_OPTIONS}" "--target-glib" index)
    if( index GREATER -1 )
        # ... we display a warning
        message( "${WarningColor}You don't need to precise '--target-glib 2.32'${NC} as it is added by default.")
    else()
        # By default the new glibc is used: 2.32
        set( EXTRA_VALA_OPTIONS "--target-glib=2.32" )
    endif()
    
    handle_packages () 
    # if you don't mind keeping the naming convention 
    # you could do that in a loop for all variables too e.g. foreach(TYPE CFLAGS LIBRARIES ...) 
    # TODO Add vapi folder if present

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
            ${EXTRA_VALA_OPTIONS}
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
            ${EXTRA_VALA_OPTIONS}
            ${ARGS_VALA_OPTIONS}
        )
    endif()
    #message ( "VALA_FILES:  ${VALA_FILES}")
    # message ("VALA_C: ${VALA_C}")
    # Build files ${ARGS_SOURCE_PATH}
    include_directories (${CMAKE_CURRENT_SOURCE_DIR})

    #include_directories (${ARGS_SOURCE_PATH})
endmacro()

macro(handle_packages)
    # Handle the packges
    set (VALA_PACKAGES "")
    set (VALA_LOCAL_PACKAGES "")
    # Used in libs.pc.make
    set (COMPLETE_DIST_PC_PACKAGES "")
    # Used in libs.deps.make
    set (ELEM_DEPS_PC_PACKAGES "")
    set (APT_PC_PACKAGES "")

    # Pre process the package list to get the version and version operators if specified
    foreach(vala_package ${ARGS_PACKAGES})

        # Extracting (and removing the )
        string( STRIP "${vala_package}" vala_package)
        #string( FIND "${vala_package}" " " index)
        #message( "PACKAGE: ${vala_package} ")
        #set( package_version "")
        #if( index GREATER -1 )
        #    string( LENGTH ${vala_package} line_len)
        #    string( SUBSTRING ${vala_package} index line_len package_version)
        #    string( SUBSTRING ${vala_package} 0 1 vala_package)
        #endif()
        #message( "PKG: ${vala_package} VER: ${package_version}")
        if ("${vala_package}"  STREQUAL ">=" OR "${vala_package}" STREQUAL "<="  OR "${vala_package}"  STREQUAL "=")
            set (ignore_next "true")
            set (package_version_op ${vala_package})
        else ()
            if( "${ignore_next}"  STREQUAL "true")
                set (package_version ${vala_package})
                unset (ignore_next)    
            else ()
                list( APPEND PACKAGES ${vala_package})
            endif()
        endif ()
    endforeach()

    foreach(vala_package ${PACKAGES})

        string( STRIP "${vala_package}" vala_package)

        set (pc_package "")
        get_pc_package (${vala_package} pc_package)
        set (in_debian "")
        # return "true" if package is in debian repo
        is_vala_package_in_debian (${vala_package} in_debian)

        if(vala_package STREQUAL "posix" OR NOT in_debian STREQUAL "true" OR vala_package STREQUAL "linux")
            # message ("Ignoring checking for ${pkg}")
            list(APPEND vapi_packages "${vala_package}")
            # Is this correct???
            #list(APPEND checked_pc_packages "${pc_package}")
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
            set (apt_pkg "")
            get_apt_pc_packages( ${vala_package} apt_pkg)
            set(APT_PC_PACKAGES ${APT_PC_PACKAGES} "${apt_pkg}")
        endif()

        # TODO Handle threading better with the options etc
        # TODO test this
        if( NOT vala_package STREQUAL "gthread-2.0"  )
            set(VALA_PACKAGES ${VALA_PACKAGES} ${vala_package})
        endif()

    endforeach()
    install_apt_packges ("${APT_PC_PACKAGES}")
    #set (DEPS_CFLAGS "")
    #set (DEPS_LIBRARIES "")
    #set (DEPS_LIBRARY_DIRS "")

    #set (bin_cflags "")
    #set (bin_libs "")
    #set (bin_lib_dirs "")
    #message ("Checked ${checked_pc_packages}")
    if( checked_pc_packages )
        # message ("CHEKING: ${checked_pc_packages}...")
        set (DEPSNAME "DEPS_${ARGS_BINARY_NAME}_VAR")
        pkg_check_modules (${DEPSNAME} REQUIRED QUIET ${checked_pc_packages})
        
    endif()
    foreach( vala_local_pkg ${list_vala_local_packages} )
        local_check_package ("${DEPSNAME}" "${vala_local_pkg}")
    endforeach()
    # get_property(bin_libs VARIABLE PROPERTY "${DEPSNAME}_LIBRARIES")
    # Setting the flags so that the required libraries are found 
    # at compile time and linkin time
    if( NOT "${${DEPSNAME}_CFLAGS}" STREQUAL "" )
        #message ("!!! CFLAGS : ${${DEPSNAME}_CFLAGS}")
        add_definitions (${${DEPSNAME}_CFLAGS})
    endif()
    if( NOT "${${DEPSNAME}_LIBRARY_DIRS}" STREQUAL "" )
        #message ("!!! DIRS : ${${DEPSNAME}_LIBRARY_DIRS}")
        link_directories (${${DEPSNAME}_LIBRARY_DIRS})
    endif()
    if( NOT "${${DEPSNAME}_LIBRARIES}" STREQUAL "" )
        #message ("!!! LIBS : ${${DEPSNAME}_LIBRARIES}")
        link_libraries (${${DEPSNAME}_LIBRARIES})
    endif()
endmacro()   