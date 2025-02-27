# iPhone SDK 路径
SDK_PATH = ~/codes/github/theos/sdks/iPhoneOS15.6.sdk

# 直接输出到当前目录
export THEOS_PACKAGE_DIR = $(CURDIR)

# TARGET
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.5

# 引入 Theos 的通用设置
include $(THEOS)/makefiles/common.mk

# 设置 generator=internal
export LOGOS_DEFAULT_GENERATOR = internal

TWEAK_NAME = app-secure-lock

ApplicationLock_FILES = Tweak.x
ApplicationLock_CFLAGS = -fobjc-arc
ApplicationLock_LDFLAGS = -framework UIKit -framework Foundation

# Theos编译规则
include $(THEOS_MAKE_PATH)/tweak.mk
