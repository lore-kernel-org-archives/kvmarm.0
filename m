From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/12] KVM/ARM Fixes for v4.8-rc3
Date: Wed, 17 Aug 2016 21:38:47 +0200
Message-ID: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here's a set of KVM/ARM fixes for v4.8-rc3 or as soon as you can make
it.  They address:
 - ITS init issues
 - ITS error handling issues
 - ITS IRQ leakage fix
 - Plug a couple of ITS race conditions
 - An erratum workaround for timers
 - Some removal of misleading use of errors and comments
 - A fix for GICv3 on 32-bit guests

Note that the patch previously submitted 'KVM: arm64: vgic-its: Grab
kvm->lock when reading kvm->devices', was dropped from this series
because we were already holding the kvm->lock in the call path to the
ITS code.

The following changes since commit 29b4817d4018df78086157ea3a55c1d9424a7cfc:

  Linux 4.8-rc1 (2016-08-07 18:18:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.8-rc3

for you to fetch changes up to f7f6f2d94f0027242ddfd665289b107a873fde43:

  arm64: KVM: report configured SRE value to 32-bit world (2016-08-17 12:46:23 +0200)

Thanks,
-Christoffer

----------------------------------------------------------------
Andre Przywara (4):
      KVM: arm64: ITS: return 1 on successful MSI injection
      KVM: arm64: ITS: move ITS registration into first VCPU run
      KVM: arm64: check for ITS device on MSI injection
      KVM: arm64: ITS: avoid re-mapping LPIs

Christoffer Dall (4):
      KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
      KVM: arm64: vgic-its: Plug race in vgic_put_irq
      KVM: arm64: vgic-its: Make updates to propbaser/pendbaser atomic
      KVM: arm/arm64: Change misleading use of is_error_pfn

Marc Zyngier (2):
      arm64: Document workaround for Cortex-A72 erratum #853709
      KVM: arm/arm64: timer: Workaround misconfigured timer interrupt

Vladimir Murzin (2):
      arm64: KVM: remove misleading comment on pmu status
      arm64: KVM: report configured SRE value to 32-bit world

 Documentation/arm64/silicon-errata.txt |   1 +
 arch/arm/kvm/mmu.c                     |   2 +-
 arch/arm64/kvm/hyp/switch.c            |   2 +-
 arch/arm64/kvm/sys_regs.c              |  10 +--
 include/linux/irqchip/arm-gic-v3.h     |   1 +
 virt/kvm/arm/arch_timer.c              |  11 ++-
 virt/kvm/arm/vgic/vgic-its.c           | 158 ++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic-mmio-v3.c       |  26 +++---
 virt/kvm/arm/vgic/vgic-v3.c            |   8 ++
 virt/kvm/arm/vgic/vgic.c               |  10 +--
 virt/kvm/arm/vgic/vgic.h               |   6 ++
 11 files changed, 164 insertions(+), 71 deletions(-)
