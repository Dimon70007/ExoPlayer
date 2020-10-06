#
# Copyright (C) 2016 The Android Open Source Project
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
#

LOCAL_PATH := $(call my-dir)

MY_FFMPEG_PATH := $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)
LOCAL_EXPORT_LDLIBS :=
LOCAL_EXPORT_C_INCLUDES :=
include $(CLEAR_VARS)
MY_LIB_NAME := swresample
LOCAL_MODULE := lib$(MY_LIB_NAME)
LOCAL_SRC_FILES := $(MY_FFMPEG_PATH)/lib/$(LOCAL_MODULE).so
LOCAL_EXPORT_C_INCLUDES := $(MY_FFMPEG_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
MY_LIB_NAME := avutil
LOCAL_MODULE := lib$(MY_LIB_NAME)
LOCAL_SRC_FILES := $(MY_FFMPEG_PATH)/lib/$(LOCAL_MODULE).so
LOCAL_EXPORT_C_INCLUDES := $(MY_FFMPEG_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
MY_LIB_NAME := avcodec
LOCAL_MODULE := lib$(MY_LIB_NAME)
LOCAL_SRC_FILES := $(MY_FFMPEG_PATH)/lib/$(LOCAL_MODULE).so
LOCAL_EXPORT_C_INCLUDES := $(MY_FFMPEG_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

# include $(CLEAR_VARS)
# LOCAL_MODULE    := libavcodec
# LOCAL_SRC_FILES := $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/lib/$(LOCAL_MODULE).so
# LOCAL_C_INCLUDES:= $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/include
# include $(PREBUILT_SHARED_LIBRARY)
# 
# include $(CLEAR_VARS)
# LOCAL_MODULE    := libswresample
# LOCAL_SRC_FILES := $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/lib/$(LOCAL_MODULE).so
# LOCAL_C_INCLUDES:= $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/include
# include $(PREBUILT_SHARED_LIBRARY)
# 
# include $(CLEAR_VARS)
# LOCAL_MODULE    := libavutil
# LOCAL_SRC_FILES := $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/lib/$(LOCAL_MODULE).so
# LOCAL_C_INCLUDES:= $(LOCAL_PATH)/ffmpeg/android-libs/$(TARGET_ARCH_ABI)/include
# include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ffmpeg_jni
LOCAL_SRC_FILES := ffmpeg_jni.cc
LOCAL_SHARED_LIBRARIES := libavcodec libswresample libavutil
LOCAL_LDLIBS := -llog -landroid
include $(BUILD_SHARED_LIBRARY)