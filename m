From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 0/7] Handle forwarded level-triggered interrupts
Date: Fri, 15 Sep 2017 15:19:47 -0700
Message-ID: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

This series illustrates an alternative approach to Eric Auger's direct EOI
setup patches [1] in terms of the KVM VGIC support.

The idea is to maintain existing semantics for the VGIC for mapped
level-triggered IRQs and also support the timer using mapped IRQs with
the same VGIC support as VFIO interrupts.

Based on v4.13

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


Christoffer Dall (6):
  KVM: arm/arm64: Remove redundant preemptible checks
  KVM: arm/arm64: Factor out functionality to get vgic mmio
    requester_vcpu
  KVM: arm/arm64: Don't cache the timer IRQ level
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Provide a vgic interrupt line level sample function
  KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs

Eric Auger (1):
  KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq

 include/kvm/arm_arch_timer.h  |   2 +
 include/kvm/arm_vgic.h        |  19 +++++--
 virt/kvm/arm/arch_timer.c     |  52 ++++++++----------
 virt/kvm/arm/arm.c            |   2 -
 virt/kvm/arm/vgic/vgic-mmio.c | 122 +++++++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic-v2.c   |  29 ++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   |  29 ++++++++++
 virt/kvm/arm/vgic/vgic.c      |  96 +++++++++++++++++++++++++++------
 virt/kvm/arm/vgic/vgic.h      |   8 +++
 9 files changed, 286 insertions(+), 73 deletions(-)

-- 
2.7.4
