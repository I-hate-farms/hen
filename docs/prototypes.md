Hen defines the following binaries prototypes: 
  - [ConsoleApplication](#consoleapplication)
  - [Application](#application)
  - [Library](#library)
  - [ElementaryPlug](#elementaryplug)
  - [ElementaryContract](#elementarycontract)

The prototypes are declared in the `project.hen` file simply one after the other possibily referencing each others.

```
# You can also set Debug as your default build
set (BUILD_TYPE "Debug")

# This new application will conquer the world

library (
    NAME
        echo
    AUTHOR
        "Echo Developers"
    HOMEPAGE
        "https://github.com/I-hate-farms/echo"
    LICENSE
        "Apache 2.0"
    TITLE
        "Have your editor bark back at you"
    VERSION
        "0.1"
    SOURCE_PATH
        echo
    LINKING
        shared
    VALA_OPTIONS
        --target-glib=2.32
    PACKAGES
        libvala-0.28
        gio-2.0
        gee-0.8
)

console_application (
    NAME
        echo-testing
    LICENSE
        "Apache 2.0"
    VERSION
        "0.1"
    TITLE
        "Echo Testing, testing, testing..."
    SOURCE_PATH
        src
    PACKAGES
        echo
)

```

> **note** you need to declare the prototypes in the proper build order

## ConsoleApplication 

## Application 

## Library 

## ElementaryPlug

## ElementaryContract 
