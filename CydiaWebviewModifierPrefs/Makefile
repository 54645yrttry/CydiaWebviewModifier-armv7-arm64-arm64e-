# Must match the architectures of the main tweak, otherwise Settings
# cannot load the bundle on 64-bit devices.
TARGET := iphone:clang:14.5:7.0

ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CydiaWebviewModifierPrefs

CydiaWebviewModifierPrefs_FILES = CWMRootListController.m
CydiaWebviewModifierPrefs_FRAMEWORKS = UIKit
CydiaWebviewModifierPrefs_PRIVATE_FRAMEWORKS = Preferences
CydiaWebviewModifierPrefs_INSTALL_PATH = /Library/PreferenceBundles
CydiaWebviewModifierPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
