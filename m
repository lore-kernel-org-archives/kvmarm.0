From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 00/14] KVM: arm64: Optimise FPSIMD context switching
Date: Fri,  4 May 2018 17:05:21 +0100
Message-ID: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Note: Most of these patches are Arm-specific.  People not Cc'd on the
whole series can find it in the linux-arm-kernel archive [3].

This series aims to improve the way FPSIMD context is handled by KVM,
building on the previous RFC v4 [1].

Patches 1-2 are picked from a separate RFC series [2] since they
introduce a helper I wanted to use here.


The main changes since RFC v4 are:

 * Rebased to -rc3.

 * Patches 1-2 pulled into series from [2], and other patches modified
   to use it.

 * Redundant additions by patch 3 that were reverted by other patches
   are now gone.

 * New patches 12-14 move the call to __hyp_switch_fpsimd() out of asm
   completely, moving it to the fixup_guest_exit() path instead.  This
   should significantly cleaner, but does add a bit of overhead to
   FPSIMD trapping.

   This is presented as an independent change in case people want to
   benchmark with/without.


Other minor changes as noted.


Some testing done on Juno and the Arm fast model (arm64), including
combinations of (non-)SVE and (non-)VHE configurations.

Cheers
---Dave

[1] [RFC PATCH 0/8] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-April/572781.html

[2] [RFC PATCH 0/6] Simplify setting thread flags to a particular value
https://lkml.org/lkml/2018/4/19/225

[3] linux-arm-kernel archive
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/thread.html


Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (13):
  thread_info: Add update_thread_flag() helpers
  arm64: Use update{,_tsk}_thread_flag()
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  arm64: fpsimd: Generalise context saving for non-task contexts
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
 arch/arm64/Kconfig                  |   7 +++
 arch/arm64/include/asm/cpufeature.h |  29 ---------
 arch/arm64/include/asm/fpsimd.h     |  20 ++++++
 arch/arm64/include/asm/kvm_host.h   |  22 ++++---
 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/kernel/fpsimd.c          | 120 +++++++++++++++++------------------
 arch/arm64/kernel/ptrace.c          |   1 +
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/fpsimd.c             | 105 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S          |  43 -------------
 arch/arm64/kvm/hyp/hyp-entry.S      |  19 ------
 arch/arm64/kvm/hyp/switch.c         | 121 +++++++++++++++++++++++++-----------
 include/linux/kvm_host.h            |   9 +++
 include/linux/sched.h               |   6 ++
 include/linux/thread_info.h         |  11 ++++
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/arm/arm.c                  |  25 +++++++-
 virt/kvm/kvm_main.c                 |   7 ++-
 20 files changed, 360 insertions(+), 202 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c

-- 
2.1.4
