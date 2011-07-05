ifdef ROS_ROOT
default: install
include $(shell rospack find mk)/cmake.mk
include $(shell rosstack find orocos_toolchain)/env.mk
EXTRA_CMAKE_FLAGS=-DCMAKE_INSTALL_PREFIX=`rosstack find orocos_toolchain`/install
install: all
	cd build; ${MAKE} install
else
$(warning This Makefile only works with ROS rosmake. Without rosmake, create a build directory and run cmake ..)
endif
