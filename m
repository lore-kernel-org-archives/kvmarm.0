From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for 4.6
Date: Wed,  9 Mar 2016 07:29:54 +0000
Message-ID: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F010412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:31:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Cph4fT6V3zr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:31:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45769410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:31:45 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

Please find below the KVM/ARM updates for 4.6. As you can tell by the
explosion of your mailbox, we've been fairly busy lately.

Most notable things are PMU support for guests, as well as the v8.1
VHE support. Other than that, the 32bit port went under the knife just
like we did for the 64bit port in 4.5, rewriting most of the assembly
code in C for ease of maintenance as well as code sharing. Finally, a
handful of optimizations that do speed up the world switch.

Please note that:
- the series is on top of 4.5-rc6 in order to avoid ugly conflicts
with the fixes that went in during the 4.5 cycle
- there is still quite a few conflicts with the arm64 tree that should
be resolved just like it has been done in linux-next

Thanks!

	M.

The following changes since commit fc77dbd34c5c99bce46d40a2491937c3bcbd10af:

  Linux 4.5-rc6 (2016-02-28 08:41:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-4.6

for you to fetch changes up to b40c4892d175874d118860c8282a85ee7b64bcbb:

  arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit (2016-03-09 04:24:16 +0000)

----------------------------------------------------------------
KVM/ARM updates for 4.6

- VHE support so that we can run the kernel at EL2 on ARMv8.1 systems
- PMU support for guests
- 32bit world switch rewritten in C
- Various optimizations to the vgic save/restore code

----------------------------------------------------------------
Marc Zyngier (76):
      arm/arm64: KVM: Add hook for C-based stage2 init
      ARM: KVM: Move the  HYP code to its own section
      ARM: KVM: Remove __kvm_hyp_code_start/__kvm_hyp_code_end
      ARM: KVM: Move VFP registers to a CPU context structure
      ARM: KVM: Move CP15 array into the CPU context structure
      ARM: KVM: Move GP registers into the CPU context structure
      ARM: KVM: Add a HYP-specific header file
      ARM: KVM: Add system register accessor macros
      ARM: KVM: Add TLB invalidation code
      ARM: KVM: Add CP15 save/restore code
      ARM: KVM: Add timer save/restore
      ARM: KVM: Add vgic v2 save/restore
      ARM: KVM: Add VFP save/restore
      ARM: KVM: Add banked registers save/restore
      ARM: KVM: Add guest entry code
      ARM: KVM: Add VFP lazy save/restore handler
      ARM: KVM: Add the new world switch implementation
      ARM: KVM: Add populating of fault data structure
      ARM: KVM: Add HYP mode entry code
      ARM: KVM: Add panic handling code
      ARM: KVM: Change kvm_call_hyp return type to unsigned long
      ARM: KVM: Remove the old world switch
      ARM: KVM: Switch to C-based stage2 init
      ARM: KVM: Remove __weak attributes
      ARM: KVM: Turn CP15 defines to an enum
      ARM: KVM: Cleanup asm-offsets.c
      ARM: KVM: Remove unused hyp_pc field
      ARM: KVM: Remove handling of ARM_EXCEPTION_DATA/PREF_ABORT
      ARM: KVM: Remove __kvm_hyp_exit/__kvm_hyp_exit_end
      arm/arm64: KVM: Handle out-of-RAM cache maintenance as a NOP
      arm64: KVM: Switch to C-based stage2 init
      arm/arm64: Add new is_kernel_in_hyp_mode predicate
      arm64: Allow the arch timer to use the HYP timer
      arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
      arm64: KVM: Skip HYP setup when already running in HYP
      arm64: KVM: VHE: Patch out use of HVC
      arm64: KVM: VHE: Patch out kern_hyp_va
      arm64: KVM: VHE: Introduce unified system register accessors
      arm64: KVM: VHE: Differenciate host/guest sysreg save/restore
      arm64: KVM: VHE: Split save/restore of registers shared between guest and host
      arm64: KVM: VHE: Use unified system register accessors
      arm64: KVM: VHE: Enable minimal sysreg save/restore
      arm64: KVM: VHE: Make __fpsimd_enabled VHE aware
      arm64: KVM: VHE: Implement VHE activate/deactivate_traps
      arm64: KVM: VHE: Use unified sysreg accessors for timer
      arm64: KVM: VHE: Add fpsimd enabling on guest access
      arm64: KVM: VHE: Add alternative panic handling
      arm64: KVM: Move most of the fault decoding to C
      arm64: perf: Count EL2 events if the kernel is running in HYP
      arm64: hw_breakpoint: Allow EL2 breakpoints if running in HYP
      arm64: VHE: Add support for running Linux in EL2 mode
      arm64: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
      arm64: KVM: Move vgic-v2 and timer save/restore to virt/kvm/arm/hyp
      ARM: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
      ARM: KVM: Use common version of vgic-v2-sr.c
      ARM: KVM: Use common version of timer-sr.c
      arm64: KVM: Move __cpu_init_stage2 after kvm_call_hyp
      arm64: KVM: Add temporary kvm_perf_event.h
      arm64: KVM: Switch the sys_reg search to be a binary search
      ARM: KVM: Properly sort the invariant table
      ARM: KVM: Enforce sorting of all CP tables
      ARM: KVM: Rename struct coproc_reg::is_64 to is_64bit
      ARM: KVM: Switch the CP reg search to be a binary search
      KVM: arm/arm64: timer: Add active state caching
      KVM: arm/arm64: vgic-v2: Avoid accessing GICH registers
      KVM: arm/arm64: vgic-v2: Save maintenance interrupt state only if required
      KVM: arm/arm64: vgic-v2: Move GICH_ELRSR saving to its own function
      KVM: arm/arm64: vgic-v2: Do not save an LR known to be empty
      KVM: arm/arm64: vgic-v2: Reset LRs at boot time
      KVM: arm/arm64: vgic-v2: Only wipe LRs on vcpu exit
      KVM: arm/arm64: vgic-v2: Make GICD_SGIR quicker to hit
      arm64: KVM: vgic-v3: Avoid accessing ICH registers
      arm64: KVM: vgic-v3: Save maintenance interrupt state only if required
      arm64: KVM: vgic-v3: Do not save an LR known to be empty
      arm64: KVM: vgic-v3: Reset LRs at boot time
      arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit

Shannon Zhao (19):
      arm64: KVM: Define PMU data structure for each vcpu
      arm64: KVM: Add access handler for PMCR register
      arm64: KVM: Add access handler for PMSELR register
      arm64: KVM: Add access handler for PMCEID0 and PMCEID1 register
      arm64: KVM: Add access handler for event counter register
      arm64: KVM: Add access handler for PMCNTENSET and PMCNTENCLR register
      arm64: KVM: PMU: Add perf event map and introduce perf event creating function
      arm64: KVM: Add access handler for event type register
      arm64: KVM: Add access handler for PMINTENSET and PMINTENCLR register
      arm64: KVM: Add access handler for PMOVSSET and PMOVSCLR register
      arm64: KVM: Add access handler for PMSWINC register
      arm64: KVM: Add helper to handle PMCR register bits
      arm64: KVM: Add access handler for PMUSERENR register
      arm64: KVM: Add PMU overflow interrupt routing
      arm64: KVM: Reset PMU state when resetting vcpu
      arm64: KVM: Free perf event of PMU when destroying vcpu
      arm64: KVM: Add a new feature bit for PMUv3
      arm64: KVM: Introduce per-vcpu kvm device controls
      arm64: KVM: Add a new vcpu device control group for PMUv3

 Documentation/virtual/kvm/api.txt               |  12 +-
 Documentation/virtual/kvm/devices/vcpu.txt      |  33 ++
 arch/arm/include/asm/kvm_asm.h                  |  41 +-
 arch/arm/include/asm/kvm_emulate.h              |  20 +-
 arch/arm/include/asm/kvm_host.h                 |  80 ++-
 arch/arm/include/asm/kvm_hyp.h                  | 139 +++++
 arch/arm/include/asm/kvm_mmu.h                  |   2 +-
 arch/arm/include/asm/virt.h                     |   9 +
 arch/arm/kernel/asm-offsets.c                   |  40 +-
 arch/arm/kernel/vmlinux.lds.S                   |   6 +
 arch/arm/kvm/Makefile                           |   1 +
 arch/arm/kvm/arm.c                              | 244 ++++++---
 arch/arm/kvm/coproc.c                           | 126 +++--
 arch/arm/kvm/coproc.h                           |  24 +-
 arch/arm/kvm/emulate.c                          |  34 +-
 arch/arm/kvm/guest.c                            |   5 +-
 arch/arm/kvm/handle_exit.c                      |   7 -
 arch/arm/kvm/hyp/Makefile                       |  17 +
 arch/arm/kvm/hyp/banked-sr.c                    |  77 +++
 arch/arm/kvm/hyp/cp15-sr.c                      |  84 +++
 arch/arm/kvm/hyp/entry.S                        | 101 ++++
 arch/arm/kvm/hyp/hyp-entry.S                    | 169 ++++++
 arch/arm/kvm/hyp/s2-setup.c                     |  33 ++
 arch/arm/kvm/hyp/switch.c                       | 232 +++++++++
 arch/arm/kvm/hyp/tlb.c                          |  70 +++
 arch/arm/kvm/hyp/vfp.S                          |  68 +++
 arch/arm/kvm/init.S                             |   8 -
 arch/arm/kvm/interrupts.S                       | 480 +-----------------
 arch/arm/kvm/interrupts_head.S                  | 648 ------------------------
 arch/arm/kvm/mmu.c                              |  23 +
 arch/arm/kvm/reset.c                            |   2 +-
 arch/arm64/Kconfig                              |  13 +
 arch/arm64/include/asm/cpufeature.h             |   6 +-
 arch/arm64/include/asm/hw_breakpoint.h          |  18 +-
 arch/arm64/include/asm/kvm_arm.h                |   6 +-
 arch/arm64/include/asm/kvm_asm.h                |   6 +-
 arch/arm64/include/asm/kvm_emulate.h            |   8 +
 arch/arm64/include/asm/kvm_host.h               |  34 +-
 arch/arm64/include/asm/kvm_hyp.h                | 181 +++++++
 arch/arm64/include/asm/kvm_mmu.h                |  12 +-
 arch/arm64/include/asm/kvm_perf_event.h         |  68 +++
 arch/arm64/include/asm/virt.h                   |  10 +
 arch/arm64/include/uapi/asm/kvm.h               |   6 +
 arch/arm64/kernel/asm-offsets.c                 |   3 -
 arch/arm64/kernel/cpufeature.c                  |  11 +
 arch/arm64/kernel/head.S                        |  28 +-
 arch/arm64/kernel/perf_event.c                  |   6 +-
 arch/arm64/kvm/Kconfig                          |   7 +
 arch/arm64/kvm/Makefile                         |   1 +
 arch/arm64/kvm/guest.c                          |  51 ++
 arch/arm64/kvm/hyp-init.S                       |  15 +-
 arch/arm64/kvm/hyp.S                            |   7 +
 arch/arm64/kvm/hyp/Makefile                     |   8 +-
 arch/arm64/kvm/hyp/debug-sr.c                   |   4 +-
 arch/arm64/kvm/hyp/entry.S                      |   6 +
 arch/arm64/kvm/hyp/hyp-entry.S                  | 109 ++--
 arch/arm64/kvm/hyp/hyp.h                        |  90 ----
 arch/arm64/kvm/hyp/s2-setup.c                   |  43 ++
 arch/arm64/kvm/hyp/switch.c                     | 206 +++++++-
 arch/arm64/kvm/hyp/sysreg-sr.c                  | 149 ++++--
 arch/arm64/kvm/hyp/tlb.c                        |   2 +-
 arch/arm64/kvm/hyp/vgic-v2-sr.c                 |  84 ---
 arch/arm64/kvm/hyp/vgic-v3-sr.c                 | 341 ++++++++-----
 arch/arm64/kvm/reset.c                          |   7 +
 arch/arm64/kvm/sys_regs.c                       | 609 ++++++++++++++++++++--
 drivers/clocksource/arm_arch_timer.c            |  96 ++--
 include/kvm/arm_arch_timer.h                    |   5 +
 include/kvm/arm_pmu.h                           | 110 ++++
 include/kvm/arm_vgic.h                          |   8 +-
 include/uapi/linux/kvm.h                        |   2 +
 virt/kvm/arm/arch_timer.c                       |  31 ++
 {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c |  14 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c                   | 170 +++++++
 virt/kvm/arm/pmu.c                              | 529 +++++++++++++++++++
 virt/kvm/arm/vgic-v2-emul.c                     |  10 +-
 virt/kvm/arm/vgic-v2.c                          |  12 +
 virt/kvm/arm/vgic-v3.c                          |  11 +-
 77 files changed, 4023 insertions(+), 1965 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vcpu.txt
 create mode 100644 arch/arm/include/asm/kvm_hyp.h
 create mode 100644 arch/arm/kvm/hyp/Makefile
 create mode 100644 arch/arm/kvm/hyp/banked-sr.c
 create mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 create mode 100644 arch/arm/kvm/hyp/entry.S
 create mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 create mode 100644 arch/arm/kvm/hyp/s2-setup.c
 create mode 100644 arch/arm/kvm/hyp/switch.c
 create mode 100644 arch/arm/kvm/hyp/tlb.c
 create mode 100644 arch/arm/kvm/hyp/vfp.S
 delete mode 100644 arch/arm/kvm/interrupts_head.S
 create mode 100644 arch/arm64/include/asm/kvm_hyp.h
 create mode 100644 arch/arm64/include/asm/kvm_perf_event.h
 delete mode 100644 arch/arm64/kvm/hyp/hyp.h
 create mode 100644 arch/arm64/kvm/hyp/s2-setup.c
 delete mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
 create mode 100644 include/kvm/arm_pmu.h
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c (86%)
 create mode 100644 virt/kvm/arm/hyp/vgic-v2-sr.c
 create mode 100644 virt/kvm/arm/pmu.c
