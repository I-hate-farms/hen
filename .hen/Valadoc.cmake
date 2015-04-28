# Bundle version: 0.9
#
# File History:
#    - 0.1 :
#    - 0.2 : add comment

include(ParseArguments)
find_package(Valadoc REQUIRED)

macro(build_valadoc)
    # Create dist folder if necessary 
    SET( DIST_PATH "${CMAKE_CURRENT_SOURCE_DIR}/dist")
    SET( DIST_VALADOC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/dist/${ARGS_NAME}/valadoc/")
    
    if(NOT EXISTS "${DIST_VALADOC_PATH}")
        file(MAKE_DIRECTORY "${DIST_VALADOC_PATH}")
    endif()
    
    valadoc ( ${ARGS_NAME} "${DIST_VALADOC_PATH}" ${VALA_FILES}
        PACKAGES
            ${VALA_PACKAGES}
        #OPTIONS
        #CUSTOM_VAPIS
        )
    # Replace valadoc default style.css
    # message ("XXX: ${DIST_VALADOC_PATH}/style.css")
    #file (REMOVE "${DIST_VALADOC_PATH}/style.css")
    #file (COPY "${DIR_ELEMENTARY_TEMPLATES}/valadoc_style.css" DESTINATION "${DIST_VALADOC_PATH}")
    #file (RENAME "${DIST_VALADOC_PATH}/valadoc_style.css" "${DIST_VALADOC_PATH}/style.css")
endmacro()

macro(valadoc target outdir)
	parse_arguments(ARGS "PACKAGES;OPTIONS;CUSTOM_VAPIS" "" ${ARGN})
	set(vala_pkg_opts "")
	foreach(pkg ${ARGS_PACKAGES})
		list(APPEND vala_pkg_opts "--pkg=${pkg}")
	endforeach(pkg ${ARGS_PACKAGES})

	set(vapi_dir_opts "")
	foreach(src ${ARGS_CUSTOM_VAPIS})
		get_filename_component(pkg ${src} NAME_WE)
		list(APPEND vala_pkg_opts "--pkg=${pkg}")
		
		get_filename_component(path ${src} PATH)
		list(APPEND vapi_dir_opts "--vapidir=${path}")
	endforeach(src ${ARGS_DEFAULT_ARGS})
	list(REMOVE_DUPLICATES vapi_dir_opts)

	add_custom_command(TARGET ${target}
	COMMAND
		${VALADOC_EXECUTABLE}
	ARGS
		"--force"
		"-b" ${CMAKE_CURRENT_SOURCE_DIR}
		"-o" ${outdir}
		"--package-name=${CMAKE_PROJECT_NAME}"
		"--package-version=${PROJECT_VERSION}"
		${vala_pkg_opts}
		${vapi_dir_opts}
		${ARGS_OPTIONS}
		${in_files} 
	DEPENDS
		${in_files}
		${ARGS_CUSTOM_VAPIS}
	COMMENT
		"Generating valadoc in ${outdir}"
	)
endmacro()
