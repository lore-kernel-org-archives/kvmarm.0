From: vijay.kilari@gmail.com
Subject: [RFC PATCH v3 0/5] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Wed, 24 Aug 2016 16:50:04 +0530
Message-ID: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1CC40C9A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 07:12:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gi3EVIFp3m4a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 07:12:44 -0400 (EDT)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
 [209.85.192.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FC02407A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 07:12:43 -0400 (EDT)
Received: by mail-pf0-f195.google.com with SMTP id h186so1065732pfg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 04:20:32 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

This patchset adds API for saving and restoring
of VGICv3 registers to support live migration with new vgic feature.
This API definition is as per version of VGICv3 specification
http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html

To test live migration with QEMU, use below patch series
https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg01444.html

The patch 3 & 4 are picked from the Pavel's previous implementation.
http://www.spinics.net/lists/kvm/msg122040.html

v2 => v3:
 - Implemented separate API for ISPENDR and ICPENDR to
   read soft_pending instead of pending for level triggerred interrupts
 - Implemented ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO to access line level
 - Rebased on top of Christoffer's patch set
   http://www.spinics.net/lists/kvm/msg136840.html

 NOTE: GICD_STATUSR and GICR_STATUSR are implemented as RAZ/WI.

v1 => v2:
 - The init sequence change patch is no more required.
   Fixed in patch 2 by using static vgic_io_dev regions structure instead
   of using dynamic allocation pointer.
 - Updated commit message of patch 4.
 - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
   Used local variable for 32-bit access.
 - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in
   arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.

Vijaya Kumar K (5):
  arm/arm64: vgic-new: Implement support for userspace access
  arm/arm64: vgic-new: Add distributor and redistributor access
  arm/arm64: vgic-new: Introduce find_reg_by_id()
  arm/arm64: vgic-new: Implement VGICv3 CPU interface access
  arm/arm64: vgic-new: Implement KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl

 arch/arm64/include/uapi/asm/kvm.h   |  24 +++-
 arch/arm64/kvm/Makefile             |   1 +
 arch/arm64/kvm/sys_regs.c           |  22 ++--
 arch/arm64/kvm/sys_regs.h           |   4 +
 include/linux/irqchip/arm-gic-v3.h  |   4 +
 virt/kvm/arm/vgic/vgic-kvm-device.c | 198 ++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |   9 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 178 ++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c       | 123 +++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.h       |  31 ++++++
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 211 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  17 +++
 12 files changed, 789 insertions(+), 33 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-sys-reg-v3.c

-- 
1.9.1
