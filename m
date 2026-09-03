Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC0A4B5126
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451625; cv=none; b=sxaFdKHS5Ec1ky5xn0Ft/yTS9oI3yE8KceaWHFee6cA3+YL+fzItGVc9fHTNFtNh7pA4KsVT5/xuc71BemmBhkRtT/dIgGr7NFY31xL/O0/vPJtVJ5gx1P39L9YhnlBKyKGd2OIy3/iMQ1TYawuZfXVq2zye8pyUlb172Vjr73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451625; c=relaxed/simple;
	bh=oSHyRwFbp8CcIvJRUxCoa8j2gKUewpk4ziRPugeFJrQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj8ju4OkXS98Ed/iknyat5xTqtX0j0HVZavinAfDY2yjF30Bpyakf7ccXBZKA/oKjXHop892QDXmB9z1jS5yuvp4fyQdZiiVopZ2kGOwUJHdOpL49igvCt0OgQKk2Z1UkBzHL5Q4iCSZSDtw4iPKpn3OKWuH9Lnxpny8qTrlH/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=U6yEKfo3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="U6yEKfo3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDC9A1650;
	Thu,  3 Sep 2026 09:06:58 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8D5C3F673;
	Thu,  3 Sep 2026 09:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451622; bh=oSHyRwFbp8CcIvJRUxCoa8j2gKUewpk4ziRPugeFJrQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=U6yEKfo3ccbzFkBCkTRlCfIvjkqrPcZ4QX19RcTUnfUtDloKerA+kfFBEoAwe4niP
	 nbjlvS3PloiBw+wMFmaCCxKUhWTPmr/hOX5vQPiTN2a9LIa2uYwUuXMAuui7+sosPj
	 pVH12LoZBVl8KfLYQi99yO2U46o5ycfcv6Qir6hk=
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
Subject: [RFC PATCH v7 13/28] KVM: arm64: Add SPE VCPU device attribute to set the SPE device
Date: Thu,  3 Sep 2026 17:06:08 +0100
Message-ID: <20260903160623.315525-14-alexandru.elisei@arm.com>
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

To support systems where there is more than one SPE instance, or where not
all the PEs have SPE, add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_ID) for
userspace to set the SPE instance it wants the virtual machine to use.
Similar to the PMU, it is entirely up to userspace to make sure the VCPUs
are run only on the physical CPUs which share this SPE instance.

If the ioctl is called for multiple VCPUs, userspace must use the same
SPE identifier for each of the VCPUs.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 32 +++++++++
 arch/arm64/include/asm/kvm_host.h       |  4 ++
 arch/arm64/include/asm/kvm_spe.h        | 19 ++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    | 43 ++++++++++++
 arch/arm64/kvm/pmu-emul.c               | 11 ++-
 arch/arm64/kvm/spe.c                    | 90 +++++++++++++++++++++++++
 7 files changed, 198 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index d30b2f7fec9a..d60dd1daa67f 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -329,3 +329,35 @@ Specifies the Profiling Buffer management interrupt number. The interrupt number
 must be a PPI and the interrupt number must be the same for each VCPU. Arm
 recommends 21 as the interrupt number. SPE virtualization requires an in-kernel
 vGIC implementation.
