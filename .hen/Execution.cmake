# Bundle version: 0.9
#
# File History:
#    - 0.1 : initial release
#    - 0.2 : target specific make task 

macro (create_execution_tasks)
	SET( EXECNAME "")
	if( PROJECT_TYPE STREQUAL "APPLICATION")
		 SET( EXECNAME "${CMAKE_CURRENT_BINARY_DIR}/${ARGS_NAME}")
	endif() 

	if( PROJECT_TYPE STREQUAL "PLUG")
		 SET( EXECNAME "switchboard")
	endif() 

	if(EXECNAME) 
		# Run 
		add_custom_target(
			run_${ARGS_NAME}
		COMMAND 
			${EXECNAME}
		WORKING_DIRECTORY
			"${CMAKE_CURRENT_BINARY_DIR}"
		COMMENT 
			"Running ${ARGS_NAME}..."
		)
		add_custom_target(
			debug_${ARGS_NAME}
		COMMAND 
			gdb -ex=run --args ${EXECNAME}
		WORKING_DIRECTORY
			"${CMAKE_CURRENT_BINARY_DIR}"
		COMMENT 
			"Running ${ARGS_NAME}..."
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

	if( NOT EXECUTION_TOP_TARGET_ADDED AND EXECNAME)
		add_custom_target(
			run
		DEPENDS
			run_${ARGS_NAME}
		)
		add_custom_target(
			debug
		DEPENDS
			debug_${ARGS_NAME}
		)
		set(EXECUTION_TOP_TARGET_ADDED "true")
	endif ()
endmacro()    