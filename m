Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D61C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE9352225E
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE9352225E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F29EC4B408;
	Tue, 27 Oct 2020 13:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CoJoLB0v3-dB; Tue, 27 Oct 2020 13:26:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2CC4B3F2;
	Tue, 27 Oct 2020 13:26:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E93914B3DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RoTtaYYpfhMm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 143084B3D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69985139F;
 Tue, 27 Oct 2020 10:26:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0324B3F719;
 Tue, 27 Oct 2020 10:26:12 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 00/16] KVM: arm64: Add Statistical Profiling Extension
 (SPE) support
Date: Tue, 27 Oct 2020 17:26:49 +0000
Message-Id: <20201027172705.15181-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

Statistical Profiling Extension (SPE) is an optional feature added in
ARMv8.2. It allows sampling at regular intervals of the operations executed
by the PE and storing a record of each operation in a memory buffer. A high
level overview of the extension is presented in an article on arm.com [1].

This series implements SPE support for KVM guests. The series is based on
v5.10-rc1 has been almost completely rewritten, but I've tried to keep some
patches from v2 [2] and the initial version of the series [3]. The series
can also be found in a repo [4] to make testing easier.

This series is firmly in RFC territory for several reasons:

* It introduces an userspace API to pre-map guest memory at stage 2, which
  I think deserves some discussion before we commit to it.

* The way I'm handling the SPE interrupt is completely different than what
  was implemented in v2.

* SPE state save/restore unconditionally save the host SPE state on VM
  entry and restores it on VM exit, regardless of whether the host is
  actually profiling or not. I plan to improve this in following
  iterations.

I am also interested to know why the spe header lives in
/include/kvm/kvm_spe.h instead of /arch/arm64/incluse/asm/kvm_spe.h. My
guess is that the headers there are for code that was shared with KVM arm.
 Since KVM arm was removed, I would like to move the header to /arch/arm64,
but I wanted to make sure that is acceptable.

The profiling buffer
====================

KVM cannot handle SPE stage 2 faults and the guest memory must be
memory-resident and mapped at stage 2 the entire lifetime of the guest.
More details in patch #10 ("KVM: arm64: Add a new VM device control group
for SPE").

This is achieved with the help of userspace in two stages:

1. Userspace calls mlock() on the VMAs that represent the guest memory.

2. After userspace has copied everything to the guest memory, it uses the
   KVM_ARM_VM_SPE_CTRL(KVM_ARM_VM_SPE_FINALIZE) ioctl to tell KVM to map
   all VM_LOCKED and VM_HUGETLB VMAs at stage 2 (explanation why VM_HUGETLB
   is also mapped in patch #10).

I have added support for SPE to kvmtool, patches are on the mailing list
[5], as well as in a repo [6] for easy testing.

There are some things that I'm not 100% sure about and I would like to get
some feedback before we commit to an ABI:

* At the moment, having SPE enabled for a guest forces unmapping of the
  guest memory when the VCPU is reset. This is done to make sure the
  dcaches are cleaned to POC when the VM starts. It isn't necessary when
  the system has FWB, but I decided to unmap the guest memory even in this
  case for two reasons:

  1. Userspace doesn't know when FWB is available and thus if the finalize
call is necessary.

  2. I haven't seen anywhere in the documentation a statement regarding
changing memslots when the VM is in the process of resetting, I am assuming
it's not forbidden (please correct me if I'm wrong).

If it's forbidden to change memslots when resetting the VM, then we could
add an extension of something similar that tells userspace if a finalize
call is required after VM reset.

* Instead of a SPE control group we could have a KVM_ARM_VM_FINALIZE ioctl
  on the vm fd, similar to KVM_ARM_VCPU_FINALIZE. I don't have a strong
  preference for either, the reason for the current implementation is that
  I hadn't thought about KVM_ARM_VM_FINALIZE until the series were almost
  finished.

The buffer interrupt
====================

Also referred to in the Arm ARM as the Profiling Buffer management
interrupt. The guest SPE interrupt handling has been completely reworked
and now it's handled by checking the service bit in the PMBSR_EL1 register
on every switch to host; implementation in patch #14 ("KVM: arm64: Emulate
SPE buffer management event interrupt").

