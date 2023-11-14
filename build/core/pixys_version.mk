# Copyright (C) 2018 The PixysOS Project
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

PIXYS_MOD_VERSION = v7.2.2

ifndef PIXYS_BUILD_TYPE
PIXYS_BUILD_TYPE := UNOFFICIAL

endif

ifeq ($(PIXYS_BUILD_TYPE), OFFICIAL)

PRODUCT_PACKAGES += \
   OpenDelta
endif

TARGET_PRODUCT_SHORT := $(subst pixysos_,,$(PIXYS_BUILD))

# Gapps by default
BUILD_WITH_GAPPS ?= true
ifeq ($(BUILD_WITH_GAPPS),true)
$(call inherit-product, vendor/gms/products/gms.mk)
$(call inherit-product, vendor/pixys/config/pixel-rro_overlays.mk)
PIXYS_EDITION := GAPPS
else
PIXYS_EDITION := VANILLA
endif

PIXYS_BUILD_DATETIME := $(shell date +%s)
PIXYS_BUILD_DATE := $(shell date -d @$(PIXYS_BUILD_DATETIME) +"%Y%m%d-%H%M%S")
PIXYS_VERSION := PixysOS-$(PIXYS_MOD_VERSION)-$(PIXYS_EDITION)-$(PIXYS_BUILD)-$(PIXYS_BUILD_TYPE)-$(PIXYS_BUILD_DATE)
PIXYS_FINGERPRINT := PixysOS/$(PIXYS_MOD_VERSION)/$(PIXYS_EDITION)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(PIXYS_BUILD_DATE)
PIXYS_DISPLAY_VERSION := $(PIXYS_MOD_VERSION)-$(PIXYS_EDITION)-$(PIXYS_BUILD)-$(PIXYS_BUILD_TYPE)-$(PIXYS_BUILD_DATE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.pixys.version=$(PIXYS_VERSION) \
  ro.pixys.releasetype=$(PIXYS_BUILD_TYPE) \
  ro.modversion=$(PIXYS_MOD_VERSION) \
  ro.pixys.build.date=$(PIXYS_BUILD_DATETIME)\
  ro.pixys.display.version=$(PIXYS_DISPLAY_VERSION) \
  ro.pixys.fingerprint=$(PIXYS_FINGERPRINT)\
  ro.pixys.edition=$(PIXYS_EDITION)\

# Signing
ifeq (user,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/pixys/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/pixys/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/pixys/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/pixys/signing/keys/otakey.x509.pem
endif
endif
