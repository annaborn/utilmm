# $Revision: 1284 $
# $Id: test.mk 1284 2006-01-20 09:37:27Z sjoyeux $

ifneq (1,$(HAS_TEST_SUPPORT))
    $(error Test support not enabled)
endif

ifneq (,$(UNIT_TEST))
    TEST_SUITE=$(UNIT_TEST)
    TEST_LIB=boost_unit_test_framework
else
    $(error Unknown test mode)
endif

APP_NAME=test_$(TEST_SUITE)
APP_SRC=$(notdir $(wildcard $(srcdir)/*.cc $(srcdir)/*.c))
APP_CPPFLAGS = $($(TEST_SUITE)_CPPFLAGS) $(CLBS_TEST_CPPFLAGS)
APP_CXXFLAGS = $($(TEST_SUITE)_CXXFLAGS)
APP_CFLAGS = $($(TEST_SUITE)_CFLAGS)
APP_LDFLAGS = $($(TEST_SUITE)_LDFLAGS) $(CLBS_TEST_LDFLAGS) -l$(TEST_LIB)
APP_LIBS = $($(TEST_SUITE)_LIBS)

TEST_RUN_DIR ?= $(builddir)

test: boost-test
boost-test:
	test_abs_path=$(CURDIR)/$(builddir)/$(APP_NAME) && cd $(TEST_RUN_DIR) && $$test_abs_path

include $(top_srcdir)/mk/app.mk

