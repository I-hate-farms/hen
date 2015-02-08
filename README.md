## Introduction
**elementary.cmake** is a set of predefined [cmake](http://cmake.org/) macros to build vala projects in a simple declarative way using sane defaults.

All is needed in **one only cmake** `CMakeLists.txt` filefile for your whole project

```cmake
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Elementary)

set (VALA_VERSION_MIN "0.26")

set (BUILD_TYPE "Release")

build_elementary_app (
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

elementary.cmake builds the following binary files: 
   - application with a UI: `build_elementary_app`
   - command line (cli) application: `build_elementary_cli`
   - library (static or shared): `build_elementary_library`
   - elementary plug (shared library): `build_elementary_plug`

elementary.cmake creates the following `make` targets:
   - `make`: build the binary with support for translations
       - generates a `Build` vala namespace   
       - generates the `pc` and `deps` file if the binary is a library 
       - uses translation files if available in the `po` folder
   - `make install`: install the binary along with provided files (.desktop, icons, contracts)
   - `make uninstall`:
   - `make pot`: create the translations files

elementary.cmake generates a [build file](docs/build.md) that can be called from vala code:  
```java
   void print_info () {
      stout.printf ("Usage: %s flickr /my/path/to/image.png\n", Build.BINARY_NAME);
   }
```

## How to use

Replace the cmake folder in your project by the one provided.

Write a cmake `CMakeLists.txt` file as described in [the documentation](docs/doc.md)

> Note: `CMakeLists.txt` may contain many build_elementary_xxx calls if your project produces many binary files

Run 
```
mkdir build && cd build
cmake ../ 
make
```

> Note: elementary.cmake set `CMAKE_INSTALL_PREFIX` to `/usr` and uses the value `BUILD_TYPE` for `CMAKE_BUILD_TYPE`

## Differences with other cmake setup
- Only one cmake file `CMakeLists.txt` is needed for the entire project. No need to have a cmake file in sub folder or in the `po` folder
-  Additional files are generated: no need to have `Config.vala.cmake` or `.deps` or `.deps.cmake` or `.pc` or `.pc.cmake` files
-  No need to bother with pc packages (managed with `pkg_check_modules`). elementary.cmake can deduce the list from the vala package (and handle the case when the pc package is different from the vala package name via [a dependency map](docs/dependencies.md))  

## Samples

You can find samples for: 
  - [vala-stacktrace][1]: a library and a sample cli test program
  - [eidete][2]: an elementary gtk app
  - [useraccounts][4]: an elementary [switchboard][3] plug 
  - [webcontracts][5]: an elementary plug shipping with a cli application 

[1]: https://github.com/PerfectCarl/vala-stacktrace
[2]: https://code.launchpad.net/~name-is-carl/eidete/use-elementary.cmake
[3]: https://launchpad.net/switchboard
[4]: https://code.launchpad.net/~name-is-carl/switchboard-plug-useraccounts/use-elementary.cmake
[5]: https://code.launchpad.net/~elementary-apps/webcontracts/fix-for-freya


## [Documentation](docs/doc.md) 

## [Changelog](CHANGELOG.md)
