Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2609C55178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 309D222384
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 309D222384
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F2C4B4B7;
	Tue, 27 Oct 2020 13:26:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sl646U9zWmSD; Tue, 27 Oct 2020 13:26:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3084D4B54D;
	Tue, 27 Oct 2020 13:26:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790184B448
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4xongtdQ5yjw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 949974B3DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BCA3150C;
 Tue, 27 Oct 2020 10:26:25 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 267EF3F719;
 Tue, 27 Oct 2020 10:26:24 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 08/16] KVM: arm64: Add a new VCPU device control group
 for SPE
Date: Tue, 27 Oct 2020 17:26:57 +0000
Message-Id: <20201027172705.15181-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, will@kernel.org
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

From: Sudeep Holla <sudeep.holla@arm.com>

To configure the virtual SPE buffer management interrupt number, we use a
VCPU kvm_device ioctl, encapsulating the KVM_ARM_VCPU_SPE_IRQ attribute
within the KVM_ARM_VCPU_SPE_CTRL group.

After configuring the SPE, userspace is required to call the VCPU ioctl
with the attribute KVM_ARM_VCPU_SPE_INIT to initialize SPE on the VCPU.

[Alexandru E: Fixed compilation errors, don't allow userspace to set the
	VCPU feature, removed unused functions, fixed mismatched
	descriptions, comments and error codes, reworked logic, rebased on
	top of v5.10-rc1]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  40 ++++++++
 arch/arm64/include/uapi/asm/kvm.h       |   3 +
 arch/arm64/kvm/Makefile                 |   1 +
 arch/arm64/kvm/guest.c                  |   9 ++
 arch/arm64/kvm/reset.c                  |  23 +++++
 arch/arm64/kvm/spe.c                    | 129 ++++++++++++++++++++++++
 include/kvm/arm_spe.h                   |  27 +++++
 include/uapi/linux/kvm.h                |   1 +
 8 files changed, 233 insertions(+)
 create mode 100644 arch/arm64/kvm/spe.c

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 2acec3b9ef65..6135b9827fbe 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -161,3 +161,43 @@ Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
 region. See Documentation/virt/kvm/arm/pvtime.rst for more information
 including the layout of the stolen time structure.
+
+4. GROUP: KVM_ARM_VCPU_SPE_CTRL
+===============================
+
+:Architectures: ARM64
+
+4.1 ATTRIBUTE: KVM_ARM_VCPU_SPE_IRQ
+-----------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for the SPE buffer management
+             interrupt is a pointer to an int
+
+Returns:
+
+	 =======  ========================================================
+	 -EBUSY   The SPE buffer management interrupt is already set
+	 -EINVAL  Invalid SPE overflow interrupt number
+	 -EFAULT  Could not read the buffer management interrupt number
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ========================================================
+
+A value describing the SPE (Statistical Profiling Extension) overflow interrupt
+number for this vcpu. This interrupt should be a PPI and the interrupt type and
+number must be same for each vcpu.
+
+4.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
+------------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+Returns:
+
+	 =======  ======================================================
+	 -EBUSY   SPE already initialized
+	 -ENODEV  GIC not initialized
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ======================================================
+
+Request the initialization of the SPE. Must be done after initializing the
+in-kernel irqchip and after setting the interrupt number for the VCPU.
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 489e12304dbb..ca57dfb7abf0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -360,6 +360,9 @@ struct kvm_vcpu_events {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_SPE_CTRL		3
+#define   KVM_ARM_VCPU_SPE_IRQ		0
+#define   KVM_ARM_VCPU_SPE_INIT		1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1504c81fbf5d..f6e76f64ffbe 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
+kvm-$(CONFIG_KVM_ARM_SPE)  += spe.o
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfb5218137ca..2ba790eeb782 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -926,6 +926,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_arm_spe_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -949,6 +952,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_arm_spe_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -972,6 +978,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_SPE_CTRL:
+		ret = kvm_arm_spe_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f32490229a4c..4dc205fa4be1 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -87,6 +87,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_SPE:
+		r = kvm_arm_supports_spe();
+		break;
 	default:
 		r = 0;
 	}
