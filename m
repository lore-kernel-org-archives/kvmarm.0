Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BEDC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 14:55:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671E249EE0;
	Mon, 25 Apr 2022 10:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XxY480rVnAf7; Mon, 25 Apr 2022 10:55:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6E749F26;
	Mon, 25 Apr 2022 10:55:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCAB049EE0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 10:55:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s40FTeKCtUKW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 10:55:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA7249ECA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 10:55:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 700741FB;
 Mon, 25 Apr 2022 07:55:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 488B83F774;
 Mon, 25 Apr 2022 07:55:33 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if feature
 not set
Date: Mon, 25 Apr 2022 15:55:30 +0100
Message-Id: <20220425145530.723858-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
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

kvm->arch.arm_pmu is set when userspace attempts to set the first PMU
attribute. As certain attributes are mandatory, arm_pmu ends up always
being set to a valid arm_pmu, otherwise KVM will refuse to run the VCPU.
However, this only happens if the VCPU has the PMU feature. If the VCPU
doesn't have the feature bit set, kvm->arch.arm_pmu will be left
uninitialized and equal to NULL.

KVM doesn't do ID register emulation for 32-bit guests and accesses to the
PMU registers aren't gated by the pmu_visibility() function. This is done
to prevent injecting unexpected undefined exceptions in guests which have
detected the presence of a hardware PMU. But even though the VCPU feature
is missing, KVM still attempts to emulate certain aspects of the PMU when
PMU registers are accessed. This leads to a NULL pointer dereference like
this one, which happens on an odroid-c4 board when running the
kvm-unit-tests pmu-cycle-counter test with kvmtool and without the PMU
feature being set:

[  454.402699] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000150
[  454.405865] Mem abort info:
[  454.408596]   ESR = 0x96000004
[  454.411638]   EC = 0x25: DABT (current EL), IL = 32 bits
[  454.416901]   SET = 0, FnV = 0
[  454.419909]   EA = 0, S1PTW = 0
[  454.423010]   FSC = 0x04: level 0 translation fault
[  454.427841] Data abort info:
[  454.430687]   ISV = 0, ISS = 0x00000004
[  454.434484]   CM = 0, WnR = 0
[  454.437404] user pgtable: 4k pages, 48-bit VAs, pgdp=000000000c924000
[  454.443800] [0000000000000150] pgd=0000000000000000, p4d=0000000000000000
[  454.450528] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[  454.456036] Modules linked in:
[  454.459053] CPU: 1 PID: 267 Comm: kvm-vcpu-0 Not tainted 5.18.0-rc4 #113
[  454.465697] Hardware name: Hardkernel ODROID-C4 (DT)
[  454.470612] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  454.477512] pc : kvm_pmu_event_mask.isra.0+0x14/0x74
[  454.482427] lr : kvm_pmu_set_counter_event_type+0x2c/0x80
[  454.487775] sp : ffff80000a9839c0
[  454.491050] x29: ffff80000a9839c0 x28: ffff000000a83a00 x27: 0000000000000000
[  454.498127] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00000a510000
[  454.505198] x23: ffff000000a83a00 x22: ffff000003b01000 x21: 0000000000000000
[  454.512271] x20: 000000000000001f x19: 00000000000003ff x18: 0000000000000000
[  454.519343] x17: 000000008003fe98 x16: 0000000000000000 x15: 0000000000000000
[  454.526416] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  454.533489] x11: 000000008003fdbc x10: 0000000000009d20 x9 : 000000000000001b
[  454.540561] x8 : 0000000000000000 x7 : 0000000000000d00 x6 : 0000000000009d00
[  454.547633] x5 : 0000000000000037 x4 : 0000000000009d00 x3 : 0d09000000000000
[  454.554705] x2 : 000000000000001f x1 : 0000000000000000 x0 : 0000000000000000
[  454.561779] Call trace:
[  454.564191]  kvm_pmu_event_mask.isra.0+0x14/0x74
[  454.568764]  kvm_pmu_set_counter_event_type+0x2c/0x80
[  454.573766]  access_pmu_evtyper+0x128/0x170
[  454.577905]  perform_access+0x34/0x80
[  454.581527]  kvm_handle_cp_32+0x13c/0x160
[  454.585495]  kvm_handle_cp15_32+0x1c/0x30
[  454.589462]  handle_exit+0x70/0x180
[  454.592912]  kvm_arch_vcpu_ioctl_run+0x1c4/0x5e0
[  454.597485]  kvm_vcpu_ioctl+0x23c/0x940
[  454.601280]  __arm64_sys_ioctl+0xa8/0xf0
[  454.605160]  invoke_syscall+0x48/0x114
[  454.608869]  el0_svc_common.constprop.0+0xd4/0xfc
[  454.613527]  do_el0_svc+0x28/0x90
[  454.616803]  el0_svc+0x34/0xb0
[  454.619822]  el0t_64_sync_handler+0xa4/0x130
[  454.624049]  el0t_64_sync+0x18c/0x190
[  454.627675] Code: a9be7bfd 910003fd f9000bf3 52807ff3 (b9415001)
[  454.633714] ---[ end trace 0000000000000000 ]---

