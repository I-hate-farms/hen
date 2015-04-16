
// Generated file: do not modify
// Bundle version: 0.9
//File History:
//    - 0.1 : initial release
//    - 0.2 : refactor to support apps
//    - 0.3 : members are internal
//    - 0.4 : refactor names
//    - 0.5 : fix is_debug

namespace Build {

    internal const string DATA_DIR = "@DATADIR@";
    internal const string PACKAGE_DATA_DIR = "@PKGDATADIR@";
    internal const string GETTEXT_PACKAGE = "@GETTEXT_PACKAGE@";

    internal const string VERSION = "@ELEM_VERSION@";
    internal const string RELEASE_NAME = "@ELEM_RELEASE_NAME@";
    internal const string TITLE = "@ELEM_TITLE@";
    internal const string PROJECT_NAME = "@CMAKE_PROJECT_NAME@";

    internal const string AUTHOR = "@ARGS_AUTHOR@";
    internal const string HOMEPAGE = "@ARGS_HOMEPAGE@";
    internal const string LICENSE = "@ARGS_LICENSE@";    
    
    // Values: Release or Debug
    internal const string BUILD = "@CMAKE_BUILD_TYPE@";

    // Values: personal, hardware, network, system
    internal const string PLUG_CATEGORY = "@PLUG_CATEGORY@";

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
        result.append (" - PROJECT_NAME     : %s\n".printf(PROJECT_NAME)) ;
        result.append (" - AUTHOR           : %s\n".printf(AUTHOR)) ;
        result.append (" - HOMEPAGE         : %s\n".printf(HOMEPAGE)) ;
        result.append (" - RELEASE_NAME     : %s\n".printf(RELEASE_NAME)) ;
        result.append (" - BUILD            : %s\n".printf(BUILD)) ;
        result.append (" - PLUG_CATEGORY    : %s\n".printf(PLUG_CATEGORY)) ;
        return result.str ;
    }
}
