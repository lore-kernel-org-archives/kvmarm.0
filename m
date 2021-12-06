Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6866FC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:02:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 001814A534;
	Mon,  6 Dec 2021 12:02:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PGbkGpke9P6m; Mon,  6 Dec 2021 12:02:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2773D4B0C3;
	Mon,  6 Dec 2021 12:02:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5BF4B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtVFE5lqTiXw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:02:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4404B0D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0045F12FC;
 Mon,  6 Dec 2021 09:02:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40AF43F73B;
 Mon,  6 Dec 2021 09:02:38 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
Date: Mon,  6 Dec 2021 17:02:22 +0000
Message-Id: <20211206170223.309789-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206170223.309789-1-alexandru.elisei@arm.com>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 25 +++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               | 37 +++++++++++++++++++++++--
 include/kvm/arm_pmu.h                   |  1 +
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 5 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60a29972d3f1..c82be5cbc268 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -104,6 +104,31 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
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
+systems where there are at least two CPU PMUs on the system.
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
index eaaad4c06561..618138c5f792 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -603,6 +603,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct arm_pmu *arm_pmu = pmu->arm_pmu;
 	struct kvm_pmc *pmc;
 	struct perf_event *event;
 	struct perf_event_attr attr;
@@ -638,8 +639,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
-	attr.type = PERF_TYPE_RAW;
-	attr.size = sizeof(attr);
+	attr.type = arm_pmu ? arm_pmu->pmu.type : PERF_TYPE_RAW;
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
 	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
@@ -941,6 +941,29 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
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
@@ -1027,6 +1050,15 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
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
@@ -1064,6 +1096,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e249c5f172aa..ab3046a8f9bb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -34,6 +34,7 @@ struct kvm_pmu {
 	bool created;
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
