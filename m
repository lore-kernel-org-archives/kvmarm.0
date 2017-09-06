From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 0/5] Handle forwarded level-triggered interrupts
Date: Wed,  6 Sep 2017 14:26:07 +0200
Message-ID: <20170906122612.18050-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series illustrates an alternative approach to Eric Auger's direct EOI
setup patches [1] in terms of the KVM VGIC support.

The idea is to maintain existing semantics for the VGIC for mapped
level-triggered IRQs and think support for the timer into it.

Patch 1 is necessary to align the timer and VFIO ways of signaling the
VGIC.  Patch 2 is stolen from Eric's series and is necessary for these
patches to compile as well.  Patch 3 includes the core support for
mapped level-triggered interrupts.  Patch 4 handles guest MMIO access to
the virtual distributor.  Patch 5 moves some code around for patch 6.
Patch 6 implements an optimization for the timer.  The last two patches
could be deferred until the timer optimization series.

Based on v4.13

Changes since v2:
 - Removed patch 5 from v2 and integrating the changes in what's now
   patch 5 to make it easier to reuse code when adding VFIO integration.
 - Changed the virtual distributor MMIO handling to use the
   pending_latch and more closely match the semantics of SPENDR and
   CPENDR for both level and edge mapped interrupts.

Changes since v1:
 - Added necessary changes to the timer (Patch 1)
 - Added handling of guest MMIO accesses to the virtual distributor
   (Patch 4)
 - Addressed Marc's comments from the initial RFC (mostly renames)

Thanks,
-Christoffer

---

Christoffer Dall (4):
  KVM: arm/arm64: Don't cache the timer IRQ level
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
  KVM: arm/arm64: Provide a vgic interrupt line level sample function

Eric Auger (1):
  KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq

 include/kvm/arm_vgic.h        | 19 +++++++--
 virt/kvm/arm/arch_timer.c     | 52 +++++++++++------------
 virt/kvm/arm/vgic/vgic-mmio.c | 33 +++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   | 29 +++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   | 29 +++++++++++++
 virt/kvm/arm/vgic/vgic.c      | 96 ++++++++++++++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic.h      |  8 ++++
 7 files changed, 219 insertions(+), 47 deletions(-)

-- 
2.9.0
