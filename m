Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E57C8F4
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:14 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tItGoF8BhDVztrUiIc+AuTU29mTV71m1mnJE4Zpdg24=;
	b=LWyLA1Ow1Z+VKG0OJPDbZZAL4gLnsxxwpc4oCva9cJMjwv4VPyHxhTcuolTIm62dHJ1mii
	x1ZT8kCZbi6oIso0nmbE+mBQCHUpn2BqfUeO/EIk9nkLG7JXIz7y0CF4c6cTaTTUtVpbTV
	0noIjU1xt2sIeEJXPLHGeO8FiiGIMNc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 03/11] KVM: arm64: Make vCPU feature flags consistent VM-wide
Date: Fri,  9 Jun 2023 19:00:46 +0000
Message-ID: <20230609190054.1542113-4-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To date KVM has allowed userspace to construct asymmetric VMs where
particular features may only be supported on a subset of vCPUs. This
wasn't really the intened usage pattern, and it is a total pain in the
ass to keep working in the kernel. What's more, this is at odds with CPU
features in host userspace, where asymmetric features are largely hidden
or disabled.

It's time to put an end to the whole game. Require all vCPUs in the VM
to have the same feature set, rejecting deviants in the
KVM_ARM_VCPU_INIT ioctl. Preserve some of the vestiges of per-vCPU
feature flags in case we need to reinstate the old behavior for some
limited configurations. Yes, this is a sign of cowardice around a
user-visibile change.

Hoist all of the 32-bit limitations into kvm_vcpu_init_check_features()
to avoid nested attempts to acquire the config_lock, which won't end
well.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h |  7 +---
 arch/arm64/include/asm/kvm_host.h    | 22 +++++------
 arch/arm64/kvm/arm.c                 | 31 ++++++++++++++-
 arch/arm64/kvm/reset.c               | 58 ----------------------------
 4 files changed, 40 insertions(+), 78 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b31b32ecbe2d..b19c35129d1c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -62,12 +62,7 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 #else
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
-
-	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
-			       &kvm->arch.flags));
-
-	return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
+	return test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
 }
 #endif
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 565cad211388..2c8c4ace81ef 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -215,25 +215,21 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
 	/* At least one vCPU has ran in the VM */
 #define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
-	/*
-	 * The following two bits are used to indicate the guest's EL1
-	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
-	 * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
-	 * Otherwise, the guest's EL1 register width has not yet been
-	 * determined yet.
-	 */
-#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
-#define KVM_ARCH_FLAG_EL1_32BIT				4
+	/* The vCPU feature set for the VM is configured */
+#define KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED		3
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
-#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		4
 	/* VM counter offset */
-#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
+#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			5
 	/* Timer PPIs made immutable */
-#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
+#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
 	/* SMCCC filter initialized for the VM */
-#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		7
 	unsigned long flags;
 
+	/* VM-wide vCPU feature set */
+	DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
+
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
 	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a9c18f45df3f..85c978ad1f27 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -170,6 +170,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	 */
 	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
 
+	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
+
 	return 0;
 
 err_free_cpumask:
@@ -1181,6 +1183,20 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
+	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
+		return 0;
+
+	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+		return -EINVAL;
+
+	/* MTE is incompatible with AArch32 */
+	if (kvm_has_mte(vcpu->kvm))
+		return -EINVAL;
+
+	/* NV is incompatible with AArch32 */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1197,7 +1213,14 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
 	unsigned long features = init->features[0];
-	int ret;
+	struct kvm *kvm = vcpu->kvm;
+	int ret = -EINVAL;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags) &&
+	    !bitmap_equal(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES))
+		goto out_unlock;
 
 	vcpu->arch.target = init->target;
 	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
@@ -1207,8 +1230,14 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	if (ret) {
 		vcpu->arch.target = -1;
 		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
+		goto out_unlock;
 	}
 
+	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
+	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b5dee8e57e77..bc8556b6f459 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -186,57 +186,6 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/**
- * kvm_set_vm_width() - set the register width for the guest
- * @vcpu: Pointer to the vcpu being configured
- *
- * Set both KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
- * in the VM flags based on the vcpu's requested register width, the HW
- * capabilities and other options (such as MTE).
- * When REG_WIDTH_CONFIGURED is already set, the vcpu settings must be
- * consistent with the value of the FLAG_EL1_32BIT bit in the flags.
- *
- * Return: 0 on success, negative error code on failure.
- */
-static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = vcpu->kvm;
-	bool is32bit;
-
-	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
-
-	lockdep_assert_held(&kvm->arch.config_lock);
-
-	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
-		/*
-		 * The guest's register width is already configured.
-		 * Make sure that the vcpu is consistent with it.
-		 */
-		if (is32bit == test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags))
-			return 0;
-
-		return -EINVAL;
-	}
-
-	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
-		return -EINVAL;
-
-	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(kvm) && is32bit)
-		return -EINVAL;
-
-	/* NV is incompatible with AArch32 */
-	if (vcpu_has_nv(vcpu) && is32bit)
-		return -EINVAL;
-
-	if (is32bit)
-		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
-
-	set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
-
-	return 0;
-}
-
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -262,13 +211,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->arch.config_lock);
-	ret = kvm_set_vm_width(vcpu);
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
-
-	if (ret)
-		return ret;
-
 	spin_lock(&vcpu->arch.mp_state_lock);
 	reset_state = vcpu->arch.reset_state;
 	vcpu->arch.reset_state.reset = false;
-- 
2.41.0.162.gfafddb0af9-goog

