From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/arm updates for 4.21
Date: Wed, 19 Dec 2018 18:03:21 +0000
Message-ID: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B154A341
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8y0pfYR-Df71 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DC654A33F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:11 -0500 (EST)
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the KVM/arm updates for 4.21. The biggest thing is the support
for 1GB PUD support for HugeTLB backed guest memory. The rest is a
bunch of cleanups and other fixes.

Please pull,

	M.

The following changes since commit 2e6e902d185027f8e3cb8b7305238f7e35d6a436:

  Linux 4.20-rc4 (2018-11-25 14:19:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v4.21

for you to fetch changes up to 8c33df1afd86c611da8473dc6fc5f3af3dabe984:

  arm: KVM: Add S2_PMD_{MASK,SIZE} constants (2018-12-19 17:48:21 +0000)

----------------------------------------------------------------
KVM/arm updates for 4.21

- Large PUD support for HugeTLB
- Single-stepping fixes
- Improved tracing
- Various timer and vgic fixups

----------------------------------------------------------------
Christoffer Dall (9):
      KVM: arm/arm64: Fix VMID alloc race by reverting to lock-less
      KVM: arm/arm64: vgic-v2: Set active_source to 0 when restoring state
      KVM: arm64: Clarify explanation of STAGE2_PGTABLE_LEVELS
      KVM: arm/arm64: vgic: Consider priority and active state for pending irq
      KVM: arm/arm64: Fixup the kvm_exit tracepoint
      KVM: arm/arm64: Remove arch timer workqueue
      KVM: arm/arm64: arch_timer: Simplify kvm_timer_vcpu_terminate
      KVM: arm64: Make vcpu const in vcpu_read_sys_reg
      KVM: arm/arm64: Fix unintended stage 2 PMD mappings

Gustavo A. R. Silva (1):
      KVM: arm/arm64: vgic: Fix off-by-one bug in vgic_get_irq()

Julien Thierry (1):
      KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled

Marc Zyngier (5):
      KVM: arm/arm64: vgic: Cap SPIs to the VM-defined maximum
      arm64: KVM: Add trapped system register access tracepoint
      arm/arm64: KVM: vgic: Force VM halt when changing the active state of GICv3 PPIs/SGIs
      arm/arm64: KVM: Add ARM_EXCEPTION_IS_TRAP macro
      arm: KVM: Add S2_PMD_{MASK,SIZE} constants

Mark Rutland (3):
      arm64: KVM: Skip MMIO insn after emulation
      arm64: KVM: Consistently advance singlestep when emulating instructions
      KVM: arm/arm64: Log PSTATE for unhandled sysregs

Punit Agrawal (8):
      KVM: arm/arm64: Share common code in user_mem_abort()
      KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault
      KVM: arm/arm64: Introduce helpers to manipulate page table entries
      KVM: arm64: Support dirty page tracking for PUD hugepages
      KVM: arm64: Support PUD hugepage in stage2_is_exec()
      KVM: arm64: Support handling access faults for PUD hugepages
      KVM: arm64: Update age handlers to support PUD hugepages
      KVM: arm64: Add support for creating PUD hugepages at stage 2

Will Deacon (1):
      arm64: KVM: Avoid setting the upper 32 bits of VTCR_EL2 to 1

 arch/arm/include/asm/kvm_asm.h           |   4 +
 arch/arm/include/asm/kvm_host.h          |   5 -
 arch/arm/include/asm/kvm_mmu.h           |  61 +++++
 arch/arm/include/asm/stage2_pgtable.h    |   8 +
 arch/arm/kvm/coproc.c                    |   4 +-
 arch/arm64/include/asm/kvm_arm.h         |   6 +-
 arch/arm64/include/asm/kvm_asm.h         |   7 +
 arch/arm64/include/asm/kvm_emulate.h     |  35 ++-
 arch/arm64/include/asm/kvm_host.h        |   3 +-
 arch/arm64/include/asm/kvm_mmu.h         |  48 ++++
 arch/arm64/include/asm/pgtable-hwdef.h   |   4 +
 arch/arm64/include/asm/pgtable.h         |   9 +
 arch/arm64/include/asm/stage2_pgtable.h  |  16 +-
 arch/arm64/kvm/debug.c                   |  21 --
 arch/arm64/kvm/handle_exit.c             |  14 +-
 arch/arm64/kvm/hyp/switch.c              |  43 +---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  12 +-
 arch/arm64/kvm/sys_regs.c                |  12 +-
 arch/arm64/kvm/sys_regs.h                |   4 +
 arch/arm64/kvm/trace.h                   |  35 +++
 include/kvm/arm_arch_timer.h             |   4 -
 virt/kvm/arm/arch_timer.c                |  35 +--
 virt/kvm/arm/arm.c                       |  25 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c            |   6 +-
 virt/kvm/arm/mmio.c                      |  11 +-
 virt/kvm/arm/mmu.c                       | 384 +++++++++++++++++++++++--------
 virt/kvm/arm/trace.h                     |  18 +-
 virt/kvm/arm/vgic/vgic-mmio.c            |  44 ++--
 virt/kvm/arm/vgic/vgic.c                 |  13 +-
 29 files changed, 595 insertions(+), 296 deletions(-)
