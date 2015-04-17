From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 0/3] VFIO platform reset
Date: Fri, 17 Apr 2015 15:37:10 +0200
Message-ID: <1429277833-28663-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC514DE27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:32:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nQAceDLJpvnZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2015 09:32:06 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC50C4DDC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:32:05 -0400 (EDT)
Received: by wgso17 with SMTP id o17so113845943wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 06:40:02 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
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

This series adds VFIO platform reset support by specializing the vfio
platform driver for a given device, adding its HW reset modality. Generally
that code can be reused from the native driver. It basically deals with
IRQ disabling and DMA transfert stop.

It is still possible to use the generic VFIO platform driver, without
the reset modality. Here we introduce a new driver for Calxeda xgmac,
illustrating the mechanism. That code was tested on Calxeda Midway where
smmu aborts do not seem to be observed anymore.

Obviously the drawback of this approach is possible multiplication of
VFIO platform drivers. Other solution I envisionned was to put that vfio
reset function in the native driver and implement some enumeration
mechanism in the driver core but this looks very weird at the end, with the
a device somehow bound to 2 different platform drivers.

Any feedback welcome!

Best Regards

Eric

The series can be found at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/4.O_forward_and_reset

Also some user guidelines are available at
https://wiki.linaro.org/LEG/Engineering/Virtualization/Platform_Device_Passthrough_on_Midway

Eric Auger (3):
  VFIO: platform: add reset support
  VFIO: platform: export platform callbacks, probe and remove
  VFIO: platform: add vfio-platform-calxedaxgmac driver

 drivers/vfio/platform/Kconfig                      |   2 +
 drivers/vfio/platform/Makefile                     |   2 +
 drivers/vfio/platform/reset/Kconfig                |   7 ++
 drivers/vfio/platform/reset/Makefile               |   5 +
 .../platform/reset/vfio_platform_calxedaxgmac.c    | 109 +++++++++++++++++++++
 drivers/vfio/platform/vfio_platform.c              |  14 ++-
 drivers/vfio/platform/vfio_platform_common.c       |  12 ++-
 drivers/vfio/platform/vfio_platform_private.h      |   8 ++
 8 files changed, 152 insertions(+), 7 deletions(-)
 create mode 100644 drivers/vfio/platform/reset/Kconfig
 create mode 100644 drivers/vfio/platform/reset/Makefile
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c

-- 
1.9.1
