# SDK 14.5 still ships armv7 stubs, so one build can cover every slice.
# arm64 needs a deployment target of 7.0 or higher.
TARGET := iphone:clang:14.5:7.0

ARCHS = armv7 arm64 arm64e
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CydiaWebviewModifier

CydiaWebviewModifier_FILES = Tweak.x
CydiaWebviewModifier_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += CydiaWebviewModifierPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
