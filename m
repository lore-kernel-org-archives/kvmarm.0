From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 0/9] KVM: arm/arm64: vgic: Virtual interrupt grouping
 support
Date: Sat, 14 Jul 2018 19:05:31 +0200
Message-ID: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1FDC4A10C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yu7Bk+utgHdP for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:04 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02hn0232.outbound.protection.outlook.com [104.47.6.232])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 098E24A0ED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:03 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This series addresses a peculiarity of the current VGIC
implementation, namely that we don't support interrupt grouping.

KVM either implements a GICv2 without support for the security
extensions, or a GICv3 with DS=1.  For GICv2, on systems without the
security extensions, group 0 interrupts can be configured to be either
signalled as FIQs or as IRQs by the VM, whereas group 1 interrupts are
always IRQs.  For GICv3, with DS=1, group 1 interrupts are always IRQs
and group 0 interrupts are always FIQs, and there is no concept of
secure vs. non-secure group 1 interrupts when DS=1.

We were treating all interrupts on GICv2 as group 0, but yet telling the
guest that they were group 1.  The first patch changes this behavior,
which seems to have no effect on no known guests, but still.

The remaining patches introduce proper interrupt grouping support, along
with MMIO accessors for the VM and userspace to retrieve and set the
which group SGIs, PPIs, and SPIs belong to.  LPIs are always group 1
interrupts as per the architecture, and there is no way to modify this
configuration (no IGROUPR registers for LPIs or equivalent ITS
commands).

Tested on Seattle, TX1, and the foundation model.  I've run a
GICv2 guest on a GICv3 host on the foundation model.  I've tested
migration on Seattle, and migration from an old kernel to a newer kernel
with an unmodified QEMU binary continues to work.  I also tested a
modified userspace that sets some interrupts to group 1, and that is
reflected in the vgic debug output.

Applies to v4.18-rc3.

Changes since v2:
 - Patch 6 doesn't allow configuraiton of groups from userspace for
   GICv2.
 - Patches 7 through 9 are new in v3 of this series, and prevents
   userspace from restoring an incompatible IIDR without seeing an error
   in the future, and supports legacy userspace migration from old to
   new kernels.

Changes since v1:
 - Bumped implementation revision field in GICD_IIDR along with changes
 - Changed logic in init code to correctly detect vgic emulation type
 - Rebased to v4.18-rc3

Christoffer Dall (9):
  KVM: arm/arm64: vgic: Define GICD_IIDR fields for GICv2 and GIv3
  KVM: arm/arm64: vgic: Keep track of implementation revision
  KVM: arm/arm64: vgic: GICv2 IGROUPR should read as zero
  KVM: arm/arm64: vgic: Add group field to struct irq
  KVM: arm/arm64: vgic: Signal IRQs using their configured group
  KVM: arm/arm64: vgic: Allow configuration of interrupt groups
  KVM: arm/arm64: vgic: Permit uaccess writes to return errors
  KVM: arm/arm64: vgic: Let userspace opt-in to writable v2 IGROUPR
  KVM: arm/arm64: vgic: Update documentation of the GICv2 device

 Documentation/virtual/kvm/devices/arm-vgic.txt | 12 +++---
 include/kvm/arm_vgic.h                         |  7 +++
 include/linux/irqchip/arm-gic-v3.h             | 10 +++++
 include/linux/irqchip/arm-gic.h                | 11 +++++
 virt/kvm/arm/vgic/vgic-debug.c                 |  8 ++--
 virt/kvm/arm/vgic/vgic-init.c                  | 20 ++++++++-
 virt/kvm/arm/vgic/vgic-its.c                   |  1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 60 +++++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c               | 51 ++++++++++++++++------
 virt/kvm/arm/vgic/vgic-mmio.c                  | 56 +++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio.h                  | 25 +++++++----
 virt/kvm/arm/vgic/vgic-v2.c                    |  3 ++
 virt/kvm/arm/vgic/vgic-v3.c                    |  6 +--
 13 files changed, 223 insertions(+), 47 deletions(-)

--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
