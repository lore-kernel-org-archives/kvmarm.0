From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 00/13] arm64/KVM: RAS & IESB for firmware first support
Date: Fri, 15 Dec 2017 15:50:48 +0000
Message-ID: <20171215155101.23505-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F327349D72
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:49:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5pYwoqaYR-mm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 10:49:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDB0406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:49:37 -0500 (EST)
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

The aim of this series is to enable IESB to let us kick any pending RAS
errors into firmware to be handled by firmware-first.

(This series used to be 'SError rework + RAS&IESB for firmware first support'
 but the SError rework got merged).

The major change since v4 is the use of local cpu caps in the arch helpers.
This means KVM can't use them from its pre-emptible handle_exit(), resulting
in a new helper that runs earlier. (more details below)

Not all systems will have firmware support, so these RAS errors will become
pending SErrors delivered to the kernel. The first part of the series adds
some crude categorization for SErrors into 'fatal' or ignorable. This stops us
panic()ing for corrected errors, but we make no attempt to handle the error.
Proper kernel-first support will be able to do a much better job here.

The second part of the series provides the same minimal handling for SError
that interrupt KVM. KVM is currently unable to handle SErrors during
world-switch, unless they occur during a magic single-instruction window,
it hyp-panics. I suspect this will be easier to fix once the VHE world-switch
is further optimised.

KVMs kvm_inject_vabt() needs updating for v8.2 as now we can specify an ESR,
and all-zeros has a RAS meaning.

Until we have kernel-first support, containable RAS errors that interrupt a
guest are considered by KVM using the same crude categorization the arch code
uses. Fatal errors are treated as an impdef-SError, non-fatal errors are
ignored. Again, proper kernel-first support will do better.
(uncontained errors from a guest will always cause the host to panic)

KVM's existing 'impdef SError to the guest' behaviour probably needs revisiting.
These are errors where we don't know what they mean, they may not be
synchronised by ESB. Today we blame the guest.
My half-baked suggestion would be to make a virtual SError pending, but then
exit to user-space to give Qemu the chance to quit (for virtual machines that
don't generate SError), pend an SError with a new Qemu-specific ESR, or blindly
continue and take KVMs default all-zeros impdef ESR. This behaviour should never
apply to RAS errors, where Qemu finds out about the result of the error from
the host kernel.

Known issues:
 * Synchronous external abort SET severity is not yet considered, all
   synchronous-external-aborts are still considered fatal.

 * KVM-Migration: HCR_EL2.VSE and VSESR_EL2 cannot be migrated when the guest
   has an SError pending. An API using {G,S}ET_EVENTS is on my todo list.

 * KVM unmasks SError and IRQ before calling handle_exit_early, we may take
   interrupts while holding an uncontained ESR... (this is currently an
   improvement on assuming its an impdef error we can blame on the guest)
    * We need to fix this for APEI's SEI or kernel-first RAS, the guest-exit
      SError handling will need to move to before kvm_arm_vhe_guest_exit(),
      or at least into a region where SError and IRQ is still masked.

Changes since v4:
 * (The first two patches are new)
 * Use local cpu cap accesors instead of global so we can spot survivable RAS
   errors when we've not enabled the RAS cpufeature due to mixed support on a
   big-little system.
 * Moved KVM SError handling into handle_exit_early(), which is called before
   we are preemptible so that we can use the local-cpu-cap helpers. We can't
   make handle_exit() non-preemptible as the WFE/WFI handlers yield/reschedule.
   The SError handling code here will need to mmove to before we unmask
   SError to support kernel-first, hence its grouped together now.
   The use of local-cpu-caps makes the KVM support a little odd as SError taken
   from EL2 depends on the global feature, as it uses alternatives to store the
   DISR. Whereas the SError taken from EL1 depends on the local cpu support.
   Where these are different, we are going to assume SError taken from EL2 are
   impdef.


Thanks,

James

Dongjiu Geng (1):
  KVM: arm64: Emulate RAS error registers and set HCR_EL2's TERR & TEA

James Morse (11):
  arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
  arm64: sysreg: Move to use definitions for all the SCTLR bits
  arm64: kernel: Survive corrected RAS errors notified by SError
  arm64: Unconditionally enable IESB on exception entry/return for
    firmware-first
  arm64: kernel: Prepare for a DISR user
  KVM: arm/arm64: mask/unmask daif around VHE guests
  KVM: arm64: Set an impdef ESR for Virtual-SError using VSESR_EL2.
  KVM: arm64: Save/Restore guest DISR_EL1
  KVM: arm64: Save ESR_EL2 on guest SError
  KVM: arm64: Handle RAS SErrors from EL1 on guest exit
  KVM: arm64: Handle RAS SErrors from EL2 on guest exit

Xie XiuQi (1):
  arm64: cpufeature: Detect CPU RAS Extentions

 arch/arm/include/asm/kvm_host.h      |  5 +++
 arch/arm64/Kconfig                   | 16 +++++++
 arch/arm64/include/asm/assembler.h   |  7 ++++
 arch/arm64/include/asm/cpucaps.h     |  3 +-
 arch/arm64/include/asm/esr.h         | 20 +++++++++
 arch/arm64/include/asm/exception.h   | 14 +++++++
 arch/arm64/include/asm/kvm_arm.h     |  2 +
 arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++
 arch/arm64/include/asm/kvm_host.h    | 17 ++++++++
 arch/arm64/include/asm/processor.h   |  1 +
 arch/arm64/include/asm/sysreg.h      | 81 +++++++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/traps.h       | 54 ++++++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kernel/cpufeature.c       | 26 +++++++++++-
 arch/arm64/kernel/head.S             | 13 ++----
 arch/arm64/kernel/traps.c            | 51 ++++++++++++++++++++---
 arch/arm64/kvm/handle_exit.c         | 32 +++++++++++++-
 arch/arm64/kvm/hyp/entry.S           | 13 ++++++
 arch/arm64/kvm/hyp/switch.c          | 12 ++++--
 arch/arm64/kvm/hyp/sysreg-sr.c       |  6 +++
 arch/arm64/kvm/inject_fault.c        | 13 +++++-
 arch/arm64/kvm/sys_regs.c            | 11 +++++
 arch/arm64/mm/proc.S                 | 29 +++----------
 virt/kvm/arm/arm.c                   |  7 ++++
 24 files changed, 402 insertions(+), 49 deletions(-)

-- 
2.15.0