Another option that I considered was to change the host irq handler for the
SPE interrupt to check kvm_get_running_cpu() and defer the handling of the
interrupt to the KVM code. There are a few reasons I decided against it:

* We need to keet the PMBSR_EL1.S bit set until KVM enables interrupts,
  which means that the host won't be able to profile KVM between
  kvm_load()/kvm_put().

* Software can trigger the interrupt with a write to the PMBSR_EL1 register
  that sets the service bit. This means that the KVM irq handler won't be
  able to distinguish between the guest configuring PMBSR_EL1 to report a
  stage 2 fault, which is harmless for the host, and the hardware reporting
  it, which can indicate a bug. Even more serious, KVM won't be able to
  distinguish between a PMBSR_EL1 value indicating an External Abort written
  by the guest, again, harmless, and one reported by the hardware, which
  is pretty serious.

This is what the architecture says about SPE external aborts, on page
D9-2806:

"A write to the Profiling Buffer might generate an external abort,
including an external abort on a translation table walk or translation
table update. It is an IMPLEMENTATION DEFINED choice whether such an
external abort:
* Is reported to the Statistical Profiling Extension and treated as a
  Profiling Buffer management event.
* Generates an SError interrupt exception."

I decided to treat the SPE external abort like an SError and panic.
However, I'm not 100% sure that's the right thing to do because the SPE
driver never checks the PMBSR_EL1.EA bit.

There is an argument to be made against my approach to handling the buffer
interrupt, and that is that it requires KVM to trap accesses to the buffer
registers and to read one extra register, PMBSR_EL1, when switching to the
host. I believe this overhead to be minimal because writes to the buffer
registers are rare and they happen when an event is installed or stopped.

Note that in both cases the guest SPE interrupt is purely virtual and has
to be deactivated by KVM when the guest clears the PMBSR_EL1.S bit. This
means trapping the accesses to the buffer registers while the interrupt is
asserted even in the case where the host SPE driver irq handler handles the
interrupt triggered by the guest.

Context switching SPE registers
===============================

As mentioned earlier, this is done on every world switch under the
assumption that the host is using SPE at the same time as the guest, which
obviously will not always be the case.

I plan to improve this in following iterations by doing the context switch
on vcpu_load()/vcpu_put() when the host is not profiling. The challenge
will be detecting when the host is profiling. That can be detected in
vcpu_load(), but according to my understanding of perf, a new event can be
installed on the CPU via an IPI. In that case the perf driver would have to
notify KVM that it's starting profiling on the core so KVM can save the
guest SPE registers.

In v2 of the patches it has been suggested that on NVHE systems, the EL2
code must do the SPE context switch unconditionally [7]. I don't believe
that is necessary because all the registers that SPE uses in the NVHE case
are EL1 registers.

Testing
=======

I have written two basic kvm-unit-tests tests for SPE that I used while
developing the series [8]; they can also be found on this branch [9].

For testing, I have used FVP and a Neoverse N1 machine. These are the tests
that I ran:

1. kvm-unit-tests tests

The tests check the basic operation of the SPE buffer and some corner cases
which were hard to trigger with a Linux guest.

2. Check that profiling behaves the same in the guest and in the host

I used this command for testing on an N1 machine:

$ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ dd if=/dev/zero of=/dev/null count=5000000

then I checked the output of perf report --dump-raw-trace. The command is
not executed simultaneously in the guest and in the host. Results:

* On VHE:
  - guest 538 interrupts, perf.data size 541.190MiB, 1096 total events.
  - host 536 interrupts, perf.data size 541.190MiB, 1096 total events.

* Without VHE:
  - guest 537 interrupts, perf.data size 539,997 MiB, 1091 total events.
  - host 535 interrupts, perf.data size 539.986 MiB, 1093 total events.

I ran the tests multiple times and there were very minor variations in the
results.

3. Test concurrent profiling in the guest and host, version A

For this test I used the command:

perf record -ae arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ -- iperf3 -c 127.0.0.1 -t 60

The command is executed concurrently in the guest and the host; at the same
time I run the kvm-unit-tests tests in a loop on the host.

The guest had the same number of CPUs as the host (4). On the host,
perf.data was around 3.5G and the SPE interrupt fired 3100 times.  In the
guest, perf.data was around 2.8G and the interrupt fired 2700 times.  I
dumped the data with perf report --dump-raw-trace > perf.trace, looked sane
to me. My explanation for the difference is that the timer frequency is the
same for the guest and the host, but the guest spends less time executing
on the physical CPU because it's shared with the host, hence fewer
operations in the same amount of time.

