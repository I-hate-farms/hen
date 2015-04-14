#!/usr/bin/make -f
# -*- makefile -*-
# Sample debian/rules that uses debhelper.


# Uncomment this to turn on verbose mode.
#export DH_VERBOSE=1

%:
	dh $@

override_dh_strip:
	dh_strip --dbg-package=@ARGS_BINARY_NAME@-dbg

override_dh_auto_install:
	dh_auto_install --destdir=debian/@ARGS_BINARY_NAME@

override_dh_builddeb:
	dh_builddeb -- -Zxz
