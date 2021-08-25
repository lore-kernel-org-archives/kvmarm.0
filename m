Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E038FC4320E
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5537361163
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5537361163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C477A4B23B;
	Wed, 25 Aug 2021 12:17:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id olwBa2rrEdGm; Wed, 25 Aug 2021 12:17:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E956D4B20D;
	Wed, 25 Aug 2021 12:17:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDFB4B205
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id exEaMoBcYO7p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 902E04B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3745D6E;
 Wed, 25 Aug 2021 09:17:11 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 821C73F66F;
 Wed, 25 Aug 2021 09:17:10 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 00/39] KVM: arm64: Add Statistical Profiling Extension
 (SPE) support
Date: Wed, 25 Aug 2021 17:17:36 +0100
Message-Id: <20210825161815.266051-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
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

This is v4 of the SPE series posted at [1]. v2 can be found at [2], and the
original series at [3].

Statistical Profiling Extension (SPE) is an optional feature added in
ARMv8.2. It allows sampling at regular intervals of the operations executed
by the PE and storing a record of each operation in a memory buffer. A high
level overview of the extension is presented in an article on arm.com [4].

This is another complete rewrite of the series, and nothing is set in
stone. If you think of a better way to do things, please suggest it.


Features added
==============

The rewrite enabled me to add support for several features not
present in the previous iteration:

- Support for heterogeneous systems, where only some of the CPUs support SPE.
  This is accomplished via the KVM_ARM_VCPU_SUPPORTED_CPUS VCPU ioctl.

- Support for VM migration with the KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_STOP)
  VCPU ioctl.

- The requirement for userspace to mlock() the guest memory has been removed,
  and now userspace can make changes to memory contents after the memory is
  mapped at stage 2.

- Better debugging of guest memory pinning by printing a warning when we
  get an unexpected read or write fault. This helped me catch several bugs
  during development, it has already proven very useful. Many thanks to
  James who suggested when reviewing v3.


Missing features
================

I've tried to keep the series as small as possible to make it easier to review,
while implementing the core functionality needed for the SPE emulation. As such,
I've chosen to not implement several features:

- Host profiling a guest which has the SPE feature bit set (see open
  questions).

- No errata workarounds have been implemented yet, and there are quite a few of
  them for Neoverse N1 and Neoverse V1.

- Disabling CONFIG_NUMA_BALANCING is a hack to get KVM SPE to work and I am
  investigating other ways to get around automatic numa balancing, like
  requiring userspace to disable it via set_mempolicy(). I am also going to
  look at how VFIO gets around it. Suggestions welcome.

- There's plenty of room for optimization. Off the top of my head, using
  block mappings at stage 2, batch pinning of pages (similar to what VFIO
  does), optimize the way KVM keeps track of pinned pages (using a linked
  list triples the memory usage), context-switch the SPE registers on
  vcpu_load/vcpu_put on VHE if the host is not profiling, locking
  optimizations, etc, etc.

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
  kvm_lock_all_vcpus()->mutex_trylock(&vcpu->mutex) with more than 48
  VCPUs.

This BUG statement can also be triggered with mainline. To reproduce it,
compile kvmtool from this branch [5] and follow the instruction in the
kvmtool commit message.

One workaround could be to stop trying to lock all VCPUs when locking a
memslot and document the fact that it is required that no VCPUs are run
before the ioctl completes, otherwise bad things might happen to the VM.


Open questions
==============

1. Implementing support for host profiling a guest with the SPE feature
means setting the profiling buffer owning regime to EL2. While that is in
effect,  PMBIDR_EL1.P will equal 1. This has two consequences: if the guest
probes SPE during this time, the driver will fail; and the guest will be
able to determine when it is profiled. I see two options here:

- Do not allow the host's userspace to profile a guest where at least one
  VCPU has SPE.

- Document the effects somewhere and let userspace do whatever it likes.

No preference for either.

2. Userspace is not allowed to profile a CPU event (not bound to a task) is
!perf_allow_cpu(). It is my understanding that this is because of security
reasons, as we don't want a task to profile another task. Because a VM
will only be able to profile itself, I don't think it's necessary to
restrict the VM in any way based on perf_allow_cpu(), like we do with
perfmon_capable() and physical timer timestamps.

3. How to handle guest triggered SPE SErrors. Right now the Linux SPE drivers
doesn't do anything special SErrors reported by SPE, and I've done the same when
a guest manages to trigger one. Should I do something more? Disabling SPE
emulation for the entire VM is one option.


Summary of the patches
======================

Below is a short summary of the patches. For a more detailed explanation of
how SPE works, please see version 3 of the series [1].

Patches 1-11 implement the memslot locking functionality.

Patch 12 implements the KVM_ARM_VCPU_SUPPORTED_CPUS ioctl.

Patches 13-14 are preparatory for KVM SPE.

Patches 15-19 makes it possible for KVM to deny running a SPE enabled VCPU
on CPUs which don't have the SPE hardware.

Patches 20-22 add the userspace interface to configure SPE.

Patches 23-32 implement context switching of the SPE registers.

Patch 33 allows a guest to use physical timestamps only if the VMM is
perfmon_capable().

Patch 34 add the emulation for the SPE buffer management interrupts.

Patches 35-37 add the userspace API to temprorarily stop profiling so
memory can be unlocked and the VM migrated.

Patch 38 is a hack to get KVM SPE emulation going on NUMA systems (like the
Altra server which I used for testing).

Patch 39 finally enables SPE.


