Source: @ARGS_PACKAGE_NAME@
Section: x11
Priority: optional
Maintainer: @ARGS_AUTHOR@
Build-Depends: cmake (>= 2.8),
               debhelper (>= 9),
@COMPLETE_DIST_APT_PACKAGES@
               valac (>= 0.22)
Standards-Version: 3.9.5
Homepage: @ARGS_HOMEPAGE@

Package: @ARGS_PACKAGE_NAME@
Architecture: any
Depends: @DOLLAR@{misc:Depends}, @DOLLAR@{shlibs:Depends}
Pre-Depends: dpkg (>= 1.15.6)
Description: @ELEM_TITLE@
  @ARGS_BINARY_NAME@: @ELEM_TITLE@ 

Package: @ARGS_PACKAGE_NAME@-dbg
Architecture: any
Section: debug
Priority: extra
Depends: @ARGS_PACKAGE_NAME@ (= @DOLLAR@{binary:Version}), @DOLLAR@{misc:Depends}
Pre-Depends: dpkg (>= 1.15.6)
Enhances: @ARGS_PACKAGE_NAME@
Description: @ELEM_TITLE@ (debugging symbols)
   @ARGS_BINARY_NAME@-dbg: this package contains debugging symbols for @ARGS_BINARY_NAME@.