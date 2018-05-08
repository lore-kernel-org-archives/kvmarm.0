From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 00/15] KVM: arm64: Optimise FPSIMD context switching
Date: Tue,  8 May 2018 17:44:45 +0100
Message-ID: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Note: Most of these patches are Arm-specific.  People not Cc'd on the
whole series can find it in the linux-arm-kernel archive [3].

This series aims to improve the way FPSIMD context is handled by KVM.
Only minor changes have been made since the previous v5 [1].
The changes are summarised in the individual patches.

Patch 6 is new, and does some simple refactoring to enable new bits to
be added to an existing vcpu_arch flags field.

Patches 1, 2, 6, 7 and 14 are still missing Reviewed-bys/Acked-bys, so
reviewer attention on these patches would be much appreciated.


Some testing done on Juno and the Arm fast model (arm64), including
(on earlier versions of the patches) combinations of (non-)SVE and
(non-)VHE configurations.

Cheers
---Dave

[1] [PATCH v5 00/14] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/575805.html

[2] [RFC PATCH 0/6] Simplify setting thread flags to a particular value
https://lkml.org/lkml/2018/4/19/225

[3] linux-arm-kernel archive
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/thread.html


Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (14):
  thread_info: Add update_thread_flag() helpers
  arm64: Use update{,_tsk}_thread_flag()
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  arm64: fpsimd: Generalise context saving for non-task contexts
  KVM: arm64: Repurpose vcpu_arch.debug_flags for general-purpose flags
  KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing
  arm64/sve: Move read_zcr_features() out of cpufeature.h
  arm64/sve: Switch sve_pffr() argument from task to thread
  arm64/sve: Move sve_pffr() to fpsimd.h and make inline
  KVM: arm64: Save host SVE context as appropriate
  KVM: arm64: Remove eager host SVE state saving
  KVM: arm64: Remove redundant *exit_code changes in fpsimd_guest_exit()
  KVM: arm64: Fold redundant exit code checks out of fixup_guest_exit()
  KVM: arm64: Invoke FPSIMD context switch trap from C

 arch/arm/include/asm/kvm_host.h     |   9 ++-
 arch/arm64/Kconfig                  |   7 ++
 arch/arm64/include/asm/cpufeature.h |  29 ---------
 arch/arm64/include/asm/fpsimd.h     |  20 ++++++
 arch/arm64/include/asm/kvm_asm.h    |   3 +
 arch/arm64/include/asm/kvm_host.h   |  24 ++++---
 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/kernel/fpsimd.c          | 120 ++++++++++++++++++-----------------
 arch/arm64/kernel/ptrace.c          |   1 +
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/debug.c              |   8 +--
 arch/arm64/kvm/fpsimd.c             | 110 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c       |   6 +-
 arch/arm64/kvm/hyp/entry.S          |  43 -------------
 arch/arm64/kvm/hyp/hyp-entry.S      |  19 ------
 arch/arm64/kvm/hyp/switch.c         | 123 +++++++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/sysreg-sr.c      |   4 +-
 arch/arm64/kvm/sys_regs.c           |   8 +--
 include/linux/kvm_host.h            |   9 +++
 include/linux/sched.h               |   6 ++
 include/linux/thread_info.h         |  11 ++++
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/arm/arm.c                  |  25 +++++++-
 virt/kvm/kvm_main.c                 |   7 +-
 25 files changed, 383 insertions(+), 217 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c

-- 
2.1.4
