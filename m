From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 12/13] KVM: arm64: add a new vcpu device control group for
 SPEv1
Date: Thu, 28 Feb 2019 16:07:34 +0000
Message-ID: <20190228160737.3323-13-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2490B4A483
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0OEvInc8hC+n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:20 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9968C4A453
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:20 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

To configure the virtual SPEv1 overflow interrupt number, we use the
vcpu kvm_device ioctl, encapsulating the KVM_ARM_VCPU_SPE_V1_IRQ
attribute within the KVM_ARM_VCPU_SPE_V1_CTRL group.

After configuring the SPEv1, call the vcpu ioctl with attribute
KVM_ARM_VCPU_SPE_V1_INIT to initialize the SPEv1.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 Documentation/virtual/kvm/devices/vcpu.txt |  28 ++++
 arch/arm64/include/asm/kvm_host.h          |   2 +-
 arch/arm64/include/uapi/asm/kvm.h          |   4 +
 arch/arm64/kvm/Makefile                    |   1 +
 arch/arm64/kvm/guest.c                     |   9 ++
 arch/arm64/kvm/reset.c                     |   3 +
 include/kvm/arm_spe.h                      |  35 +++++
 include/uapi/linux/kvm.h                   |   1 +
 virt/kvm/arm/spe.c                         | 163 +++++++++++++++++++++
 9 files changed, 245 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/arm/spe.c

diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
index 2b5dab16c4f2..d1ece488aeee 100644
--- a/Documentation/virtual/kvm/devices/vcpu.txt
+++ b/Documentation/virtual/kvm/devices/vcpu.txt
@@ -60,3 +60,31 @@ time to use the number provided for a given timer, overwriting any previously
 configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
+
+3. GROUP: KVM_ARM_VCPU_SPE_V1_CTRL
+Architectures: ARM64
+
+1.1. ATTRIBUTE: KVM_ARM_VCPU_SPE_V1_IRQ
+Parameters: in kvm_device_attr.addr the address for SPE buffer overflow interrupt
+	    is a pointer to an int
+Returns: -EBUSY: The SPE overflow interrupt is already set
+         -ENXIO: The overflow interrupt not set when attempting to get it
+         -ENODEV: SPEv1 not supported
+         -EINVAL: Invalid SPE overflow interrupt number supplied or
+                  trying to set the IRQ number without using an in-kernel
+                  irqchip.
+
+A value describing the SPEv1 (Statistical Profiling Extension v1) overflow
+interrupt number for this vcpu. This interrupt should be PPI and the interrupt
+type and number must be same for each vcpu.
+
+1.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_V1_INIT
+Parameters: no additional parameter in kvm_device_attr.addr
+Returns: -ENODEV: SPEv1 not supported or GIC not initialized
+         -ENXIO: SPEv1 not properly configured or in-kernel irqchip not
+                 configured as required prior to calling this attribute
+         -EBUSY: SPEv1 already initialized
+
+Request the initialization of the SPEv1.  If using the SPEv1 with an in-kernel
+virtual GIC implementation, this must be done after initializing the in-kernel
+irqchip.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9a5b90dc8962..1c40eb29093e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,7 +44,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478ee6e7..152f8b9d8c1a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -102,6 +102,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_SPE_V1		4 /* Support guest SPEv1 */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -263,6 +264,9 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_SPE_V1_CTRL	2
+#define   KVM_ARM_VCPU_SPE_V1_IRQ	0
+#define   KVM_ARM_VCPU_SPE_V1_INIT	1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 0f2a135ba15b..6c09fd1cb647 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -37,3 +37,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
+kvm-$(CONFIG_KVM_ARM_SPE) += $(KVM)/arm/spe.o
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd436a50fce7..b92a540d7fdc 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -497,6 +497,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_V1_CTRL:
+		ret = kvm_arm_spe_v1_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -517,6 +520,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_V1_CTRL:
+		ret = kvm_arm_spe_v1_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -537,6 +543,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_V1_CTRL:
+		ret = kvm_arm_spe_v1_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f16a5f8ff2b4..2d08026789c4 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -85,6 +85,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 		break;
+	case KVM_CAP_ARM_SPE_V1:
+		r = kvm_arm_support_spe_v1();
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 132efd636722..1a13163e19a2 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -19,6 +19,9 @@ struct kvm_spe {
 #ifdef CONFIG_KVM_ARM_SPE
 
 #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
+#define kvm_arm_spe_irq_initialized(v)		\
+	((v)->arch.spe.irq >= VGIC_NR_SGIS &&	\
+	(v)->arch.spe.irq <= VGIC_MAX_PRIVATE)
 
 static inline bool kvm_arm_support_spe_v1(void)
 {
@@ -26,10 +29,42 @@ static inline bool kvm_arm_support_spe_v1(void)
 	return !!cpuid_feature_extract_unsigned_field(dfr0,
 						      ID_AA64DFR0_PMSVER_SHIFT);
 }
+
+int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_spe_v1_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu);
 #else
 
 #define kvm_arm_spe_v1_ready(v)		(false)
 #define kvm_arm_support_spe_v1()	(false)
