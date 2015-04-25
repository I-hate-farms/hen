# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#    - 0.2 : target specific make task 

macro (package_debian)

	# Write all the variables in the a script 
	set(CacheForScript ${CMAKE_BINARY_DIR}/package_debian_${ARGS_NAME}.cmake)
	file(WRITE ${CacheForScript} "")

	get_cmake_property(Vars VARIABLES)
	foreach(Var ${Vars})
		
			string(FIND ${Var} "CMAKE_" pos)
		
	    # If variable doesn't start with CMAKE and is defined
	    set (VALUE ${${Var}})
	    if(${Var})
		    string(REPLACE "\\" "\\\\" VALUE ${${Var}})
		  endif ()
		  if( pos EQUAL -1 OR "${Var}" STREQUAL "CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT" OR 
		  	"${Var}" STREQUAL "CMAKE_INSTALL_PREFIX")
		  	file(APPEND ${CacheForScript} "set(${Var} \"${VALUE}\")\n")
		  endif()
		
	endforeach()

	add_custom_target(
		package_debian_${ARGS_NAME}
 	COMMAND 
 		cmake -D "CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}" -D "CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}" -D "VARIABLES_FILE=${CacheForScript}" -P "${DIR_ELEMENTARY_TEMPLATES}/../PackageDebianExec.cmake" 
 	WORKING_DIRECTORY
 		"${CMAKE_CURRENT_BINARY_DIR}"
 	COMMENT 
 		"Executing PackageDebianExec.cmake"
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
