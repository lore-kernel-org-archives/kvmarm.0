From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for Linux 4.8, take #1
Date: Fri, 22 Jul 2016 18:28:17 +0100
Message-ID: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Please find below the first batch of 4.8 updates for KVM/ARM. Biggest
feature is the long awaited GICv3 ITS emulation, allowing MSIs to be
delivered into guests running on GICv3 HW. The other big feature is
the removal of the old vgic implementation. Less visible is the revamp
of the way we deal with the HYP initialization (by keeping an idmap
around), and making HYP page tables honor the kernel's own protection.

This may generate a few conflicts, all of which have been seen in
-next. 3 which are KVM specific (and pretty easy to resolve), and
another one in include/irqchip/arm-gic-v3.h. They should be resolved
as in -next.

Please pull!

	M.

The following changes since commit 8ff7b956471faadb0f874a49e8603d43cb1e55d5:

  Merge tag 'kvm-s390-next-4.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2016-06-21 15:21:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.8

for you to fetch changes up to 3a88bded203591d4683aacdbb65cd0f549bc58cb:

  KVM: arm64: vgic-its: Simplify MAPI error handling (2016-07-18 18:15:20 +0100)

----------------------------------------------------------------
KVM/ARM changes for Linux 4.8

- GICv3 ITS emulation
- Simpler idmap management that fixes potential TLB conflicts
- Honor the kernel protection in HYP mode
- Removal of the old vgic implementation

----------------------------------------------------------------
Andre Przywara (17):
      KVM: arm/arm64: vgic: Move redistributor kvm_io_devices
      KVM: arm/arm64: vgic: Check return value for kvm_register_vgic_device
      KVM: Extend struct kvm_msi to hold a 32-bit device ID
      KVM: arm/arm64: Extend arch CAP checks to allow per-VM capabilities
      KVM: kvm_io_bus: Add kvm_io_bus_get_dev() call
      KVM: arm/arm64: vgic: Add refcounting for IRQs
      irqchip/gic-v3: Refactor and add GICv3 definitions
      KVM: arm64: vgic: Handle ITS related GICv3 redistributor registers
      KVM: arm64: vgic-its: Introduce ITS emulation file with MMIO framework
      KVM: arm64: vgic-its: Introduce new KVM ITS device
      KVM: arm64: vgic-its: Implement basic ITS register handlers
      KVM: arm64: vgic-its: Connect LPIs to the VGIC emulation
      KVM: arm64: vgic-its: Read initial LPI pending table
      KVM: arm64: vgic-its: Allow updates of LPI configuration table
      KVM: arm64: vgic-its: Implement ITS command queue command handlers
      KVM: arm64: vgic-its: Implement MSI injection in ITS emulation
      KVM: arm64: vgic-its: Enable ITS emulation as a virtual MSI controller

Dan Carpenter (1):
      arm64: KVM: Clean up a condition

Eric Auger (1):
      KVM: arm/arm64: Fix vGICv2 KVM_DEV_ARM_VGIC_GRP_CPU/DIST_REGS

