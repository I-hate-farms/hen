# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release

macro (package_debian)

	# Write all the variables in the a script 
	set(CacheForScript ${CMAKE_BINARY_DIR}/package_debian_${ARGS_BINARY_NAME}.cmake)
	file(WRITE ${CacheForScript} "")

	get_cmake_property(Vars VARIABLES)
	foreach(Var ${Vars})
		
			string(FIND ${Var} "CMAKE_" pos)
		
	    # If variable doesn't start with CMAKE and is defined
	    set (VALUE ${${Var}})
	    if(${Var})
		    string(REPLACE "\\" "\\\\" VALUE ${${Var}})
		  endif ()
		  if( pos EQUAL -1 )
		  	file(APPEND ${CacheForScript} "set(${Var} \"${VALUE}\")\n")
		  endif()
		
	endforeach()

	add_custom_target(
		package_debian_${ARGS_BINARY_NAME}
 	COMMAND 
 		cmake -D "CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}" -D "CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}" -D "VARIABLES_FILE=${CacheForScript}" -P "${DIR_ELEMENTARY_TEMPLATES}/../PackageDebianExec.cmake" 
 	WORKING_DIRECTORY
 		"${CMAKE_CURRENT_BINARY_DIR}"
 	COMMENT 
 		"Executing PackageDebianExec.cmake"
 	)
endmacro()	
