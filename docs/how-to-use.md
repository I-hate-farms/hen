## How to use

hen can build the following binaries : 
   - applications with a UI with the `application` declaration
   - console/command line/cli applications with the `console_application`
   - libraries (static or shared) with the `library` declaration
   - elementary plug (shared library) with the `elementary_plug` declaration

Write a hen specfic `CMakeLists.txt` file as described in [the documentation](docs/doc.md)

> Note: `CMakeLists.txt` will build all the binaries corresponding to the declarations (application/console_application/library/etc) in your cmakefile

Copy the [hen](/cmake/hen) script file (and just that) at the root of your project (at the same level as your CMakeLists.txt file) and make it executable.

Run:
```shell 
./hen build
```

`hen` will automatically download and install the cmake templates in the `cmake/` folder.
> **Caution:** if a  `cmake/` folder already exists, it will be deleted and replaced.

> Note: hen set `CMAKE_INSTALL_PREFIX` to `/usr` and uses the value `BUILD_TYPE` for `CMAKE_BUILD_TYPE`

For more help about the `hen` command line, run:
```shell
./hen help
``` 

## Differences with other cmake setups
- Only one cmake file `CMakeLists.txt` is needed for the entire project. No need to have a cmake file in sub folder or in the `po` folder
-  Additional files are generated: no need to have `Config.vala.cmake` or `.deps` or `.deps.cmake` or `.pc` or `.pc.cmake` files
-  No need to bother with pc packages (managed with `pkg_check_modules`). hen can deduce the list from the vala package (and handle the case when the pc package is different from the vala package name via [a dependency map](docs/dependencies.md))  

## Hen and make

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
