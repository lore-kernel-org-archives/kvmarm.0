Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743A225FA13
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136458; cv=none; b=I2QJlfyRHSJag62jlOvNurDXtpSrXqkxUcR2VpG3cLkbOngSUOuT7FPrmKk5Tuu6x9//38a+uqpSNuBesIWu4ypRD3WtOKt10kO0TC26EEk88C/sgLGRnZQXSZ3O/BP4H2LcrbJaEy1HhKgRX/ZB8yBgWDQGXktgRnm6DM2yZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136458; c=relaxed/simple;
	bh=R0oQ2b5fw+o3mjTyfXUUNdk8xMGAkQMEeQ1BTvnaino=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R5IOy1Zvp2zG5f5Bee2GgfVCpvhBozcyP1Ifef9xUGyXC0h/0lJWxcTuEoMtKkg0hKfqi4IyHKdfCLP2YZiL28XKlkOnCdWD+SqB9z+haVkpUNQM0SQF78Ixr3AgaSBjYUuTssAVjo0F36NbV6b7pmbICs2KcG1SDCMfMkr07vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C262E1063;
	Fri, 14 Nov 2025 08:07:26 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4180D3F5A1;
	Fri, 14 Nov 2025 08:07:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 00/35] KVM: arm64: Add Statistical Profiling Extension (SPE) support
Date: Fri, 14 Nov 2025 16:06:41 +0000
Message-ID: <20251114160717.163230-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The series is based on v6.18-rc2 + the fix to FGT traps being computed too
late [1], which hasn't yet been merged. A branch containing everything be
found at [2].  kvmtool support is needed to create a VM with SPE enabled; a
branch with the necessary changes can be found at [3]. For testing, I used
kvm-unit-tests, which can be found at [4].

