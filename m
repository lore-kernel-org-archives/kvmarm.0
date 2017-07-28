From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 00/16] SError rework + v8.2 RAS and IESB cpufeature support
Date: Fri, 28 Jul 2017 15:10:03 +0100
Message-ID: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80C7049C19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0-AIoM1cVIeY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED31440D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:26 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This series reworks the exception masking so that SError is unmasked ~all the
time, and adds the RAS and IESB cpufeatures.

The major change from v1 is the priority-order for DAIF exceptions after the
SError rework is different due to IESB.

The SError rework is needed for the esb in __switch_to() to be delivered as
an exception, instead of being 'deferred' requiring a sysreg read to check.
The esb cost should be small compared to the dsb(ish) immediately before.

Systems with the RAS Extensions[0] are likely to be servers with APEI's
firmware-first support. For these any SError will be taken to EL3, and Linux
will be notified by some other mechanism... we will never get a physical SError
and don't need to check DISR_EL1 on these systems.
But, if we don't handle RAS SErrors and check DISR_EL1, systems with the RAS
Extensions but no APEI firmware-first will lose SErrors. This series adds the
minimum handling for non-APEI systems.

The ESR AET 'severity' has 'corrected' and not-yet-consumed values, we ignore
RAS SErrors that have these severity values, and panic() for everything else.

v8.2's IESB adds an implicit ESB 'after' TakeException() and 'before'
ExceptionReturn() when entering/returning-from EL1. The TakeException()
esb will always be deferred, so we have to check DISR_EL1. For
ExceptionReturn() we need to unmask SError over the kernel's ERET, so that
any deferred SError isn't left in DISR_EL1 while we are running at EL0.

This means being able to restore SPSR and ELR if we take a 'survivable' SError
during kernel_exit, which is done by stashing the values in a per-cpu variable.

There is no SCTLR_EL2.IESB bit, so KVM only has IESB's behaviour if its using
VHE and we have RAS & IESB. To avoid losing SErrors KVM needs to check DISR_EL1
on __guest_exit(). For ExceptionReturn() a pending host-error will be
blamed on a guest, unmask SError over ERET... if there is an error and the
system doesn't have APEI firmware-first this will cause a hyp-panic.
Future work: add the same minimum-handling to KVMs EL2 panic code.

The DISR_EL1 read on every TakeException() may have an impact on performance.
I'd be interested in seeing any numbers that can be shared, I only have a
software model to test this. If we know a system has APEI firmware-first,
(indicated by GHES entries in the HEST), we can assume firmware has set
SCR_EL3.EA, making DISR_EL1 RAZ/WI for EL{1,2}. More future work is to use
a static key to disable the DISR_EL1 checking on kernel-entry if we know
all reads will be zero.

Known-issues:
 * A synchronous exception taken from the SError handler will overwrite
   the per-cpu SPSR/ELR values on return. Getting the asm code to save these
   and do the restore makes it more complicated and shouldn't be necessary for
   the SError handler as it is today.
 * Handing v8.2s RAS without v8.1s VHE is weird, (see kvm_explicit_esb). Would
   anyone object to making 'all v8.1 features' a runtime requirement of any
   v8.2 feature?


This series can be retrieved from:
git://linux-arm.org/linux-jm.git -b serror_rework/v2


Thanks,

James

[0] https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf

James Morse (14):
  arm64: explicitly mask all exceptions
  arm64: introduce an order for exceptions
  arm64: unmask all exceptions from C code on CPU startup
  arm64: entry.S: mask all exceptions during kernel_exit
  arm64: entry.S: move enable_step_tsk into kernel_exit
  arm64: entry.S: convert elX_sync
  arm64: entry.S: convert elX_irq
  arm64: kernel: Survive corrected RAS errors notified by SError
  arm64: kernel: Handle deferred SError on kernel entry
  arm64: entry.S: Make eret restartable
  arm64: cpufeature: Enable Implicit ESB on entry/return-from EL1
  KVM: arm64: Take pending SErrors on entry to the guest
  KVM: arm64: Save ESR_EL2 on guest SError
  KVM: arm64: Handle deferred SErrors consumed on guest exit

Xie XiuQi (2):
  arm64: entry.S: move SError handling into a C function for future
    expansion
  arm64: cpufeature: Detect CPU RAS Extentions

 arch/arm64/Kconfig                   |  33 ++++-
 arch/arm64/include/asm/assembler.h   |  75 ++++++++---
 arch/arm64/include/asm/barrier.h     |   1 +
 arch/arm64/include/asm/cpucaps.h     |   4 +-
 arch/arm64/include/asm/esr.h         |  17 +++
 arch/arm64/include/asm/exception.h   |  34 +++++
 arch/arm64/include/asm/irqflags.h    |  58 +++++++--
 arch/arm64/include/asm/kvm_emulate.h |   5 +
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/include/asm/processor.h   |   2 +
 arch/arm64/include/asm/sysreg.h      |   4 +
 arch/arm64/kernel/asm-offsets.c      |   1 +
 arch/arm64/kernel/cpufeature.c       |  43 +++++++
 arch/arm64/kernel/entry.S            | 241 +++++++++++++++++++++++++----------
 arch/arm64/kernel/hibernate.c        |   4 +-
 arch/arm64/kernel/machine_kexec.c    |   3 +-
 arch/arm64/kernel/process.c          |   3 +
 arch/arm64/kernel/setup.c            |   7 +-
 arch/arm64/kernel/smp.c              |  12 +-
 arch/arm64/kernel/suspend.c          |   6 +-
 arch/arm64/kernel/traps.c            |  68 +++++++++-
 arch/arm64/kvm/handle_exit.c         |  84 +++++++++---
 arch/arm64/kvm/hyp.S                 |   1 +
 arch/arm64/kvm/hyp/entry.S           |  27 ++++
 arch/arm64/kvm/hyp/switch.c          |  15 ++-
 arch/arm64/mm/proc.S                 |  17 +--
 26 files changed, 618 insertions(+), 148 deletions(-)

-- 
2.13.2
