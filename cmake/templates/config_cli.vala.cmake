
// Generated file: do not modify
// Bundle version: 0.9
//File History:
//    - 0.1 : initial release
//    - 0.2 : members are internal
//    - 0.3 : refactor names
//    - 0.4 : fix is_debug

namespace Build {

    internal const string DATA_DIR = "@DATADIR@";
    internal const string PACKAGE_DATA_DIR = "@PKGDATADIR@";
    internal const string GETTEXT_PACKAGE = "@GETTEXT_PACKAGE@";

    internal const string VERSION = "@ELEM_VERSION@";
    internal const string RELEASE_NAME = "@ELEM_RELEASE_NAME@";
    internal const string TITLE = "@ELEM_TITLE@";
    internal const string BINARY_NAME = "@CMAKE_PROJECT_NAME@";

    // Values: Release or Debug
    internal const string BUILD = "@CMAKE_BUILD_TYPE@";

    internal bool is_debug () {
        return BUILD == "Debug" ;
    }

    internal string to_string () {
        var result = new StringBuilder () ;
        result.append (" - DATA_DIR         : %s\n".printf(DATA_DIR)) ;
        result.append (" - PACKAGE_DATA_DIR : %s\n".printf(PACKAGE_DATA_DIR)) ;
        result.append (" - GETTEXT_PACKAGE  : %s\n".printf(GETTEXT_PACKAGE)) ;
        result.append (" - TITLE            : %s\n".printf(TITLE)) ;
        result.append (" - VERSION          : %s\n".printf(VERSION)) ;
        result.append (" - RELEASE_NAME     : %s\n".printf(RELEASE_NAME)) ;
        result.append (" - BINARY_NAME      : %s\n".printf(BINARY_NAME)) ;
        result.append (" - BUILD            : %s\n".printf(BUILD)) ;
        return result.str ;
    }
}
