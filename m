From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 0/6] KVM/ARM Fixes for v4.12-rc5 - Take 2
Date: Wed,  7 Jun 2017 19:11:46 +0200
Message-ID: <20170607171152.21874-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim and Paolo,

Six additional fixes for KVM/ARM for v4.12 (instead of only the first
three in the first version of this pull request).

The changes are:
 - Fix an issue with migrating GICv2 VMs on GICv3 systems.
 - Squashed a bug for gicv3 when figuring out preemption levels.
 - Fix a potential null pointer derefence in KVM happening under memory
   pressure.
 - Maintain RES1 bits in the SCTLR_EL2 to make sure KVM works on new
   architecture revisions.
 - Allow unaligned accesses at EL2/HYP

The following changes since commit fa472fa91a5a0b241f5ddae927d2e235d07545df:

  KVM: arm/arm64: Hold slots_lock when unregistering kvm io bus devices (2017-05-18 11:18:16 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.12-rc5-take2

for you to fetch changes up to 33b5c38852b29736f3b472dd095c9a18ec22746f:

  arm: KVM: Allow unaligned accesses at HYP (2017-06-06 22:20:02 +0200)

Thanks,
-Christoffer

---
Christoffer Dall (2):
      KVM: arm/arm64: Fix isues with GICv2 on GICv3 migration
      KVM: arm/arm64: vgic-v3: Fix nr_pre_bits bitfield extraction

Marc Zyngier (4):
      KVM: arm/arm64: Handle possible NULL stage2 pud when ageing pages
      arm64: KVM: Preserve RES1 bits in SCTLR_EL2
      arm64: KVM: Allow unaligned accesses at EL2
      arm: KVM: Allow unaligned accesses at HYP

 arch/arm/kvm/init.S                |  5 ++--
 arch/arm64/include/asm/sysreg.h    |  4 ++++
 arch/arm64/kvm/hyp-init.S          | 11 +++++----
 arch/arm64/kvm/vgic-sys-reg-v3.c   | 10 ++++----
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 include/linux/irqchip/arm-gic.h    | 28 ++++++++++++++++++++---
 virt/kvm/arm/hyp/vgic-v3-sr.c      |  2 +-
 virt/kvm/arm/mmu.c                 |  3 +++
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 +++++++++++--
 virt/kvm/arm/vgic/vgic-v2.c        | 28 ++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c        | 47 ++++++++++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic.h           | 12 ++++++----
 12 files changed, 131 insertions(+), 39 deletions(-)
