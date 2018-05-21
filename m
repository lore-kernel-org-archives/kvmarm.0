From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v9 00/16] KVM: arm64: Optimise FPSIMD context switching
Date: Mon, 21 May 2018 15:17:01 +0100
Message-ID: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Note: Most of these patches are Arm-specific.  People not Cc'd on the
whole series can find it in the linux-arm-kernel archive [2].

This series aims to improve the way FPSIMD context is handled by KVM.
Only minor changes have been made since the previous v8 [1], though
this posting does apply a couple of fixes.

This is a minor update to fix a couple of build breaks introduced late
in the evolution of the series. [3] [4]

There is also an unexplained NULL-dereference bug observed by Marc on
ESPRESSOBin [5] that I need to look into.  We've not been able to
reproduce this so far.

In the meantime, this post will give people an opportunity to look over
the current changes.


The changes are summarised in the individual patches.

Reviewers please note:

 * **Only patches 8 and 12** have changed since v8.

 * I have stripped tags from patch 12 due to the introduction of a new
   source file, which may not be the best approach.

   If Christoffer, Marc and Catalin could take another look that
   would be much appreciated.

Cheers
---Dave

[1] [PULL v8] KVM: arm64: Optimise FPSIMD context switching
lists.infradead.org/pipermail/linux-arm-kernel/2018-May/578184.html

[2] linux-arm-kernel archive
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/thread.html

[3] [kvmarm:queue 9/29] arch/arm/kvm/../../../virt/kvm/arm/arm.c:783:3: error: implicit declaration of function 'kvm_arch_vcpu_ctxsync_fp'; did you mean 'kvm_arch_vcpu_put_fp'?
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/579400.html

[4] [kvmarm:queue 13/29] arch/arm/kvm/../../../virt/kvm/arm/arm.c:1598:6: error: implicit declaration of function 'system_supports_sve'
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/579399.html

[5] [PULL v8] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/579353.html


Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (15):
  thread_info: Add update_thread_flag() helpers
  arm64: Use update{,_tsk}_thread_flag()
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  arm64: fpsimd: Generalise context saving for non-task contexts
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

 arch/arm/include/asm/kvm_host.h     |  10 ++-
 arch/arm64/Kconfig                  |   7 ++
 arch/arm64/include/asm/cpufeature.h |  29 -------
 arch/arm64/include/asm/fpsimd.h     |  21 ++++++
 arch/arm64/include/asm/kvm_asm.h    |   3 -
 arch/arm64/include/asm/kvm_host.h   |  33 +++++---
 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/kernel/fpsimd.c          | 147 +++++++++++++++++++-----------------
 arch/arm64/kernel/ptrace.c          |   1 +
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/Makefile             |   4 +-
 arch/arm64/kvm/debug.c              |   8 +-
 arch/arm64/kvm/fpsimd.c             | 111 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c       |   6 +-
 arch/arm64/kvm/hyp/entry.S          |  43 -----------
 arch/arm64/kvm/hyp/hyp-entry.S      |  19 -----
 arch/arm64/kvm/hyp/switch.c         | 124 ++++++++++++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c      |   4 +-
 arch/arm64/kvm/init.c               |  33 ++++++++
 arch/arm64/kvm/sys_regs.c           |   9 +--
 include/linux/kvm_host.h            |   9 +++
 include/linux/sched.h               |   6 ++
 include/linux/thread_info.h         |  11 +++
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/arm/arm.c                  |  13 +++-
 virt/kvm/kvm_main.c                 |   7 +-
 26 files changed, 430 insertions(+), 234 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c
 create mode 100644 arch/arm64/kvm/init.c

-- 
2.1.4
