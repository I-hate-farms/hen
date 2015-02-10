# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#    - 0.2 : fix deps hardcoded run-passwd
#    - 0.3 : install apt packages
#    - 0.4 : fix local_check_package for multiple packages (ox)
#    - 0.5 : only install packages if necesseray (avoid sudo each time)
#    - 0.6 : fix dependending project (ox)

if( NOT DIR_ELEMENTARY_CMAKE )
    set(DIR_ELEMENTARY_CMAKE ${CMAKE_CURRENT_LIST_DIR})
endif()

if( NOT DIR_ELEMENTARY_TEMPLATES )
    set(DIR_ELEMENTARY_TEMPLATES ${DIR_ELEMENTARY_CMAKE}/templates)
endif()

macro (read_dependency_file)
    if( NOT DEPEND_FILE_READ )

        set( list_vala_packages "")
        set( list_pc_packages "")

        set( depend_file "${DIR_ELEMENTARY_CMAKE}/dependencies.list")
        #message ("Reading ${depend_file}")

        file(STRINGS ${depend_file} file_content)
        set (line_number 0)

        foreach(line IN LISTS file_content)
            if( line )
                string( STRIP ${line} line)
                string( LENGTH ${line} line_len)
                MATH(EXPR line_number ${line_number}+1)
                #message ("Reading line ${line_number}")

                # Ignore commented line starting with # or empty line
                if( line_len GREATER 0 )
                    string( SUBSTRING ${line} 0 1 line_start)
                    if( NOT line_start STREQUAL "#")
                        #message("line = ${line}")
                        string(REPLACE "->" ";"  line_list ${line})

                        list(GET line_list 0 first_col)
                        string( STRIP ${first_col} first_col)

                        list(GET line_list 1 second_col)
                        string( STRIP ${second_col} second_col)

                        if( second_col STREQUAL "<same>")
                            set (second_col ${first_col})
                        endif()

                        if( second_col STREQUAL "<none>")
                            set (second_col "")
                        endif()

                        list(LENGTH line_list len)
                        set( third_col "")
                        if( len GREATER 2 )
                            list(GET line_list 2 third_col)
                            string( STRIP ${third_col} third_col)
                        endif()

                        list (APPEND list_pc_packages ${first_col})
                        if(third_col)
                            list (APPEND list_vala_packages ${third_col})
                        else()
                            list (APPEND list_vala_packages ${first_col})
                        endif()
                        if( second_col)
                            list (APPEND list_apt_packages ${second_col})
                        endif()
                        # message("first = ${first_col}")
                        # message("second = ${second_col}")
                        # message("third = ${third_col}")
                        # message("-")
                    endif()
                endif()
            endif()
        endforeach()
        set(DEPEND_FILE_READ "true")
    endif()
endmacro()

macro (install_apt_packges apt_packages)


    string( REPLACE "," " " pkgs "${apt_packages}")
    string( REPLACE ";" " " pkgs "${pkgs}")
    string( STRIP "${pkgs}" pkgs)
    string( LENGTH "${pkgs}" pkgs_len)
    if( pkgs_len GREATER 0 )
        EXEC_PROGRAM( dpkg  
            ARGS
                -s "${pkgs}"
            OUTPUT_VARIABLE 
                output
            RETURN_VALUE  
                result_code)
        #message ("result_code: ${result_code}")
        #message ("OUTPUT: ${output}")
        # INFO dpkg -S `which <command>` 
        # and whereis wicd
        #   wicd: /etc/wicd
        
        # If some packages are missing
        if( NOT "${result_code}" STREQUAL "0")

            message ("")
            message( "${MessageColor}Installing the dependencies${NC} for ${ARGS_BINARY_NAME} via ${MessageColor}apt${NC}...")
            message ("----------")

            EXEC_PROGRAM( sudo
                ARGS 
                    apt-get install -y "${pkgs}"
                OUTPUT_VARIABLE 
                    output
                RETURN_VALUE 
                    result_code)
            # message ("result_code: ${result_code}")
            # message ("OUTPUT: ${output}")
        endif()
    endif()
endmacro()

# Returns true if the vala_package can be found in the
# debian package.
# Returns false otherwise meaning that the package is local
# (code - c or vala - and the vapi files are included in the
# project)
macro (is_vala_package_in_debian vala_package in_debian)
     set( in_debian "")
     list(FIND list_vala_packages ${vala_package} index)

    if( index GREATER -1 )
        set( in_debian "true")
    endif()
endmacro()

macro (get_pc_package vala_package pc_package )
    read_dependency_file()

    list(FIND list_vala_packages ${vala_package} index)

    if( index GREATER -1 )
        list(GET list_pc_packages ${index} pc_package)
    endif()
    #if( NOT pc_package)
    #    set( pc_package ${vala_package} )
    #endif()
endmacro()

macro(add_local_package vala_package dependencies)
    list (APPEND list_vala_local_packages ${vala_package})
    string (STRIP ${dependencies} deps)
    list (APPEND list_vala_local_packages_deps ${deps})
endmacro()

# Not used!!!
macro (is_vala_package_local package_name is_local)
     if( package_name STREQUAL "vala-stacktrace")
        set (is_local "true")
    else ()
        set (is_local "false")
    endif()
endmacro()

macro (local_check_package variable_name vala_package )

    list(FIND list_vala_local_packages ${vala_package} index)
    if( index GREATER -1 )
        list(GET list_vala_local_packages_deps ${index} deps)
        #get_property(pack_libs VARIABLE PROPERTY "${variable_name}_LIBRARIES")
        #message ("OOO: pack_libs:  ${pack_libs} ")
        set ("${variable_name}_LIBRARIES" "${${variable_name}_LIBRARIES}" "${vala_package}")
        #get_property(after_libs VARIABLE PROPERTY "${variable_name}_LIBRARIES")
        #message ("OOO: after_libs:  ${after_libs} ")

        string( REPLACE " " ";" final_deps "${deps}")
        set(VALA_PACKAGES ${VALA_PACKAGES} "${final_deps}")
    else ()
        message ( FATAL_ERROR "${FatalColor}Local vala package not found${NC}: ${vala_package}") 
    endif()
endmacro()

macro(get_apt_pc_packages vala_package apt_packages)
    read_dependency_file()

    list(FIND list_vala_packages ${vala_package} index)
    set (apt_packages "")
    if( index GREATER -1 )
        list(GET list_apt_packages ${index} apt_pkg)
        string( REPLACE "," " " final_pkg "${apt_pkg}")
        set (apt_packages "${final_pkg}")
    endif()
endmacro()