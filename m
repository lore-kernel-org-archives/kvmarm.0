Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890C51B0404
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079781; cv=none; b=JPADTCIEXBnKcuUNe9zT5pjUTcwybUlbEP543LvPiHXAAWt9i0nY7aHK9OtGOJOKGLAXe9l8i8JEPUITtxr5o2stm73VT5CV0fJANEiuhz5jXFw5NWDtS+kgQPrj5CcUSvzq1ZZr8cXRse8p4805eI1a/c5S+9X0mXJBqPjaSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079781; c=relaxed/simple;
	bh=tmca2NzW3yUIbeotp5YQMV3iuuxb+zLmuYYcKxQuCFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dWsd2V6IiyVwT1j87Aaa56GaT4AOvruxYkQC/ez8PHTaSwifZEpUrxe+THYZMx0QLlAcFJEtS6eaCeSzYmP1A6ifBu4q4ruHYn2oDmK0yNHudAA+dfdSs/CXgX5UWlgcjh0U0GhMkaWemPpmxJYfsOtEeUa09YlNobhdMOPaC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62F9C153B;
	Tue, 28 Jan 2025 07:56:44 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 35B6D3F694;
	Tue, 28 Jan 2025 07:56:16 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH 4/4] KVM: arm64: expose SMCCC_ARCH_WORKAROUND_4 to guests
Date: Tue, 28 Jan 2025 15:54:28 +0000
Message-Id: <20250128155428.210645-5-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250128155428.210645-1-mark.rutland@arm.com>
References: <20250128155428.210645-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire up KVM support so that guests can detect the presence of
SMCCC_ARCH_WORKAROUND_4 and determine whether firmware has mitigated
CVE-2024-7881.

SMCCC_ARCH_WORKAROUND_4 is documented in the SMCCC 1.6 G BET0
specification, which can be found at:

  https://developer.arm.com/documentation/den0028/gbet0/?lang=en

Note that SMCCC_ARCH_WORKAROUND_4 has no return value, and exists solely
such that it can be detected via SMCCC_ARCH_FEATURES.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev
---
 arch/arm64/include/asm/spectre.h  |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kernel/cpufeature.c    | 14 ++++++++++++++
 arch/arm64/kvm/hypercalls.c       | 21 +++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index 0c4d9045c31f4..365e5d7199f90 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -95,6 +95,8 @@ void spectre_v4_enable_task_mitigation(struct task_struct *tsk);
 
 enum mitigation_state arm64_get_meltdown_state(void);
 
+enum mitigation_state arm64_get_cve_2024_7881_state(void);
+
 enum mitigation_state arm64_get_spectre_bhb_state(void);
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
 u8 spectre_bhb_loop_affected(int scope);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 66736ff04011e..aa207c633b115 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -304,6 +304,10 @@ struct kvm_arm_counter_offset {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL		1
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED	2
 
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4	KVM_REG_ARM_FW_REG(4)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4_AVAIL		1
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e90bf4dcb6f1c..50536abcdfac3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1823,6 +1823,7 @@ static bool cpu_has_leaky_prefetcher(void)
 }
 
 static bool __meltdown_safe = true;
+static bool __leaky_prefetch_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
@@ -1838,6 +1839,8 @@ static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 		__meltdown_safe = false;
 
 	prefetcher_safe = !cpu_has_leaky_prefetcher();
+	if (!prefetcher_safe)
+		__leaky_prefetch_safe = false;
 
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
@@ -3945,3 +3948,14 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+enum mitigation_state arm64_get_cve_2024_7881_state(void)
+{
+	if (__leaky_prefetch_safe)
+		return SPECTRE_UNAFFECTED;
+
+	if (arm64_kernel_unmapped_at_el0())
+		return SPECTRE_MITIGATED;
+
+	return SPECTRE_VULNERABLE;
+}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 27ce4cb449049..876e6f29a73e0 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -337,6 +337,16 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_4:
+			switch (arm64_get_cve_2024_7881_state()) {
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_VULNERABLE:
+			case SPECTRE_MITIGATED:
+				break;
+			}
+			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
 			if (test_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME,
 				     &smccc_feat->std_hyp_bmap))
@@ -387,6 +397,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
 	KVM_REG_ARM_VENDOR_HYP_BMAP,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -468,6 +479,14 @@ static int get_kernel_wa_level(struct kvm_vcpu *vcpu, u64 regid)
 			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
 		}
 		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4:
+		switch (arm64_get_cve_2024_7881_state()) {
+		case SPECTRE_VULNERABLE:
+		case SPECTRE_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4_NOT_AVAIL;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4_AVAIL;
+		}
 	}
 
 	return -EINVAL;
@@ -486,6 +505,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4:
 		val = get_kernel_wa_level(vcpu, reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	case KVM_REG_ARM_STD_BMAP:
@@ -587,6 +607,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_4:
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
-- 
2.30.2

