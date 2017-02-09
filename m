From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM updates for 4.11
Date: Thu,  9 Feb 2017 14:58:58 +0000
Message-ID: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Pavel Fedin <p.fedin@samsung.com>, Shanker Donthineni <shankerd@codeaurora.org>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Here's the KVM/ARM updates for 4.11. On the menu this time, GICv3
save/restore, physical timer emulation, and a number of fixes.

Thanks,

	M.

The following changes since commit 7a308bb3016f57e5be11a677d15b821536419d36:

  Linux 4.10-rc5 (2017-01-22 12:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-4.11

for you to fetch changes up to 7b6b46311a8562fb3a9e035ed6ffab6d49c28886:

  KVM: arm/arm64: Emulate the EL1 phys timer registers (2017-02-08 15:13:37 +0000)

----------------------------------------------------------------
kvmarm updates for 4.11

- GICv3 save restore
- Cache flushing fixes
- MSI injection fix for GICv3 ITS
- Physical timer emulation support

----------------------------------------------------------------
Christoffer Dall (3):
      KVM: arm/arm64: Remove struct vgic_irq pending field
      KVM: arm/arm64: vgic: Add debugfs vgic-state file
      KVM: arm/arm64: Remove kvm_vgic_inject_mapped_irq

Jintack Lim (10):
      KVM: arm/arm64: Abstract virtual timer context into separate structure
      KVM: arm/arm64: Move cntvoff to each timer context
      KVM: arm/arm64: Decouple kvm timer functions from virtual timer
      KVM: arm/arm64: Add the EL1 physical timer context
      KVM: arm/arm64: Initialize the emulated EL1 physical timer
      KVM: arm/arm64: Update the physical timer interrupt level
      KVM: arm/arm64: Set a background timer to the earliest timer expiration
      KVM: arm/arm64: Set up a background timer for the physical timer emulation
      KVM: arm64: Add the EL1 physical timer access handler
      KVM: arm/arm64: Emulate the EL1 phys timer registers

Marc Zyngier (3):
      arm/arm64: KVM: Enforce unconditional flush to PoC when mapping to stage-2
      arm/arm64: KVM: Stop propagating cacheability status of a faulted page
      arm/arm64: KVM: Get rid of KVM_MEMSLOT_INCOHERENT

Shanker Donthineni (1):
      KVM: arm/arm64: vgic: Stop injecting the MSI occurrence twice

Vijaya Kumar K (8):
      KVM: arm/arm64: vgic: Implement support for userspace access
      KVM: arm/arm64: vgic: Add distributor and redistributor access
      KVM: arm/arm64: vgic: Introduce find_reg_by_id()
      irqchip/gic-v3: Add missing system register definitions
      KVM: arm/arm64: vgic: Introduce VENG0 and VENG1 fields to vmcr struct
      KVM: arm/arm64: vgic: Implement VGICv3 CPU interface access
      KVM: arm/arm64: vgic: Implement KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
      KVM: arm/arm64: Documentation: Update arm-vgic-v3.txt

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  11 +-
 arch/arm/include/asm/kvm_host.h                   |   3 -
 arch/arm/include/asm/kvm_mmu.h                    |  12 +-
 arch/arm/include/uapi/asm/kvm.h                   |  13 +
 arch/arm/kvm/Makefile                             |   5 +-
 arch/arm/kvm/arm.c                                |   4 +-
 arch/arm/kvm/mmu.c                                |  20 +-
 arch/arm/kvm/reset.c                              |   9 +-
 arch/arm/kvm/vgic-v3-coproc.c                     |  35 +++
 arch/arm64/include/asm/kvm_host.h                 |   3 -
 arch/arm64/include/asm/kvm_mmu.h                  |   6 +-
 arch/arm64/include/uapi/asm/kvm.h                 |  13 +
 arch/arm64/kvm/Makefile                           |   4 +-
 arch/arm64/kvm/reset.c                            |   9 +-
 arch/arm64/kvm/sys_regs.c                         |  92 +++++-
 arch/arm64/kvm/sys_regs.h                         |   4 +
 arch/arm64/kvm/vgic-sys-reg-v3.c                  | 346 ++++++++++++++++++++++
 include/kvm/arm_arch_timer.h                      |  39 +--
 include/kvm/arm_vgic.h                            |  18 +-
 include/linux/irqchip/arm-gic-v3.h                |  45 ++-
 include/linux/kvm_host.h                          |   1 -
 virt/kvm/arm/arch_timer.c                         | 201 +++++++++----
 virt/kvm/arm/hyp/timer-sr.c                       |  13 +-
 virt/kvm/arm/vgic/vgic-debug.c                    | 283 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-init.c                     |   4 +
 virt/kvm/arm/vgic/vgic-irqfd.c                    |   3 +
 virt/kvm/arm/vgic/vgic-its.c                      |   6 +-
 virt/kvm/arm/vgic/vgic-kvm-device.c               | 231 ++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                  |  87 ++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 203 +++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c                     | 167 +++++++++--
 virt/kvm/arm/vgic/vgic-mmio.h                     |  24 ++
 virt/kvm/arm/vgic/vgic-v2.c                       |  12 +-
 virt/kvm/arm/vgic/vgic-v3.c                       |  40 ++-
 virt/kvm/arm/vgic/vgic.c                          |  66 ++---
 virt/kvm/arm/vgic/vgic.h                          |  83 +++++-
 36 files changed, 1785 insertions(+), 330 deletions(-)
 create mode 100644 arch/arm/kvm/vgic-v3-coproc.c
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v3.c
 create mode 100644 virt/kvm/arm/vgic/vgic-debug.c