Testing
=======

Testing was done on Altra server with two sockets, both populated.

The Linux patches are based on v5.14-rc5 and can also be found on gitlab
[6].

For testing, I've used an SPE enabled version of kvmtool, which can be
found at [7]; the kvmtool patches will also be sent upstream. To test the
SPE_STOP API, I used a special version of kvmtool which starts the guest in
one of the stopped states; that can be found at [8] (compile from a
different commit if a different state and/or transition is desired).

Finally, in the VM I used defconfig Linux guest compiled from v5.15-rc5 and
some kvm-unit-tests patches which I wrote to test SPE [9].

All tests were run three times: once with VHE enabled, once in NVHE mode
(kvm-arm.mode=nvhe) and once in protected mode (kvm-arm.mode=protected).

The first test that I ran was the kvm-unit-tests test. This is also the
test that I used to check that KVM_ARM_VCPU_SPE_STOP_{TRAP,EXIT,RESUME}
works correctly with kvmtool.

Then I profiled iperf3 in the guest (16 VCPUs to limit the size of perf.data,
32GiB memory), while concurrently profiling in the host. This is the command
that I used:

# perf record -ae arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ -- iperf3 -c 127.0.0.1 -t 30

Everything looked right to me and I didn't see any kernel warnings or bugs.

[1] https://lore.kernel.org/linux-arm-kernel/20201027172705.15181-1-alexandru.elisei@arm.com/
[2] https://www.spinics.net/lists/arm-kernel/msg776228.html
[3] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034887.html
[4] https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/statistical-profiling-extension-for-armv8-a
[5] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/vgic-lock-all-vcpus-lockdep-bug-v1
[6] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v4
[7] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v4
[8] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v4-spe-stop-tests
[9] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v4

Alexandru Elisei (35):
  KVM: arm64: Make lock_all_vcpus() available to the rest of KVM
  KVM: arm64: Add lock/unlock memslot user API
  KVM: arm64: Implement the memslot lock/unlock functionality
  KVM: arm64: Defer CMOs for locked memslots until a VCPU is run
  KVM: arm64: Perform CMOs on locked memslots when userspace resets
    VCPUs
  KVM: arm64: Delay tag scrubbing for locked memslots until a VCPU runs
  KVM: arm64: Unlock memslots after stage 2 tables are freed
  KVM: arm64: Deny changes to locked memslots
  KVM: Add kvm_warn{,_ratelimited} macros
  KVM: arm64: Print a warning for unexpected faults on locked memslots
  KVM: arm64: Allow userspace to lock and unlock memslots
  KVM: arm64: Add the KVM_ARM_VCPU_SUPPORTED_CPUS VCPU ioctl
  KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig option
  KVM: arm64: Add SPE capability and VCPU feature
  drivers/perf: Expose the cpumask of CPUs that support SPE
  KVM: arm64: Make SPE available when at least one CPU supports it
  KVM: arm64: Set the VCPU SPE feature bit when SPE is available
  KVM: arm64: Expose SPE version to guests
  KVM: arm64: Do not emulate SPE on CPUs which don't have SPE
  KVM: arm64: debug: Configure MDCR_EL2 when a VCPU has SPE
  KVM: arm64: Move the write to MDCR_EL2 out of
    __activate_traps_common()
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

Sudeep Holla (4):
  KVM: arm64: Add a new VCPU device control group for SPE
  KVM: arm64: Add SPE VCPU device attribute to set the interrupt number
  KVM: arm64: Add SPE VCPU device attribute to initialize SPE
  KVM: arm64: VHE: Clear MDCR_EL2.E2PB in vcpu_put()

 Documentation/virt/kvm/api.rst          |  87 ++++-
 Documentation/virt/kvm/devices/vcpu.rst |  76 ++++
 arch/arm64/include/asm/kvm_arm.h        |   1 +
 arch/arm64/include/asm/kvm_host.h       |  75 +++-
 arch/arm64/include/asm/kvm_hyp.h        |  51 ++-
 arch/arm64/include/asm/kvm_mmu.h        |   8 +
 arch/arm64/include/asm/kvm_spe.h        |  96 ++++++
 arch/arm64/include/asm/sysreg.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h       |  11 +
 arch/arm64/kvm/Kconfig                  |   8 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/arm.c                    | 140 +++++++-
 arch/arm64/kvm/debug.c                  |  55 ++-
 arch/arm64/kvm/guest.c                  |  10 +
 arch/arm64/kvm/hyp/include/hyp/spe-sr.h |  32 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   1 -
 arch/arm64/kvm/hyp/nvhe/Makefile        |   1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |  24 +-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c        | 133 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  35 +-
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c         | 193 +++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  43 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |   2 +-
 arch/arm64/kvm/mmu.c                    | 441 +++++++++++++++++++++++-
 arch/arm64/kvm/reset.c                  |  23 ++
 arch/arm64/kvm/spe.c                    | 381 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               |  77 ++++-
 arch/arm64/kvm/vgic/vgic-init.c         |   4 +-
 arch/arm64/kvm/vgic/vgic-its.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  50 +--
 arch/arm64/kvm/vgic/vgic.h              |   3 -
 drivers/perf/arm_spe_pmu.c              |  30 +-
 include/linux/kvm_host.h                |   4 +
 include/linux/perf/arm_pmu.h            |   7 +
 include/uapi/linux/kvm.h                |  13 +
 36 files changed, 1983 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/spe-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/spe.c

-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
