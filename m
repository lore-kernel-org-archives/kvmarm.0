Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAFCC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:18:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B395849ED9;
	Thu, 27 Jan 2022 11:18:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D1-ThxhEcbHb; Thu, 27 Jan 2022 11:18:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43E4049F10;
	Thu, 27 Jan 2022 11:18:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9B04A11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wFl8ejG9XwJY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:17:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C1449ED9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:17:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A7A61063;
 Thu, 27 Jan 2022 08:17:58 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 241263F766;
 Thu, 27 Jan 2022 08:17:56 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 0/6] KVM: arm64: Improve PMU support on heterogeneous
 systems
Date: Thu, 27 Jan 2022 16:17:53 +0000
Message-Id: <20220127161759.53553-1-alexandru.elisei@arm.com>
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

Detailed explanation of the issue and symptoms that the patches attempt to
correct can be found in the cover letter for v1 [3].

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

Changes since v3 [4]:

- Gathered Reviewed-by, thank you!
- Rebased on top of v5.17-rc1, on top of which I added the USB Type-C fixes to
  get my rockpro64 to boot [6]. Shouldn't affect KVM in any way.
- Patches #1 ("KVM: arm64: Do not change the PMU event filter after a
  VCPU has run") and #3 ("KVM: arm64: Keep a per-VM pointer to the default PMU")
  are new.
- Use list_is_singular() in #4 ("KVM: arm64: Keep a list of probed PMUs").
- Return -EBUSY if a VCPU has run or if a PMU event filter has been set.
- Use the PMU that the user specified to replace the default PMU at the VM
  level.

Changes since v2 [5]:

- Rebased on top of v5.16-rc5
- Check that all VCPUs have the same PMU set (or none at all).
- Use the VCPU's PMUVer value when calculating the event mask, if a PMU is
  set for that VCPU.
- Clear the unsupported CPU flag in vcpu_put().
- Move the handling of the unsupported CPU flag in kvm_vcpu_exit_request().
- Free the cpumask of supported CPUs if kvm_arch_vcpu_create() fails.

Changes since v1 [3]:

- Rebased on top of v5.16-rc4
- Implemented review comments: protect iterating through the list of PMUs
  with a mutex, documentation changes, initialize vcpu-arch.supported_cpus
  to cpu_possible_mask, changed vcpu->arch.cpu_not_supported to a VCPU
  flag, set exit reason to KVM_EXIT_FAIL_ENTRY and populate fail_entry when
  the VCPU is run on a CPU not in the PMU's supported cpumask. Many thanks
  for the review!

[1] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v4
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v2
[3] https://www.spinics.net/lists/arm-kernel/msg933579.html
[4] https://www.spinics.net/lists/kvm-arm/msg51079.html
[5] https://www.spinics.net/lists/kvm-arm/msg50944.html
[6] https://www.spinics.net/lists/linux-usb/msg221604.html

Alexandru Elisei (4):
  perf: Fix wrong name in comment for struct perf_cpu_context
  KVM: arm64: Keep a list of probed PMUs
  KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
  KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical
    CPU

Marc Zyngier (2):
  KVM: arm64: Do not change the PMU event filter after a VCPU has run
  KVM: arm64: Keep a per-VM pointer to the default PMU

 Documentation/virt/kvm/devices/vcpu.rst |  34 +++++-
 arch/arm64/include/asm/kvm_host.h       |  15 ++-
 arch/arm64/include/uapi/asm/kvm.h       |   4 +
 arch/arm64/kvm/arm.c                    |  21 ++++
 arch/arm64/kvm/pmu-emul.c               | 141 ++++++++++++++++++------
 include/kvm/arm_pmu.h                   |   5 +
 include/linux/perf_event.h              |   2 +-
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 8 files changed, 189 insertions(+), 34 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
