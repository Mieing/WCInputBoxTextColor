TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = test3

test3_FILES = Tweak.xm
test3_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
