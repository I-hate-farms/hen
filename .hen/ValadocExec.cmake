# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#include(ParseArguments)
include (${VARIABLES_FILE})


    # Create dist folder if necessary 

    message ("CURRENT_SOURCE_DIR  ${CURRENT_SOURCE_DIR}")
    message ("ARGS_NAME ${ARGS_NAME}")
    message ("VALA_PACKAGES ${VALA_PACKAGES}")
    message ("VALA_FILES ${VALA_FILES}")
    message ("ARGS_VALA_OPTIONS ${ARGS_VALA_OPTIONS}")

    SET( DIST_PATH "${CURRENT_SOURCE_DIR}/dist")
    SET( DIST_VALADOC_PATH "${CURRENT_SOURCE_DIR}/dist/${ARGS_NAME}/valadoc/")
    
    if(NOT EXISTS "${DIST_VALADOC_PATH}")
        file(MAKE_DIRECTORY "${DIST_VALADOC_PATH}")
    endif()
    
    #
    # Calling valadoc 
    # 
    set(vala_pkg_opts "")
		foreach(pkg ${VALA_PACKAGES})
			list(APPEND vala_pkg_opts "--pkg=${pkg}")
		endforeach()

		set(vapi_dir_opts "")
		foreach(src ${CUSTOM_VAPIS})
			get_filename_component(pkg ${src} NAME_WE)
			list(APPEND vala_pkg_opts "--pkg=${pkg}")
			
			get_filename_component(path ${src} PATH)
			list(APPEND vapi_dir_opts "--vapidir=${path}")
		endforeach()
		list(REMOVE_DUPLICATES vapi_dir_opts)

    string(FIND "${ARGS_VALA_OPTIONS}" "--target-glib" index)
    if( index GREATER -1 )

			EXECUTE_PROCESS (
				COMMAND
					valadoc --force -b ${CMAKE_CURRENT_SOURCE_DIR} -o ${DIST_VALADOC_PATH} --package-name=${CMAKE_PROJECT_NAME} --package-version=${PROJECT_VERSION} --target-glib=2.32 ${vala_pkg_opts} ${vapi_dir_opts}  ${VALA_FILES} 
			)
		else () 
			EXECUTE_PROCESS (
				COMMAND
					valadoc --force -b ${CMAKE_CURRENT_SOURCE_DIR} -o ${DIST_VALADOC_PATH} --package-name=${CMAKE_PROJECT_NAME} --package-version=${PROJECT_VERSION} ${vala_pkg_opts} ${vapi_dir_opts}  ${VALA_FILES} 
			)
		endif()
#	DEPENDS
#		${in_files}
#		${CUSTOM_VAPIS}
#	COMMENT
#s		"Generating valadoc in ${DIST_VALADOC_PATH}"

    #valadoc ( ${ARGS_NAME} "${DIST_VALADOC_PATH}" ${VALA_FILES}
    #    PACKAGES
    #        ${VALA_PACKAGES}
        #OPTIONS
        #CUSTOM_VAPIS
    #    )
    # Replace valadoc default style.css
    # message ("XXX: ${DIST_VALADOC_PATH}/style.css")
    #file (REMOVE "${DIST_VALADOC_PATH}/style.css")
    file (COPY "${DIR_ELEMENTARY_TEMPLATES}/valadoc/style.css" DESTINATION "${DIST_VALADOC_PATH}")
    file (COPY "${DIR_ELEMENTARY_TEMPLATES}/valadoc/scripts.js" DESTINATION "${DIST_VALADOC_PATH}")
    #file (RENAME "${DIST_VALADOC_PATH}/valadoc_style.css" "${DIST_VALADOC_PATH}/style.css")
    



