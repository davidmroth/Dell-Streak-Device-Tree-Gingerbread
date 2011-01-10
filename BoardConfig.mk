# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# BoardConfig.mk
#
# Product-specific compile-time definitions.
#

# Set this up here so that BoardVendorConfig.mk can override it
BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_LIBSECRIL_STUB := true
BOARD_NO_PAGE_FLIPPING := true

# Use the non-open-source parts, if they're present
-include vendor/dell/streak/BoardConfigVendor.mk

BOARD_HAVE_BLUETOOTH := false
BOARD_HAVE_BLUETOOTH_BCM := false

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true

TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_BOARD_PLATFORM := qsd8k
TARGET_BOOTLOADER_BOARD_NAME := qcom

BOARD_EGL_CFG := device/dell/streak/boot/egl.cfg

TARGET_SEC_INTERNAL_STORAGE := false

# Enable NEON feature
TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
ARCH_ARM_HAVE_TLS_REGISTER := true

ifeq ($(BOARD_USES_GENERIC_AUDIO),false)
BOARD_USES_ALSA_AUDIO := false
BUILD_WITH_ALSA_UTILS := false
endif

USE_CAMERA_STUB := true
ifeq ($(USE_CAMERA_STUB),false)
BOARD_CAMERA_LIBRARIES := libcamera
endif

BOARD_KERNEL_BASE := 0x20000000
BOARD_KERNEL_CMDLINE := console=ttyDCC0 androidboot.hardware=qcom
#BOARD_KERNEL_CMDLINE := no_console_suspend=1 console=null androidboot.hardware=qcom


#~ # cat /proc/mtd 
#dev:    size   erasesize  name 
#mtd0: 00500000 00020000 "boot" 
#mtd1: 00600000 00020000 "recovery" 
#mtd2: 00600000 00020000 "recovery_bak" 
#mtd3: 00040000 00020000 "LogFilter" 
#mtd4: 00300000 00020000 "oem_log" 
#mtd5: 00100000 00020000 "splash" 
#mtd6: 10400000 00020000 "system" 
#mtd7: 08c00000 00020000 "userdata"

#TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 272629760
BOARD_USERDATAIMAGE_PARTITION_SIZE := 146800640
BOARD_BOOTIMAGE_PARTITION_SIZE := 5242880
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 6291456
BOARD_FLASH_BLOCK_SIZE := 131072

# Connectivity - Wi-Fi
WPA_SUPPLICANT_VERSION := VER_0_6_X
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
BOARD_WLAN_DEVICE           := dhd
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/dhd.ko"
WIFI_DRIVER_FW_STA_PATH     := "/vendor/firmware/wlan/sdio-g-cdc-reclaim-idsup-wme-pktfilter-keepalive-aoe-toe-ccx-wapi.bin"
WIFI_DRIVER_FW_AP_PATH      := "/vendor/firmware/wlan/fw_bcm4325_apsta.bin"
WIFI_DRIVER_MODULE_ARG      :=  "firmware_path=/vendor/firmware/wlan/sdio-g-cdc-reclaim-idsup-wme-pktfilter-keepalive-aoe-toe-ccx-wapi.bin nvram_path=/vendor/firmware/wlan/nvram.txt"
WIFI_DRIVER_MODULE_NAME     :=  "dhd"

WITH_JIT := true
ENABLE_JSC_JIT := true
