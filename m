Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68329C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DACB461BE1
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DACB461BE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32DB24B125;
	Wed, 17 Nov 2021 10:37:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1b1E1X9ceKP2; Wed, 17 Nov 2021 10:37:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A434B10E;
	Wed, 17 Nov 2021 10:37:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D834B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIBUhmDbw9hT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 207C64B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:02 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 820B01FB;
 Wed, 17 Nov 2021 07:37:01 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C24C53F5A1;
 Wed, 17 Nov 2021 07:36:59 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 00/38] KVM: arm64: Add Statistical Profiling Extension
 (SPE) support
Date: Wed, 17 Nov 2021 15:38:04 +0000
Message-Id: <20211117153842.302159-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The series is based on v5.16-rc1 can be found on gitlab at [1]. kvmtool
support is needed to create a VM with SPE enabled; a branch with the
necessary changes can be found at [2].

v4 of the patches can be found at [3]. v3 can be found at [4], and the
original series at [5].

Introduction
============

Statistical Profiling Extension (SPE) is an optional feature added in
ARMv8.2. It allows sampling at regular intervals of the operations executed
by the PE and storing a record of each operation in a memory buffer. A high
level overview of the extension is presented in an article on arm.com [4].

More information about how I implemented the SPE emulation and why can be
found in the cover letter for version 3 of the series [4].

Changes from v4
===============

Mostly fixes, but some small features were added too:

- Implemented review comments, many thanks!

- Reworked heterogeneous support, because probing was broken on systems
  which had more than one SPE instance.

- Allow locking a memslot after the VCPU has run to make it possible for
  the VMM to cancel migration, as migration requires unlocking the memslots
  before it is initiated.

