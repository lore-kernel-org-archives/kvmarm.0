From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 00/14] KVM: arm/arm64: Various rework in preparation of nested
 virt support
Date: Thu, 24 Jan 2019 15:00:18 +0100
Message-ID: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA214A3F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ps-6-8cefQ3m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EADB04A3A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:36 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series contains a somewhat random set of reworks and improvements to the
KVM/Arm code in preparation for nested virtualization support.

We plan to merge these as early as v5.1.

The series relies on an additional patch which exposes the physical EL1 timer's
IRQ number to KVM:
  "clocksource/arm_arch_timer: Store physical timer IRQ number for KVM on VHE"
  https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1908965.html


Andre Przywara (1):
  KVM: arm/arm64: consolidate arch timer trap handlers

Christoffer Dall (6):
  KVM: arm/arm64: Factor out VMID into struct kvm_vmid
  KVM: arm/arm64: Simplify bg_timer programming
  KVM: arm/arm64: timer: Rework data structures for multiple timers
  KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems
  KVM: arm/arm64: Rework the timer code to use a timer_map
  KVM: arm/arm64: Move kvm_is_write_fault to header file

Marc Zyngier (7):
  arm/arm64: KVM: Introduce kvm_call_hyp_ret()
  arm64: KVM: Allow for direct call of HYP functions when using VHE
  arm64: KVM: Drop VHE-specific HYP call stub
  ARM: KVM: Teach some form of type-safety to kvm_call_hyp
  arm/arm64: KVM: Statically configure the host's view of MPIDR
  KVM: arm64: Fix ICH_ELRSR_EL2 sysreg naming
  KVM: arm64: Reuse sys_reg() macro when searching the trap table

 arch/arm/include/asm/arch_gicv3.h    |   4 +-
 arch/arm/include/asm/kvm_emulate.h   |   8 +
 arch/arm/include/asm/kvm_host.h      |  53 ++-
 arch/arm/include/asm/kvm_hyp.h       |   4 +
 arch/arm/include/asm/kvm_mmu.h       |  11 +
 arch/arm/kvm/coproc.c                |  23 +-
 arch/arm/kvm/hyp/cp15-sr.c           |   1 -
 arch/arm/kvm/hyp/hyp-entry.S         |   2 +-
 arch/arm/kvm/hyp/switch.c            |   2 +-
 arch/arm/kvm/hyp/tlb.c               |   4 +-
 arch/arm/kvm/interrupts.S            |   4 +-
 arch/arm64/include/asm/kvm_emulate.h |   8 +
 arch/arm64/include/asm/kvm_host.h    |  48 ++-
 arch/arm64/include/asm/kvm_hyp.h     |   3 +-
 arch/arm64/include/asm/kvm_mmu.h     |  11 +
 arch/arm64/include/asm/sysreg.h      |   6 +-
 arch/arm64/kvm/debug.c               |   2 +-
 arch/arm64/kvm/hyp.S                 |   3 -
 arch/arm64/kvm/hyp/hyp-entry.S       |  12 -
 arch/arm64/kvm/hyp/sysreg-sr.c       |   1 -
 arch/arm64/kvm/sys_regs.c            |  99 +++--
 include/kvm/arm_arch_timer.h         |  68 +++-
 virt/kvm/arm/arch_timer.c            | 583 +++++++++++++++++++--------
 virt/kvm/arm/arm.c                   |  62 +--
 virt/kvm/arm/hyp/vgic-v3-sr.c        |   2 +-
 virt/kvm/arm/mmu.c                   |  10 +-
 virt/kvm/arm/trace.h                 | 105 +++++
 virt/kvm/arm/vgic/vgic-v3.c          |   4 +-
 28 files changed, 799 insertions(+), 344 deletions(-)

-- 
2.18.0
