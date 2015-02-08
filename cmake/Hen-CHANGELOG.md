- support uninstall
- support po translation files

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
