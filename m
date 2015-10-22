From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 0/6] VFIO platform reset module rework
Date: Thu, 22 Oct 2015 11:41:56 +0200
Message-ID: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes the current implementation by getting rid of the
usage of __symbol_get which caused a compilation issue with
CONFIG_MODULES disabled. On top of this, the usage of MODULE_ALIAS makes
possible to add a new reset module without being obliged to update the
framework. The new implementation relies on the reset module registering
its reset function to the vfio-platform driver.

The series is available at

https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc6-rework-v2

Best Regards

Eric

v1 -> v2:
* in vfio_platform_common.c:
  - move reset lookup at load time and put reset at release: this is to
    prevent a race between the 2 load module loads
  - reset_list becomes static
  - vfio_platform_register/unregister_reset take a const char * as compat
  - fix node link
  - remove old combo struct and cleanup proto of vfio_platform_get_reset
  - add mutex to protect the reset list
* in calxeda xgmac reset module
  - introduce vfio_platform_reset_private.h
  - use module_vfio_reset_handler macro
  - do not export vfio_platform_calxedaxgmac_reset symbol anymore
  - add a pr_info to show the device is reset by vfio reset module


Eric Auger (6):
  vfio: platform: add capability to register a reset function
  vfio: platform: reset: add vfio_platform_reset_private.h
  vfio: platform: reset: calxedaxgmac: add reset function registration
  vfio: platform: add compat in vfio_platform_device
  vfio: platform: use list of registered reset function
  vfio: platform: move get/put reset at open/release

 drivers/vfio/platform/reset/Makefile               |   2 +-
 .../platform/reset/vfio_platform_calxedaxgmac.c    |   9 +-
 .../platform/reset/vfio_platform_reset_private.h   |  66 +++++++++
 drivers/vfio/platform/vfio_platform_common.c       | 151 ++++++++++++++++-----
 drivers/vfio/platform/vfio_platform_private.h      |  15 +-
 5 files changed, 201 insertions(+), 42 deletions(-)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_reset_private.h

-- 
1.9.1