+
+5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_ID
+------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to an int representing the SPE
+             identifier.
+
+:Returns:
+
+	 =======  =========================================================
+	 -EBUSY   Virtual machine has already run
+	 -EFAULT  Error accessing the SPE identifier
+	 -EINVAL  A different SPE instance already assigned, or no physical
+                  CPUs found
+	 -ENXIO   SPE not supported or not properly configured, or the SPE
+                  module not loaded
+	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
+	 =======  =========================================================
+
+Required.
+
+Request that the VCPU uses the specified SPE instance. The SPE identifier can be
+read from the 'type' file for the desired SPE instance under /sys/devices (or,
+equivalent, /sys/bus/event_source). Must be set for at least one VCPU, in which
+case all the other VCPUs will use the same SPE instance. Once a SPE instance has
+been set, attempting to set a different one will result in an error.
+
+Similar to KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_SET_PMU), userspace is
+responsible for making sure that the VCPU is run only on physical CPUs which
+share the specified SPE instance. If the VCPU has a PMU assigned, and there are
+no physical CPUs which share the same SPE and PMU instance, an error is
+returned.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7332bd82bf3..10fa223bdbda 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -382,6 +382,7 @@ struct kvm_arch {
 	 */
 	unsigned long *pmu_filter;
 	struct arm_pmu *arm_pmu;
+	struct kvm_spe kvm_spe;
 
 	cpumask_var_t supported_cpus;
 
@@ -1499,6 +1500,9 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 int __init kvm_set_ipa_limit(void);
 u32 kvm_get_pa_bits(struct kvm *kvm);
 
+int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
+			      cpumask_t *spe_cpus);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 8ded2d821bff..b8afb419c851 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -11,6 +11,11 @@ struct kvm_vcpu;
 struct kvm_device_attr;
 
 #ifdef CONFIG_KVM_ARM_SPE
+struct arm_spe_pmu;
+struct kvm_spe {
+	struct arm_spe_pmu *spe_pmu;
+};
+
 struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrupt number */
 };
@@ -20,10 +25,17 @@ bool kvm_supports_spe(void);
 #define vcpu_has_spe(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 
+void kvm_spe_destroy_vm(struct kvm *kvm);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+
+bool kvm_spe_pmu_set(struct kvm *kvm);
 #else
+struct kvm_spe {
+};
+
 struct kvm_vcpu_spe {
 };
 
@@ -34,6 +46,9 @@ static __always_inline bool kvm_supports_spe(void)
 
 #define vcpu_has_spe(vcpu)	false
 
+static inline void kvm_spe_destroy_vm(struct kvm *kvm)
+{
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
@@ -46,6 +61,10 @@ static inline int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr
 {
 	return -ENXIO;
 }
+static inline bool kvm_spe_pmu_set(struct kvm *kvm)
+{
+	return false;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b9e5019181eb..8ffa3e89d38c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -448,6 +448,7 @@ enum {
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
 #define   KVM_ARM_VCPU_SPE_IRQ		0
+#define   KVM_ARM_VCPU_SPE_ID		1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 763b102dc51f..132df44c3088 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -336,6 +336,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
+	kvm_spe_destroy_vm(kvm);
+
 	kvm_unshare_hyp(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
@@ -612,6 +614,47 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 }
 
+int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
+			      cpumask_t *spe_cpus)
+{
+	cpumask_t *supported_cpus;
+	cpumask_t *cpus;
+	int ret;
+
+	if (!zalloc_cpumask_var(&supported_cpus, GFP_KERNEL_ACCOUNT))
+		return -ENOMEM;
+
+	cpumask_copy(supported_cpus, kvm->arch.supported_cpus);
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	ret = -EINVAL;
+	/* Cannot update for SPE and PMU at the same time. */
+	if (WARN_ON_ONCE(pmu_cpus && spe_cpus))
+		goto out;
+
+	if (pmu_cpus)
+		cpus = pmu_cpus;
+	else
+		cpus = spe_cpus;
+
+	if ((spe_cpus && kvm->arch.arm_pmu) ||
+	    (pmu_cpus && kvm_spe_pmu_set(kvm)))
+		cpumask_and(supported_cpus, cpus, supported_cpus);
+	else
+		cpumask_copy(supported_cpus, cpus);
+
+	if (cpumask_empty(supported_cpus))
+		goto out;
+
+	cpumask_copy(kvm->arch.supported_cpus, supported_cpus);
+	ret = 0;
+out:
+	free_cpumask_var(supported_cpus);
+
+	return ret;
+}
+
 static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_has_ptrauth(vcpu) && !is_protected_kvm_enabled()) {
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5b1af7e2176f..59930e1bf357 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1085,6 +1085,11 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return 0;
 }
 
+static int kvm_pmu_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus)
+{
+	return kvm_update_supported_cpus(kvm, pmu_cpus, NULL);
+}
+
 static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1104,8 +1109,11 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
