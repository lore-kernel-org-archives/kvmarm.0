Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FB63E834D
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451627; cv=none; b=Ms1PJlZ91K75Uq3TGD6cuI9uU25f72XOcKpXaTvKzPKo0d1d0JZ4jdG1rVAlIfjTLdpdLS3hRNFQ9TR1I86pwd12w4DL6vCMY/KZTMRErZkK6jMqs6dL22IG3qUv9143USZIbQzKoFKECqjMh483iqNbua4Qcij1yyJEjXhiVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451627; c=relaxed/simple;
	bh=3IfnUm9vz09avMaQ0L4QYQr/qFwcijBTANKLRIl4G3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAHkf7fR9GVDrSypUbz06COxi5To/6eZExRmp1s6izxPIqjWp+qVd3xWOPyAj9mRYziEbvbmzjHE9bWrqqmL+4pwalhfgVkRHIAx1Mvz2DfNSuTqtkjKpBcLK3HCNp2+/+nRzLUilE7HLCxvn42uaBI8T1pBMuRDPnkHm8aX9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AoZHctmF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AoZHctmF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2979E1D34;
	Thu,  3 Sep 2026 09:07:01 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F36C73F673;
	Thu,  3 Sep 2026 09:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451624; bh=3IfnUm9vz09avMaQ0L4QYQr/qFwcijBTANKLRIl4G3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoZHctmFX0/ra2UO9wED8g9ssvWSRJhVeC3FsT3iPuNY8ddszpOVMJo1sl3NdxFxf
	 wW702FRb8eItvSYloKAs3aAAmR1it9k4LrRxt0gQwdAIq+y/kAS2kXshSUOzSTkdjM
	 GEyNMjTl+yirQyb5XbjJH0QpKka6SOqSqFt+MKX8=
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
Subject: [RFC PATCH v7 14/28] KVM: arm64: Add SPE VCPU device attribute to initialize SPE
Date: Thu,  3 Sep 2026 17:06:09 +0100
Message-ID: <20260903160623.315525-15-alexandru.elisei@arm.com>
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

Add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_INIT) VCPU ioctl to initialize
SPE. Initialization must be done exactly once for each VCPU.

[ Alexandru E: Split from "KVM: arm64: Add a new VCPU device control group
	   for SPE" ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 28 ++++++++++++++++++++---
 arch/arm64/include/asm/kvm_spe.h        |  6 +++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    |  6 +++++
 arch/arm64/kvm/spe.c                    | 30 +++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index d60dd1daa67f..e2eac48b9d28 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -317,6 +317,7 @@ From the destination VMM process:
 Returns:
 
 	 =======  ==========================================================
+	 -EBUSY   SPE already initialized
 	 -EFAULT  Error accessing the buffer management interrupt number
 	 -EINVAL  Invalid interrupt number or not using an in-kernel irqchip
 	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
@@ -338,15 +339,15 @@ vGIC implementation.
 
 :Returns:
 
-	 =======  =========================================================
-	 -EBUSY   Virtual machine has already run
+	 =======  ===========================================================
+	 -EBUSY   Virtual machine has already run, or SPE already initialized
 	 -EFAULT  Error accessing the SPE identifier
 	 -EINVAL  A different SPE instance already assigned, or no physical
                   CPUs found
 	 -ENXIO   SPE not supported or not properly configured, or the SPE
                   module not loaded
 	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set
-	 =======  =========================================================
+	 =======  ===========================================================
 
 Required.
 
@@ -361,3 +362,24 @@ responsible for making sure that the VCPU is run only on physical CPUs which
 share the specified SPE instance. If the VCPU has a PMU assigned, and there are
 no physical CPUs which share the same SPE and PMU instance, an error is
 returned.
+
+5.3 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
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
+KVM will refuse to run the VCPU and KVM_RUN will return an error if the SPE
+feature has been set for the VCPU, but SPE hasn't been initialized.
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index b8afb419c851..a6999709b298 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -18,6 +18,7 @@ struct kvm_spe {
 
 struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrupt number */
+	bool initialized;	/* SPE initialized for the VCPU */
 };
 
 bool kvm_supports_spe(void);
@@ -25,6 +26,7 @@ bool kvm_supports_spe(void);
 #define vcpu_has_spe(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 void kvm_spe_destroy_vm(struct kvm *kvm);
 
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -46,6 +48,10 @@ static __always_inline bool kvm_supports_spe(void)
 
 #define vcpu_has_spe(vcpu)	false
 
+static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_spe_destroy_vm(struct kvm *kvm)
 {
 }
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8ffa3e89d38c..c695aae484d3 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -449,6 +449,7 @@ enum {
 #define KVM_ARM_VCPU_SPE_CTRL		3
 #define   KVM_ARM_VCPU_SPE_IRQ		0
 #define   KVM_ARM_VCPU_SPE_ID		1
+#define   KVM_ARM_VCPU_SPE_INIT		2
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 132df44c3088..c9a026c61ce7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1026,6 +1026,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	if (vcpu_has_spe(vcpu)) {
+		ret = kvm_spe_vcpu_first_run_init(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	ret = vgic_v5_finalize_ppi_state(kvm);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 87fcdbbcbd67..fa87d224c8af 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -59,6 +59,16 @@ bool kvm_supports_spe(void)
 	return !list_empty(&spe_pmus);
 }
 
+int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+
+	if (!vcpu_spe->initialized)
+		return -EINVAL;
+
+	return 0;
+}
+
 void kvm_spe_destroy_vm(struct kvm *kvm)
 {
 	struct arm_spe_pmu *spe_pmu;
@@ -147,12 +157,16 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
@@ -182,6 +196,21 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_spe_set_spe_id(vcpu, spe_id);
 	}
+	case KVM_ARM_VCPU_SPE_INIT:
+		if (!vcpu_spe->irq_num)
+			return -ENXIO;
+
+		if (!kvm_spe->spe_pmu)
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
@@ -240,6 +269,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch(attr->attr) {
 	case KVM_ARM_VCPU_SPE_IRQ:
 	case KVM_ARM_VCPU_SPE_ID:
+	case KVM_ARM_VCPU_SPE_INIT:
 		return 0;
 	}
 
-- 
2.43.0

