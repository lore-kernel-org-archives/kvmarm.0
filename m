Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79F44B1B38
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451622; cv=none; b=rcezTaEIvt9OCJbpy5ihEKygfkg3gLskFMiQv9XmFtvZ1JPEyc6KdJ/ar1ct2VWCthnbZBb9l+ylQBusAwlIYCTWoOyJCbZBqerDDdTYqORFPcUzyH3vq8vCAO46ynmhDa27dR8VeH5+l2th4mYx9TuE+9Zry22wZD0YqgRm/nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451622; c=relaxed/simple;
	bh=pNq9nTMAIPUQA4Ji23znNHSvdazZ4B9jcKnv+m2hL5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGRXGyzEUbjeYYNVNpQYtIRpsihndkaNOk42ls+arhjlSod3NUFvA67qZJv7aFkicPP3+YWCVxBodnc12cN/VC+pD2tjQ1jLkkrOLpaF7S/Zuf9WTRX4Q+MCUZadV+PTYY+nGmL7+2c3k4yT2GmLbtq2hbIlSotFT+g+LSev+zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yd0Gizvd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yd0Gizvd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5C721D34;
	Thu,  3 Sep 2026 09:06:56 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D7263F673;
	Thu,  3 Sep 2026 09:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451620; bh=pNq9nTMAIPUQA4Ji23znNHSvdazZ4B9jcKnv+m2hL5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yd0GizvdJjcm00m4lpd0BAAb75vEoWq3r/pg6H5tv9ExlvBYQFmJOmVgZCnjnFlnb
	 WwkOyhcxkQxcQqG/Fz5LRXp9Ev+Cbsvvp/rdycgzNBtIvvVx55JGPQ3Ua1ut+gdrGB
	 XtBfUByPHK2B/9S/B5u7YxF3G+5zm2wm04tkszy8=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Cc: Sudeep Holla <sudeep.holla@arm.com>
Subject: [RFC PATCH v7 12/28] KVM: arm64: Add SPE VCPU device attribute to set the interrupt number
Date: Thu,  3 Sep 2026 17:06:07 +0100
Message-ID: <20260903160623.315525-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
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
 arch/arm64/include/asm/kvm_spe.h        | 11 ++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/guest.c                  |  2 +
 arch/arm64/kvm/spe.c                    | 82 +++++++++++++++++++++++++
 6 files changed, 120 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index e0a7fa35dfd2..d30b2f7fec9a 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -307,3 +307,25 @@ From the destination VMM process:
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
index 27fe0cd5b2d7..e7332bd82bf3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_spe.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -918,6 +919,7 @@ struct kvm_vcpu_arch {
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
+	struct kvm_vcpu_spe vcpu_spe;
 
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 1327064d0984..8ded2d821bff 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -6,7 +6,15 @@
 #ifndef __ARM64_KVM_SPE_H__
 #define __ARM64_KVM_SPE_H__
 
+struct kvm;
+struct kvm_vcpu;
+struct kvm_device_attr;
+
 #ifdef CONFIG_KVM_ARM_SPE
+struct kvm_vcpu_spe {
+	int irq_num;		/* Buffer management interrupt number */
+};
+
 bool kvm_supports_spe(void);
 
 #define vcpu_has_spe(vcpu)					\
@@ -16,6 +24,9 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 #else
+struct kvm_vcpu_spe {
+};
+
 static __always_inline bool kvm_supports_spe(void)
 {
 	return false;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index e8a68e34be63..b9e5019181eb 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -447,6 +447,7 @@ enum {
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
+#define   KVM_ARM_VCPU_SPE_IRQ		0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 56c5f937fcdb..f953b235b458 100644
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
index fe45ad4c703a..dd5f80318ba4 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -59,17 +59,99 @@ bool kvm_supports_spe(void)
 	return !list_empty(&spe_pmus);
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
+		if (!irq_is_ppi(kvm, irq))
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
2.43.0

