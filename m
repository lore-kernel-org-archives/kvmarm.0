From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v7 0/5] arm64: Support perf event modifiers :G and :H
Date: Tue, 11 Dec 2018 12:13:35 +0000
Message-ID: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F4B4A36F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WW0TTRN9BHPk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 07:14:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459024A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:05 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patchset provides support for perf event modifiers :G and :H which
allows for filtering of PMU events between host and guests when used
with KVM.

As the underlying hardware cannot distinguish between guest and host
context, the performance counters must be stopped and started upon
entry/exit to the guest. This is performed at EL2 in a way that
minimizes overhead and improves accuracy of recording events that only
occur in the requested context.

This has been tested with VHE and non-VHE kernels with a KVM guest.

Changes from v6:

 - Move events_host/events_guest out of kvm_cpu_context

Changes from v5:

 - Tweak logic in use of kvm_set_pmu_events

Changes from v4:

 - Prevent unnecessary write_sysreg calls by improving
   __pmu_switch_to_xxx logic.

Changes from v3:

 - Remove confusing _only suffix from bitfields in kvm_cpu_context
 - Remove unnecessary condition when clearing event bits in disable
 - Simplify API of KVM accessors
 - Prevent unnecessary setting of pmcnten when guest/host events are
   the same.

Changes from v2:

 - Ensured that exclude_kernel works for guest
 - Removed unnecessary exclusion of EL2 with exclude_host on !VHE
 - Renamed kvm_clr_set_host_pmu_events to reflect args order
 - Added additional information to isb patch

Changes from v1:

 - Removed unnecessary exclusion of EL1 with exclude_guest on VHE
 - Removed unnecessary isb from existing perf_event.c driver
 - Folded perf_event.c patches together
 - Added additional information to last patch commit message

Andrew Murray (5):
  arm64: arm_pmu: remove unnecessary isb instruction
  arm64: KVM: encapsulate kvm_cpu_context in kvm_host_data
  arm64: KVM: add accessors to track guest/host only counters
  arm64: arm_pmu: Add support for exclude_host/exclude_guest attributes
  arm64: KVM: Enable support for :G/:H perf event modifiers

 arch/arm64/include/asm/kvm_host.h | 36 +++++++++++++++++++++++++--
 arch/arm64/kernel/asm-offsets.c   |  3 ++-
 arch/arm64/kernel/perf_event.c    | 52 +++++++++++++++++++++++++++++++++------
 arch/arm64/kvm/hyp/switch.c       | 52 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  4 ++-
 5 files changed, 135 insertions(+), 12 deletions(-)

-- 
2.7.4
