Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4617AC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 15:23:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1754B174;
	Mon, 13 Dec 2021 10:23:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fwmIoMcRVzEk; Mon, 13 Dec 2021 10:23:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08114B1AA;
	Mon, 13 Dec 2021 10:23:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704F54B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxFipMTg1oHC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 10:23:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F5064B1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 10:23:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA55AD6E;
 Mon, 13 Dec 2021 07:23:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 190553F73B;
 Mon, 13 Dec 2021 07:23:26 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
Date: Mon, 13 Dec 2021 15:23:08 +0000
Message-Id: <20211213152309.158462-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213152309.158462-1-alexandru.elisei@arm.com>
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
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

When KVM creates an event and there are more than one PMUs present on the
system, perf_init_event() will go through the list of available PMUs and
will choose the first one that can create the event. The order of the PMUs
in the PMU list depends on the probe order, which can change under various
circumstances, for example if the order of the PMU nodes change in the DTB
or if asynchronous driver probing is enabled on the kernel command line
(with the driver_async_probe=armv8-pmu option).

Another consequence of this approach is that, on heteregeneous systems,
all virtual machines that KVM creates will use the same PMU. This might
cause unexpected behaviour for userspace: when a VCPU is executing on
the physical CPU that uses this PMU, PMU events in the guest work
correctly; but when the same VCPU executes on another CPU, PMU events in
the guest will suddenly stop counting.

Fortunately, perf core allows user to specify on which PMU to create an
event by using the perf_event_attr->type field, which is used by
perf_init_event() as an index in the radix tree of available PMUs.

Add the KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU
attribute to allow userspace to specify the arm_pmu that KVM will use when
creating events for that VCPU. KVM will make no attempt to run the VCPU on
the physical CPUs that share this PMU, leaving it up to userspace to
manage the VCPU threads' affinity accordingly.

Setting the PMU for a VCPU is an all of nothing affair to avoid exposing an
asymmetric system to the guest: either all VCPUs have the same PMU, either
none of the VCPUs have a PMU set. Attempting to do something in between
will result in an error being returned when doing KVM_ARM_VCPU_PMU_V3_INIT.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Checking that all VCPUs have the same PMU is done when the PMU is
initialized because setting the VCPU PMU is optional, and KVM cannot know
what the user intends until the KVM_ARM_VCPU_PMU_V3_INIT ioctl, which
prevents further changes to the VCPU PMU. vcpu->arch.pmu.created has been
changed to an atomic variable because changes to the VCPU PMU state now
need to be observable by all physical CPUs.

 Documentation/virt/kvm/devices/vcpu.rst | 30 ++++++++-
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               | 88 ++++++++++++++++++++-----
 include/kvm/arm_pmu.h                   |  4 +-
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 5 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60a29972d3f1..b918669bf925 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -49,8 +49,8 @@ Returns:
 	 =======  ======================================================
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
-	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set
+	 -ENXIO   PMUv3 not supported, missing VCPU feature, interrupt
+		  number not set or mismatched PMUs set
 	 -EBUSY   PMUv3 already initialized
 	 =======  ======================================================
 
@@ -104,6 +104,32 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
 isn't strictly speaking an event. Filtering the cycle counter is possible
 using event 0x11 (CPU_CYCLES).
 
+1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_SET_PMU
+------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to an int representing the PMU
+             identifier.
+
+:Returns:
+
+	 =======  ===============================================
+	 -EBUSY   PMUv3 already initialized
+	 -EFAULT  Error accessing the PMU identifier
+	 -ENXIO   PMU not found
+	 -ENODEV  PMUv3 not supported or GIC not initialized
+	 -ENOMEM  Could not allocate memory
+	 =======  ===============================================
+
+Request that the VCPU uses the specified hardware PMU when creating guest events
+for the purpose of PMU emulation. The PMU identifier can be read from the "type"
+file for the desired PMU instance under /sys/devices (or, equivalent,
+/sys/bus/even_source). This attribute is particularly useful on heterogeneous
+systems where there are at least two CPU PMUs on the system. All VCPUs must have
+the same PMU, otherwise KVM_ARM_VCPU_PMU_V3_INIT will fail.
+
+Note that KVM will not make any attempts to run the VCPU on the physical CPUs
+associated with the PMU specified by this attribute. This is entirely left to
+userspace.
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..1d0a0a2a9711 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
 #define   KVM_ARM_VCPU_PMU_V3_FILTER	2