4. Test concurrent profiling in the guest and host, version B

For this test I used the command:

$ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ dd if=/dev/zero of=/dev/null count=50000000

which means 10 times more operations than in test 2. This exhibits a
behavior which I don't fully understand. In the host, I get similar results
(interrupt number, total events) with what I would get if the guest isn't
running, which is expected. But in the guest, I get 50% less interrupts
than in the host and the total number of events is less. I am still looking
into this, it might be something that I don't understand about the
workload.

[1] https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/statistical-profiling-extension-for-armv8-a
[2] https://www.spinics.net/lists/arm-kernel/msg776228.html
[3] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034887.html
[4] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3
[5] https://lore.kernel.org/kvm/20201027171735.13638-1-alexandru.elisei@arm.com/
[6] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
[7] https://lore.kernel.org/linux-arm-kernel/2a9c9076588ef1dd36a6a365848cdfe7@kernel.org/
[8] https://lore.kernel.org/kvm/20201027171944.13933-1-alexandru.elisei@arm.com/
[9] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v2

Alexandru Elisei (12):
  KVM: arm64: Initialize VCPU mdcr_el2 before loading it
  KVM: arm64: Hide SPE from guests
  arm64: Introduce CPU SPE feature
  KVM: arm64: Introduce VCPU SPE feature
  KVM: arm64: Introduce SPE primitives
  KVM: arm64: Use separate function for the mapping size in
    user_mem_abort()
  KVM: arm64: Add a new VM device control group for SPE
  KVM: arm64: Add SPE system registers to VCPU context
  KVM: arm64: Switch SPE context on VM entry/exit
  KVM: arm64: Emulate SPE buffer management interrupt
  KVM: arm64: Enable SPE for guests
  Documentation: arm64: Document ARM Neoverse-N1 erratum #1688567

Sudeep Holla (4):
  dt-bindings: ARM SPE: Highlight the need for PPI partitions on
    heterogeneous systems
  KVM: arm64: Define SPE data structure for each VCPU
  KVM: arm64: Add a new VCPU device control group for SPE
  KVM: arm64: VHE: Clear MDCR_EL2.E2PB in vcpu_put()

 Documentation/arm64/silicon-errata.rst        |   2 +
 .../devicetree/bindings/arm/spe-pmu.txt       |   5 +-
 Documentation/virt/kvm/devices/vcpu.rst       |  40 +++
 Documentation/virt/kvm/devices/vm.rst         |  28 ++
 arch/arm64/include/asm/cpucaps.h              |   3 +-
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |  30 +-
 arch/arm64/include/asm/kvm_hyp.h              |  28 +-
 arch/arm64/include/asm/kvm_mmu.h              |   2 +
 arch/arm64/include/asm/sysreg.h               |   4 +
 arch/arm64/include/uapi/asm/kvm.h             |   7 +
 arch/arm64/kernel/cpufeature.c                |  24 ++
 arch/arm64/kvm/Kconfig                        |   8 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/arm.c                          |  84 ++++-
 arch/arm64/kvm/debug.c                        | 100 ++++--
 arch/arm64/kvm/guest.c                        |  57 +++
 arch/arm64/kvm/hyp/include/hyp/spe-sr.h       |  38 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   1 -
 arch/arm64/kvm/hyp/nvhe/Makefile              |   1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  16 +-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c              | 109 ++++++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  12 +
 arch/arm64/kvm/hyp/vhe/Makefile               |   1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c               | 139 ++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  50 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |   2 +-
 arch/arm64/kvm/mmu.c                          | 224 ++++++++++--
 arch/arm64/kvm/reset.c                        |  23 ++
 arch/arm64/kvm/spe.c                          | 324 ++++++++++++++++++
 arch/arm64/kvm/sys_regs.c                     |  52 +++
 include/kvm/arm_spe.h                         | 104 ++++++
 include/uapi/linux/kvm.h                      |   1 +
 33 files changed, 1454 insertions(+), 67 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/spe-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/spe.c
 create mode 100644 include/kvm/arm_spe.h

-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
