Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F37C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:49:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9ADB561AED
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:49:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9ADB561AED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 018F04B1A9;
	Mon, 15 Nov 2021 11:49:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LDZJxXSuujYf; Mon, 15 Nov 2021 11:49:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FA34B187;
	Mon, 15 Nov 2021 11:49:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 082164B183
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:49:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0bYlrFhstfh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:49:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 087784B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:49:19 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5752C1FB;
 Mon, 15 Nov 2021 08:49:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA0C63F766;
 Mon, 15 Nov 2021 08:49:16 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] KVM: arm64: Improve PMU support on heterogeneous systems
Date: Mon, 15 Nov 2021 16:50:37 +0000
Message-Id: <20211115165041.194884-1-alexandru.elisei@arm.com>
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

(CC'ing Peter Maydell in case this might be of interest to qemu)

The series can be found at [x], and the kvmtool support at [2].

At the moment, the experience of running a virtual machine with a PMU on a
heterogeneous systems (where there are different PMUs), varies from just
works, if the VCPUs run only on the correct physical CPUs, to doesn't work
at all, if the VCPUs run only on the incorrect physical CPUs, to something
doesn't look right, if the VCPUs run some of the time on the correct
physical CPUs, and some of the time on the incorrect physical CPUs. The
reason for this behaviour is that KVM creates perf events to emulate a
guest PMU, and the choice of PMU that is used to create these events is
left entirely up to the perf core system, based on the hardware probe
order. The first PMU to register with perf (via perf_pmu_register()) is the
PMU that will always be chosen when creating the events (in
perf_event_create_kernel_counter() -> perf_event_alloc() ->
perf_event_init()).

Let's take the example of a rockpro64 board, CPUs 0-3 are Cortex-A53 (the
little cores), CPUs 4-5 are Cortex-A72 (the big cores), and each group has
their own PMU. When running the pmu-cycle-counter test from kvm-unit-tests
on the little cores, everything is working as expected:

taskset -c 0-3 ./vm run -c1 -m64 --nodefaults -k arm/pmu.flat -p "cycle-counter 0" --pmu
[..]
PASS: pmu: cycle-counter: Monotonically increasing cycle count
[..]
PASS: pmu: cycle-counter: Cycle/instruction ratio
SUMMARY: 2 tests

But when running the same test on the big cores:

$ taskset -c 4-5 ./vm run -c1 -m64 --nodefaults -k arm/pmu.flat -p "cycle-counter 0" --pmu
[..]
FAIL: pmu: cycle-counter: Monotonically increasing cycle count
[..]
FAIL: pmu: cycle-counter: Cycle/instruction ratio
SUMMARY: 2 tests, 2 unexpected failures

The same behaviour is exhibited when running under qemu.

The test passes on the little cores in that particular setup because the
little cores are the "correct" cores: the PMU that perf chooses to create
the events on is the PMU associated with the little cores. The test fails
on the big cores because the events cannot be scheduled in, as the PMU is
associated with a different set of cores (merge_sched_in() exits early
because event_filter_match() returns false).

It gets even more impredicatable, as the order in which the PMUs are probed
during boot dictates which PMU is chosen for creating the events, and the
probe order can change if, for example, the order of the PMU nodes in the
DTB changes, or if the kernel is booted with asynchronous driver probing
for the armv8-pmu driver. A user can end up in a situation where pinning
the VM on a set of CPUs works just fine, and after a reboot doesn't work
anymore, without any kind of explanation or hints of why it stopped
working.

All of this is not ideal from the user perspective and this series aims to
improve that by adding a new PMU attribute which can be used to tell KVM
exactly on which PMU events for the VCPU should be created. The contract is
that user is still responsible for pinning the VCPUs on the corresponding
CPUs, and KVM will refuse to run the VCPU on a CPU with a different PMU.

With this series on top of kvmtool support for KVM_ARM_VCPU_PMU_V3_SET_PMU
attribute [2], running the same test as above on the little cores, then on
the big cores:

$ taskset -c 0-3 ./vm run -c1 -m64 --nodefaults -k arm/pmu.flat -p "cycle-counter 0" --pmu
[..]
PASS: pmu: cycle-counter: Monotonically increasing cycle count
[..]
PASS: pmu: cycle-counter: Cycle/instruction ratio
SUMMARY: 2 tests

$ taskset -c 4-5 ./vm run -c1 -m64 --nodefaults -k arm/pmu.flat -p "cycle-counter 0" --pmu
[..]
PASS: pmu: cycle-counter: Monotonically increasing cycle count
[..]
PASS: pmu: cycle-counter: Cycle/instruction ratio
SUMMARY: 2 tests

We get a saner behaviour, which is reproducible across reboots, regardless
of the probe order.

And this is what happens if the VCPU is run on a physical PMU with a
different PMU than what was set by userspace:

$ taskset -c 3-4 ./vm run -c1 -m64 --nodefaults -k arm/pmu.flat -p "cycle-counter 0" --pmu
KVM_RUN failed: Exec format error

kvmtool sets the PMU for all VCPUs from the main thread; the main thread
runs on the little core (CPU3), but the VCPU is scheduled on the big core
(CPU4); there is a mismatch between the VCPU PMU and the physical CPU PMU,
and KVM returns -ENOEXEC from KVM_RUN.

[1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v1
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v1

Alexandru Elisei (4):
  perf: Fix wrong name in comment for struct perf_cpu_context
  KVM: arm64: Keep a list of probed PMUs
  KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
  KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical
    CPU

 Documentation/virt/kvm/api.rst          |  5 ++-
 Documentation/virt/kvm/devices/vcpu.rst | 26 +++++++++++
 arch/arm64/include/asm/kvm_host.h       |  3 ++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    | 15 +++++++
 arch/arm64/kvm/pmu-emul.c               | 58 +++++++++++++++++++++++--
 include/kvm/arm_pmu.h                   |  6 +++
 include/linux/perf_event.h              |  2 +-
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 9 files changed, 110 insertions(+), 7 deletions(-)

-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
