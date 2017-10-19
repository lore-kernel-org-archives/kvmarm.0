From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first support
Date: Thu, 19 Oct 2017 15:57:46 +0100
Message-ID: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3159B4078A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GCgoyBhOL5sa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:58:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1D70406BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:58:49 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

The aim of this series is to enable IESB and add ESB-instructions to let us
kick any pending RAS errors into firmware to be handled by firmware-first.

Not all systems will have this firmware, so these RAS errors will become
pending SErrors. We should take these as quickly as possible and avoid
panic()ing for errors where we could have continued.

This first part of this series reworks the DAIF masking so that SError is
unmasked unless we are handling a debug exception.

The last part provides the same minimal handling for SError that interrupt
KVM. KVM is currently unable to handle SErrors during world-switch, unless
they occur during a magic single-instruction window, it hyp-panics. I suspect
this will be easier to fix once the VHE world-switch is further optimised.

KVMs kvm_inject_vabt() needs updating for v8.2 as now we can specify an ESR,
and all-zeros has a RAS meaning.

KVM's existing 'impdef SError to the guest' behaviour probably needs revisiting.
These are errors where we don't know what they mean, they may not be
synchronised by ESB. Today we blame the guest.
My half-baked suggestion would be to make a virtual SError pending, but then
exit to user-space to give Qemu the change to quit (for virtual machines that
don't generate SError), pend an SError with a new Qemu-specific ESR, or blindly
continue and take KVMs default all-zeros impdef ESR.

Known issues:
 * Synchronous external abort SET severity is not yet considered, all
   synchronous-external-aborts are still considered fatal.

 * KVM-Migration: VDISR_EL2 is exposed to userspace as DISR_EL1, but how should
   HCR_EL2.VSE or VSESR_EL2 be migrated when the guest has an SError pending but
   hasn't taken it yet...?

 * KVM unmasks SError and IRQ before calling handle_exit, we may be rescheduled
   while holding an uncontained ESR... (this is currently an improvement on
   assuming its an impdef error we can blame on the guest)
    * We need to fix this for APEI's SEI or kernel-first RAS, the guest-exit
      SError handling will need to move to before kvm_arm_vhe_guest_exit().


Changes from v3:
 * Symbol naming around daif flag helpers
 * Removed the IESB kconfig option
 * Moved that nop out of the firing line in the vaxorcism code
 * Added last patch to Trap ERR registers and make them RAZ/WI


Comments and contradictions welcome,

James


Dongjiu Geng (1):
  KVM: arm64: Trap RAS error registers and set HCR_EL2's TERR & TEA

James Morse (18):
  arm64: explicitly mask all exceptions
  arm64: introduce an order for exceptions
  arm64: Move the async/fiq helpers to explicitly set process context
    flags
  arm64: Mask all exceptions during kernel_exit
  arm64: entry.S: Remove disable_dbg
  arm64: entry.S: convert el1_sync
  arm64: entry.S convert el0_sync
  arm64: entry.S: convert elX_irq
  KVM: arm/arm64: mask/unmask daif around VHE guests
  arm64: kernel: Survive corrected RAS errors notified by SError
  arm64: cpufeature: Enable IESB on exception entry/return for
    firmware-first
  arm64: kernel: Prepare for a DISR user
  KVM: arm64: Set an impdef ESR for Virtual-SError using VSESR_EL2.
  KVM: arm64: Save/Restore guest DISR_EL1
  KVM: arm64: Save ESR_EL2 on guest SError
  KVM: arm64: Handle RAS SErrors from EL1 on guest exit
  KVM: arm64: Handle RAS SErrors from EL2 on guest exit
  KVM: arm64: Take any host SError before entering the guest

Xie XiuQi (2):
  arm64: entry.S: move SError handling into a C function for future
    expansion
  arm64: cpufeature: Detect CPU RAS Extentions

 arch/arm64/Kconfig                   | 18 +++++++-
 arch/arm64/include/asm/assembler.h   | 51 ++++++++++++++-------
 arch/arm64/include/asm/barrier.h     |  1 +
 arch/arm64/include/asm/cpucaps.h     |  4 +-
 arch/arm64/include/asm/daifflags.h   | 72 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/esr.h         | 17 +++++++
 arch/arm64/include/asm/exception.h   | 14 ++++++
 arch/arm64/include/asm/irqflags.h    | 40 ++++++-----------
 arch/arm64/include/asm/kvm_arm.h     |  2 +
 arch/arm64/include/asm/kvm_emulate.h | 17 +++++++
 arch/arm64/include/asm/kvm_host.h    | 16 +++++++
 arch/arm64/include/asm/processor.h   |  2 +
 arch/arm64/include/asm/sysreg.h      | 16 +++++++
 arch/arm64/include/asm/traps.h       | 36 +++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kernel/cpufeature.c       | 41 +++++++++++++++++
 arch/arm64/kernel/debug-monitors.c   |  5 ++-
 arch/arm64/kernel/entry.S            | 86 +++++++++++++++++++++---------------
 arch/arm64/kernel/hibernate.c        |  5 ++-
 arch/arm64/kernel/machine_kexec.c    |  4 +-
 arch/arm64/kernel/process.c          |  3 ++
 arch/arm64/kernel/setup.c            |  8 ++--
 arch/arm64/kernel/signal.c           |  8 +++-
 arch/arm64/kernel/smp.c              | 12 ++---
 arch/arm64/kernel/suspend.c          |  7 +--
 arch/arm64/kernel/traps.c            | 64 ++++++++++++++++++++++++++-
 arch/arm64/kvm/handle_exit.c         | 19 +++++++-
 arch/arm64/kvm/hyp-init.S            |  3 ++
 arch/arm64/kvm/hyp/entry.S           | 13 ++++++
 arch/arm64/kvm/hyp/switch.c          | 19 ++++++--
 arch/arm64/kvm/hyp/sysreg-sr.c       |  6 +++
 arch/arm64/kvm/inject_fault.c        | 13 +++++-
 arch/arm64/kvm/sys_regs.c            | 11 +++++
 arch/arm64/mm/proc.S                 | 14 +++---
 virt/kvm/arm/arm.c                   |  4 ++
 35 files changed, 537 insertions(+), 115 deletions(-)
 create mode 100644 arch/arm64/include/asm/daifflags.h

-- 
2.13.3
