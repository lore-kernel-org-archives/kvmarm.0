From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/arm updates for Linux v5.1
Date: Fri, 22 Feb 2019 16:25:38 +0000
Message-ID: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDBB94A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:26:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7SKyYVU3HRF6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:26:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4476D4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:26:51 -0500 (EST)
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the KVM/arm updates for Linux v5.1, much smaller than expected, as
most of the stuff we were hoping to queue missed the merge window. Oh well,
5.2 will be "interesting".

This time, we have a bunch of changes that prepare the landing of the some
of the nested virt code, some optimisations on the timer emulation (direct
assignment of the physical timer on VHE systems), some better type-safety
checks for the HYP code, Set/Way optimisations for silly 32bit guests, and a
bunch of cleanups here and there. Oh, and a MAINTAINERS update to officially
mention that we have a set of dedicated reviewers working with us!

Note that the first patch hits code that is outside of the KVM tree, but
that Daniel has agreed to us taking directly given that it was required for
a lot of other things in this drop.

Please pull,

	M.

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v5.1

for you to fetch changes up to c88b093693ccbe41991ef2e9b1d251945e6e54ed:

  arm64: KVM: Fix architecturally invalid reset value for FPEXC32_EL2 (2019-02-22 09:59:20 +0000)

----------------------------------------------------------------
KVM/arm updates for Linux v5.1

- A number of pre-nested code rework
- Direct physical timer assignment on VHE systems
- kvm_call_hyp type safety enforcement
- Set/Way cache sanitisation for 32bit guests
- Build system cleanups
- A bunch of janitorial fixes

----------------------------------------------------------------
Andre Przywara (2):
      clocksource/arm_arch_timer: Store physical timer IRQ number for KVM on VHE
      KVM: arm/arm64: consolidate arch timer trap handlers

Ard Biesheuvel (2):
      arm64: KVM: Expose sanitised cache type register to guest
      arm64: KVM: Describe data or unified caches as having 1 set and 1 way

Christoffer Dall (6):
      KVM: arm/arm64: Factor out VMID into struct kvm_vmid
      KVM: arm/arm64: Simplify bg_timer programming
      KVM: arm/arm64: timer: Rework data structures for multiple timers
      KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems
      KVM: arm/arm64: Rework the timer code to use a timer_map
      KVM: arm/arm64: Move kvm_is_write_fault to header file

Colin Ian King (1):
      KVM: arm/arm64: fix spelling mistake: "auxilary" -> "auxiliary"

Dave Martin (1):
      arm64: KVM: Fix architecturally invalid reset value for FPEXC32_EL2

Marc Zyngier (9):
      arm/arm64: KVM: Introduce kvm_call_hyp_ret()
      arm64: KVM: Allow for direct call of HYP functions when using VHE
      arm64: KVM: Drop VHE-specific HYP call stub
      ARM: KVM: Teach some form of type-safety to kvm_call_hyp
      arm/arm64: KVM: Statically configure the host's view of MPIDR
      KVM: arm64: Fix ICH_ELRSR_EL2 sysreg naming
      KVM: arm64: Reuse sys_reg() macro when searching the trap table
      KVM: arm/arm64: arch_timer: Mark physical interrupt active when a virtual interrupt is pending
      KVM: arm/arm64: Update MAINTAINERS entries

Masahiro Yamada (3):
      KVM: arm/arm64: Fix TRACE_INCLUDE_PATH
      KVM: arm/arm64: Remove -I. header search paths
      KVM: arm/arm64: Prefix header search paths with $(srctree)/

Shaokun Zhang (2):
      KVM: arm/arm64: Remove unused gpa_end variable
      KVM: arm/arm64: Remove unused timer variable

Zenghui Yu (1):
      KVM: arm64: Fix comment for KVM_PHYS_SHIFT

 MAINTAINERS                          |  18 +-
 arch/arm/include/asm/arch_gicv3.h    |   4 +-
 arch/arm/include/asm/kvm_emulate.h   |   8 +
 arch/arm/include/asm/kvm_host.h      |  53 ++-
 arch/arm/include/asm/kvm_hyp.h       |   4 +
 arch/arm/include/asm/kvm_mmu.h       |   9 +-
 arch/arm/kvm/Makefile                |   5 +-
 arch/arm/kvm/coproc.c                |  23 +-
 arch/arm/kvm/hyp/cp15-sr.c           |   1 -
 arch/arm/kvm/hyp/hyp-entry.S         |   2 +-
 arch/arm/kvm/hyp/switch.c            |   2 +-
 arch/arm/kvm/hyp/tlb.c               |   4 +-
 arch/arm/kvm/interrupts.S            |   4 +-
 arch/arm64/include/asm/kvm_emulate.h |  12 +
 arch/arm64/include/asm/kvm_host.h    |  48 ++-
 arch/arm64/include/asm/kvm_hyp.h     |   3 +-
 arch/arm64/include/asm/kvm_mmu.h     |  13 +-
 arch/arm64/include/asm/sysreg.h      |   7 +-
 arch/arm64/kvm/Makefile              |   4 +-
 arch/arm64/kvm/debug.c               |   2 +-
 arch/arm64/kvm/hyp.S                 |   3 -
 arch/arm64/kvm/hyp/hyp-entry.S       |  12 -
 arch/arm64/kvm/hyp/sysreg-sr.c       |   1 -
 arch/arm64/kvm/sys_regs.c            | 168 ++++++----
 drivers/clocksource/arm_arch_timer.c |  11 +-
 include/clocksource/arm_arch_timer.h |   1 +
 include/kvm/arm_arch_timer.h         |  68 ++--
 virt/kvm/arm/arch_timer.c            | 608 ++++++++++++++++++++++++-----------
 virt/kvm/arm/arm.c                   |  64 ++--
 virt/kvm/arm/hyp/vgic-v3-sr.c        |   2 +-
 virt/kvm/arm/mmu.c                   |  18 +-
 virt/kvm/arm/trace.h                 | 107 +++++-
 virt/kvm/arm/vgic/vgic-v3.c          |   4 +-
 33 files changed, 909 insertions(+), 384 deletions(-)
