From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM updates for 4.18
Date: Fri,  1 Jun 2018 16:27:14 +0100
Message-ID: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F9E4A12F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:17:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fHJEjWa2kLzZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:17:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2719F4A0FE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:17:07 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the set of updates for KVM/ARM for v4.18. This time, lazy
context switching of the floating point registers for arm64, and the
ability to deal with multiple redistributor ranges (which allows for
larger numbers of vcpu).

Note that some additional KVM/ARM updates will come via the arm64 tree
with the SSBD patches. This will generate three conflicts that are
pretty simple to resolve (-next has a good example of the resolution).

Please pull,

	M.

The following changes since commit 75bc37fefc4471e718ba8e651aa74673d4e0a9eb:

  Linux 4.17-rc4 (2018-05-06 16:57:38 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v4.18

for you to fetch changes up to e25028c8ded011d19f9a11164807507c94febc01:

  KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512 (2018-05-25 12:29:27 +0100)

----------------------------------------------------------------
KVM/ARM updates for 4.18

- Lazy context-switching of FPSIMD registers on arm64
- Allow virtual redistributors to be part of two or more MMIO ranges

----------------------------------------------------------------
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

Eric Auger (13):
      KVM: arm/arm64: Set dist->spis to NULL after kfree
      KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
      KVM: arm/arm64: Replace the single rdist region by a list
      KVM: arm/arm64: Helper to locate free rdist index
      KVM: arm/arm64: Revisit Redistributor TYPER last bit computation
      KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
      KVM: arm/arm64: Helper to register a new redistributor region
      KVM: arm/arm64: Remove kvm_vgic_vcpu_early_init
      KVM: arm/arm64: Check vcpu redist base before registering an iodev
      KVM: arm/arm64: Check all vcpu redistributors are set on map_resources
      KVM: arm/arm64: Add KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
      KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
      KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to 512

Mark Rutland (1):
      arm64: KVM: Use lm_alias() for kvm_ksym_ref()

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  30 +++-
 arch/arm/include/asm/kvm_host.h                   |  10 +-
 arch/arm/include/uapi/asm/kvm.h                   |   1 +
 arch/arm64/Kconfig                                |   7 +
 arch/arm64/include/asm/cpufeature.h               |  29 ----
 arch/arm64/include/asm/fpsimd.h                   |  21 +++
 arch/arm64/include/asm/kvm_asm.h                  |   8 +-
 arch/arm64/include/asm/kvm_host.h                 |  45 ++++--
 arch/arm64/include/asm/processor.h                |  15 +-
 arch/arm64/include/asm/thread_info.h              |  13 +-
 arch/arm64/include/uapi/asm/kvm.h                 |   1 +
 arch/arm64/kernel/fpsimd.c                        | 177 +++++++++++-----------
 arch/arm64/kernel/ptrace.c                        |   1 +
 arch/arm64/kvm/Kconfig                            |   1 +
 arch/arm64/kvm/Makefile                           |   2 +-
 arch/arm64/kvm/debug.c                            |   8 +-
 arch/arm64/kvm/fpsimd.c                           | 110 ++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c                     |   6 +-
 arch/arm64/kvm/hyp/entry.S                        |  43 ------
 arch/arm64/kvm/hyp/hyp-entry.S                    |  19 ---
 arch/arm64/kvm/hyp/switch.c                       | 124 ++++++++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c                    |   4 +-
 arch/arm64/kvm/sys_regs.c                         |   9 +-
 include/kvm/arm_vgic.h                            |  17 ++-
 include/linux/kvm_host.h                          |   9 ++
 include/linux/sched.h                             |   6 +
 include/linux/thread_info.h                       |  11 ++
 virt/kvm/Kconfig                                  |   3 +
 virt/kvm/arm/arm.c                                |  15 +-
 virt/kvm/arm/vgic/vgic-init.c                     | 100 ++++++------
 virt/kvm/arm/vgic/vgic-kvm-device.c               |  53 ++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 112 ++++++++++++--
 virt/kvm/arm/vgic/vgic-v3.c                       |  99 +++++++++---
 virt/kvm/arm/vgic/vgic.h                          |  42 ++++-
 virt/kvm/kvm_main.c                               |   7 +-
 35 files changed, 809 insertions(+), 349 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c
