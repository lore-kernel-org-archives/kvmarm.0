Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D739526E6EB
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136494; cv=none; b=fwszL8PLMveb6wFGx3JGisPJc1Jyv1LJ7Puh4CFUHKtOkpXktCT54gsmGe8KSnUH+5+uBXwqygNjFNI56p27JDzbfhmPEAIQ34USo96IJOVD46CUcgWhaBQNkA5X5TgohUDkE5VIOcy3Y8B6uIDkowdGmPWd1oe06u0X8m+3SJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136494; c=relaxed/simple;
	bh=OAzTVrxaBVtwwUfxiO4TTryWi/O5Jauv72wzBf/6YOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAZfTTSHZiRaMx/sCH/sANZ3rW5LtK+mtnjdWpKAg8gQo7kmLdYezcDD997EOSS2U8/exc6PdkGKQiBZy3435QEJ/WaK5G/KFYZES9lxCb0yeZMVGY5ZlIe1za2OTVQLuM2SIKZVXkrNX8PwAaPEB5VdWUvvXcj7RexC6LDkxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D73201BB2;
	Fri, 14 Nov 2025 08:08:04 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34B213F5A1;
	Fri, 14 Nov 2025 08:08:10 -0800 (PST)
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
Subject: [RFC PATCH v6 15/35] KVM: arm64: Add SPE VCPU device attribute to initialize SPE
Date: Fri, 14 Nov 2025 16:06:56 +0000
Message-ID: <20251114160717.163230-16-alexandru.elisei@arm.com>
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

Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_INIT) VCPU ioctl to initialize
SPE. Initialization must be done exactly once for each VCPU.

[ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
	   for SPE" ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 28 +++++++++++++++++--
 arch/arm64/include/asm/kvm_spe.h        |  6 +++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    |  4 +++
 arch/arm64/kvm/spe.c                    | 36 +++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index bb1bbd2ff6e2..29dd1f087d4a 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -306,6 +306,7 @@ From the destination VMM process:
 Returns:
 
 	 =======  ==========================================================
+	 -EBUSY   SPE already initialized
 	 -EFAULT  Error accessing the buffer management interrupt number
 	 -EINVAL  Invalid interrupt number or not using an in-kernel irqchip
 	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
@@ -328,7 +329,8 @@ vGIC implementation.
 :Returns:
 
 	 =======  ================================================
-	 -EBUSY   Virtual machine has already run
+	 -EBUSY   Virtual machine has already run, or SPE already
+                  initialized
 	 -EFAULT  Error accessing the SPU identifier
 	 -EINVAL  A different SPU already set
 	 -ENXIO   SPE not supported or not properly configured, or
@@ -357,7 +359,8 @@ have the specified SPU.
 :Returns:
 
 	 =======  =========================================================
-	 -EBUSY   Virtual machine has already run
+	 -EBUSY   Virtual machine has already run, or SPE already
+                  initialized
 	 -EDOM    Buffer size cannot be represented by hardware
 	 -EFAULT  Error accessing the max buffer size identifier
 	 -EINVAL  A different maximum buffer size already set or the size is
@@ -396,3 +399,24 @@ This memory that is pinned will count towards the process RLIMIT_MEMLOCK. To
 avoid the limit being exceeded, userspace must increase the RLIMIT_MEMLOCK limit
 prior to running the VCPU, otherwise KVM_RUN will return to userspace with an
 error.
+
+5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
+-----------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+Returns:
+
+	 =======  ============================================
+	 -EBUSY   SPE already initialized for this VCPU
+	 -ENXIO   SPE not supported or not properly configured
+	 =======  ============================================
+
+Required.
+
+Request initialization of the Statistical Profiling Extension for this VCPU.
+Must be done last, after SPE has been fully configured for the VCPU, and after
+the in-kernel irqchip has been initialized.
+
+KVM will refuse to run the VCPU and KVM_RUN will return an error if SPE hasn't
+been initialized for the VCPU.
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index e48f7a7f67bb..6ce70cf2abaf 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -17,6 +17,7 @@ struct kvm_spe {
 
 struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrupt number */
+	bool initialized;	/* SPE initialized for the VCPU */
 };
 
 DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
@@ -30,6 +31,7 @@ static __always_inline bool kvm_supports_spe(void)
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 
 void kvm_spe_init_vm(struct kvm *kvm);
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -47,6 +49,10 @@ struct kvm_vcpu_spe {
 static inline void kvm_spe_init_vm(struct kvm *kvm)
 {
 }
+static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9db652392781..186dcaf5e210 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -448,6 +448,7 @@ enum {
 #define   KVM_ARM_VCPU_SPE_IRQ			0
 #define   KVM_ARM_VCPU_SPE_SPU			1
 #define   KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE	2
+#define   KVM_ARM_VCPU_SPE_INIT			3
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9afdf66be8b2..783e331fb57a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -899,6 +899,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	ret = kvm_spe_vcpu_first_run_init(vcpu);
+	if (ret)
+		return ret;
+
 	mutex_lock(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
 	mutex_unlock(&kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 3478da2a1f7c..6bd074e40f6c 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -55,6 +55,19 @@ void kvm_spe_init_vm(struct kvm *kvm)
 	kvm->arch.kvm_spe.max_buffer_size = KVM_SPE_MAX_BUFFER_SIZE_UNSET;
 }
 
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+
+	if (!vcpu_has_spe(vcpu))
+		return 0;
+
+	if (!vcpu_spe->initialized)
+		return -EINVAL;
+
+	return 0;
+}
+
 static u64 max_buffer_size_to_pmbidr_el1(u64 size)
 {
 	u64 msb_idx, num_bits;
@@ -195,12 +208,16 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (!vcpu_has_spe(vcpu))
 		return -ENODEV;
 
+	if (vcpu_spe->initialized)
+		return -EBUSY;
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
@@ -239,6 +256,24 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_spe_set_max_buffer_size(vcpu, size);
 	}
+	case KVM_ARM_VCPU_SPE_INIT:
+		if (!vcpu_spe->irq_num)
+			return -ENXIO;
+
+		if (!kvm_spe->arm_spu)
+			return -ENXIO;
+
+		if (kvm_spe->max_buffer_size == KVM_SPE_MAX_BUFFER_SIZE_UNSET)
+			return -ENXIO;
+
+		if (!vgic_initialized(kvm))
+			return -ENXIO;
+
+		if (kvm_vgic_set_owner(vcpu, vcpu_spe->irq_num, vcpu_spe))
+			return -ENXIO;
+
+		vcpu_spe->initialized = true;
+		return 0;
 	}
 
 	return -ENXIO;
@@ -310,6 +345,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_SPE_IRQ:
 	case KVM_ARM_VCPU_SPE_SPU:
 	case KVM_ARM_VCPU_SPE_MAX_BUFFER_SIZE:
+	case KVM_ARM_VCPU_SPE_INIT:
 		return 0;
 	}
 
-- 
2.51.2

