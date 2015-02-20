Download [hen](https://raw.githubusercontent.com/I-hate-farms/hen/master/hen) in your project folder

Make it executable (on linux via `chmod +x hen`)

Write a simple project named `CMakeLists.txt` file for your application 

```java
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Hen)

set (BUILD_TYPE "Release")

application (
    BINARY_NAME
        happy-pig
    TITLE
        "A swine are happy"
    VERSION
        "1.0"
    SOURCE_PATH
        src
    PACKAGES
        gtk+-3.0
)
```

Run:
```shell 
./hen build
```

This command will:
   - install the necessary packages once if needed: mainly `cmake`, `vala` and `build-essentials`
   - generate an icon and desktop file so that your application appears in the application list (for example slingshot on elementary) once installed 
   - generate the make files in the `build/` folder
   - build your application
