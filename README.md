## Introduction
**hen** is a set of predefined [cmake](http://cmake.org/) macros to build vala projects in a simple declarative way using sane defaults.

All is needed in **one only cmake** `CMakeLists.txt` filefile for your whole project

```cmake
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Hen)

set (VALA_VERSION_MIN "0.26")

set (BUILD_TYPE "Release")

application (
    BINARY_NAME
        webcontracts
    TITLE
        "Sharing Accounts"
    VERSION
        "0.2"
    SOURCE_PATH
        src
    PACKAGES
        gtk+-3.0
        json-glib-1.0
        granite
        rest-0.7
        webkitgtk-3.0
        libsoup-2.4
)

build_translations()
```

hen can build the following binaries : 
   - applications with a UI with the `application` declaration
   - console/command line/cli applications with the `console_application`
   - libraries (static or shared) with the `library` declaration
   - elementary plug (shared library) with the `elementary_plug` declaration

hen creates the following `make` targets:
   - `make`: build the binary with support for translations
       - generates a `Build` vala namespace   
       - generates the `pc` and `deps` file if the binary is a library 
       - uses translation files if available in the `po` folder
   - `make install`: install the binary along with provided files (.desktop, icons, contracts)
   - `make pot`: create the translations files

hen generates a [build file](docs/build.md) that can be called from vala code:  
```java
   void print_info () {
      stout.printf ("Usage: %s flickr /my/path/to/image.png\n", Build.BINARY_NAME);
   }
```

## How to use

Write a hen specfic `CMakeLists.txt` file as described in [the documentation](docs/doc.md)

> Note: `CMakeLists.txt` will build all the binaries corresponding to the declarations (application/console_application/library/etc) in your cmakefile

Copy the `hen` script file at the root of your project (at the same level as your CMakeLists.txt file)

Run:
```
./hen build
```

`hen` will automatically download and install the cmake templates in the `cmake/` folder.
> **Caution:** if a  `cmake/` folder already exists, it will be deleted and replaced.

> Note: hen set `CMAKE_INSTALL_PREFIX` to `/usr` and uses the value `BUILD_TYPE` for `CMAKE_BUILD_TYPE`

For more help about the `hen` command line, run:
```
./hen help
``` 

## Differences with other cmake setups
- Only one cmake file `CMakeLists.txt` is needed for the entire project. No need to have a cmake file in sub folder or in the `po` folder
-  Additional files are generated: no need to have `Config.vala.cmake` or `.deps` or `.deps.cmake` or `.pc` or `.pc.cmake` files
-  No need to bother with pc packages (managed with `pkg_check_modules`). hen can deduce the list from the vala package (and handle the case when the pc package is different from the vala package name via [a dependency map](docs/dependencies.md))  

## Samples

You can find samples for: 
  - [vala-stacktrace][1]: a library and a sample command line test program
  - [eidete][2]: an elementary gtk app
  - [useraccounts][4]: an elementary [switchboard][3] plug 
  - [webcontracts][5]: an elementary plug shipping with a cli application 
  - [gtk-test][6]: a simple Gtk application
  - [cli-test][7]: a simple command line application

[1]: https://github.com/PerfectCarl/vala-stacktrace
[2]: https://code.launchpad.net/~name-is-carl/eidete/use-elementary.cmake
[3]: https://launchpad.net/switchboard
[4]: https://code.launchpad.net/~name-is-carl/switchboard-plug-useraccounts/use-elementary.cmake
[5]: https://code.launchpad.net/~elementary-apps/webcontracts/fix-for-freya
[6]: none
[7]: none

## [Documentation](docs/doc.md) 

## [Changelog](CHANGELOG.md)
