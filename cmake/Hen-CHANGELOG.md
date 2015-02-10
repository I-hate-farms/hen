- support uninstall
- generate debian files and BUILD.md
- support system icons for ICON
- support po translation files
- support threads

* 0.9.9
 - only install apt packages if not present in the system (avoid asking for sudo without reason)
 - fix issues with gtk3.0 and ox
 - refactoring
 - version number can be added to packages (they are ignored for now)

* 0.9.8
 - misc fixes for apt dependencies
 - misc formatting fixes
 - hen is now updated with updates

* 0.9.7
 - add an internal release task

* 0.9.6
 - apt packages are installed automatically

* 0.9.5
 - fix comments
 - add rebuild task
 
* 0.9.4
 - add list options
 - add colors
 - fix library task (vala-stacktrace working)
 - add --target-glib 2.32 by default (and emit a warning if set in the cmake file)

* 0.9.3
 - refactoring (eidete working)
 - add build and prepare options

* 0.9.1:
 - add `hen.sh`
 - publish 0.9.1 to github

* 0.9: 
- 0.1 : initial release
- 0.2 : support schemas
- 0.3 : support app
- 0.4 : misc fixes
- 0.5 : support shared libraries
- 0.6 : support cli apps. Support C_OPTIONS
- 0.7 : add full dependencies support
- 0.8 : fix hard coded vapi and add local ./vapi folder
- 0.9 : support VALA_DEFINES
- 0.10: add RELEASE_NAME
- 0.11: adding support for desktop and icon files
- 0.12: setting a default for CMAKE_INSTALL_PREFIX if left empty
- 0.13: use BUILD_TYPE for the build and set vala define BUILD_IS_DEBUG and BUILD_IS_RELEASE
- 0.14: support and install contracts
- 0.15: implement *.vala and *.c files
