Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9763BC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 15:23:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB664B17D;
	Mon, 13 Dec 2021 10:23:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1wfRG-ZKFJ4z; Mon, 13 Dec 2021 10:23:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB654B1AF;
	Mon, 13 Dec 2021 10:23:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA6914B162
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JvUVu0xFz5Ot for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 10:23:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE394B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79B281FB;
 Mon, 13 Dec 2021 07:23:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC2923F73B;
 Mon, 13 Dec 2021 07:23:20 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
Date: Mon, 13 Dec 2021 15:23:05 +0000
Message-Id: <20211213152309.158462-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Cc: tglx@linutronix.de, mingo@redhat.com
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

The series can be found on a branch at [1], and the kvmtool support at [2].
The kvmtool patches are also on the mailing list [3] and haven't changed
since v1.

Detailed explanation of the issue and symptoms that the patches attempt to
correct can be found in the cover letter for v1 [4].

A summary of the problem is that on heterogeneous systems KVM will always
use the same PMU for creating the VCPU events for *all* VCPUs regardless of
the physical CPU on which the VCPU is running, leading to events suddenly
stopping and resuming in the guest as the VCPU thread gets migrated across
different CPUs.

This series proposes to fix this behaviour by allowing the user to specify
which physical PMU is used when creating the VCPU events needed for guest
PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
physical which is not part of the supported CPUs for the specified PMU. The
restriction is that all VCPUs must use the same PMU to avoid emulating an
asymmetric platform.

The default behaviour stays the same - without userspace setting the PMU,
events will stop counting if the VCPU is scheduled on the wrong CPU.

Tested with a hacked version of kvmtool that does the PMU initialization
from the VCPU thread as opposed to from the main thread. Tested on
rockpro64 by testing what happens when all VCPUs having the same PMU, one
random VCPU having a different PMU than the other VCPUs and one random VCPU
not having the PMU set (each test was run 1,000 times on the little cores
and 1,000 times on the big cores).

Also tested on an Altra by testing all VCPUs having the same PMU, all VCPUs
not having a PMU set, and one random VCPU not having the PMU set; the VM
had 64 threads in each of the tests and each test was run 10,000 times.

Changes since v2 [5]:

- Rebased on top of v5.16-rc5
- Check that all VCPUs have the same PMU set (or none at all).
- Use the VCPU's PMUVer value when calculating the event mask, if a PMU is
  set for that VCPU.
- Clear the unsupported CPU flag in vcpu_put().
- Move the handling of the unsupported CPU flag in kvm_vcpu_exit_request().
- Free the cpumask of supported CPUs if kvm_arch_vcpu_create() fails.

Changes since v1 [4]:

- Rebased on top of v5.16-rc4
- Implemented review comments: protect iterating through the list of PMUs
  with a mutex, documentation changes, initialize vcpu-arch.supported_cpus
  to cpu_possible_mask, changed vcpu->arch.cpu_not_supported to a VCPU
  flag, set exit reason to KVM_EXIT_FAIL_ENTRY and populate fail_entry when
  the VCPU is run on a CPU not in the PMU's supported cpumask. Many thanks
  for the review!

[1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v3
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v1
[3] https://www.spinics.net/lists/arm-kernel/msg933584.html
[4] https://www.spinics.net/lists/arm-kernel/msg933579.html
[5] https://www.spinics.net/lists/kvm-arm/msg50944.html


Alexandru Elisei (4):
  perf: Fix wrong name in comment for struct perf_cpu_context
  KVM: arm64: Keep a list of probed PMUs
  KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
  KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical
    CPU

 Documentation/virt/kvm/devices/vcpu.rst |  34 ++++++-
 arch/arm64/include/asm/kvm_host.h       |  12 +++
 arch/arm64/include/uapi/asm/kvm.h       |   4 +
 arch/arm64/kvm/arm.c                    |  29 +++++-
 arch/arm64/kvm/pmu-emul.c               | 114 ++++++++++++++++++++----
 include/kvm/arm_pmu.h                   |   9 +-
 include/linux/perf_event.h              |   2 +-
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 8 files changed, 180 insertions(+), 25 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
