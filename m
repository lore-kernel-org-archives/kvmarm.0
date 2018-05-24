From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v11 00/19] KVM: arm64: Optimise FPSIMD context switching
Date: Thu, 24 May 2018 17:56:29 +0100
Message-ID: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Note: Most of these patches are Arm-specific.  People not Cc'd on the
whole series can find it in the linux-arm-kernel archive [2].

Git: see [3]

This series aims to improve the way FPSIMD context is handled by KVM.
Changes since the previous v10 [1] are minor, but one patch has been
split.

** To Catalin Marinas, Alex Bennée: **

I have retained your Reviewed-bys on patches 7 and 8: these were split
from patch 7 of v9.  Although the code is (almost) the same as noted
below, I advise you to take a look.

(all) reviewers please note:

 * Patches 7 and 8 have been split from the previous patch 7, since
   the update to INIT_THREAD_INFO is logically a fix and deserves
   a Fixes: tag.

   I have also moved the definition of INIT_THREAD_INFO to after the
   TIF_* definitions that it now depends on (mysteriously this wasn't
   causing a compile error anyway, but I've not dug into why).

 * Other changes are all additions or rewordings of comments, and
   amendments commit messages.

Cheers
---Dave

[1] [PATCH v10 00/18] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/579899.html

[2] linux-arm-kernel archive
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/thread.html

[3] http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/kvm-vhe-fpsimd/v11

Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (18):
  arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after invalidating cpu regs
  thread_info: Add update_thread_flag() helpers
  arm64: Use update{,_tsk}_thread_flag()
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  arm64: fpsimd: Generalise context saving for non-task contexts
  arm64: fpsimd: Avoid FPSIMD context leakage for the init task
  arm64: fpsimd: Eliminate task->mm checks
  arm64/sve: Refactor user SVE trap maintenance for external use
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

 arch/arm/include/asm/kvm_host.h      |  10 +-
 arch/arm64/Kconfig                   |   7 ++
 arch/arm64/include/asm/cpufeature.h  |  29 ------
 arch/arm64/include/asm/fpsimd.h      |  21 +++++
 arch/arm64/include/asm/kvm_asm.h     |   3 -
 arch/arm64/include/asm/kvm_host.h    |  45 +++++++--
 arch/arm64/include/asm/processor.h   |  15 ++-
 arch/arm64/include/asm/thread_info.h |  13 +--
 arch/arm64/kernel/fpsimd.c           | 177 +++++++++++++++++------------------
 arch/arm64/kernel/ptrace.c           |   1 +
 arch/arm64/kvm/Kconfig               |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/debug.c               |   8 +-
 arch/arm64/kvm/fpsimd.c              | 110 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c        |   6 +-
 arch/arm64/kvm/hyp/entry.S           |  43 ---------
 arch/arm64/kvm/hyp/hyp-entry.S       |  19 ----
 arch/arm64/kvm/hyp/switch.c          | 124 ++++++++++++++++--------
 arch/arm64/kvm/hyp/sysreg-sr.c       |   4 +-
 arch/arm64/kvm/sys_regs.c            |   9 +-
 include/linux/kvm_host.h             |   9 ++
 include/linux/sched.h                |   6 ++
 include/linux/thread_info.h          |  11 +++
 virt/kvm/Kconfig                     |   3 +
 virt/kvm/arm/arm.c                   |  14 ++-
 virt/kvm/kvm_main.c                  |   7 +-
 26 files changed, 437 insertions(+), 260 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c

-- 
2.1.4
