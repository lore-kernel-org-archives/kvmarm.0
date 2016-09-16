From: vijay.kilari@gmail.com
Subject: [PATCH v5 0/6] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Fri, 16 Sep 2016 17:50:47 +0530
Message-ID: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33AD241390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:12:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IwywETpOdjKU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 08:12:22 -0400 (EDT)
Received: from mail-pa0-f67.google.com (mail-pa0-f67.google.com
 [209.85.220.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50CE9412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:12:22 -0400 (EDT)
Received: by mail-pa0-f67.google.com with SMTP id pp5so3438361pac.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 05:21:14 -0700 (PDT)
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

Compatible live migration QEMU patches will be sent later.

The patch 3 & 4 are picked from the Pavel's previous implementation.
http://www.spinics.net/lists/kvm/msg122040.html

v4 => v5:
 - ICC_CTLR_EL1 access is updated to reflect HW values
 - Updated ICC reg access mask and shift macros
 - Introduced patch 4 for VMCR changes
 - Other minor fixes.
v3 => v4:
 - Rebased to latest code base
 - Moved vgic_uaccess() from vgic-mmio-v2.c to vgic-mmio.c
 - Dropped macro REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED_UACCESS
 - Dropped LE conversion for userspace access
 - Introduced vgic_uaccess_write_pending() for ISPENDR write
 - Change macro KVM_DEV_ARM_VGIC_V3_CPUID_MASK to KVM_DEV_ARM_VGIC_V3_MIDR_MASK
 - Refactored some code as common code.
 - Changed handing of ICC_* registers
 - Allowed ICC_SRE_EL1 read by userspace
 - Fixed KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_* macros

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


Vijaya Kumar K (6):
  arm/arm64: vgic-new: Implement support for userspace access
  arm/arm64: vgic-new: Add distributor and redistributor access
  arm/arm64: vgic-new: Introduce find_reg_by_id()
  arm/arm64: vgic-new: Introduce VENG0 and VENG1 fields to vmcr struct
  arm/arm64: vgic-new: Implement VGICv3 CPU interface access
  arm/arm64: vgic-new: Implement KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl

 arch/arm64/include/uapi/asm/kvm.h   |  13 ++
 arch/arm64/kvm/Makefile             |   1 +
 arch/arm64/kvm/sys_regs.c           |  22 ++-
 arch/arm64/kvm/sys_regs.h           |   4 +
 include/linux/irqchip/arm-gic-v3.h  |  45 +++++-
 virt/kvm/arm/vgic/vgic-kvm-device.c | 226 +++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |  57 +------
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 199 +++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio.c       | 149 +++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio.h       |  28 ++++
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 296 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         |  10 +-
 virt/kvm/arm/vgic/vgic.h            |  23 +++
 13 files changed, 969 insertions(+), 104 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-sys-reg-v3.c

-- 
1.9.1
