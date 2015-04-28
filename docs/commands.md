Hen supports the following commands: 
  - [init](#init): create a `project.hen` for you
  - [build](#build): build your binaries in `build/`
  - [rebuild](#rebuild): delete your output folders `dist/` and `build/` and build your binaries
  - [install](#install): install your binaries locally depending on the `PREFIX` (`usr/` by default)
  - [valadoc](#valadoc): generate the [valadoc](www.valadoc.org) in the `dist/valadoc` folder
  - [package](#package): package your binaries for your distribution (only `debian` like supported)
  - [run](#run): run your application if applicable (doesn't apply to libraries)
  - [debug](#debug): start a `gdb` session with your application
  - [update](#update): update `hen` to the last version
  - [force-update](#force-update): delete `hen` locally and start an `update` 
  
## Init
> ./hen init

Create a `project.hen` for you

## Build
> ./hen build 

Build all your binaries in the `build/<binary>` folder

## Rebuild 
> ./hen rebuild 

Delete your output folders `dist/` and `build/` and build your binaries
 
## Install 
> ./hen install [binary] 

Install your binaries locally depending on the `PREFIX` (`usr/` by default).

| name | option | description |
|--------|----------|---------|
| binary | optional | the name of the binary to install. If left blank, the command installs all the binaries defined  in the `project.hen` file|


## Valadoc 
> ./hen valadoc 

Generate the [valadoc](www.valadoc.org) for all the binaries in `dist/<binary>` using enhanced [Parrot templates](https://github.com/I-hate-farms/parrot) 

See Parrot [in action](http://i-hate-farms.github.io/parrot/)

## Package 
> ./hen run [binary] [system] 

Package your binaries for your packaging system (only `debian` supported at the moment)

| name | option | description |
|--------|----------|---------|
| binary | optional | the name of the binary to install. If left blank, the command installs all the binaries defined  in the `project.hen` file|
| system | optional | the packaging system to use to generate the package to. The only one supported is `debian` at the moment |

See how to package [for debian](packaging_for_debian.md)

## Run 

> ./hen run [binary] 

Launch your application if applicable. 

While `Library` nor `ElementaryContract`can't be ran, `ElementaryPlug` are runnable by launching [switchboard](https://launchpad.net/switchboard)

| name | option | description |
|--------|----------|---------|
| binary | optional | the name of the binary to run. If left blank, the command runs the last binary in the `project.hen` that is not a library |
 
## Debug

> ./hen debug [binary] 

Start a `gdb` session with your application for applicable binaries. See [run](#run) for more information.

## Update 

> ./hen update

## Force-update 

> ./hen force-update