@@ -223,6 +226,19 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_vcpu_enable_spe(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_supports_spe())
+		return -EINVAL;
+
+	/* SPE is disabled if the PE is in AArch32 state */
+	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
+		return -EINVAL;
+
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SPE;
+	return 0;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -274,6 +290,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (test_bit(KVM_ARM_VCPU_SPE, vcpu->arch.features)) {
+		if (kvm_vcpu_enable_spe(vcpu)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
new file mode 100644
index 000000000000..f91a52cd7cd3
--- /dev/null
+++ b/arch/arm64/kvm/spe.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 ARM Ltd.
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+
+#include <kvm/arm_spe.h>
+#include <kvm/arm_vgic.h>
+
+static bool kvm_arm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_spe(vcpu))
+		return false;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return false;
+
+	return true;
+}
+
+static int kvm_arm_spe_init(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_spe_irq_initialized(vcpu))
+		return -ENXIO;
+
+	if (!vgic_initialized(vcpu->kvm))
+		return -ENODEV;
+
+	if (kvm_arm_spe_vcpu_initialized(vcpu))
+		return -EBUSY;
+
+	if (kvm_vgic_set_owner(vcpu, vcpu->arch.spe_cpu.irq_num, &vcpu->arch.spe_cpu))
+		return -ENXIO;
+
+	vcpu->arch.spe_cpu.initialized = true;
+
+	return 0;
+}
+
+static bool kvm_arm_spe_irq_is_valid(struct kvm *kvm, int irq)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	/* The SPE overflow interrupt can be a PPI only */
+	if (!irq_is_ppi(irq))
+		return false;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_spe_irq_initialized(vcpu))
+			continue;
+
+		if (vcpu->arch.spe_cpu.irq_num != irq)
+			return false;
+	}
+
+	return true;
+}
+
+int kvm_arm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!kvm_arm_vcpu_supports_spe(vcpu))
+			return -ENXIO;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		if (!kvm_arm_spe_irq_is_valid(vcpu->kvm, irq))
+			return -EINVAL;
+
+		if (kvm_arm_spe_irq_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM SPE irq: %d\n", irq);
+		vcpu->arch.spe_cpu.irq_num = irq;
+
+		return 0;
+	}
+	case KVM_ARM_VCPU_SPE_INIT:
+		return kvm_arm_spe_init(vcpu);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!kvm_arm_vcpu_supports_spe(vcpu))
+			return -ENXIO;
+
+		if (!kvm_arm_spe_irq_initialized(vcpu))
+			return -ENXIO;
+
+		irq = vcpu->arch.spe_cpu.irq_num;
+		if (put_user(irq, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ:
+		fallthrough;
+	case KVM_ARM_VCPU_SPE_INIT:
+		if (kvm_arm_vcpu_supports_spe(vcpu))
+			return 0;
+	}
+
+	return -ENXIO;
+}
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 46ec447ed013..0275e8097529 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -18,11 +18,38 @@ struct kvm_spe_cpu {
 	bool initialized; 	/* Feature is initialized on VCPU */
 };
 
+#define kvm_arm_spe_irq_initialized(v)			\
+	((v)->arch.spe_cpu.irq_num >= VGIC_NR_SGIS &&	\
+	 (v)->arch.spe_cpu.irq_num < VGIC_MAX_PRIVATE)
+#define kvm_arm_spe_vcpu_initialized(v)	((v)->arch.spe_cpu.initialized)
+
+int kvm_arm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+
 #else
 #define kvm_arm_supports_spe()	false
 
 struct kvm_spe_cpu {
 };
 
+#define kvm_arm_spe_irq_initialized(v)	false
+#define kvm_arm_spe_vcpu_initialized(v)	false
+
+static inline int kvm_arm_spe_set_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+static inline int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 #endif /* __ASM_ARM_KVM_SPE_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..96228b823711 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_ARM_SPE 191
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
