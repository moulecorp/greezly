# Makefile for greezly targets

GR_PV := $(shell git tag --points-at HEAD | grep -o '[0-9]*')

export KBUILD_BUILD_USER = marvin
export KBUILD_BUILD_HOST = Heart_of_Gold

ifneq ($(GR_PV),)
	export KBUILD_BUILD_VERSION := $(GR_PV)
	export LOCALVERSION =
endif

quiet_cmd_builddeb = BUILDDEB
      cmd_builddeb =						\
	set -e;							\
	test `id -u` = 0					\
	|| test -n "$(ROOTCMD)"					\
	|| {							\
		which fakeroot > /dev/null 2>&1			\
		&& ROOTCMD="fakeroot -u";			\
	} || {							\
		echo;						\
		echo "Error: install fakeroot or set ROOTCMD";	\
		echo;						\
		false;						\
	} && $$ROOTCMD $(CONFIG_SHELL)				\
		$(srctree)/scripts/greezly/package/build-greezly-deb

greezly-deb: FORCE
	$(MAKE) KBUILD_SRC=
	$(call cmd,builddeb)

greezly-verify: FORCE
	$(Q) $(srctree)/scripts/greezly/verify.sh

help: FORCE
	@echo '  greezly-deb         - Build greezly .deb packages'
