# Makefile for greezly targets

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
