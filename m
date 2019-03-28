From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v12 0/8] arm64: Support perf event modifiers :G and :H
Date: Thu, 28 Mar 2019 10:37:23 +0000
Message-ID: <20190328103731.27264-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Julien Thierry <julien.thierry@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patchset provides support for perf event modifiers :G and :H which
allows for filtering of PMU events between host and guests when used
with KVM.

As the underlying hardware cannot distinguish between guest and host
context we must switch the performance counters upon entry/exit to the
guest.

For non-VHE the counters must be stopped and started upon entry/exit to
the guest in __kvm_vcpu_run_nvhe.

For VHE we keep the counters enabled but instead change the event type
to include/exclude EL0 as appropriate. This allows us to perform this
switch outside the critical section of world-switch code in vcpu_load.

This has been tested with VHE and non-VHE kernels with a KVM guest.

Changes from v11:

 - Rebased to v5.1-rc2

 - Minor changes to commit messages, fixing typos, removing superfluous
   comments, code.

 - Change ^ to != in kvm_pmu_switch_needed

Changes from v10:

 - Remove counter switch code from kvm_vcpu_run_vhe and replace with
   enable/disable EL0 event type in kvm_arch_vcpu_load instead

 - Reduce counter switch code in __kvm_vcpu_run_nvhe by moving some
   logic to kvm_set_pmu_events (kvm_pmu_switch_needed)

 - Simplify code by removing need for KVM_PMU_EVENTS_{HOST,GUEST}

 - Add kvm_host helper function to let PMU determine if event should
   start counting when it is enabled

 - Exclude EL2 on !VHE when exclude_host (to avoid counting host events
   as guest during entry/exit)

 - Moved PMU switching code to its own file

 - Rebased to v5.0

 - Added documentation

 - Removed Reviewed-By's for changed patches and updated commit messages

Changes from v9:

 - Rebased to v5.0-rc2
 - Ensure get_host_ctxt considers host_ctxt offset

Changes from v8:

 - Added additional comments
 - Fixed bisect build failure
 - Renamed cpu_ctxt variable to cpu_data

Changes from v7:

 - Added additional patch to encapsulate kvm_cpu_context in kvm_host_data

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


Andrew Murray (8):
  arm64: arm_pmu: remove unnecessary isb instruction
  arm64: KVM: encapsulate kvm_cpu_context in kvm_host_data
  arm64: KVM: add accessors to track guest/host only counters
  arm64: arm_pmu: Add !VHE support for exclude_host/exclude_guest
    attributes
  arm64: KVM: Enable !VHE support for :G/:H perf event modifiers
  arm64: KVM: Enable VHE support for :G/:H perf event modifiers
  arm64: KVM: avoid isb's by using direct pmxevtyper sysreg
  arm64: docs: document perf event attributes

 Documentation/arm64/perf.txt      |  74 ++++++++++
 arch/arm/include/asm/kvm_host.h   |  11 +-
 arch/arm64/include/asm/kvm_asm.h  |   3 +-
 arch/arm64/include/asm/kvm_host.h |  39 ++++-
 arch/arm64/kernel/asm-offsets.c   |   1 +
 arch/arm64/kernel/perf_event.c    |  50 +++++--
 arch/arm64/kvm/Makefile           |   2 +-
 arch/arm64/kvm/hyp/switch.c       |   6 +
 arch/arm64/kvm/pmu.c              | 232 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |   3 +
 virt/kvm/arm/arm.c                |  16 ++-
 11 files changed, 412 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/arm64/perf.txt
 create mode 100644 arch/arm64/kvm/pmu.c

-- 
2.21.0
