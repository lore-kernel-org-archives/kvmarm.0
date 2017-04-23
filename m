From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 00/79] KVM/ARM Changes for v4.12
Date: Sun, 23 Apr 2017 19:08:10 +0200
Message-ID: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D374149C3A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kjFtQtXsaNdo for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:45 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9DD349C2C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:44 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id r190so4710412wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:31 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here are the changes for KVM/ARM for v4.12 so far.  I may send another
pull request next week with the ITS save/restore patches if we feel they
are ready.  The ABI part of the ITS save/restore patches has matured for
a while so we just need to make sure on the implementation bits.

Note that this pull request shares a common base branch with the arm64
tree which has already been pulled by the arm64 folks into their
for-next/core branch.

As for these changes, they include:
 - Using the common sysreg definitions between KVM and arm64
 - Improved hyp-stub implementation with support for kexec and kdump on the 32-bit side
 - Proper PMU exception handling
 - Performance improvements of our GIC handling
 - Support for irqchip in userspace with in-kernel arch-timers and PMU support
 - A fix for a race condition in our PSCI code


The following changes since commit 97da3854c526d3a6ee05c849c96e48d21527606c:

  Linux 4.11-rc3 (2017-03-19 19:09:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.12

for you to fetch changes up to 1edb632133efb6226b6bef3e7d9fa8c7134ac4e2:

  ARM: KVM: Fix idmap stub entry when running Thumb-2 code (2017-04-20 20:17:57 +0200)

Thanks,
-Christoffer

---

Alexander Graf (2):
  KVM: arm/arm64: Add ARM user space interrupt signaling ABI
  KVM: arm/arm64: Support arch timers with a userspace gic

Andrew Jones (1):
  KVM: arm/arm64: fix races in kvm_psci_vcpu_on

Christoffer Dall (12):
  KVM: arm/arm64: vgic: Defer touching GICH_VMCR to vcpu_load/put
  KVM: arm/arm64: vgic: Get rid of live_lrs
  KVM: arm/arm64: vgic: Only set underflow when actually out of LRs
  KVM: arm/arm64: vgic: Get rid of unnecessary process_maintenance
    operation
  KVM: arm/arm64: vgic: Get rid of unnecessary save_maint_int_state
  KVM: arm/arm64: vgic: Get rid of MISR and EISR fields
  KVM: arm/arm64: vgic: Implement early VGIC init functionality
  KVM: arm/arm64: vgic: Don't check vgic_initialized in sync/flush
  KVM: arm/arm64: vgic: Improve sync_hwstate performance
  KVM: arm/arm64: Cleanup the arch timer code's irqchip checking
  KVM: arm/arm64: Report PMU overflow interrupts to userspace irqchip
  KVM: arm/arm64: Advertise support for KVM_CAP_ARM_USER_IRQ

Marc Zyngier (45):
  arm64: KVM: PMU: Refactor pmu_*_el0_disabled
  arm64: KVM: PMU: Inject UNDEF exception on illegal register access
  arm64: KVM: PMU: Inject UNDEF on non-privileged accesses
  arm64: KVM: Make unexpected reads from WO registers inject an undef
  arm64: KVM: PMU: Inject UNDEF on read access to PMSWINC_EL0
  arm64: KVM: Treat sysreg accessors returning false as successful
  arm64: KVM: Do not corrupt registers on failed 64bit CP read
  arm: KVM: Make unexpected register accesses inject an undef
  arm: KVM: Treat CP15 accessors returning false as successful
  arm64: hyp-stub: Stop pointlessly clobbering lr
  arm64: KVM: Move lr save/restore to do_el2_call
  arm64: hyp-stub: Don't save lr in the EL1 code
  arm64: hyp-stub: Define a return value for failed stub calls
  arm64: hyp-stub: Update documentation in asm/virt.h
  arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init
    code
  arm64: KVM: Implement HVC_GET_VECTORS in the init code
  arm64: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  arm64: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Convert KVM to use HVC_GET_VECTORS
  ARM: Update cpu_v7_reset documentation
  ARM: hyp-stub: Use r1 for the soft-restart address
  ARM: Expose the VA/IDMAP offset
  ARM: hyp-stub: Define a return value for failed stub calls
  ARM: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init code
  ARM: KVM: Implement HVC_GET_VECTORS in the init code
  ARM: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  ARM: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  ARM: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Gracefully handle hyp-stubs being restored from under our
    feet
  arm/arm64: KVM: Use __hyp_reset_vectors() directly
  arm/arm64: KVM: Remove kvm_get_idmap_start
  arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP mode
  ARM: decompressor: Remove __hyp_get_vectors usage
  ARM: hyp-stub/KVM: Kill __hyp_get_vectors
  arm64: hyp-stub/KVM: Kill __hyp_get_vectors
  arm64: hyp-stub: Zero x0 on successful stub handling
  ARM: hyp-stub: Zero r0 on successful stub handling
  arm/arm64: Add hyp-stub API documentation
  KVM: arm/arm64: vgic-v3: De-optimize VMCR save/restore when emulating
    a GICv2
  KVM: arm/arm64: vgic-v3: Fix off-by-one LR access
  ARM: hyp-stub: Fix Thumb-2 compilation
  ARM: KVM: Fix idmap stub entry when running Thumb-2 code

Mark Rutland (15):
  arm64: sysreg: sort by encoding
  arm64: sysreg: add debug system registers
  arm64: sysreg: add performance monitor registers
  arm64: sysreg: subsume GICv3 sysreg definitions
  arm64: sysreg: add physical timer registers
  arm64: sysreg: add register encodings used by KVM
  arm64: sysreg: add Set/Way sys encodings
  KVM: arm64: add SYS_DESC()
  KVM: arm64: Use common debug sysreg definitions
  KVM: arm64: Use common performance monitor sysreg definitions
  KVM: arm64: Use common GICv3 sysreg definitions
  KVM: arm64: Use common physical timer sysreg definitions
  KVM: arm64: use common invariant sysreg definitions
  KVM: arm64: Use common sysreg definitions
  KVM: arm64: Use common Set/Way sys definitions

Russell King (2):
  ARM: hyp-stub: improve ABI
  ARM: soft-reboot into same mode that we entered the kernel

Shih-Wei Li (1):
  KVM: arm/arm64: vgic: Avoid flushing vgic state when there's no
    pending IRQ

Suzuki K Poulose (1):
  kvm: arm/arm64: Rework gpa callback handlers


 Documentation/virtual/kvm/api.txt         |  42 +++
 Documentation/virtual/kvm/arm/hyp-abi.txt |  53 ++++
 arch/arm/boot/compressed/head.S           |  12 +-
 arch/arm/include/asm/kvm_asm.h            |   7 +-
 arch/arm/include/asm/kvm_host.h           |   6 -
 arch/arm/include/asm/kvm_mmu.h            |   1 -
 arch/arm/include/asm/proc-fns.h           |   4 +-
 arch/arm/include/asm/virt.h               |  14 +-
 arch/arm/include/uapi/asm/kvm.h           |   2 +
 arch/arm/kernel/hyp-stub.S                |  43 ++-
 arch/arm/kernel/reboot.c                  |   7 +-
 arch/arm/kvm/arm.c                        |  66 ++--
 arch/arm/kvm/coproc.c                     |  24 +-
 arch/arm/kvm/coproc.h                     |  18 --
 arch/arm/kvm/handle_exit.c                |   8 +
 arch/arm/kvm/hyp/hyp-entry.S              |  28 +-
 arch/arm/kvm/init.S                       |  51 ++-
 arch/arm/kvm/interrupts.S                 |   4 -
 arch/arm/kvm/mmu.c                        |  36 +--
 arch/arm/kvm/psci.c                       |   8 +-
 arch/arm/mm/mmu.c                         |   5 +
 arch/arm/mm/proc-v7.S                     |  15 +-
 arch/arm64/include/asm/arch_gicv3.h       |  81 +----
 arch/arm64/include/asm/kvm_asm.h          |   5 +-
 arch/arm64/include/asm/kvm_host.h         |   7 -
 arch/arm64/include/asm/kvm_mmu.h          |   1 -
 arch/arm64/include/asm/sysreg.h           | 162 +++++++++-
 arch/arm64/include/asm/virt.h             |  31 +-
 arch/arm64/include/uapi/asm/kvm.h         |   2 +
 arch/arm64/kernel/head.S                  |   8 +-
 arch/arm64/kernel/hyp-stub.S              |  38 +--
 arch/arm64/kvm/hyp-init.S                 |  46 ++-
 arch/arm64/kvm/hyp.S                      |   5 +-
 arch/arm64/kvm/hyp/hyp-entry.S            |  43 ++-
 arch/arm64/kvm/sys_regs.c                 | 496 +++++++++++-------------------
 arch/arm64/kvm/sys_regs.h                 |  23 +-
 arch/arm64/kvm/sys_regs_generic_v8.c      |   4 +-
 include/kvm/arm_arch_timer.h              |   2 +
 include/kvm/arm_pmu.h                     |   7 +
 include/kvm/arm_vgic.h                    |   9 +-
 include/uapi/linux/kvm.h                  |   8 +
 virt/kvm/arm/arch_timer.c                 | 124 ++++++--
 virt/kvm/arm/hyp/vgic-v2-sr.c             |  78 +----
 virt/kvm/arm/hyp/vgic-v3-sr.c             |  87 ++----
 virt/kvm/arm/pmu.c                        |  39 ++-
 virt/kvm/arm/vgic/vgic-init.c             | 108 ++++---
 virt/kvm/arm/vgic/vgic-v2.c               |  90 +++---
 virt/kvm/arm/vgic/vgic-v3.c               |  87 +++---
 virt/kvm/arm/vgic/vgic.c                  |  60 +++-
 virt/kvm/arm/vgic/vgic.h                  |   8 +-
 50 files changed, 1175 insertions(+), 938 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt
