From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/37] KVM/arm updates for v4.19
Date: Mon, 13 Aug 2018 15:57:18 +0100
Message-ID: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4DB4A1DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:58:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wwKzmQ8Z9XcK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:58:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444CD4A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:58:50 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the bulk of the KVM/arm changes for 4.19. On the menu, the
usual bulk of vgic changes (this time with group0 interrupt support),
some cache management optimizations for recent versions of the
architecture, some more RAS stuff and the usual collection of fixes.

Please pull,

	M.

The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:

  Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v4.19

for you to fetch changes up to 976d34e2dab10ece5ea8fe7090b7692913f89084:

  KVM: arm/arm64: Skip updating PTE entry if no change (2018-08-13 15:32:01 +0100)

----------------------------------------------------------------
KVM/arm updates for 4.19

- Support for Group0 interrupts in guests
- Cache management optimizations for ARMv8.4 systems
- Userspace interface for RAS, allowing error retrival and injection
- Fault path optimization
- Emulated physical timer fixes
- Random cleanups

----------------------------------------------------------------
Christoffer Dall (13):
      KVM: arm/arm64: Fix vgic init race
      KVM: arm/arm64: vgic: Define GICD_IIDR fields for GICv2 and GIv3
      KVM: arm/arm64: vgic: Keep track of implementation revision
      KVM: arm/arm64: vgic: GICv2 IGROUPR should read as zero
      KVM: arm/arm64: vgic: Add group field to struct irq
      KVM: arm/arm64: vgic: Signal IRQs using their configured group
      KVM: arm/arm64: vgic: Permit uaccess writes to return errors
      KVM: arm/arm64: vgic: Return error on incompatible uaccess GICD_IIDR writes
      KVM: arm/arm64: vgic: Allow configuration of interrupt groups
      KVM: arm/arm64: vgic: Let userspace opt-in to writable v2 IGROUPR
      KVM: arm/arm64: vgic: Update documentation of the GIC devices wrt IIDR
      KVM: arm/arm64: Fix potential loss of ptimer interrupts
      KVM: arm/arm64: Fix lost IRQs from emulated physcial timer when blocked

Dongjiu Geng (2):
      arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
      arm64: KVM: export the capability to set guest SError syndrome

Gustavo A. R. Silva (1):
      KVM: arm: Use true and false for boolean values

James Morse (2):
      KVM: arm64: Share the parts of get/set events useful to 32bit
      KVM: arm: Add 32bit get/set events support

Jia He (2):
      KVM: arm/arm64: vgic: Move DEBUG_SPINLOCK_BUG_ON to vgic.h
      KVM: arm/arm64: vgic: Do not use spin_lock_irqsave/restore with irq disabled

Kees Cook (1):
      KVM: arm64: vgic-its: Remove VLA usage

Marc Zyngier (13):
      arm64: KVM: Add support for Stage-2 control of memory types and cacheability
      arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is present
      arm64: KVM: Avoid marking pages as XN in Stage-2 if CTR_EL0.DIC is set
      KVM: arm/arm64: Consolidate page-table accessors
      KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers
      KVM: arm/arm64: Remove unnecessary CMOs when creating HYP page tables
      KVM: arm/arm64: Enable adaptative WFE trapping
      KVM: arm/arm64: vgic-debug: Show LPI status
      arm64: KVM: Cleanup tpidr_el2 init on non-VHE
      KVM: arm64: Remove non-existent AArch32 ICC_SGI1R encoding
      KVM: arm/arm64: vgic-v3: Add core support for Group0 SGIs
      KVM: arm64: vgic-v3: Add support for ICC_SGI0R_EL1 and ICC_ASGI1R_EL1 accesses
      KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses

Mark Rutland (1):
      KVM: arm/arm64: vgic: Fix possible spectre-v1 write in vgic_mmio_write_apr()

Punit Agrawal (2):
      KVM: arm/arm64: Skip updating PMD entry if no change
      KVM: arm/arm64: Skip updating PTE entry if no change

 Documentation/virtual/kvm/api.txt                 | 80 +++++++++++++++++++--
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  8 +++
 Documentation/virtual/kvm/devices/arm-vgic.txt    | 15 ++--
 arch/arm/include/asm/kvm_emulate.h                | 12 +++-
 arch/arm/include/asm/kvm_host.h                   |  5 ++
 arch/arm/include/asm/kvm_mmu.h                    | 14 +---
 arch/arm/include/uapi/asm/kvm.h                   | 13 ++++
 arch/arm/kvm/coproc.c                             | 25 ++++++-
 arch/arm/kvm/guest.c                              | 23 ++++++
 arch/arm64/include/asm/cpucaps.h                  |  3 +-
 arch/arm64/include/asm/kvm_arm.h                  |  1 +
 arch/arm64/include/asm/kvm_emulate.h              | 17 +++++
 arch/arm64/include/asm/kvm_host.h                 | 28 ++++----
 arch/arm64/include/asm/kvm_mmu.h                  | 35 ++++++---
 arch/arm64/include/asm/memory.h                   |  7 ++
 arch/arm64/include/asm/pgtable-prot.h             | 24 ++++++-
 arch/arm64/include/asm/sysreg.h                   |  3 +
 arch/arm64/include/uapi/asm/kvm.h                 | 13 ++++
 arch/arm64/kernel/cpufeature.c                    | 20 ++++++
 arch/arm64/kvm/guest.c                            | 33 +++++++++
 arch/arm64/kvm/hyp-init.S                         |  6 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                    |  5 --
 arch/arm64/kvm/inject_fault.c                     |  6 +-
 arch/arm64/kvm/reset.c                            |  4 ++
 arch/arm64/kvm/sys_regs.c                         | 54 ++++++++++++--
 include/kvm/arm_vgic.h                            |  9 ++-
 include/linux/irqchip/arm-gic-v3.h                | 10 +++
 include/linux/irqchip/arm-gic.h                   | 11 +++
 include/uapi/linux/kvm.h                          |  1 +
 virt/kvm/arm/arch_timer.c                         | 15 ++--
 virt/kvm/arm/arm.c                                | 51 +++++++++++++
 virt/kvm/arm/mmu.c                                | 87 ++++++++++++++++++-----
 virt/kvm/arm/vgic/vgic-debug.c                    | 50 +++++++++----
 virt/kvm/arm/vgic/vgic-init.c                     | 24 ++++++-
 virt/kvm/arm/vgic/vgic-its.c                      | 27 ++++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c                  | 66 +++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 72 ++++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio.c                     | 56 +++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.h                     | 25 ++++---
 virt/kvm/arm/vgic/vgic-v2.c                       | 10 ++-
 virt/kvm/arm/vgic/vgic-v3.c                       | 13 ++--
 virt/kvm/arm/vgic/vgic.c                          | 19 ++---
 virt/kvm/arm/vgic/vgic.h                          |  7 ++
 43 files changed, 834 insertions(+), 173 deletions(-)
