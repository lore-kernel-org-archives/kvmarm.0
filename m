Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E035280330
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136492; cv=none; b=tvEbQh+mW/5RjslAV0BcI1vw5c1zC7SOnmDO6z8jb3sCNqg1Qcgf7nUqxK/N9ukvqTzrwqyzxUw2RmcQFLPq/mgJDzQZ9UEs0/FbSzjC9L0Mtk9+VkFAyqX4yinz0n9Vzfws466KLwUCi14gKlY265P7Bdn41P92a54RpY8n5ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136492; c=relaxed/simple;
	bh=OCMn1G00MpdiPMlhwqbixPEK3S60XyyTbq/QxYHl2LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+u+O0Wk0+5cxVHcHLeR//UIriBE7PvnH0dpg85+GMZuI1M3YKUAJzG7yGABprfzZWqDMRvIxEiwoZgZ/prLOXovIzijS2qCOOl7qwB3BXDYQuewrdETwxXQHztdNvu94qw4vxN6ePrJY3cDM1VEjl6uqMofX6JbuAY0H1UvsXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3990E1AC1;
	Fri, 14 Nov 2025 08:08:02 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AC793F5A1;
	Fri, 14 Nov 2025 08:08:07 -0800 (PST)
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
Subject: [RFC PATCH v6 14/35] KVM: arm64: Add SPE VCPU device attribute to set the max buffer size
Date: Fri, 14 Nov 2025 16:06:55 +0000
Message-ID: <20251114160717.163230-15-alexandru.elisei@arm.com>
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

During profiling, the buffer programmed by the guest must be kept mapped at
stage 2 by KVM, making this memory pinned from the host's perspective.

To make sure that a guest doesn't consume too much memory, add a new SPE
VCPU device attribute, KVM_ARM_VCPU_MAX_BUFFER_SIZE, which is used by
userspace to limit the amount of memory a VCPU can pin when programming
the profiling buffer. This value will be advertised to the guest in the
PMBIDR_EL1.MaxBuffSize field.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  49 ++++++++++
 arch/arm64/include/asm/kvm_spe.h        |   6 ++
 arch/arm64/include/uapi/asm/kvm.h       |   5 +-
 arch/arm64/kvm/arm.c                    |   2 +
 arch/arm64/kvm/spe.c                    | 116 ++++++++++++++++++++++++
 5 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index e305377fadad..bb1bbd2ff6e2 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -347,3 +347,52 @@ attempting to set a different one will result in an error.
 Similar to KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_SET_PMU), userspace is
 responsible for making sure that the VCPU is run only on physical CPUs which
 have the specified SPU.