+			ret = kvm_pmu_update_supported_cpus(kvm, &arm_pmu->supported_cpus);
+			if (ret)
+				break;
 			kvm_arm_set_pmu(kvm, arm_pmu);
-			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
+
 
 			/*
 			 * Since a specific PMU is explicitly selected,
@@ -1117,7 +1125,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				kvm->arch.pmmir_slots =
 					FIELD_GET(ARMV8_PMU_SLOTS,
 						  arm_pmu->reg_pmmir);
-			ret = 0;
 			break;
 		}
 	}
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index dd5f80318ba4..87fcdbbcbd67 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -59,6 +59,71 @@ bool kvm_supports_spe(void)
 	return !list_empty(&spe_pmus);
 }
 
+void kvm_spe_destroy_vm(struct kvm *kvm)
+{
+	struct arm_spe_pmu *spe_pmu;
+
+	guard(mutex)(&spe_pmus_lock);
+
+	spe_pmu = kvm->arch.kvm_spe.spe_pmu;
+	if (!spe_pmu)
+		return;
+
+	module_put(spe_pmu->pmu.module);
+}
+
+bool kvm_spe_pmu_set(struct kvm *kvm)
+{
+	return !!kvm->arch.kvm_spe.spe_pmu;
+}
+
+static int kvm_spe_update_supported_cpus(struct kvm *kvm, cpumask_t *spe_cpus)
+{
+	return kvm_update_supported_cpus(kvm, NULL, spe_cpus);
+}
+
+static int kvm_spe_set_spe_id(struct kvm_vcpu *vcpu, int spe_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	struct arm_spe_pmu *existing_spe_pmu, *spe_pmu = NULL;
+	struct spe_pmu_entry *entry;
+
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
+	guard(mutex)(&spe_pmus_lock);
+
+	list_for_each_entry(entry, &spe_pmus, link) {
+		if (entry->spe_pmu->pmu.type == spe_id) {
+			spe_pmu = entry->spe_pmu;
+			break;
+		}
+	}
+
+	if (!spe_pmu)
+		return -ENXIO;
+
+	existing_spe_pmu = kvm_spe->spe_pmu;
+	if (existing_spe_pmu) {
+		if (existing_spe_pmu != spe_pmu)
+			return -EINVAL;
+		return 0;
+	}
+
+	if (!try_module_get(spe_pmu->pmu.module))
+		return -ENXIO;
+
+	if (kvm_spe_update_supported_cpus(kvm, &spe_pmu->supported_cpus)) {
+		module_put(spe_pmu->pmu.module);
+		return -EINVAL;
+	}
+
+	kvm_spe->spe_pmu = spe_pmu;
+
+	return 0;
+}
+
 static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
 {
 	struct kvm_vcpu *vcpu;
@@ -108,6 +173,15 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		vcpu_spe->irq_num = irq;
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_ID: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int spe_id;
+
+		if (get_user(spe_id, uaddr))
+			return -EFAULT;
+
+		return kvm_spe_set_spe_id(vcpu, spe_id);
+	}
 	}
 
 	return -ENXIO;
@@ -117,6 +191,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
 
 	if (!vcpu_has_spe(vcpu))
 		return -ENODEV;
@@ -138,6 +213,20 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_ID: {
+		struct arm_spe_pmu *spe_pmu = kvm_spe->spe_pmu;
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int spe_id;
+
+		if (!spe_pmu)
+			return -ENXIO;
+
+		spe_id = spe_pmu->pmu.type;
+		if (put_user(spe_id, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
 	}
 
 	return -ENXIO;
@@ -150,6 +239,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
+	case KVM_ARM_VCPU_SPE_ID:
 		return 0;
 	}
 
-- 
2.43.0