+#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eb4be96f144d..8de38d7fa493 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -24,9 +24,16 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
 
 #define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 kvm_pmu_event_mask(struct kvm_vcpu *vcpu)
 {
-	switch (kvm->arch.pmuver) {
+	unsigned int pmuver;
+
+	if (vcpu->arch.pmu.arm_pmu)
+		pmuver = vcpu->arch.pmu.arm_pmu->pmuver;
+	else
+		pmuver = vcpu->kvm->arch.pmuver;
+
+	switch (pmuver) {
 	case ID_AA64DFR0_PMUVER_8_0:
 		return GENMASK(9, 0);
 	case ID_AA64DFR0_PMUVER_8_1:
@@ -34,7 +41,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	case ID_AA64DFR0_PMUVER_8_5:
 		return GENMASK(15, 0);
 	default:		/* Shouldn't be here, just for sanity */
-		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
+		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
 		return 0;
 	}
 }
@@ -119,7 +126,7 @@ static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
 		return false;
 
 	reg = PMEVTYPER0_EL0 + select_idx;
-	eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
+	eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu);
 
 	return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
 }
@@ -534,7 +541,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 
 		/* PMSWINC only applies to ... SW_INC! */
 		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
-		type &= kvm_pmu_event_mask(vcpu->kvm);
+		type &= kvm_pmu_event_mask(vcpu);
 		if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
 			continue;
 
@@ -602,6 +609,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct arm_pmu *arm_pmu = pmu->arm_pmu;
 	struct kvm_pmc *pmc;
 	struct perf_event *event;
 	struct perf_event_attr attr;
@@ -622,7 +630,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
 	else
-		eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
+		eventsel = data & kvm_pmu_event_mask(vcpu);
 
 	/* Software increment event doesn't need to be backed by a perf event */
 	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
@@ -637,8 +645,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
-	attr.type = PERF_TYPE_RAW;
-	attr.size = sizeof(attr);
+	attr.type = arm_pmu ? arm_pmu->pmu.type : PERF_TYPE_RAW;
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
 	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
@@ -733,7 +740,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 
 	mask  =  ARMV8_PMU_EVTYPE_MASK;
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
-	mask |= kvm_pmu_event_mask(vcpu->kvm);
+	mask |= kvm_pmu_event_mask(vcpu);
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
@@ -836,7 +843,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	if (!bmap)
 		return val;
 
-	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+	nr_events = kvm_pmu_event_mask(vcpu) + 1;
 
 	for (i = 0; i < 32; i += 8) {
 		u64 byte;
@@ -857,7 +864,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return 0;
 
-	if (!vcpu->arch.pmu.created)
+	if (!atomic_read(&vcpu->arch.pmu.created))
 		return -EINVAL;
 
 	/*
@@ -887,15 +894,20 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		int ret;
+	struct arm_pmu *arm_pmu = vcpu->arch.pmu.arm_pmu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu *v;
+	int ret = 0;
+	int i;
+
+	if (irqchip_in_kernel(kvm)) {
 
 		/*
 		 * If using the PMU with an in-kernel virtual GIC
 		 * implementation, we require the GIC to be already
 		 * initialized when initializing the PMU.
 		 */
-		if (!vgic_initialized(vcpu->kvm))
+		if (!vgic_initialized(kvm))
 			return -ENODEV;
 
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
@@ -910,7 +922,16 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 	init_irq_work(&vcpu->arch.pmu.overflow_work,
 		      kvm_pmu_perf_overflow_notify_vcpu);
 
-	vcpu->arch.pmu.created = true;
+	atomic_set(&vcpu->arch.pmu.created, 1);
+
+	kvm_for_each_vcpu(i, v, kvm) {
+		if (!atomic_read(&v->arch.pmu.created))
+			continue;
+
+		if (v->arch.pmu.arm_pmu != arm_pmu)
+			return -ENXIO;
+	}
+
 	return 0;
 }
 
@@ -940,12 +961,35 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
+{
+	struct kvm_pmu *kvm_pmu = &vcpu->arch.pmu;
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *arm_pmu;
+	int ret = -ENXIO;
+
+	mutex_lock(&arm_pmus_lock);
+
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		arm_pmu = entry->arm_pmu;
+		if (arm_pmu->pmu.type == pmu_id) {
+			kvm_pmu->arm_pmu = arm_pmu;
+			ret = 0;
+			goto out_unlock;
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&arm_pmus_lock);
+	return ret;
+}
+
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
-	if (vcpu->arch.pmu.created)
+	if (atomic_read(&vcpu->arch.pmu.created))
 		return -EBUSY;
 
 	if (!vcpu->kvm->arch.pmuver)
@@ -984,7 +1028,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+		nr_events = kvm_pmu_event_mask(vcpu) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
@@ -1026,6 +1070,15 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int pmu_id;
+
+		if (get_user(pmu_id, uaddr))
+			return -EFAULT;
+
+		return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -1063,6 +1116,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e249c5f172aa..892728f85b25 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,7 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/atomic.h>
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
 
@@ -31,9 +32,10 @@ struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
-	bool created;
+	atomic_t created;
 	bool irq_level;
 	struct irq_work overflow_work;
+	struct arm_pmu *arm_pmu;
 };
 
 struct arm_pmu_entry {
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..1d0a0a2a9711 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
 #define   KVM_ARM_VCPU_PMU_V3_FILTER	2
+#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
