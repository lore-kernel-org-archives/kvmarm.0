From: vijay.kilari@gmail.com
Subject: [RFC PATCH v2 0/4] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Tue,  9 Aug 2016 16:28:42 +0530
Message-ID: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C91CF49B49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ifxoHGsY8VMF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 06:52:10 -0400 (EDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
 [209.85.220.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D792949B3B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:09 -0400 (EDT)
Received: by mail-pa0-f65.google.com with SMTP id hh10so788917pac.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 03:59:16 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
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

v1 => v2:
 - The init sequence change patch is no more required.
   Fixed in patch 2 by using static vgic_io_dev regions structure instead
   of using dynamic allocation pointer.
 - Updated commit message of patch 4.
 - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
   Used local variable for 32-bit access.
 - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in 
   arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.

Vijaya Kumar K (4):
  arm/arm64: vgic-new: Introduce 64-bit reg access support
  arm/arm64: vgic-new: Add distributor and redistributor access
  arm/arm64: vgic-new: Introduce find_reg_by_id()
  arm/arm64: vgic-new: Implement VGICv3 CPU interface access

 arch/arm64/include/uapi/asm/kvm.h   |  18 ++-
 arch/arm64/kvm/Makefile             |   1 +
 arch/arm64/kvm/sys_regs.c           |  22 ++--
 arch/arm64/kvm/sys_regs.h           |   4 +
 include/linux/irqchip/arm-gic-v3.h  |   4 +
 virt/kvm/arm/vgic/vgic-kvm-device.c | 138 +++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |   4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 119 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       |   2 +-
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 225 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  14 +++
 11 files changed, 525 insertions(+), 26 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-sys-reg-v3.c

-- 
1.9.1
