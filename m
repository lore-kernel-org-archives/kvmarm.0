Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A88315777
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136484; cv=none; b=fSVzxP8asCYWmvjjV7I5uj0nMQnZqS0+cL+9Uacukc1gru1o43sZ5uUkuvb7JMVXi4ZUaXwPtdPdMT5BR5p8ho96X7zKwo14CCJ0CivjBDG1ISgBvm7GENlHvdBvGMM19vM8uFO6GGO6ckYKzWQZ60g5Yp6G8ozZVL6Usvxsofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136484; c=relaxed/simple;
	bh=zNJuH9zQLB1r80m/vO0hS2Y09tnBqpOrNMUI0tcu6vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvgRuAoaB6BVwpVfO27TsoyiivQ+yTTsasKochwamDZJ1sE2k4fkh0i+rsGSxW9K+/ff3/quxm6NHw/eWN5B+8zPx28VdqiqYbr0qMbuK3fZXhwaPMvtjTLR4m2Oppop8uGtMtOdfZ0ug/RfyVmKiskJIiKgf6K8/vZsxfQomuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FDE71AC1;
	Fri, 14 Nov 2025 08:07:54 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1F733F5A1;
	Fri, 14 Nov 2025 08:07:59 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [RFC PATCH v6 11/35] KVM: arm64: Add SPE VCPU device attribute to set the interrupt number
Date: Fri, 14 Nov 2025 16:06:52 +0000
Message-ID: <20251114160717.163230-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sudeep Holla <sudeep.holla@arm.com>

Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_IRQ) to allow the user to set
the interrupt number for the buffer management interrupt.

[ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
               for SPE" ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 22 +++++++
 arch/arm64/include/asm/kvm_host.h       |  2 +
 arch/arm64/include/asm/kvm_spe.h        | 10 +++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/guest.c                  |  2 +
 arch/arm64/kvm/spe.c                    | 82 +++++++++++++++++++++++++
 6 files changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 8c5208ccd107..9a26252d0a34 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -296,3 +296,25 @@ From the destination VMM process:
 ===============================
 
 :Architectures: ARM64
+
+5.1 ATTRIBUTE: KVM_ARM_VCPU_SPE_IRQ
+-----------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for the Profiling Buffer
+             management interrupt number as a pointer to an int
+
+Returns:
+
+	 =======  ==========================================================
+	 -EFAULT  Error accessing the buffer management interrupt number
+	 -EINVAL  Invalid interrupt number or not using an in-kernel irqchip
+	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ==========================================================
+
+Required.
+
+Specifies the Profiling Buffer management interrupt number. The interrupt number
+must be a PPI and the interrupt number must be the same for each VCPU. Arm
+recommends 21 as the interrupt number. SPE virtualization requires an in-kernel
+vGIC implementation.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355..bc7aeae39fb9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_spe.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -865,6 +866,7 @@ struct kvm_vcpu_arch {
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
+	struct kvm_vcpu_spe vcpu_spe;
 
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 7c8268f6f507..6855976b4c72 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -6,7 +6,14 @@
 #ifndef __ARM64_KVM_SPE_H__
 #define __ARM64_KVM_SPE_H__
 
+#include <linux/kvm.h>
+
 #ifdef CONFIG_KVM_ARM_SPE
+
+struct kvm_vcpu_spe {
+	int irq_num;		/* Buffer management interrupt number */
+};
+
 DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
 
 static __always_inline bool kvm_supports_spe(void)
@@ -21,6 +28,9 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 #else
+struct kvm_vcpu_spe {
+};
+
 #define kvm_supports_spe()	false
 #define vcpu_has_spe(vcpu)	false
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5e2d47572136..578a0f6c3f8f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -445,6 +445,7 @@ enum {
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
+#define   KVM_ARM_VCPU_SPE_IRQ		0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d1bf8b154a31..fbc17a71edc3 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -920,7 +920,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_SPE_CTRL:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = kvm_spe_set_attr(vcpu, attr);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 		break;
 	default:
 		ret = -ENXIO;
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 4d635e881620..c6b81a2ef71f 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -41,17 +41,99 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 		static_branch_enable(&kvm_spe_available);
 }
 
+static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_spe *vcpu_spe;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu_spe = &vcpu->arch.vcpu_spe;
+
+		if (!vcpu_spe->irq_num)
+			continue;
+
+		if (vcpu_spe->irq_num != irq)
+			return false;
+	}
+
+	return true;
+}
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	struct kvm *kvm = vcpu->kvm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!vcpu_has_spe(vcpu))
+		return -ENODEV;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(kvm))
+			return -EINVAL;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		if (!irq_is_ppi(irq))
+			return -EINVAL;
+
+		if (!kvm_spe_irq_is_valid(kvm, irq))
+			return -EINVAL;
+
+		vcpu_spe->irq_num = irq;
+		return 0;
+	}
+	}
+
 	return -ENXIO;
 }
 
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!vcpu_has_spe(vcpu))
+		return -ENODEV;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(kvm))
+			return -EINVAL;
+
+		if (!vcpu_spe->irq_num)
+			return -ENXIO;
+
+		irq = vcpu_spe->irq_num;
+		if (put_user(irq, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
+	}
+
 	return -ENXIO;
 }
 
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
+	if (!vcpu_has_spe(vcpu))
+		return -ENODEV;
+
+	switch(attr->attr) {
+	case KVM_ARM_VCPU_SPE_IRQ:
+		return 0;
+	}
+
 	return -ENXIO;
 }
-- 
2.51.2

