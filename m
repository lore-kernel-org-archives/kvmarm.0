From: vijay.kilari@gmail.com
Subject: [RFC PATCH v1 0/4] arm/arm64: vgic-new: Implement API for vGICv3 live
 migration
Date: Wed, 20 Jul 2016 18:32:24 +0530
Message-ID: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E67949B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XhCiPF5LW9A1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 08:56:31 -0400 (EDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
 [209.85.220.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4D20499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:31 -0400 (EDT)
Received: by mail-pa0-f68.google.com with SMTP id hh10so3343848pac.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 06:02:42 -0700 (PDT)
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
This API definition is as per draft version of VGICv3 specification
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-May/020355.html

To test live migration with QEMU, the QEMU patches will
be posted soon.

The patch 3 & 4 are picked from the Pavel's previous implementation.
http://www.spinics.net/lists/kvm/msg122040.html

Vijaya Kumar K (4):
  arm/arm64: vgic-new: Introduce 64-bit reg access support
  arm/arm64: vgic-new: Add distributor and redistributor access
  arm/arm64: vgic-new: Introduce find_reg_by_id()
  arm/arm64: vgic-new: Implement VGICv3 CPU interface access

 arch/arm64/include/uapi/asm/kvm.h   |   12 ++
 arch/arm64/kvm/Makefile             |    1 +
 arch/arm64/kvm/sys_regs.c           |   22 ++--
 arch/arm64/kvm/sys_regs.h           |    4 +
 include/linux/irqchip/arm-gic-v3.h  |    4 +
 virt/kvm/arm/vgic/vgic-kvm-device.c |  120 +++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |    4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  111 +++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       |    2 +-
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c |  225 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |   14 +++
 11 files changed, 497 insertions(+), 22 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-sys-reg-v3.c

-- 
1.7.9.5
