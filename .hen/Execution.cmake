# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
macro (create_execution_tasks)
	SET( EXECNAME "")
	if( PROJECT_TYPE STREQUAL "APPLICATION")
		 SET( EXECNAME "${CMAKE_CURRENT_BINARY_DIR}/${ARGS_BINARY_NAME}")
	endif() 

	if( PROJECT_TYPE STREQUAL "PLUG")
		 SET( EXECNAME "switchboard")
	endif() 

	if(EXECNAME) 
		# Run 
		add_custom_target(
			run
		COMMAND 
			${EXECNAME}
		WORKING_DIRECTORY
			"${CMAKE_CURRENT_BINARY_DIR}"
		COMMENT 
			"Running ${ARGS_BINARY_NAME}..."
		)
		add_custom_target(
			debug
		COMMAND 
			gdb -ex=run --args ${EXECNAME}
		WORKING_DIRECTORY
			"${CMAKE_CURRENT_BINARY_DIR}"
		COMMENT 
			"Running ${ARGS_BINARY_NAME}..."
		)
	#else()
		# Can't be executed
	#	add_custom_target(
	#		run
	#	COMMAND 
	#		echo "This is not an executable, it cannot be run"
	#	WORKING_DIRECTORY
	#		"${CMAKE_CURRENT_BINARY_DIR}"
	#	COMMENT 
	#		"Error"
	#	)
		# or debugged
	#	add_custom_target(
	#		debug
	#	COMMAND 
	#		echo "This is not an executable, it cannot be debugged"
	#	WORKING_DIRECTORY
	#		"${CMAKE_CURRENT_BINARY_DIR}"
	#	COMMENT 
	#		"Error"
	#	)
	endif()
endmacro()    