In this particular case, Linux hasn't detected the presence of a hardware
PMU because the PMU node is missing from the DTB, so userspace would have
been unable to set the VCPU PMU feature even if it attempted it. What
happens is that the 32-bit guest reads ID_DFR0, which advertises the
presence of the PMU, and when it tries to program a counter, it triggers
the NULL pointer dereference because kvm->arch.arm_pmu is NULL.

kvm-arch.arm_pmu was introduced by commit 46b187821472 ("KVM: arm64:
Keep a per-VM pointer to the default PMU"). Until that commit, this
error would be triggered instead:

[   73.388140] ------------[ cut here ]------------
[   73.388189] Unknown PMU version 0
[   73.390420] WARNING: CPU: 1 PID: 264 at arch/arm64/kvm/pmu-emul.c:36 kvm_pmu_event_mask.isra.0+0x6c/0x74
[   73.399821] Modules linked in:
[   73.402835] CPU: 1 PID: 264 Comm: kvm-vcpu-0 Not tainted 5.17.0 #114
[   73.409132] Hardware name: Hardkernel ODROID-C4 (DT)
[   73.414048] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   73.420948] pc : kvm_pmu_event_mask.isra.0+0x6c/0x74
[   73.425863] lr : kvm_pmu_event_mask.isra.0+0x6c/0x74
[   73.430779] sp : ffff80000a8db9b0
[   73.434055] x29: ffff80000a8db9b0 x28: ffff000000dbaac0 x27: 0000000000000000
[   73.441131] x26: ffff000000dbaac0 x25: 00000000c600000d x24: 0000000000180720
[   73.448203] x23: ffff800009ffbe10 x22: ffff00000b612000 x21: 0000000000000000
[   73.455276] x20: 000000000000001f x19: 0000000000000000 x18: ffffffffffffffff
[   73.462348] x17: 000000008003fe98 x16: 0000000000000000 x15: 0720072007200720
[   73.469420] x14: 0720072007200720 x13: ffff800009d32488 x12: 00000000000004e6
[   73.476493] x11: 00000000000001a2 x10: ffff800009d32488 x9 : ffff800009d32488
[   73.483565] x8 : 00000000ffffefff x7 : ffff800009d8a488 x6 : ffff800009d8a488
[   73.490638] x5 : ffff0000f461a9d8 x4 : 0000000000000000 x3 : 0000000000000001
[   73.497710] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000000dbaac0
[   73.504784] Call trace:
[   73.507195]  kvm_pmu_event_mask.isra.0+0x6c/0x74
[   73.511768]  kvm_pmu_set_counter_event_type+0x2c/0x80
[   73.516770]  access_pmu_evtyper+0x128/0x16c
[   73.520910]  perform_access+0x34/0x80
[   73.524532]  kvm_handle_cp_32+0x13c/0x160
[   73.528500]  kvm_handle_cp15_32+0x1c/0x30
[   73.532467]  handle_exit+0x70/0x180
[   73.535917]  kvm_arch_vcpu_ioctl_run+0x20c/0x6e0
[   73.540489]  kvm_vcpu_ioctl+0x2b8/0x9e0
[   73.544283]  __arm64_sys_ioctl+0xa8/0xf0
[   73.548165]  invoke_syscall+0x48/0x114
[   73.551874]  el0_svc_common.constprop.0+0xd4/0xfc
[   73.556531]  do_el0_svc+0x28/0x90
[   73.559808]  el0_svc+0x28/0x80
[   73.562826]  el0t_64_sync_handler+0xa4/0x130
[   73.567054]  el0t_64_sync+0x1a0/0x1a4
[   73.570676] ---[ end trace 0000000000000000 ]---
[   73.575382] kvm: pmu event creation failed -2

The root cause remains the same: kvm->arch.pmuver was never set to
something sensible because the VCPU feature itself was never set.

The odroid-c4 is somewhat of a special case, because Linux doesn't probe
the PMU. But the above errors can easily be reproduced on any hardware,
with or without a PMU driver, as long as userspace doesn't set the PMU
feature.

Work around the fact that KVM advertises a PMU even when the VCPU feature
is not set by gating all PMU emulation on the feature. The guest can still
access the registers without KVM injecting an undefined exception.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
This looked to me like the easiest fix. I'm open to suggestions if someone
comes up with a better solution.

In the long run, I think the best fix would be to do ID register emulation
for 32-bit guests, like KVM does today for 64-bit guests.

 arch/arm64/kvm/pmu-emul.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 78fdc443adc7..3dc990ac4f44 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -177,6 +177,9 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return 0;
+
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
 	if (kvm_pmu_pmc_is_chained(pmc) &&
@@ -198,6 +201,9 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
 	u64 reg;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
@@ -322,6 +328,9 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
@@ -357,7 +366,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!val)
+	if (!kvm_vcpu_has_pmu(vcpu) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -527,6 +536,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
@@ -576,6 +588,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
@@ -739,6 +754,9 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 {
 	u64 reg, mask;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
 	mask  =  ARMV8_PMU_EVTYPE_MASK;
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
@@ -827,6 +845,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return 0;
+
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
 		base = 0;
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
