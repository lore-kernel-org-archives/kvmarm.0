From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 00/23] arm64: Virtualization Host Extension support
Date: Thu, 11 Feb 2016 18:39:41 +0000
Message-ID: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D97B549BEB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sYv9adreXIOh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B54D49BE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
short), which enables simpler support of Type-2 hypervisors.

This extension allows the kernel to directly run at EL2, and
significantly reduces the number of system registers shared between
host and guest, reducing the overhead of virtualization.

In order to have the same kernel binary running on all versions of the
architecture, this series makes heavy use of runtime code patching.

The first 22 patches massage the KVM code to deal with VHE and enable
Linux to run at EL2. The last patch catches an ugly case when VHE
capable CPUs are paired with some of their less capable siblings. This
should never happen, but hey...

I have deliberately left out some of the more "advanced"
optimizations, as they are likely to distract the reviewer from the
core infrastructure, which is what I care about at the moment.

Note: GDB is currently busted on VHE systems, as it checks for version
      6 on the debug architecture, while VHE is version 7. The
      binutils people are on the case.

This has been tested on the FVP_Base_SLV-V8-A model, and based on
v4.5-rc3 + kvmarm/master. I've put a branch out on:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe

* From v3:
  - Cleaned debug handling after comments from Catalin
  - Added missing barriers in the panic patch
  - Collected Rb and Acks from Christoffer and Catalin

* From v2:
  - Added support for perf to count kernel events in EL2
  - Added support for EL2 breakpoints
  - Moved the VTCR_EL2 setup from assembly to C
  - Made the fault handling easier to understand (hopefuly)
  - Plenty of smaller fixups

* From v1:
  - Full rewrite now that the World Switch is written in C code.
  - Dropped the "early IRQ handling" for the moment.

Marc Zyngier (23):
  arm/arm64: KVM: Add hook for C-based stage2 init
  arm64: KVM: Switch to C-based stage2 init
  arm/arm64: Add new is_kernel_in_hyp_mode predicate
  arm64: Allow the arch timer to use the HYP timer
  arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
  arm64: KVM: Skip HYP setup when already running in HYP
  arm64: KVM: VHE: Patch out use of HVC
  arm64: KVM: VHE: Patch out kern_hyp_va
  arm64: KVM: VHE: Introduce unified system register accessors
  arm64: KVM: VHE: Differenciate host/guest sysreg save/restore
  arm64: KVM: VHE: Split save/restore of registers shared between guest
    and host
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
  arm64: Panic when VHE and non VHE CPUs coexist

 arch/arm/include/asm/kvm_host.h        |   4 +
 arch/arm/include/asm/virt.h            |   5 +
 arch/arm/kvm/arm.c                     | 174 ++++++++++++++++++----------
 arch/arm/kvm/mmu.c                     |   7 ++
 arch/arm64/Kconfig                     |  13 +++
 arch/arm64/include/asm/cpufeature.h    |   3 +-
 arch/arm64/include/asm/hw_breakpoint.h |  49 +++++---
 arch/arm64/include/asm/kvm_arm.h       |   6 +-
 arch/arm64/include/asm/kvm_asm.h       |   2 +
 arch/arm64/include/asm/kvm_emulate.h   |   3 +
 arch/arm64/include/asm/kvm_host.h      |   6 +
 arch/arm64/include/asm/kvm_mmu.h       |  12 +-
 arch/arm64/include/asm/virt.h          |  27 +++++
 arch/arm64/kernel/asm-offsets.c        |   3 -
 arch/arm64/kernel/cpufeature.c         |  11 ++
 arch/arm64/kernel/head.S               |  50 +++++++-
 arch/arm64/kernel/perf_event.c         |  14 ++-
 arch/arm64/kernel/smp.c                |   3 +
 arch/arm64/kvm/hyp-init.S              |  18 ---
 arch/arm64/kvm/hyp.S                   |   7 ++
 arch/arm64/kvm/hyp/Makefile            |   1 +
 arch/arm64/kvm/hyp/entry.S             |   6 +
 arch/arm64/kvm/hyp/hyp-entry.S         | 109 ++++++------------
 arch/arm64/kvm/hyp/hyp.h               | 108 ++++++++++++++++--
 arch/arm64/kvm/hyp/s2-setup.c          |  44 +++++++
 arch/arm64/kvm/hyp/switch.c            | 202 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/sysreg-sr.c         | 147 ++++++++++++++++--------
 arch/arm64/kvm/hyp/timer-sr.c          |  10 +-
 drivers/clocksource/arm_arch_timer.c   |  96 ++++++++++------
 29 files changed, 842 insertions(+), 298 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/s2-setup.c

-- 
2.1.4
