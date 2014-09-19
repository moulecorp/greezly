# Makefile for greezly targets

GR_PV := $(shell git tag --points-at HEAD | grep -o '[0-9]*')

export KBUILD_BUILD_USER = marvin
export KBUILD_BUILD_HOST = Heart_of_Gold

ifneq ($(GR_PV),)
	export KBUILD_BUILD_VERSION := $(GR_PV)
	export LOCALVERSION =
endif

cmd_check_fakeroot = set -e;						\
		     test `id -u` = 0					\
		     || test -n "$(ROOTCMD)"				\
		     || {						\
			 echo;						\
		         echo "Must be run as root or using fakeroot.";	\
			 echo;						\
			 false;						\
		        }

greezly-deb: FORCE
	$(call cmd,check_fakeroot)
	$(MAKE) KBUILD_SRC=
	$(ROOTCMD) $(CONFIG_SHELL)	\
		$(srctree)/scripts/greezly/package/build-greezly-deb

help: FORCE
	@echo '  greezly-deb         - Build greezly .deb packages'