Marc Zyngier (36):
      arm/arm64: KVM: Add a protection parameter to create_hyp_mappings
      arm64: Add PTE_HYP_XN page table flag
      arm/arm64: KVM: Enforce HYP read-only mapping of the kernel's rodata section
      arm/arm64: KVM: Map the HYP text as read-only
      arm/arm64: KVM: Make default HYP mappings non-excutable
      KVM: arm/arm64: The GIC is dead, long live the GIC
      arm64: KVM: Merged page tables documentation
      arm64: KVM: Always reference __hyp_panic_string via its kernel VA
      arm/arm64: KVM: Remove hyp_kern_va helper
      arm64: KVM: Kill HYP_PAGE_OFFSET
      arm64: Add ARM64_HYP_OFFSET_LOW capability
      arm64: KVM: Define HYP offset masks
      arm64: KVM: Refactor kern_hyp_va to deal with multiple offsets
      arm/arm64: KVM: Export __hyp_text_start/end symbols
      arm64: KVM: Runtime detection of lower HYP offset
      arm/arm64: KVM: Always have merged page tables
      arm64: KVM: Simplify HYP init/teardown
      arm/arm64: KVM: Drop boot_pgd
      arm/arm64: KVM: Kill free_boot_hyp_pgd
      arm: KVM: Simplify HYP init
      arm: KVM: Allow hyp teardown
      arm/arm64: KVM: Prune unused #defines
      arm/arm64: KVM: Check that IDMAP doesn't intersect with VA range
      arm/arm64: Get rid of KERN_TO_HYP
      irqchip/gicv3-its: Restore all cacheability attributes
      KVM: arm64: vgic-its: Generalize use of vgic_get_irq_kref
      KVM: arm64: vgic-its: Fix handling of indirect tables
      KVM: arm64: vgic-its: Fix vgic_its_check_device_id BE handling
      KVM: arm64: vgic-its: Fix misleading nr_entries in vgic_its_check_device_id
      KVM: arm64: vgic-its: Validate the device table L1 entry
      KVM: arm64: vgic-its: Fix L2 entry validation for indirect tables
      KVM: arm64: vgic-its: Add collection allocator/destructor
      KVM: arm64: vgic-its: Add pointer to corresponding kvm_device
      KVM: arm64: vgic-its: Turn device_id validation into generic ID validation
      KVM: arm64: vgic-its: Make vgic_its_cmd_handle_mapi similar to other handlers
      KVM: arm64: vgic-its: Simplify MAPI error handling

 Documentation/virtual/kvm/api.txt              |   14 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |   25 +-
 arch/arm/include/asm/kvm_asm.h                 |    2 +
 arch/arm/include/asm/kvm_host.h                |   27 +-
 arch/arm/include/asm/kvm_hyp.h                 |    3 -
 arch/arm/include/asm/kvm_mmu.h                 |   15 +-
 arch/arm/include/asm/pgtable.h                 |    4 +-
 arch/arm/include/asm/virt.h                    |    4 +
 arch/arm/kvm/Kconfig                           |    7 -
 arch/arm/kvm/Makefile                          |    6 -
 arch/arm/kvm/arm.c                             |   36 +-
 arch/arm/kvm/init.S                            |   56 +-
 arch/arm/kvm/mmu.c                             |  142 +-
 arch/arm64/include/asm/cpufeature.h            |    3 +-
 arch/arm64/include/asm/kvm_host.h              |   19 +-
 arch/arm64/include/asm/kvm_hyp.h               |   23 -
 arch/arm64/include/asm/kvm_mmu.h               |   96 +-
 arch/arm64/include/asm/pgtable-hwdef.h         |    1 +
 arch/arm64/include/asm/pgtable-prot.h          |    4 +-
 arch/arm64/include/asm/virt.h                  |    4 +
 arch/arm64/include/uapi/asm/kvm.h              |    2 +
 arch/arm64/kernel/cpufeature.c                 |   19 +
 arch/arm64/kvm/Kconfig                         |    8 +-
 arch/arm64/kvm/Makefile                        |    9 +-
 arch/arm64/kvm/hyp-init.S                      |   61 +-
 arch/arm64/kvm/hyp/entry.S                     |   19 -
 arch/arm64/kvm/hyp/hyp-entry.S                 |   15 +
 arch/arm64/kvm/hyp/switch.c                    |   11 +-
 arch/arm64/kvm/reset.c                         |   36 +-
 arch/arm64/kvm/sys_regs.c                      |    4 +-
 include/kvm/arm_vgic.h                         |  438 ++---
 include/kvm/vgic/vgic.h                        |  246 ---
 include/linux/irqchip/arm-gic-v3.h             |  212 +-
 include/linux/kvm_host.h                       |    2 +
 include/uapi/linux/kvm.h                       |    7 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c                  |   15 +-
 virt/kvm/arm/vgic-v2-emul.c                    |  856 ---------
 virt/kvm/arm/vgic-v2.c                         |  274 ---
 virt/kvm/arm/vgic-v3-emul.c                    | 1074 -----------
 virt/kvm/arm/vgic-v3.c                         |  279 ---
 virt/kvm/arm/vgic.c                            | 2440 ------------------------
 virt/kvm/arm/vgic.h                            |  140 --
 virt/kvm/arm/vgic/vgic-init.c                  |    9 +-
 virt/kvm/arm/vgic/vgic-its.c                   | 1500 +++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c               |   10 +
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |  247 ++-
 virt/kvm/arm/vgic/vgic-mmio.c                  |   64 +-
 virt/kvm/arm/vgic/vgic-mmio.h                  |   31 +-
 virt/kvm/arm/vgic/vgic-v2.c                    |   12 +-
 virt/kvm/arm/vgic/vgic-v3.c                    |   29 +-
 virt/kvm/arm/vgic/vgic.c                       |  119 +-
 virt/kvm/arm/vgic/vgic.h                       |   38 +-
 virt/kvm/kvm_main.c                            |   24 +
 54 files changed, 2698 insertions(+), 6065 deletions(-)
 delete mode 100644 include/kvm/vgic/vgic.h
 delete mode 100644 virt/kvm/arm/vgic-v2-emul.c
 delete mode 100644 virt/kvm/arm/vgic-v2.c
 delete mode 100644 virt/kvm/arm/vgic-v3-emul.c
 delete mode 100644 virt/kvm/arm/vgic-v3.c
 delete mode 100644 virt/kvm/arm/vgic.c
 delete mode 100644 virt/kvm/arm/vgic.h
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c
