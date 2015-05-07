From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/5] VFIO platform reset
Date: Thu,  7 May 2015 16:27:18 +0200
Message-ID: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, agraf@suse.de, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

In situations where the userspace driver is stopped abnormally and the
VFIO platform device is released, the assigned HW device currently is
left running. As a consequence the HW device might continue issuing IRQs
and performing DMA accesses.

On release, no physical IRQ handler is setup anymore. Also the DMA buffers
are unmapped leading to IOMMU aborts. So there is no serious consequence.

However when assigning that HW device again to another userspace driver,
this latter might face some unexpected IRQs and DMA accesses, which are
the result of the previous assignment.

In virtualization use-case, a VM newly granted with that HW device may be
impacted by the assignment of that device to a previous VM:
- IRQs may be injected very early when booting the new guest, even before
  the guest driver has initialized leading to possible driver state
  inconsistency.
- DMA accesses may hit the newly mapped VM address space at addresses that
  may jeopardize the integrity of the newly installed VM.

Obviously the criticity depends on the assigned HW devcie.

As opposed to PCI, there is no standard mechanism to reset the platform
device.

This series proposes to implement device specific reset functions in
separate vfio modules (in-kernel or external). The reset module only
registers/unregisters a reset function to the vfio platform driver using
a dedicated API, paired with the device compatibility string.

The platform driver then look for the reset function that matches the
compatibility string of the device. In case of match the device specific
reset can be applied on release and on VFIO_DEVICE_GET_INFO and
VFIO_DEVICE_RESET ioctls.

A first reset module is provided: the vfio-platform-calxedaxgmac
module. It implements a basic reset for the Calxeda xgmac.

Amba device reset is not tested.

Best Regards

Eric

The series can be found at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-rc2-reset

RFC -> PATCH v1:
- solution now based on a lookup list instead of specialized driver


Eric Auger (5):
  VFIO: platform: add reset_list and register/unregister functions
  VFIO: platform: add get_device callback
  VFIO: platform: add reset callback
  VFIO: platform: populate reset function according to compat
  VFIO: platform: VFIO platform Calxeda xgmac reset module

 drivers/vfio/platform/Kconfig                      |   2 +
 drivers/vfio/platform/Makefile                     |   2 +
 drivers/vfio/platform/reset/Kconfig                |   7 ++
 drivers/vfio/platform/reset/Makefile               |   5 +
 .../platform/reset/vfio_platform_calxedaxgmac.c    | 121 ++++++++++++++++++++
 drivers/vfio/platform/vfio_amba.c                  |   9 ++
 drivers/vfio/platform/vfio_platform.c              |  10 ++
 drivers/vfio/platform/vfio_platform_common.c       | 125 ++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h      |  15 +++
 9 files changed, 294 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/platform/reset/Kconfig
 create mode 100644 drivers/vfio/platform/reset/Makefile
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c

-- 
1.9.1
