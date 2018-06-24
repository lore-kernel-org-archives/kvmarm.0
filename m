From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 0/4] KVM: arm/arm64: vgic: Virtual interrupt grouping support
Date: Mon, 25 Jun 2018 00:10:59 +0200
Message-ID: <20180624221103.15055-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F0B4A0DC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Jun 2018 17:59:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4GdDpz40Wkhj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 24 Jun 2018 17:59:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9363C4048A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Jun 2018 17:59:17 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This small series addresses a peculiarity of the current VGIC
implementation, namely that we don't support interrupt grouping.

KVM either implements a GICv2 without support for the security
extensions, or a GICv3 with DS=1.  For GICv2, on systems without the
security extensions, group 0 interrupts can be configured to be either
signalled as FIQs or as IRQs by the VM, whereas group 1 interrupts are
always IRQs.  For GICv3, with DS=1, group 1 interrupts are always IRQs
and group 0 interrupts are always FIQs, and there is no concept of
secure vs. non-secure group 1 interrupts when DS=1.

We were treating all interrupts on GICv2 as group 0, but yet telling the
geust that they were group 1.  The first patch changes this behavior,
which seems to have no effect on no known guests, but still.

The remaining patches introduce proper interrupt grouping support, along
with MMIO accessors for the VM and userspace to retrieve and set the
which group SGIs, PPIs, and SPIs belong to.  LPIs are always group 1
interrupts as per the architecture, and there is no way to modify this
configuration (no IGROUPR registers for LPIs or equivalent ITS
commands).

Lightly tested on Seattle, TX1, and the foundation model.  I've run a
GICv2 guest on a GICv3 host on the foundation model.

Applies to v4.18-rc1.

Christoffer Dall (4):
  KVM: arm/arm64: GICv2 IGROUPR should read as zero
  KVM: arm/arm64: vgic: Add group field to struct irq
  KVM: arm/arm64: Signal IRQs using their configured group
  KVM: arm/arm64: vgic: Allow VMs to configure interrupt groups

 include/kvm/arm_vgic.h           |  1 +
 include/linux/irqchip/arm-gic.h  |  1 +
 virt/kvm/arm/vgic/vgic-debug.c   |  8 ++++---
 virt/kvm/arm/vgic/vgic-init.c    | 11 +++++++--
 virt/kvm/arm/vgic/vgic-its.c     |  1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  2 +-
 virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  6 +++++
 virt/kvm/arm/vgic/vgic-v2.c      |  3 +++
 virt/kvm/arm/vgic/vgic-v3.c      |  6 +----
 11 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.17.1