+#define kvm_arm_spe_irq_initialized(v)	(false)
+
+static inline int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static inline int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static inline int kvm_arm_spe_v1_has_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static inline int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ASM_ARM_KVM_SPE_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b6c922..83e8a25cbb14 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -988,6 +988,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_ARM_SPE_V1 168
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/spe.c b/virt/kvm/arm/spe.c
new file mode 100644
index 000000000000..87f02ed92426
--- /dev/null
+++ b/virt/kvm/arm/spe.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 ARM Ltd.
+ */
+
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <asm/kvm_emulate.h>
+#include <kvm/arm_spe.h>
+#include <kvm/arm_vgic.h>
+
+int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.spe.created)
+		return 0;
+
+	/*
+	 * A valid interrupt configuration for the SPE is either to have a
+	 * properly configured interrupt number and using an in-kernel irqchip.
+	 */
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int irq = vcpu->arch.spe.irq;
+
+		if (!kvm_arm_spe_irq_initialized(vcpu))
+			return -EINVAL;
+
+		if (!irq_is_ppi(irq))
+			return -EINVAL;
+	}
+
+	vcpu->arch.spe.ready = true;
+
+	return 0;
+}
+
+static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_support_spe_v1())
+		return -ENODEV;
+
+	if (!test_bit(KVM_ARM_VCPU_SPE_V1, vcpu->arch.features))
+		return -ENXIO;
+
+	if (vcpu->arch.spe.created)
+		return -EBUSY;
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int ret;
+
+		/*
+		 * If using the SPE with an in-kernel virtual GIC
+		 * implementation, we require the GIC to be already
+		 * initialized when initializing the SPE.
+		 */
+		if (!vgic_initialized(vcpu->kvm))
+			return -ENODEV;
+
+		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq,
+					 &vcpu->arch.spe);
+		if (ret)
+			return ret;
+	}
+
+	vcpu->arch.spe.created = true;
+	return 0;
+}
+
+/*
+ * For one VM the interrupt type must be same for each vcpu.
+ * As a PPI, the interrupt number is the same for all vcpus,
+ * while as an SPI it must be a separate number per vcpu.
+ */
+static bool spe_irq_is_valid(struct kvm *kvm, int irq)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_spe_irq_initialized(vcpu))
+			continue;
+
+		if (vcpu->arch.spe.irq != irq)
+			return false;
+	}
+
+	return true;
+}
+
+int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_V1_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
+		if (!test_bit(KVM_ARM_VCPU_SPE_V1, vcpu->arch.features))
+			return -ENODEV;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		/* The SPE overflow interrupt can be a PPI only */
+		if (!(irq_is_ppi(irq)))
+			return -EINVAL;
+
+		if (!spe_irq_is_valid(vcpu->kvm, irq))
+			return -EINVAL;
+
+		if (kvm_arm_spe_irq_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM SPE irq: %d\n", irq);
+		vcpu->arch.spe.irq = irq;
+		return 0;
+	}
+	case KVM_ARM_VCPU_SPE_V1_INIT:
+		return kvm_arm_spe_v1_init(vcpu);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_V1_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
+		if (!test_bit(KVM_ARM_VCPU_SPE_V1, vcpu->arch.features))
+			return -ENODEV;
+
+		if (!kvm_arm_spe_irq_initialized(vcpu))
+			return -ENXIO;
+
+		irq = vcpu->arch.spe.irq;
+		return put_user(irq, uaddr);
+	}
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_spe_v1_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_V1_IRQ:
+	case KVM_ARM_VCPU_SPE_V1_INIT:
+		if (kvm_arm_support_spe_v1() &&
+		    test_bit(KVM_ARM_VCPU_SPE_V1, vcpu->arch.features))
+			return 0;
+	}
+
+	return -ENXIO;
+}
-- 
2.17.1
