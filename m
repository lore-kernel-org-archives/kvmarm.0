From: Dave Martin <Dave.Martin@arm.com>
Subject: [PULL v8] KVM: arm64: Optimise FPSIMD context switching
Date: Wed, 16 May 2018 11:49:42 +0100
Message-ID: <20180516104942.GS7753@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

This is a trivial update to the previously posted v7 [1].  The only
changes are a couple of minor cosmetic changes requested by reviewers,
on-list and the addition of Acked-by/Reviewed-by tags received since the
series was posted.

Let me know if you need anything else on this.

Cheers
---Dave

[1] [PATCH v7 00/16] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/576595.html


The following changes since commit 6da6c0db5316275015e8cc2959f12a17584aeb64:

  Linux v4.17-rc3 (2018-04-29 14:17:42 -0700)

are available in the git repository at:

  git://linux-arm.org/linux-dm.git 

for you to fetch changes up to 90255dd95fe71a9bd1c4ce728abad4b0eec240d9:

  KVM: arm64: Invoke FPSIMD context switch trap from C (2018-05-16 10:44:00 +0100)

----------------------------------------------------------------
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

 arch/arm/include/asm/kvm_host.h     |   9 ++-
 arch/arm64/Kconfig                  |   7 ++
 arch/arm64/include/asm/cpufeature.h |  29 -------
 arch/arm64/include/asm/fpsimd.h     |  21 ++++++
 arch/arm64/include/asm/kvm_asm.h    |   3 -
 arch/arm64/include/asm/kvm_host.h   |  32 +++++---
 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/kernel/fpsimd.c          | 147 +++++++++++++++++++-----------------
 arch/arm64/kernel/ptrace.c          |   1 +
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/debug.c              |   8 +-
 arch/arm64/kvm/fpsimd.c             | 111 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c       |   6 +-
 arch/arm64/kvm/hyp/entry.S          |  43 -----------
 arch/arm64/kvm/hyp/hyp-entry.S      |  19 -----
 arch/arm64/kvm/hyp/switch.c         | 124 ++++++++++++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c      |   4 +-
 arch/arm64/kvm/sys_regs.c           |   9 +--
 include/linux/kvm_host.h            |   9 +++
 include/linux/sched.h               |   6 ++
 include/linux/thread_info.h         |  11 +++
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/arm/arm.c                  |  25 +++++-
 virt/kvm/kvm_main.c                 |   7 +-
 25 files changed, 406 insertions(+), 233 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c
