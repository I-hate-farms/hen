prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=@DOLLAR@{prefix}
libdir=@DOLLAR@{prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=@DOLLAR@{prefix}/@CMAKE_INSTALL_INCLUDEDIR@
plugindir=@DOLLAR@{prefix}/@PLUGIN_DIR_UNPREFIXED@

Name: @ARGS_NAME@
Description: @ARGS_NAME@: @ELEM_TITLE@ headers
Version: @ELEM_VERSION@
Libs: -l@ARGS_NAME@
Cflags: -I@DOLLAR@{includedir}/@ARGS_NAME@
Requires: @COMPLETE_DIST_PC_PACKAGES@
