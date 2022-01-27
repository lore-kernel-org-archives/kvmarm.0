Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B563AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:18:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E914B10B;
	Thu, 27 Jan 2022 11:18:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7XG1t6kNDiBI; Thu, 27 Jan 2022 11:18:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0157749EF0;
	Thu, 27 Jan 2022 11:18:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8C6C49EC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id znKR9i5e4dsZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:18:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B5A749EE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 440201063;
 Thu, 27 Jan 2022 08:18:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED2593F766;
 Thu, 27 Jan 2022 08:18:07 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 5/6] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
Date: Thu, 27 Jan 2022 16:17:58 +0000
Message-Id: <20220127161759.53553-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127161759.53553-1-alexandru.elisei@arm.com>
References: <20220127161759.53553-1-alexandru.elisei@arm.com>
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
in this list depends on the probe order, which can change under various
circumstances, for example if the order of the PMU nodes change in the DTB
or if asynchronous driver probing is enabled on the kernel command line
(with the driver_async_probe=armv8-pmu option).

Another consequence of this approach is that on heteregeneous systems all
virtual machines that KVM creates will use the same PMU. This might cause
unexpected behaviour for userspace: when a VCPU is executing on the
physical CPU that uses this default PMU, PMU events in the guest work
correctly; but when the same VCPU executes on another CPU, PMU events in
the guest will suddenly stop counting.

Fortunately, perf core allows user to specify on which PMU to create an
event by using the perf_event_attr->type field, which is used by
perf_init_event() as an index in the radix tree of available PMUs.

Add the KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU
attribute to allow userspace to specify the arm_pmu that KVM will use when
creating events for that VCPU. KVM will make no attempt to run the VCPU on
the physical CPUs that share the PMU, leaving it up to userspace to manage
the VCPU threads' affinity accordingly.

To ensure that KVM doesn't expose an asymmetric system to the guest, the
PMU set for one VCPU will be used by all other VCPUs. Once a VCPU has run,
the PMU cannot be changed in order to avoid changing the list of available
events for a VCPU, or to change the semantics of existing events.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 28 +++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               | 40 +++++++++++++++++++++++++
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 4 files changed, 70 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index d063aaee5bb7..e8c5770590a2 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -104,6 +104,34 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
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
+	 =======  ====================================================
+	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
+                  an event filter has already been set
+	 -EFAULT  Error accessing the PMU identifier
+	 -ENXIO   PMU not found
+	 -ENODEV  PMUv3 not supported or GIC not initialized
+	 -ENOMEM  Could not allocate memory
+	 =======  ====================================================
+
+Request that the VCPU uses the specified hardware PMU when creating guest events
+for the purpose of PMU emulation. The PMU identifier can be read from the "type"
+file for the desired PMU instance under /sys/devices (or, equivalent,
+/sys/bus/even_source). This attribute is particularly useful on heterogeneous
+systems where there are at least two CPU PMUs on the system. The PMU that is set
+for one VCPU will be used by all the other VCPUs. It isn't possible to set a PMU
+if a PMU event filter is already present.
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
index 7bab73f85b58..18361f367495 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -948,6 +948,36 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *arm_pmu;
+	int ret = -ENXIO;
+
+	mutex_lock(&kvm->lock);
+	mutex_lock(&arm_pmus_lock);
+
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		arm_pmu = entry->arm_pmu;
+		if (arm_pmu->pmu.type == pmu_id) {
+			if (kvm->arch.ran_once ||
+			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
+				ret = -EBUSY;
+				break;
+			}
+
+			kvm->arch.arm_pmu = arm_pmu;
+			ret = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&arm_pmus_lock);
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1046,6 +1076,15 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
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
@@ -1083,6 +1122,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
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
