From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v5 0/8] Handle forwarded level-triggered interrupts
Date: Mon, 20 Nov 2017 20:16:41 +0100
Message-ID: <20171120191649.17290-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series illustrates an alternative approach to Eric Auger's direct
EOI setup patches [1] in terms of the KVM VGIC support.

The idea is to maintain existing semantics for the VGIC for mapped
level-triggered IRQs and also support the timer using mapped IRQs with
the same VGIC support as VFIO interrupts.

Based on kvm-arm-gicv4-for-v4.15 (latest pull request of KVM/ARM changes
to the KVM tree).

Also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git level-mapped-v5

(Apologies for sending this out during the merge window, but I've been
sitting on these for a while, and the VHE optimization patches have
gotten a fair amount of review lately, and I'd like to base the next
version on these patches.)

Changes since v4:
 - Rebased on the timer optimization series merged in the v4.15 merge
   window, which caused a fair amount of modifications to patch 3.
 - Added a static key to disable the sync operations when no VMs are
   using userspace irqchips to further optimize the performance
 - Fixed extra semicolon in vgic-mmio.c
 - Added commentary as requested during review
 - Dropped what was patch 4, because it was merged as part of GICv4
   support.
 - Factored out the VGIC input level function change as separate patch
   (helps bisect and debugging), before providing a function for the
   timer.

Changes since v3:
 - Added a number of patches and moved patches around a bit.
 - Check for uaccesses in the mmio handler functions
 - Fixed bugs in the mmio handler functions

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

Christoffer Dall (8):
  KVM: arm/arm64: Remove redundant preemptible checks
  KVM: arm/arm64: Factor out functionality to get vgic mmio
    requester_vcpu
  KVM: arm/arm64: Don't cache the timer IRQ level
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Support a vgic interrupt line level sample function
  KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
  KVM: arm/arm64: Provide a get_input_level for the arch timer
  KVM: arm/arm64: Avoid work when userspace iqchips are not used

 include/kvm/arm_arch_timer.h  |   2 +
 include/kvm/arm_vgic.h        |  13 ++++-
 virt/kvm/arm/arch_timer.c     | 106 ++++++++++++++++++++++-----------------
 virt/kvm/arm/arm.c            |   2 -
 virt/kvm/arm/vgic/vgic-mmio.c | 114 ++++++++++++++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic-v2.c   |  29 +++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   |  29 +++++++++++
 virt/kvm/arm/vgic/vgic.c      |  42 ++++++++++++++--
 virt/kvm/arm/vgic/vgic.h      |   8 +++
 9 files changed, 270 insertions(+), 75 deletions(-)

-- 
2.14.2