The series is an RFC and is lightly untested, likely broken and incomplete -
support for various features, like pKVM, nested virt, nVHE, etc, etc is missing.
I wanted the focus to be on pinning memory at stage 2 (that's patches #29, 'KVM:
arm64: Pin the SPE buffer in the host and map it at stage 2', to #3, 'KVM:
arm64: Add hugetlb support for SPE') and I would very much like to start a
discussion around that.

This series is based the register definitions from DDI0601 [5] and on DEN0154
[6], which is a beta specification. One notable difference is that in this
implementation I've chosen not to ignore buffer register writes when
PMBLIMITR_EL1.E = 1, to maintain compatibility with the current SPE driver.
We're working internally on merging the changes proposed in DEN0154 with the
Arm ARM.

RFC v5 can be found at [7], although that version is four years old now and
bears little resemblance to this series. The only thing that I kept is the
userspace API, everything else was written from scratch.

Introduction
============

Statistical Profiling Extension (SPE) is an optional feature added in
ARMv8.2. It allows sampling at regular intervals of the operations executed
by the PE and storing a record of each operation in a memory buffer. A high
level overview of the extension is presented in an article on arm.com [8].

The problem
===========

When the Statistical Profiling Unit (SPU from now on) encounter a fault when
it attempts to write a record to memory, two things happen: profiling is
stopped, and the fault is reported to the CPU via an interrupt, not an
exception. This creates a blackout window during which the CPU executes
instructions which aren't profiled. The SPE driver avoid this by keeping the
buffer mapped while ProfilingBufferEnabled() = true. But when running as a
guest under KVM, the SPU will trigger stage 2 faults, with the associated
blackout windows.

Solution
========

I chose the same approach as the SPE driver, which is to avoid the blackout
windows altogether by keeping the buffer mapped at stage 2 while
ProfilingBufferEnabled() = true.

Please note when reading the patches that due to a naming quirk in the
architecture, ProfilingBufferEnabled() = true is not the same as the buffer
enable bit being set (PMBLIMITR_EL1.E = 1). ProfilingBufferEnabled() = true
require the buffer enable bit to be set and that PMBSR_EL1.S = 0.

Implementation
==============

The obvious solution would be to pin the pages corresponding to the buffer in
the host, where by 'pin' I mean to have an elevated reference count.

When ProfilingBufferEnabled() becomes true following a write made by the guest
to one of the buffer registers, KVM does the following:

1. Faults in the buffer pages* in the host's stage 1 with a
pin_user_pages(FOLL_LONGTERM) call.

2. Maps the pages at stage 2.

* The buffer is programmed by the guest with virtual addresess in the guest
stage 1; KVM must also pin the pages that map the stage 1 tables for the
buffer guest virtual addresses to avoid a SPU stage 2 fault on a stage 1
translation table walk.

Somewhat counterintuitive, this doesn't guarantee that the pages remain mapped
in the host's stage 1. split_huge_pmd() will remap a THP block mapping as PTEs,
completely ignoring an elevated reference count, and that means breaking the
existing mapping. KVM uses FOLL_SPLIT_PMD when pinned a page to break existing
block mappings, and make sure this doesn't happen.

But this is still not enough. Even more counterintuitive, a pinned page that
always has a valid mapping in the host's stage 1 can still be unmapped from
stage 2. A few examples that I've found, and I don't think this is an
exhaustive list:

1. Automatic NUMA balancing: skips individual pinned folios, but calls the
invalidate MMU notifier (which unmaps the memory from stage 2) at the **PUD**
level (introduced by commit 7f06e3aa2e83 ("mm/mprotect: push mmu notifier to
PUDs", see mm/mprotect::change_pud_range()).

2. Migration - rmap invokes the mmu invalidate notifier before checking that it
has an elevated reference count. If it finds that the page has an elevated
reference count, it doesn't remove remove it from the stage 1 translation tables
(see mm/rmap.c::try_to_unmmap_one()).

3. khugepaged invokes the mmu invalidate notifier, takes the page table
spinlock, does a check for pins, and backs out of collapsing the PTEs (see
mm/khugepaged,c::hpage_collapse_scan_pmd()).

4. KSM does something very similar to khugepaged, where it invokes the MMU
notifier, takes the page table lock, and backs out of the change if the page
is pinned (see mm/ksm.c::try_to_merge_one_page() -> write_protect_page()).

Why is the MMU notifier taken outside of the spinlock? Because
the MMU notifier must be able to sleep, and the check for an elevated
reference count must be done with the page table spinlock held. Why the need
to do the with the spinlock held? Because GUP pins the page with the spinlock held.

The issue in all the examples is structural: the MMU notifier must be able
to sleep, and so it must be called from a preemptible section; but, since GUP
pins a page with the page table spinlock held, the only reliable way to check
for an elevated reference count is by holding the spinlock, which makes the
check non-preemptible.

To get around this, I implemented a mechanism by which the arch-independent MMU
notifiers are propagated by KVM down to the arch code, and, based on the reason,
KVM will not change stage 2 for the memory region that is pinned for the region.

Alternatives
============

I would be very happy to rethink my approach if we can agree on a better
solution. Some obvious alternatives, not exhaustive by any means:

1. Have KVM prefault memory and map the buffer at stage 2 when
ProfilingBufferEnabled() becomes true. If the SPU reports a stage 2 fault, map
it at stage 2, similar to a CPU fault. Are the SPU faults rare enough for this
approach not to introduce a statistically significant difference in the
profiling data?

2. Have KVM prefault memory, map in the kernel's linear address space and
program SPE in the host to profile the guest.

3. Support only physical addressing mode. Finding large areas of contiguous
physical memory might be difficult for a guest (but not impossible, CMA could
be used for it), and this approach is incompatible with existing guests.

[1] https://lore.kernel.org/kvmarm/20251112102853.47759-1-alexandru.elisei@arm.com/
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v6
[3] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v6
[4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v6
[5] https://developer.arm.com/documentation/ddi0601/latest/
[6] https://developer.arm.com/documentation/den0154/v1_bet0
[7] https://www.spinics.net/lists/arm-kernel/msg934192.html
[8] https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/statistical-profiling-extension-for-armv8-a

Alexandru Elisei (33):
  arm64/sysreg: Add new SPE fields
  arm64/sysreg: Define MDCR_EL2.E2PB values
  KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig option
  perf: arm_spe_pmu: Move struct arm_spe_pmu to a separate header file
  KVM: arm64: Add KVM_CAP_ARM_SPE capability
  KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU feature
  HACK! KVM: arm64: Disable SPE virtualization if protected KVM is
    enabled
  HACK! KVM: arm64: Enable SPE virtualization only in VHE mode
  HACK! KVM: arm64: Disable SPE virtualization if nested virt is enabled
  KVM: arm64: Add SPE VCPU device attribute to set the SPU device
  perf: arm_spe_pmu: Add PMBIDR_EL1 to struct arm_spe_pmu
  KVM: arm64: Add SPE VCPU device attribute to set the max buffer size
  KVM: arm64: Add SPE VCPU device attribute to initialize SPE
  KVM: arm64: Advertise SPE version in ID_AA64DFR0_EL1.PMSver
  KVM: arm64: Add writable SPE system registers to VCPU context
  perf: arm_spe_pmu: Add PMSIDR_EL1 to struct arm_spe_pmu
  KVM: arm64: Trap PMBIDR_EL1 and PMSIDR_EL1
  KVM: arm64: config: Use functions from spe.c to test
    FEAT_SPE_{FnE,FDS}
  KVM: arm64: Check for unsupported CPU early in kvm_arch_vcpu_load()
  KVM: arm64: VHE: Context switch SPE state
  KVM: arm64: Allow guest SPE physical timestamps only if
    perfmon_capable()
  KVM: arm64: Handle SPE hardware maintenance interrupts
  KVM: arm64: Add basic handling of SPE buffer control registers writes
  KVM: arm64: Add comment to explain how trapped SPE registers are
    handled
  KVM: arm64: Make MTE functions public
  KVM: arm64: at: Use callback for reading descriptor
  KVM: arm64: Pin the SPE buffer in the host and map it at stage 2
  KVM: Propagate MMU event to the MMU notifier handlers
  KVM: arm64: Handle MMU notifiers for the SPE buffer
  KVM: Add KVM_EXIT_RLIMIT exit_reason
  KVM: arm64: Implement locked memory accounting for the SPE buffer
  KVM: arm64: Add hugetlb support for SPE
  KVM: arm64: Allow the creation of a SPE enabled VM

Sudeep Holla (2):
  KVM: arm64: Add a new VCPU device control group for SPE
  KVM: arm64: Add SPE VCPU device attribute to set the interrupt number

 Documentation/virt/kvm/api.rst          |   23 +
 Documentation/virt/kvm/devices/vcpu.rst |  139 ++
 arch/arm64/include/asm/kvm_emulate.h    |    9 +-
 arch/arm64/include/asm/kvm_host.h       |   21 +-
 arch/arm64/include/asm/kvm_hyp.h        |   16 +-
 arch/arm64/include/asm/kvm_mmu.h        |   13 +-
 arch/arm64/include/asm/kvm_nested.h     |    6 +
 arch/arm64/include/asm/kvm_spe.h        |  165 ++
 arch/arm64/include/asm/sysreg.h         |    3 +
 arch/arm64/include/uapi/asm/kvm.h       |    6 +
 arch/arm64/kvm/Kconfig                  |    8 +
 arch/arm64/kvm/Makefile                 |    1 +
 arch/arm64/kvm/arm.c                    |   59 +-
 arch/arm64/kvm/at.c                     |   17 +-
 arch/arm64/kvm/config.c                 |   29 +-
 arch/arm64/kvm/debug.c                  |   29 +-
 arch/arm64/kvm/guest.c                  |   12 +
 arch/arm64/kvm/hyp/vhe/Makefile         |    1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c         |   80 +
 arch/arm64/kvm/hyp/vhe/switch.c         |    2 +
 arch/arm64/kvm/mmu.c                    |  157 +-
 arch/arm64/kvm/nested.c                 |   16 +-
 arch/arm64/kvm/pmu-emul.c               |    4 +-
 arch/arm64/kvm/spe.c                    | 1872 +++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               |   76 +-
 arch/arm64/kvm/vgic/vgic-its.c          |    4 +-
 arch/arm64/tools/sysreg                 |   25 +-
 drivers/perf/arm_spe_pmu.c              |   37 +-
 include/kvm/arm_vgic.h                  |    2 +
 include/linux/kvm_host.h                |   19 +
 include/linux/perf/arm_spe_pmu.h        |   59 +
 include/uapi/linux/kvm.h                |    7 +
 virt/kvm/kvm_main.c                     |    8 +
 33 files changed, 2797 insertions(+), 128 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/spe.c
 create mode 100644 include/linux/perf/arm_spe_pmu.h

-- 
2.51.2

