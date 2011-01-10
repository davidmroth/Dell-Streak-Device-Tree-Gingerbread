LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
#----------------------------------------------------------------------
# Android makefile to build kernel as a part of Android Build
#----------------------------------------------------------------------
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/zImage
TARGET_PREBUILT_KERNEL_MODULE := $(KERNEL_OUT)/drivers/net/wireless/bcm4325/dhd.ko


ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
$(info Using uncompressed kernel)
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/piggy
else
TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_INT_KERNEL)
endif

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi- $(KERNEL_DEFCONFIG)

$(KERNEL_OUT)/piggy : $(TARGET_PREBUILT_INT_KERNEL)
	$(hide) gunzip -c $(KERNEL_OUT)/arch/arm/boot/compressed/piggy > $(KERNEL_OUT)/piggy

$(TARGET_PREBUILT_KERNEL_MODULE): $(TARGET_PREBUILT_INT_KERNEL)

$(TARGET_PREBUILT_INT_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi-
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi- modules

kerneltags: $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi- tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi- menuconfig
	cp $(KERNEL_OUT)/.config kernel/arch/arm/configs/$(KERNEL_DEFCONFIG)

else
    TARGET_PREBUILT_KERNEL := device/dell/streak/boot/kernel
    TARGET_PREBUILT_KERNEL_MODULE := device/dell/streak/boot/dhd.ko
endif

#----------------------------------------------------------------------
# Copy kenrel and module
#----------------------------------------------------------------------
$(PRODUCT_OUT)/kernel: $(TARGET_PREBUILT_KERNEL)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(TARGET_OUT_SHARED_LIBRARIES)/modules/dhd.ko
$(TARGET_OUT_SHARED_LIBRARIES)/modules/dhd.ko: $(TARGET_PREBUILT_KERNEL_MODULE)
	$(transform-prebuilt-to-target)

#----------------------------------------------------------------------
# Splash screen
#----------------------------------------------------------------------
ifneq ($(BUILD_TINY_ANDROID), true)

RGB2565 := $(HOST_OUT_EXECUTABLES)/rgb2565$(HOST_EXECUTABLE_SUFFIX)

ALL_PREBUILT += $(TARGET_ROOT_OUT)/initlogo.rle
$(TARGET_ROOT_OUT)/initlogo.rle: $(LOCAL_PATH)/boot/initlogo.png | $(RGB2565)
	mkdir -p $(TARGET_ROOT_OUT)
	convert -depth 8 $^ rgb:- | $(RGB2565) -rle > $@

 
#ALL_PREBUILT += $(PRODUCT_OUT)/splash.img
#$(PRODUCT_OUT)/splash.img: $(LOCAL_PATH)/initlogo.png | $(RGB2565)
#	convert -depth 8 $^ rgb:- | $(RGB2565) > $@

endif #end BUILD_TINY_ANDROID
