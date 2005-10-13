# $Revision: 1063 $
# $Id: lib.mk 1063 2005-10-13 08:46:17Z sjoyeux $

################ Build
build: $(MODULE)-build-lib

$(MODULE)_OBJS=	$(patsubst %.cc,%.lo,$($(MODULE)_SRC:%.c=%.lo))

################ Check if it is a convenience library or a plain one
ifeq ($($(MODULE)_VERSION),)
LIB_NAME ?= $(MODULE)
build_lib = lib$(LIB_NAME).la
install:
else
LIB_NAME ?= $(PACKAGE)_$(MODULE)
build_lib = lib$(LIB_NAME).la

$(MODULE)_ldoptions = -rpath $(libdir) -version-info $($(MODULE)_VERSION):$($(MODULE)_REVISION):$($(MODULE)_AGE)

install: $(libdir)/$(build_lib)
$(libdir)/$(build_lib): DESCRIPTION='Installing $(notdir $@) (libtool)'
$(libdir)/$(build_lib): $(build_lib)
	$(INSTALL_DIR) $(libdir)
	$(COMMAND_PREFIX)$(INSTALL_LIB) $(build_lib) $(libdir)
endif

$(MODULE)_LIB_DEPENDS=$(filter %.la,$($(MODULE)_LIBS))
ifneq ($($(MODULE)_LIB_DEPENDS),)
$($(MODULE)_LIB_DEPENDS): recurse-build
endif
recurse-build:

################ Link targets
$(MODULE)-build-lib: $(builddir)/$(build_lib)
$(build_lib): DESCRIPTION='Linking $@ (libtool)'
$(build_lib): $($(MODULE)_OBJS) $($(MODULE)_LIB_DEPENDS)
	$(COMMAND_PREFIX)$(LTLD) -o $@ $($(MODULE)_ldoptions) \
                $(LDFLAGS) $($(MODULE)_LDFLAGS) $($(MODULE)_LIBS) $(LIBS) \
                $($(MODULE)_OBJS)

include $(top_srcdir)/mk/compile.mk

################ Cleanup
clean: $(MODULE)-lib-clean
$(MODULE)-lib-clean: DESCRIPTION='Cleaning $(PWD) (libtool)'
$(MODULE)-lib-clean:
	-$(COMMAND_PREFIX)$(LTRM) $(build_lib) $($(MODULE)_OBJS)

################ Dependencies
DEP_SRC += $($(MODULE)_SRC)
DEP_CPPFLAGS += $($(MODULE)_CPPFLAGS)

ifneq ($(SUBDIRS),)
$(MODULE)-lib-clean: recurse-clean
$(MODULE)-lib-install: recurse-install
$(MODULE)-lib-distclean: recurse-distclean
$(MODULE)-lib-build: recurse-build
endif

