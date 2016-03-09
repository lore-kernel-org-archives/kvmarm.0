From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 77/95] arm64: KVM: Add a new vcpu device control group for
 PMUv3
Date: Wed,  9 Mar 2016 07:31:11 +0000
Message-ID: <1457508689-19672-78-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2806C412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U7ZvGH5IWifq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5925849B9E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:25 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

To configure the virtual PMUv3 overflow interrupt number, we use the
vcpu kvm_device ioctl, encapsulating the KVM_ARM_VCPU_PMU_V3_IRQ
attribute within the KVM_ARM_VCPU_PMU_V3_CTRL group.

After configuring the PMUv3, call the vcpu ioctl with attribute
KVM_ARM_VCPU_PMU_V3_INIT to initialize the PMUv3.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/devices/vcpu.txt |  25 +++++++
 arch/arm/include/asm/kvm_host.h            |  15 ++++
 arch/arm/kvm/arm.c                         |   3 +
 arch/arm64/include/asm/kvm_host.h          |   6 ++
 arch/arm64/include/uapi/asm/kvm.h          |   5 ++
 arch/arm64/kvm/guest.c                     |  51 +++++++++++++
 include/kvm/arm_pmu.h                      |  23 ++++++
 virt/kvm/arm/pmu.c                         | 112 +++++++++++++++++++++++++++++
 8 files changed, 240 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
index 3cc59c5..c041658 100644
--- a/Documentation/virtual/kvm/devices/vcpu.txt
+++ b/Documentation/virtual/kvm/devices/vcpu.txt
@@ -6,3 +6,28 @@ KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
 kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
 
 The groups and attributes per virtual cpu, if any, are architecture specific.
+
+1. GROUP: KVM_ARM_VCPU_PMU_V3_CTRL
+Architectures: ARM64
+
+1.1. ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_IRQ
+Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
+            pointer to an int
+Returns: -EBUSY: The PMU overflow interrupt is already set
+         -ENXIO: The overflow interrupt not set when attempting to get it
+         -ENODEV: PMUv3 not supported
+         -EINVAL: Invalid PMU overflow interrupt number supplied
+
+A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
+number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
+type must be same for each vcpu. As a PPI, the interrupt number is the same for
+all vcpus, while as an SPI it must be a separate number per vcpu.
+
+1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
+Parameters: no additional parameter in kvm_device_attr.addr
+Returns: -ENODEV: PMUv3 not supported
+         -ENXIO: PMUv3 not properly configured as required prior to calling this
+                 attribute
+         -EBUSY: PMUv3 already initialized
+
+Request the initialization of the PMUv3.
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 19e9aba..3850701 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -287,5 +287,20 @@ static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
+static inline int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+					     struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+					     struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+					     struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
 
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 1662323..75c7fed 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -835,6 +835,7 @@ static int kvm_arm_vcpu_set_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	default:
+		ret = kvm_arm_vcpu_arch_set_attr(vcpu, attr);
 		break;
 	}
 
@@ -848,6 +849,7 @@ static int kvm_arm_vcpu_get_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	default:
+		ret = kvm_arm_vcpu_arch_get_attr(vcpu, attr);
 		break;
 	}
 
@@ -861,6 +863,7 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	default:
+		ret = kvm_arm_vcpu_arch_has_attr(vcpu, attr);
 		break;
 	}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b02ef08..71fa6fe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -361,6 +361,12 @@ void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
 
 /* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6aedbe3..f209ea1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -205,6 +205,11 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
+/* Device Control API on vcpu fd */
+#define KVM_ARM_VCPU_PMU_V3_CTRL	0
+#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
+#define   KVM_ARM_VCPU_PMU_V3_INIT	1
+
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
 #define KVM_ARM_IRQ_TYPE_MASK		0xff
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index fcb7788..dbe45c3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -380,3 +380,54 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 	return 0;
 }
+
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		ret = kvm_arm_pmu_v3_get_attr(vcpu, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		ret = kvm_arm_pmu_v3_has_attr(vcpu, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index ee62497..fe389ac 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,7 @@ struct kvm_pmu {
 };
 
 #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
@@ -54,11 +55,18 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 bool kvm_arm_support_pmu_v3(void);
+int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
 #else
 struct kvm_pmu {
 };
 
 #define kvm_arm_pmu_v3_ready(v)		(false)
+#define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
 {
@@ -82,6 +90,21 @@ static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
 static inline bool kvm_arm_support_pmu_v3(void) { return false; }
+static inline int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 6e28f4f..b5754c6 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
@@ -415,3 +416,114 @@ bool kvm_arm_support_pmu_v3(void)
 	 */
 	return (perf_num_counters() > 0);
 }
+
+static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_support_pmu_v3())
+		return -ENODEV;
+
+	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
+	    !kvm_arm_pmu_irq_initialized(vcpu))
+		return -ENXIO;
+
+	if (kvm_arm_pmu_v3_ready(vcpu))
+		return -EBUSY;
+
+	kvm_pmu_vcpu_reset(vcpu);
+	vcpu->arch.pmu.ready = true;
+
+	return 0;
+}
+
+static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			continue;
+
+		if (is_ppi) {
+			if (vcpu->arch.pmu.irq_num != irq)
+				return false;
+		} else {
+			if (vcpu->arch.pmu.irq_num == irq)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+
+int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+			return -ENODEV;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		/*
+		 * The PMU overflow interrupt could be a PPI or SPI, but for one
+		 * VM the interrupt type must be same for each vcpu. As a PPI,
+		 * the interrupt number is the same for all vcpus, while as an
+		 * SPI it must be a separate number per vcpu.
+		 */
+		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
+		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
+			return -EINVAL;
+
+		if (kvm_arm_pmu_irq_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
+		vcpu->arch.pmu.irq_num = irq;
+		return 0;
+	}
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+		return kvm_arm_pmu_v3_init(vcpu);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -ENXIO;
+
+		irq = vcpu->arch.pmu.irq_num;
+		return put_user(irq, uaddr);
+	}
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ:
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+		if (kvm_arm_support_pmu_v3() &&
+		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+			return 0;
+	}
+
+	return -ENXIO;
+}
-- 
2.1.4
