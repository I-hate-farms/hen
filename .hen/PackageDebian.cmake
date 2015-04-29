# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#    - 0.2 : target specific make task 

macro (package_debian)

	write_variables_to_script ()

	add_custom_target(
		package_debian_${ARGS_NAME}
 	COMMAND 
 		cmake -D "CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}" -D "CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}" -D "VARIABLES_FILE=${CacheForScript}" -P "${DIR_ELEMENTARY_TEMPLATES}/../PackageDebianExec.cmake" 
 	WORKING_DIRECTORY
 		"${CMAKE_CURRENT_BINARY_DIR}"
 	COMMENT 
 		"Executing PackageDebianExec.cmake"
 	DEPENDS
		${ARGS_NAME}		
 	)

 	if( NOT PACKAGE_DEBIAN_TOP_TARGET_ADDED)
		add_custom_target(
			package_debian
		DEPENDS
			package_debian_${ARGS_NAME}
		)
		set(PACKAGE_DEBIAN_TOP_TARGET_ADDED "true")
	endif ()

endmacro()	