- Unmap the memory from stage 2 if a memslot is unlocked before any of the
  VCPUs have run. This is so KVM can perform the needed dcache maintenance
  operations in the stage 2 abort handler (details in patch #7 "KVM: arm64:
  Unmap unlocked memslot from stage 2 if kvm_mmu_has_pending_ops()").

- Dropped the KVM_ARM_SUPPORTED_CPUS ioctl in favor of KVM setting the
  cpumask of allowed CPUs implicitly when the SPE VCPU feature is set.

Missing features
================

Although it might look like it, I've tried to keep the series as small as
possible to make it easier to review, while implementing the core
functionality needed for the SPE emulation. As such, I've chosen to not
implement several features:

- Host profiling a guest which has the SPE feature bit set.

- No errata workarounds impacting SPE have been implemented yet.

- Disabling CONFIG_NUMA_BALANCING is a hack to get KVM SPE to work and I am
  investigating other ways to get around automatic numa balancing, like
  requiring userspace to disable it via set_mempolicy(). I am also going to
  look at how VFIO gets around it. Suggestions welcome.

- There's plenty of room for optimization. Off the top of my head, using
  block mappings at stage 2, batch pinning of pages (similar to what VFIO
  does), optimize the way KVM keeps track of pinned pages (using a linked
  list triples the memory usage), context-switch the SPE registers on
  vcpu_load/vcpu_put on VHE if the host is not profiling, improving the
  locking scheme, especially when a memslot is locked, etc, etc

- ...and others. I'm sure I'm missing at least a few things which are
  important for someone.

Known issues
============

This is an RFC, so keep in mind that almost definitely there will be scary
bugs. For example, below is a list of known issues which don't affect the
correctness of the emulation, and which I'm planning to fix in a future
iteration:

- With CONFIG_PROVE_LOCKING=y, lockdep complains about lock contention when
  the VCPU executes the dcache clean pending ops.

- With CONFIG_PROVE_LOCKING=y, KVM will hit a BUG at
  kvm_lock_all_vcpus()->mutex_trylock(&vcpu->mutex) with 47 or more VCPUs.

This BUG is bening and can also be triggered with mainline; it can be made
to go away by increasing MAX_LOCK_DEPTH. I've hacked kvmtool to to
reproduce the splat with a mainline kernel, which can be found at [6]
(instructions in the commit message).

Open questions
==============

1. Userspace is not allowed to profile a CPU event (not bound to a task) is
!perf_allow_cpu(). It is my understanding that this is because of security
reasons, as we don't want a task to profile another task. Because a VM
will only be able to profile itself, I don't think it's necessary to
restrict the VM in any way based on perf_allow_cpu(), like we do with
perfmon_capable() and physical timer timestamps.

2. How to handle guest triggered SPE errors. By error I mean all syndromes
reported by the PMSBR_EL1 register other than buffer full and stage 1
fault (because those can and should be handled by the guest). The SPE
driver disables profiling when it encounters a buffer syndrome other than
buffer full. I see several options here:

a. KVM can do the same thing as the SPE driver and disable SPE emulation
for that guest.

b. KVM returns an error from KVM_RUN.

c. KVM allows the guest direct access to the buffer register (they aren't
trapped anymore), but, because the guest can trigger a maintenance
interrupt with a write to PMBSR_EL1, KVM will ignore all syndromes,
including SError or stage 2 fault.

3. Related to 2, SPE can report an SError. The SPE driver doesn't treat
this separately from the other syndromes. Should KVM treat it like any
other syndrome? Should KVM do more?

At the moment, KVM injects an external abort when it encounters an error
syndrome, and for a Stage 2 fault, prints a warning. The warning has proved
very useful for testing and debugging.

Testing
=======

Testing was done on Altra server with two sockets, both populated. The
patches are based on v5.16-rc1.

For testing, I've used a version of kvmtool with SPE support [2].  SPE_STOP
API, I used a special version of kvmtool which starts the guest in one of
the stopped states; that can be found at [7] (compile from a different
commit if a different state and/or transition is desired).

Finally, in the VM I used defconfig Linux guest compiled from v5.15-rc5 and
kvm-unit-tests patches which I wrote to test SPE [8].

All tests were run twice times: once with VHE enabled, once in NVHE mode
(kvm-arm.mode=nvhe).

The first test that I ran was the kvm-unit-tests test. This is also the
test that I used to check that KVM_ARM_VCPU_SPE_STOP_{TRAP,EXIT,RESUME}
works correctly with kvmtool.

Then I profiled iperf3 in the guest (32 VCPUs to limit the size of
perf.data, 32GiB memory), while concurrently profiling in the host. This is
the command that I used:

# perf record -ae arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ -- iperf3 -c 127.0.0.1 -t 30

Everything looked right to me and I didn't see any kernel warnings or bugs.

[1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v5
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v5
[3] https://www.spinics.net/lists/arm-kernel/msg917220.html
[4] https://lore.kernel.org/linux-arm-kernel/20201027172705.15181-1-alexandru.elisei@arm.com/
[5] https://www.spinics.net/lists/arm-kernel/msg776228.html
[6] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/vgic-lock-all-vcpus-lockdep-bug-v1
[7] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v5-stop-tests
[8] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v4

Alexandru Elisei (35):
  KVM: arm64: Make lock_all_vcpus() available to the rest of KVM
  KVM: arm64: Add lock/unlock memslot user API
  KVM: arm64: Implement the memslot lock/unlock functionality
  KVM: arm64: Defer CMOs for locked memslots until a VCPU is run
  KVM: arm64: Perform CMOs on locked memslots when userspace resets
    VCPUs
  KVM: arm64: Delay tag scrubbing for locked memslots until a VCPU runs
  KVM: arm64: Unmap unlocked memslot from stage 2 if
    kvm_mmu_has_pending_ops()
  KVM: arm64: Unlock memslots after stage 2 tables are freed
  KVM: arm64: Deny changes to locked memslots
  KVM: Add kvm_warn{,_ratelimited} macros
  KVM: arm64: Print a warning for unexpected faults on locked memslots
  KVM: arm64: Allow userspace to lock and unlock memslots
  KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig option
  KVM: arm64: Add SPE capability and VCPU feature
  perf: arm_spe_pmu: Move struct arm_spe_pmu to a separate header file
  KVM: arm64: Allow SPE emulation when the SPE hardware is present
  KVM: arm64: Allow userspace to set the SPE feature only if SPE is
    present
  KVM: arm64: Expose SPE version to guests
  KVM: arm64: Do not run a VCPU on a CPU without SPE
  KVM: arm64: debug: Configure MDCR_EL2 when a VCPU has SPE
  KVM: arm64: Move accesses to MDCR_EL2 out of
    __{activate,deactivate}_traps_common
  KVM: arm64: VHE: Change MDCR_EL2 at world switch if VCPU has SPE
  KVM: arm64: Add SPE system registers to VCPU context
  KVM: arm64: nVHE: Save PMSCR_EL1 to the host context
  KVM: arm64: Rename DEBUG_STATE_SAVE_SPE -> DEBUG_SAVE_SPE_BUFFER flags
  KVM: arm64: nVHE: Context switch SPE state if VCPU has SPE
  KVM: arm64: VHE: Context switch SPE state if VCPU has SPE
  KVM: arm64: Save/restore PMSNEVFR_EL1 on VCPU put/load
  KVM: arm64: Allow guest to use physical timestamps if
    perfmon_capable()
  KVM: arm64: Emulate SPE buffer management interrupt
  KVM: arm64: Add an userspace API to stop a VCPU profiling
  KVM: arm64: Implement userspace API to stop a VCPU profiling
  KVM: arm64: Add PMSIDR_EL1 to the SPE register context
  KVM: arm64: Make CONFIG_KVM_ARM_SPE depend on !CONFIG_NUMA_BALANCING
  KVM: arm64: Allow userspace to enable SPE for guests

Sudeep Holla (3):
  KVM: arm64: Add a new VCPU device control group for SPE
  KVM: arm64: Add SPE VCPU device attribute to set the interrupt number
  KVM: arm64: Add SPE VCPU device attribute to initialize SPE

 Documentation/virt/kvm/api.rst          |  69 ++++
 Documentation/virt/kvm/devices/vcpu.rst |  76 ++++
 arch/arm64/include/asm/kvm_arm.h        |   1 +
 arch/arm64/include/asm/kvm_host.h       |  75 +++-
 arch/arm64/include/asm/kvm_hyp.h        |  49 ++-
 arch/arm64/include/asm/kvm_mmu.h        |   8 +
 arch/arm64/include/asm/kvm_spe.h        | 103 ++++++
 arch/arm64/include/asm/sysreg.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h       |  11 +
 arch/arm64/kvm/Kconfig                  |   8 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/arm.c                    | 120 ++++++-
 arch/arm64/kvm/debug.c                  |  55 ++-
 arch/arm64/kvm/guest.c                  |  10 +
 arch/arm64/kvm/hyp/include/hyp/spe-sr.h |  32 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  16 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |  24 +-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c        | 133 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  35 +-
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c         | 193 ++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  21 ++
 arch/arm64/kvm/mmu.c                    | 444 +++++++++++++++++++++++-
 arch/arm64/kvm/reset.c                  |   8 +
 arch/arm64/kvm/spe.c                    | 383 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               |  77 +++-
 arch/arm64/kvm/vgic/vgic-init.c         |   4 +-
 arch/arm64/kvm/vgic/vgic-its.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  50 +--
 arch/arm64/kvm/vgic/vgic.h              |   3 -
 drivers/perf/arm_spe_pmu.c              |  31 +-
 include/linux/kvm_host.h                |   4 +
 include/linux/perf/arm_spe_pmu.h        |  55 +++
 include/uapi/linux/kvm.h                |   9 +
 35 files changed, 1968 insertions(+), 153 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/spe-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/spe.c
 create mode 100644 include/linux/perf/arm_spe_pmu.h

-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
