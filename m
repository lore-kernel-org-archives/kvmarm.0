Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1132C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 101034B0B3;
	Mon,  6 Dec 2021 12:02:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id deOvDjZZ+FkW; Mon,  6 Dec 2021 12:02:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF5E14B0B6;
	Mon,  6 Dec 2021 12:02:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0642649FE6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5cUav6jyuWyI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:02:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC92407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C5CB1042;
 Mon,  6 Dec 2021 09:02:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAB9D3F73B;
 Mon,  6 Dec 2021 09:02:31 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
Date: Mon,  6 Dec 2021 17:02:19 +0000
Message-Id: <20211206170223.309789-1-alexandru.elisei@arm.com>
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

A brief summary of the problem is that on heterogeneous systems KVM will
always use the same PMU for creating the VCPU events for *all* VCPUs
regardless of the physical CPU on which the VCPU is running, leading to
events suddenly stopping and resuming in the guest as the VCPU thread gets
migrated across different CPUs.

This series proposes to fix this behaviour by allowing the user to specify
which physical PMU is used when creating the VCPU events needed for guest
PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
physical which is not part of the supported CPUs for the specified PMU.

The default behaviour stays the same - without userspace setting the PMU,
events will stop counting if the VCPU is scheduled on the wrong CPU.

Changes since v1:

- Rebased on top of v5.16-rc4

- Implemented review comments: protect iterating through the list of PMUs
  with a mutex, documentation changes, initialize vcpu-arch.supported_cpus
  to cpu_possible_mask, changed vcpu->arch.cpu_not_supported to a VCPU
  flag, set exit reason to KVM_EXIT_FAIL_ENTRY and populate fail_entry when
  the VCPU is run on a CPU not in the PMU's supported cpumask. Many thanks
  for the review!

[1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v2
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v1
[3] https://www.spinics.net/lists/arm-kernel/msg933584.html
[4] https://www.spinics.net/lists/arm-kernel/msg933579.html

Alexandru Elisei (4):
  perf: Fix wrong name in comment for struct perf_cpu_context
  KVM: arm64: Keep a list of probed PMUs
  KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
  KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical
    CPU

 Documentation/virt/kvm/devices/vcpu.rst | 29 +++++++++++
 arch/arm64/include/asm/kvm_host.h       | 12 +++++
 arch/arm64/include/uapi/asm/kvm.h       |  4 ++
 arch/arm64/kvm/arm.c                    | 19 ++++++++
 arch/arm64/kvm/pmu-emul.c               | 64 +++++++++++++++++++++++--
 include/kvm/arm_pmu.h                   |  6 +++
 include/linux/perf_event.h              |  2 +-
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 8 files changed, 132 insertions(+), 5 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
