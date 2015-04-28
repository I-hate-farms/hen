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

## Build

## Rebuild 

## Install 
> ./hen install [binary] 

## Valadoc 
Generate the valadoc for all the binaries in `dist/<binary>` using enhanced [Parrot templates](https://github.com/I-hate-farms/parrot) 

See Parrot [in action](http://i-hate-farms.github.io/parrot/)

## Package 

See how to package [for debian](packaging_for_debian.md)

## Run 

> ./hen run [binary] 

| name | option | description |
|--------|----------|------------------------------------------------------------------------------------------------------|
| binary | optional | the name of the binary to run. If left blank, the command runs the last binary that is not a library |
 
## Debug

> ./hen debug [binary] 

## Update 

## Force-update 

## 
