Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0FA30EF71
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136486; cv=none; b=t3aTR9+LPzoOtG+AP+Cs9vaiJJx8+E3RxZocRNLExV2wdfcXr7YEDhC5jnZtjsrfF1P7rk7DXDqnQLpQbi9vujwsaqJkBytE24HH1w43Yp48RYkvDKFG00H5cVJE3rqTVYF7BSA5ETWZwRaF/ZybDytqpvlC/O4WEwksLI0JiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136486; c=relaxed/simple;
	bh=/9adNoB3Qo4bFf3QpRH3xLbAuhQpxLPGv/+3twy3QWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpC1V9vt3ObaLSWzkkHruRuoxKCqobplblyVCn1KradncJe2+PKdXIFdl7UrJD0sYKSVIALXlAmliSJD9995AViLjQGQR+anunJI2CNHYsqUZThE6+QNKj+Wo0+yrihLnGo7Az+LYXXwj3hRtwztaFudRvD+O/L5kKyWhrTgCSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 168FA1BB0;
	Fri, 14 Nov 2025 08:07:57 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A9843F5A1;
	Fri, 14 Nov 2025 08:08:02 -0800 (PST)
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
	james.morse@arm.com
Subject: [RFC PATCH v6 12/35] KVM: arm64: Add SPE VCPU device attribute to set the SPU device
Date: Fri, 14 Nov 2025 16:06:53 +0000
Message-ID: <20251114160717.163230-13-alexandru.elisei@arm.com>
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

To support systems where there is more than one SPU instance, or where not
all the PEs have SPE, add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_SET_SPU)
for userspace to set the SPU instance it wants the virtual machine to use.
Similar to the PMU, it is entirely up to userspace to make sure the VCPUs
are run only on the physical CPUs which share this SPU instance.

If the ioctl is called for multiple VCPUs, userspace must use the same SPU
for each of the VCPUs.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 29 ++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/asm/kvm_spe.h        |  7 +++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               |  4 +-
 arch/arm64/kvm/spe.c                    | 62 +++++++++++++++++++++++++
 6 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 9a26252d0a34..e305377fadad 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -318,3 +318,32 @@ Specifies the Profiling Buffer management interrupt number. The interrupt number
 must be a PPI and the interrupt number must be the same for each VCPU. Arm
 recommends 21 as the interrupt number. SPE virtualization requires an in-kernel
 vGIC implementation.
+
+5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_SPU
+------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to an int representing the SPU
+             identifier.
+
+:Returns:
+
+	 =======  ================================================
+	 -EBUSY   Virtual machine has already run
+	 -EFAULT  Error accessing the SPU identifier
+	 -EINVAL  A different SPU already set
+	 -ENXIO   SPE not supported or not properly configured, or
+                  SPU not present on the system
+	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
+	 =======  ================================================
+
+Required.
+
+Request that the VCPU uses the specified hardware SPU. The SPE identifier can be
+read from the 'type' file for the desired SPE instance under /sys/devices (or,
+equivalent, /sys/bus/event_source). Must be set for at least one VCPU, in which
+case all the other VCPUs will use the same SPU. Once a SPU has been set,
+attempting to set a different one will result in an error.
+
+Similar to KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_SET_PMU), userspace is
+responsible for making sure that the VCPU is run only on physical CPUs which
+have the specified SPU.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bc7aeae39fb9..373d22ec4783 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -365,6 +365,7 @@ struct kvm_arch {
 	 */
 	unsigned long *pmu_filter;
 	struct arm_pmu *arm_pmu;
+	struct kvm_spe kvm_spe;
 
 	cpumask_var_t supported_cpus;
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 6855976b4c72..a4e9f03e3751 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -10,6 +10,10 @@
 
 #ifdef CONFIG_KVM_ARM_SPE
 
+struct kvm_spe {
+	struct arm_spe_pmu *arm_spu;
+};
+
 struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrupt number */
 };
@@ -28,6 +32,9 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 #else
+struct kvm_spe {
+};
+
 struct kvm_vcpu_spe {
 };
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 578a0f6c3f8f..760c3e074d3d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -446,6 +446,7 @@ enum {
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
 #define   KVM_ARM_VCPU_SPE_IRQ		0
+#define   KVM_ARM_VCPU_SPE_SPU		1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..f71240f5f914 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1094,7 +1094,9 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 			}
 
 			kvm_arm_set_pmu(kvm, arm_pmu);
-			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
+			/* SPE also sets the supported_cpus cpumask. */
+			cpumask_and(kvm->arch.supported_cpus, &arm_pmu->supported_cpus,
+				    kvm->arch.supported_cpus);
 			ret = 0;
 			break;
 		}
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index c6b81a2ef71f..c581838029ae 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -41,6 +41,43 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 		static_branch_enable(&kvm_spe_available);
 }
 
+static int kvm_spe_set_spu(struct kvm_vcpu *vcpu, int spu_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	struct arm_spe_pmu *existing_spu, *new_spu = NULL;
+	struct arm_spu_entry *entry;
+
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
+	guard(mutex)(&arm_spus_lock);
+
+	existing_spu = kvm_spe->arm_spu;
+	list_for_each_entry(entry, &arm_spus, link) {
+		if (entry->arm_spu->pmu.type == spu_id) {
+			new_spu = entry->arm_spu;
+			break;
+		}
+	}
+
+	if (!new_spu)
+		return -ENXIO;
+
+	if (existing_spu) {
+		if (new_spu != existing_spu)
+			return -EINVAL;
+		return 0;
+	}
+
+	kvm_spe->arm_spu = new_spu;
+	/* PMU also sets the supported_cpus cpumask. */
+	cpumask_and(kvm->arch.supported_cpus, &new_spu->supported_cpus,
+		    kvm->arch.supported_cpus);
+
+	return 0;
+}
+
 static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
 {
 	struct kvm_vcpu *vcpu;
@@ -90,6 +127,15 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		vcpu_spe->irq_num = irq;
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_SPU: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int spu_id;
+
+		if (get_user(spu_id, uaddr))
+			return -EFAULT;
+
+		return kvm_spe_set_spu(vcpu, spu_id);
+	}
 	}
 
 	return -ENXIO;
@@ -99,6 +145,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
 
 	if (!vcpu_has_spe(vcpu))
 		return -ENODEV;
@@ -120,6 +167,20 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_SPU: {
+		struct arm_spe_pmu *spu = kvm_spe->arm_spu;
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int spu_id;
+
+		if (!spu)
+			return -ENXIO;
+
+		spu_id = spu->pmu.type;
+		if (put_user(spu_id, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
 	}
 
 	return -ENXIO;
@@ -132,6 +193,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
+	case KVM_ARM_VCPU_SPE_SPU:
 		return 0;
 	}
 
-- 
2.51.2

