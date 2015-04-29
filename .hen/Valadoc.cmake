# Bundle version: 0.9
#
# File History:
#    - 0.1 :
#    - 0.2 : add comment

macro(build_valadoc)

	write_valaodoc_to_script()
	
	add_custom_target(
		valadoc_${ARGS_NAME}
 	COMMAND 
 		cmake -D "CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}" -D "CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}" -D "VARIABLES_FILE=${VALADOC_VAR_FILE}" -D "ARGS_NAME=${ARGS_NAME}" -D "DIR_ELEMENTARY_TEMPLATES=${DIR_ELEMENTARY_TEMPLATES}" -P "${DIR_ELEMENTARY_TEMPLATES}/../ValadocExec.cmake" 
 	WORKING_DIRECTORY
 		"${CMAKE_CURRENT_BINARY_DIR}"
 	COMMENT 
 		"Executing ValadocExec.cmake"
 	)

 	if( NOT VALADOC_TOP_TARGET_ADDED)
		add_custom_target(
			valadoc
		DEPENDS
			valadoc_${ARGS_NAME}
		)
		set(VALADOC_TOP_TARGET_ADDED "true")
	endif ()



endmacro()

macro(write_valaodoc_to_script)

    # Write all the variables in the a script 
    set(VALADOC_VAR_FILE ${CMAKE_BINARY_DIR}/valadoc_${ARGS_NAME}.cmake)
    file(WRITE ${VALADOC_VAR_FILE} "")

    set (var "VALA_FILES")
    set (VALUE ${${var}})
    set (TEMP_VALUE "")
    if(${var})
        string(REPLACE "\\" "\\\\" VALUE ${${var}})
    endif ()
    foreach (item ${${var}})
    	set (TEMP_VALUE "${TEMP_VALUE};${item}")
    endforeach() 
    file(APPEND ${VALADOC_VAR_FILE} "set(${var} \"${TEMP_VALUE}\")\n")


    set (var "VALA_PACKAGES")
    set (VALUE ${${var}})
    set (TEMP_VALUE "")
    if(${var})
        string(REPLACE "\\" "\\\\" VALUE ${${var}})
    endif ()
    foreach (item ${${var}})
    	set (TEMP_VALUE "${TEMP_VALUE};${item}")
    endforeach() 
    file(APPEND ${VALADOC_VAR_FILE} "set(${var} \"${TEMP_VALUE}\")\n")
    
    set (var "ARGS_VALA_OPTIONS")
    set (VALUE "${EXTRA_VALA_OPTIONS} ${ARGS_VALA_OPTIONS}")
		file(APPEND ${VALADOC_VAR_FILE} "set(${var} \"${VALUE}\")\n")
endmacro()