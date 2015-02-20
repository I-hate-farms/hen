* 0.9.13
 - fix regression if your project requires built-in dependencies 
 
* 0.9.12
 - rename cmake folder to .hen 
 - add tasks: valadoc
 - first stab at deb building and providing default icons

* 0.9.10
 - generate desktop and icon file
 - add clean task 
 - improve onboarding experience
 - more documentation
 
* 0.9.9
 - only install apt packages if not present in the system (avoid asking for sudo without reason)
 - fix issues with gtk3.0 and ox
 - refactoring
 - version number can be added to packages (they are ignored for now)

* 0.9.8
 - misc fixes for apt dependencies
 - misc formatting fixes
 - hen is now updated with updates

 * 0.9.6
 - apt packages are installed automatically
 - add more packages to dependencies.list
 
* 0.9.5
 - fix comments
 - add rebuild task
 
* 0.9.4
 - add list options
 - add colors
 - fix library task (vala-stacktrace working)
 - add --target-glib 2.32 by default (and emit a warning if set in the cmake file)

* 0.9.3
 - add `hen.sh` that provides update feature
 - refactoring (eidete working)
 - add build and prepare options
  
* Initial revision: 0.9
