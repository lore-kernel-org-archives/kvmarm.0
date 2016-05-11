From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Wed, 11 May 2016 15:29:53 +0200
Message-ID: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here is the initial set of changes for KVM/ARM for v4.7.

Sorry I'm a bit late with these, but we were trying to get the new vgic
implementation in as part of this, but I have decided to send this pull
request now, and we can follow up with another for the new VGIC,
assuming we feel like we have that in place in a few days.

There are a few changes in this pull request touching things outside
KVM, but they should all carry the necessary acks and it made the
merge process much easier to do it this way.

Hope this works for you guys.

For a description of the content, see below; otherwise:

The following changes since commit 06a71a24bae57a07afee9cda6b00495347d8a448:

  arm64: KVM: unregister notifiers in hyp mode teardown path (2016-04-06 13:47:52 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.7

for you to fetch changes up to 06485053244480f5f403d8f89b8617bd7d549113:

  kvm: arm64: Enable hardware updates of the Access Flag for Stage 2 page tables (2016-05-09 22:23:08 +0200)


Thanks,
-Christoffer

----------------------------------------------------------------
KVM/ARM Changes for Linux v4.7

Reworks our stage 2 page table handling to have page table manipulation
macros separate from those of the host systems as the underlying
hardware page tables can be configured to be noticably different in
layout from the stage 1 page tables used by the host.

Adds 16K page size support based on the above.

Adds a generic firmware probing layer for the timer and GIC so that KVM
initializes using the same logic based on both ACPI and FDT.

Finally adds support for hardware updating of the access flag.

----------------------------------------------------------------
Catalin Marinas (1):
      kvm: arm64: Enable hardware updates of the Access Flag for Stage 2 page tables

Julien Grall (10):
      clocksource: arm_arch_timer: Gather KVM specific information in a structure
      clocksource: arm_arch_timer: Extend arch_timer_kvm_info to get the virtual IRQ
      irqchip/gic-v2: Gather ACPI specific data in a single structure
      irqchip/gic-v2: Parse and export virtual GIC information
      irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
      irqchip/gic-v3: Gather all ACPI specific data in a single structure
      irqchip/gic-v3: Parse and export virtual GIC information
      KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the firmware tables
      KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware tables
      clocksource: arm_arch_timer: Remove arch_timer_get_timecounter

Marc Zyngier (1):
      arm/arm64: KVM: Enforce Break-Before-Make on Stage-2 page tables

Suzuki K Poulose (17):
      arm64: Reuse TCR field definitions for EL1 and EL2
      arm64: Cleanup VTCR_EL2 and VTTBR field values
      kvm arm: Move fake PGD handling to arch specific files
      arm64: Introduce pmd_thp_or_huge
      kvm-arm: Replace kvm_pmd_huge with pmd_thp_or_huge
      kvm-arm: Remove kvm_pud_huge()
      kvm-arm: arm32: Introduce stage2 page table helpers
      kvm-arm: arm: Introduce hyp page table empty checks
      kvm-arm: arm64: Introduce stage2 page table helpers
      kvm-arm: arm64: Introduce hyp page table empty checks
      kvm-arm: Use explicit stage2 helper routines
      kvm-arm: Add explicit hyp page table modifiers
      kvm-arm: Add stage2 page table modifiers
      kvm-arm: Cleanup kvm_* wrappers
      kvm: arm64: Get rid of fake page table levels
      kvm-arm: Cleanup stage2 pgd handling
      arm64: kvm: Add support for 16K pages

 arch/arm/include/asm/kvm_mmu.h                |  43 +--
 arch/arm/include/asm/stage2_pgtable.h         |  61 ++++
 arch/arm/kvm/arm.c                            |   2 +-
 arch/arm/kvm/mmu.c                            | 408 ++++++++++++++------------
 arch/arm64/include/asm/kvm_arm.h              |  85 +++---
 arch/arm64/include/asm/kvm_mmu.h              | 111 ++-----
 arch/arm64/include/asm/pgtable-hwdef.h        |  80 +++--
 arch/arm64/include/asm/pgtable.h              |  15 +-
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 +++
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 +++
 arch/arm64/include/asm/stage2_pgtable.h       | 142 +++++++++
 arch/arm64/kvm/Kconfig                        |   1 -
 arch/arm64/kvm/hyp/s2-setup.c                 |   8 +
 drivers/clocksource/arm_arch_timer.c          |  11 +-
 drivers/irqchip/irq-gic-common.c              |  13 +
 drivers/irqchip/irq-gic-common.h              |   3 +
 drivers/irqchip/irq-gic-v3.c                  | 176 +++++++++--
 drivers/irqchip/irq-gic.c                     |  87 +++++-
 include/clocksource/arm_arch_timer.h          |  12 +-
 include/kvm/arm_vgic.h                        |   7 +-
 include/linux/irqchip/arm-gic-common.h        |  34 +++
 virt/kvm/arm/arch_timer.c                     |  40 +--
 virt/kvm/arm/vgic-v2.c                        |  61 ++--
 virt/kvm/arm/vgic-v3.c                        |  47 +--
 virt/kvm/arm/vgic.c                           |  50 ++--
 25 files changed, 1053 insertions(+), 525 deletions(-)
 create mode 100644 arch/arm/include/asm/stage2_pgtable.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable.h
 create mode 100644 include/linux/irqchip/arm-gic-common.h
