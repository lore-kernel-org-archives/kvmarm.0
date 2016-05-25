From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/7] vgic fixes for 4.7-rc1
Date: Wed, 25 May 2016 15:26:32 +0100
Message-ID: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The dust has not yet settled on the new vgic, but here's the first
batch of fixes anyway!

The first two patches are courtesy of Christoffer, who noticed that we
fail to clear LRs that generate a maintenance interrupt, leading to
potential screaming interrupts. This bug already exists in the current
mainline (cc stable?)

The next two address a bug where we fail to properly resample the line
level on exit, which could result in spurious interrupts being
injected. This is specific to the new vgic implementation.

The following two patches tighten our GICv3 emulation by preventing
the guest from changing the SRE setting. This bug already exists in
mainline, though it is hardly critical.

The last patch is actually a performance optimization: if the guest is
using GICv3, we can drop a number of barriers (since we don't need to
change SRE, and there is no memory-mapped view to synchronize
with). This results in a world switch that is 2.5% faster on my LS2085
box when running GICv3 guests. I suspect that the bigger the box, the
bigger this impact this change will have (system-wide DSBs don't really
come cheap).

These patches have been tested on top of the kvmarm/next branch.

Thanks,

	M.

- From v1: Fix pending bit regeneration by adding the soft_pending bit
  to the mix.

Christoffer Dall (2):
  KVM: arm/arm64: vgic-v2: Clear all dirty LRs
  KVM: arm/arm64: vgic-v3: Clear all dirty LRs

Marc Zyngier (5):
  KVM: arm/arm64: vgic-v2: Always resample level interrupts
  KVM: arm/arm64: vgic-v3: Always resample level interrupts
  arm64: KVM: Make ICC_SRE_EL1 access return the configured SRE value
  arm64: KVM: vgic-v3: Prevent the guest from messing with ICC_SRE_EL1
  arm64: KVM: vgic-v3: Relax synchronization when SRE==1

 arch/arm64/kvm/hyp/vgic-v3-sr.c | 36 +++++++++++++++++++++---------------
 arch/arm64/kvm/sys_regs.c       | 13 ++++++++++++-
 virt/kvm/arm/hyp/vgic-v2-sr.c   |  7 +++----
 virt/kvm/arm/vgic/vgic-v2.c     | 14 +++++++++-----
 virt/kvm/arm/vgic/vgic-v3.c     | 14 +++++++++-----
 5 files changed, 54 insertions(+), 30 deletions(-)

-- 
2.1.4

