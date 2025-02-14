ARCHS = arm64
TARGET := iphone:clang:latest:16.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = inputboxtextcolor

inputboxtextcolor_FILES = Tweak.xm
inputboxtextcolor_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