+
+5.3 ATTRIBUTE: KVM_ARM_VCPU_MAX_BUFFER_SIZE
+------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to an u64 representing the
+             maximum buffer size, in bytes.
+
+:Returns:
+
+	 =======  =========================================================
+	 -EBUSY   Virtual machine has already run
+	 -EDOM    Buffer size cannot be represented by hardware
+	 -EFAULT  Error accessing the max buffer size identifier
+	 -EINVAL  A different maximum buffer size already set or the size is
+                  not aligned to the host's page size
+	 -ENXIO   SPE not supported or not properly configured
+	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature or SPU instance not set
+	 -ERANGE  Buffer size larger than maximum supported by the SPU
+                  instance.
+	 =======  ==========================================================
+
+Required.
+
+Limit the size of the profiling buffer for the VCPU to the specified value. The
+value will be used by all VCPUs. Can be set for more than one VCPUs, as long as
+the value stays the same.
+
+Requires that a SPU has been already assigned to the VM. The maximum buffer size
+must be less than or equal to the maximum buffer size of the assigned SPU instance,
+unless there is no limit on the maximum buffer size for the SPU. In this case
+the VCPU maximum buffer size can have any value, including 0, as long as it can
+be encoded by hardware. For details on how the hardware encodes this value,
+please consult Arm DDI0601 for the field PMBIDR_EL1.MaxBuffSize.
+
+The value 0 is special and it means that there is no upper limit on the size of
+the buffer that the guest can use. Can only be set if the SPU instance used by
+the VM has a similarly unlimited buffer size.
+
+When a guest enables SPE on the VCPU, KVM will pin the host memory backing the
+buffer to avoid the statistical profiling unit experiencing stage 2 faults when
+it writes to memory. This includes the host pages backing the guest's stage 1
+translation tables that are used to translate the buffer. As a result, it is
+expected that the size of the memory that will be pinned for each VCPU will be
+slightly larger that the maximum buffer set with this ioctl.
+
+This memory that is pinned will count towards the process RLIMIT_MEMLOCK. To
+avoid the limit being exceeded, userspace must increase the RLIMIT_MEMLOCK limit
+prior to running the VCPU, otherwise KVM_RUN will return to userspace with an
+error.
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index a4e9f03e3751..e48f7a7f67bb 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -12,6 +12,7 @@
 
 struct kvm_spe {
 	struct arm_spe_pmu *arm_spu;
+	u64 max_buffer_size;	/* Maximum per VCPU buffer size */
 };
 
 struct kvm_vcpu_spe {
@@ -28,6 +29,8 @@ static __always_inline bool kvm_supports_spe(void)
 #define vcpu_has_spe(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 
+void kvm_spe_init_vm(struct kvm *kvm);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -41,6 +44,9 @@ struct kvm_vcpu_spe {
 #define kvm_supports_spe()	false
 #define vcpu_has_spe(vcpu)	false
 
+static inline void kvm_spe_init_vm(struct kvm *kvm)
+{
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 760c3e074d3d..9db652392781 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -445,8 +445,9 @@ enum {
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 #define KVM_ARM_VCPU_SPE_CTRL		3
-#define   KVM_ARM_VCPU_SPE_IRQ		0
-#define   KVM_ARM_VCPU_SPE_SPU		1
+#define   KVM_ARM_VCPU_SPE_IRQ			0
+#define   KVM_ARM_VCPU_SPE_SPU			1
+#define   KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE	2
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d7f802035970..9afdf66be8b2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -194,6 +194,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_timer_init_vm(kvm);
 
+	kvm_spe_init_vm(kvm);
+
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index c581838029ae..3478da2a1f7c 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2021 - ARM Ltd
  */
 
+#include <linux/bitops.h>
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
@@ -41,6 +42,99 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 		static_branch_enable(&kvm_spe_available);
 }
 
+/*
+ * The maximum buffer size can be zero (no restrictions on the buffer size), so
+ * this value cannot be used as the uninitialized value. The maximum buffer size
+ * must be page aligned, so arbitrarily choose the value '1' for an
+ * uninitialized maximum buffer size.
+ */
+#define KVM_SPE_MAX_BUFFER_SIZE_UNSET		1
+
+void kvm_spe_init_vm(struct kvm *kvm)
+{
+	kvm->arch.kvm_spe.max_buffer_size = KVM_SPE_MAX_BUFFER_SIZE_UNSET;
+}
+
+static u64 max_buffer_size_to_pmbidr_el1(u64 size)
+{
+	u64 msb_idx, num_bits;
+	u64 maxbuffsize;
+	u64 m, e;
+
+	/*
+	 * size = m:zeros(12); m is 9 bits.
+	 */
+	if (size <= GENMASK_ULL(20, 12)) {
+		m = size >> 12;
+		e = 0;
+		goto out;
+	}
+
+	/*
+	 * size = 1:m:zeros(e+11)
+	 */
+
+	num_bits = fls64(size);
+	msb_idx = num_bits - 1;
+
+	/* MSB is not encoded. */
+	m = size & ~BIT(msb_idx);
+	/* m is 9 bits. */
+	m >>= msb_idx - 9;
+	/* MSB is not encoded, m is 9 bits wide and 11 bits are zero. */
+	e = num_bits - 1 - 9 - 11;
+
+out:
+	maxbuffsize = FIELD_PREP(GENMASK_ULL(8, 0), m) | \
+		      FIELD_PREP(GENMASK_ULL(13, 9), e);
+	return FIELD_PREP(PMBIDR_EL1_MaxBuffSize, maxbuffsize);
+}
+
+static u64 pmbidr_el1_to_max_buffer_size(u64 pmbidr_el1)
+{
+	u64 maxbuffsize;
+	u64 e, m;
+
+	maxbuffsize = FIELD_GET(PMBIDR_EL1_MaxBuffSize, pmbidr_el1);
+	e = FIELD_GET(GENMASK_ULL(13, 9), maxbuffsize);
+	m = FIELD_GET(GENMASK_ULL(8, 0), maxbuffsize);
+
+	if (!e)
+		return m << 12;
+	return (1ULL << (9 + e + 11)) | (m << (e + 11));
+}
+
+static int kvm_spe_set_max_buffer_size(struct kvm_vcpu *vcpu, u64 size)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	u64 decoded_size, spu_size;
+
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
+	if (!PAGE_ALIGNED(size))
+		return -EINVAL;
+
+	if (!kvm_spe->arm_spu)
+		return -ENODEV;
+
+	if (kvm_spe->max_buffer_size != KVM_SPE_MAX_BUFFER_SIZE_UNSET)
+		return size == kvm_spe->max_buffer_size ? 0 : -EINVAL;
+
+	decoded_size = pmbidr_el1_to_max_buffer_size(max_buffer_size_to_pmbidr_el1(size));
+	if (decoded_size != size)
+		return -EDOM;
+
+	spu_size = pmbidr_el1_to_max_buffer_size(kvm_spe->arm_spu->pmbidr_el1);
+	if (spu_size != 0 && (size == 0 || size > spu_size))
+		return -ERANGE;
+
+	kvm_spe->max_buffer_size = size;
+
+	return 0;
+}
+
 static int kvm_spe_set_spu(struct kvm_vcpu *vcpu, int spu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -136,6 +230,15 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_spe_set_spu(vcpu, spu_id);
 	}
+	case KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 size;
+
+		if (get_user(size, uaddr))
+			return -EFAULT;
+
+		return kvm_spe_set_max_buffer_size(vcpu, size);
+	}
 	}
 
 	return -ENXIO;
@@ -181,6 +284,18 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 size = kvm_spe->max_buffer_size;
+
+		if (size == KVM_SPE_MAX_BUFFER_SIZE_UNSET)
+			return -EINVAL;
+
+		if (put_user(size, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
 	}
 
 	return -ENXIO;
@@ -194,6 +309,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
 	case KVM_ARM_VCPU_SPE_SPU:
+	case KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE:
 		return 0;
 	}
 
-- 
2.51.2

