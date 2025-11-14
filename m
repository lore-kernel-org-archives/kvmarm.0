Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2C730595B
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136519; cv=none; b=EPicjxpI7IdPLMLPPQ3jEk4EBnXx6ZyOs6M29nbSNKdbHXnOndY9SrbvS0nXstej34AMrLSdZK7wHc1nRSXTwNHJ5X7PflynsmdVya05+iNf2DAazYEHJEi6LrJDRyHDpWYIash5jSoTwfcZifeZQbfgbYr8l724j/+l69EHnaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136519; c=relaxed/simple;
	bh=oiRUWVnuOac7Z0OmNUkgaBPNufE0cqPO0R3fsUld8i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEw5MAHoGVxM0M0ApsHoVrsxluBR5vtHxnzlXE5S6DNFZYdyNIpyDbp4Zr/FMnfumLmSwllALo2oCdQoVXO68aZN0Pkpax7mZMkEzFkPwEEhz5fnOBV+y5UFbGsE7S7VJS08yek6vyxQLTWq63Wr95znOketH+RmkyUpa1Qpgr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C88FC19F6;
	Fri, 14 Nov 2025 08:08:29 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 492E73F5A1;
	Fri, 14 Nov 2025 08:08:35 -0800 (PST)
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
Subject: [RFC PATCH v6 25/35] KVM: arm64: Add basic handling of SPE buffer control registers writes
Date: Fri, 14 Nov 2025 16:07:06 +0000
Message-ID: <20251114160717.163230-26-alexandru.elisei@arm.com>
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

The buffer is controlled with three registers: PMBLIMITR_EL1, PMBPTR_EL1
and PMBSR_EL1.

PMBSR_EL1 is the most straightforward one to handle: update the status of
the virtual buffer management interrupt following a change in the
PMBSR_EL1.S value.

For the other two, at the moment KVM only cares about detecting eroneous
programming: either the buffer is larger than the maximum advertised in
PMBIDR_EL1.MaxBuffSize, or it has been misprogrammed.

Making sure that the stage 2 mappings for the buffer don't disappear while
ProfilingBufferEnabled() = true will be handled separately.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/sysreg.h |   1 +
 arch/arm64/kvm/spe.c            | 139 +++++++++++++++++++++++++++++++-
 2 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c231d2a3e515..28388e12a251 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -350,6 +350,7 @@
 #define PMBSR_EL1_BUF_BSC_MASK		PMBSR_EL1_MSS_MASK
 
 #define PMBSR_EL1_BUF_BSC_FULL		0x1UL
+#define PMBSR_EL1_BUF_BSC_SIZE		0x4UL
 
 /*** End of Statistical Profiling Extension ***/
 
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index d163ddfdd8e2..6e8e0068e7e4 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -24,6 +24,9 @@ struct arm_spu_entry {
 };
 
 static u64 max_buffer_size_to_pmbidr_el1(u64 size);
+static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
+
+static u64 pmblimitr_el1_res0_mask = GENMASK_ULL(11, 8) | GENMASK_ULL(6, 3);
 
 void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 {
@@ -63,6 +66,33 @@ void kvm_spe_init_vm(struct kvm *kvm)
 	kvm->arch.kvm_spe.max_buffer_size = KVM_SPE_MAX_BUFFER_SIZE_UNSET;
 }
 
+static bool kvm_spe_has_physical_addrmode(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP);
+}
+
+static bool kvm_spe_has_discard_mode(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2);
+}
+
+static void kvm_spe_compute_pmblimitr_el1_res0_mask(struct kvm *kvm)
+{
+	if (!kvm_spe_has_discard_mode(kvm))
+		pmblimitr_el1_res0_mask |= PMBLIMITR_EL1_FM;
+
+	if (!kvm_spe_has_physical_addrmode(kvm))
+		pmblimitr_el1_res0_mask |= PMBLIMITR_EL1_nVM;
+
+	if (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP))
+		return;
+
+	if (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))
+		pmblimitr_el1_res0_mask |= GENMASK_ULL(13, 12);
+	else
+		pmblimitr_el1_res0_mask |= GENMASK_ULL(15, 12);
+}
+
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -81,6 +111,8 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (perfmon_capable())
 		kvm_spe->guest_pmscr_el2 = PMSCR_EL2_PCT_PHYS;
 
+	kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
+
 	return 0;
 }
 
@@ -94,10 +126,113 @@ u8 kvm_spe_get_pmsver_limit(void)
 	return min(pmsver, ID_AA64DFR0_EL1_PMSVer_V1P5);
 }
 
+/* Implements OtherSPEManagementEvent() from ARM DDI0487L.b */
+static void kvm_spe_inject_other_event(struct kvm_vcpu *vcpu, u8 bsc)
+{
+	u64 pmbsr_el1 = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+
+	pmbsr_el1 &= ~(PMBSR_EL1_MSS2 | PMBSR_EL1_EC | PMBSR_EL1_MSS);
+	pmbsr_el1 |= PMBSR_EL1_S;
+	pmbsr_el1 |= FIELD_PREP(PMBSR_EL1_MSS, bsc);
+
+	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, pmbsr_el1);
+
+	kvm_spe_update_irq_level(vcpu, true);
+}
+
+static u64 kvm_spe_max_buffer_size(struct kvm *kvm)
+{
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+
+	return kvm_spe->max_buffer_size;
+}
+
+static u16 kvm_spe_max_record_size(struct kvm *kvm)
+{
+	struct arm_spe_pmu *spu = kvm->arch.kvm_spe.arm_spu;
+
+	return spu->max_record_sz;
+}
+
+static u64 kvm_spe_buffer_limit(u64 pmblimitr_el1)
+{
+	return FIELD_GET(PMBLIMITR_EL1_LIMIT, pmblimitr_el1) << 12;
+}
+
+static u64 kvm_spe_buffer_ptr(u64 pmbptr_el1)
+{
+	return FIELD_GET(PMBPTR_EL1_PTR, pmbptr_el1);
+}
+
+static bool kvm_spe_profiling_buffer_enabled_vcpu(struct kvm_vcpu *vcpu)
+{
+	return kvm_spe_profiling_buffer_enabled(__vcpu_sys_reg(vcpu, PMBLIMITR_EL1),
+						__vcpu_sys_reg(vcpu, PMBSR_EL1));
+}
+
+static bool kvm_spe_in_discard_mode(u64 pmblimitr_el1)
+{
+	return FIELD_GET(PMBLIMITR_EL1_FM, pmblimitr_el1);
+}
+
+static bool kvm_spe_in_discard_mode_vcpu(struct kvm_vcpu *vcpu)
+{
+	return kvm_spe_in_discard_mode(__vcpu_sys_reg(vcpu, PMBLIMITR_EL1));
+}
+
+static u16 kvm_spe_min_align(struct kvm *kvm)
+{
+	struct arm_spe_pmu *spu = kvm->arch.kvm_spe.arm_spu;
+
+	return spu->align;
+}
+
 bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
-	__vcpu_assign_sys_reg(vcpu, val, reg);
+	struct kvm *kvm = vcpu->kvm;
+	u64 ptr, limit, max_buffer_size;
+
+	switch (reg) {
+	case PMBLIMITR_EL1:
+		val &= ~pmblimitr_el1_res0_mask;
+		break;
+	case PMBSR_EL1:
+		break;
+	case PMBPTR_EL1:
+		/* Treat bits PMBIDR_EL1.Align-1:0 as RES0. */
+		val = ALIGN_DOWN(val, kvm_spe_min_align(kvm));
+		break;
+	default:
+		WARN_ON_ONCE(true);
+	}
+
+	__vcpu_assign_sys_reg(vcpu, reg, val);
+	if (reg == PMBSR_EL1) {
+		kvm_spe_update_irq_level(vcpu,
+					 FIELD_GET(PMBSR_EL1_S, __vcpu_sys_reg(vcpu, PMBSR_EL1)));
+	}
+
+	if (!kvm_spe_profiling_buffer_enabled_vcpu(vcpu) || kvm_spe_in_discard_mode_vcpu(vcpu))
+		goto out;
 
+	ptr = kvm_spe_buffer_ptr(__vcpu_sys_reg(vcpu, PMBPTR_EL1));
+	limit = kvm_spe_buffer_limit(__vcpu_sys_reg(vcpu, PMBLIMITR_EL1));
+
+	/*
+	 * In the Arm ARM, Uint() performs a *signed* integer conversion.
+	 * Convert all members to signed to avoid C promotion to unsigned.
+	 */
+	if (!limit || (s64)ptr > (s64)limit - (s64)kvm_spe_max_record_size(kvm) ||
+	    FIELD_GET(GENMASK_ULL(63, 56), ptr) != FIELD_GET(GENMASK_ULL(63, 56), limit)) {
+		kvm_spe_inject_other_event(vcpu, PMBSR_EL1_BUF_BSC_FULL);
+		goto out;
+	}
+
+	max_buffer_size = kvm_spe_max_buffer_size(kvm);
+	if (max_buffer_size && limit - ptr > max_buffer_size)
+		kvm_spe_inject_other_event(vcpu, PMBSR_EL1_BUF_BSC_SIZE);
+
+out:
 	return true;
 }
 
@@ -144,7 +279,7 @@ static u64 kvm_spe_get_pmbidr_el1(struct kvm_vcpu *vcpu)
 	/* Filter out known RES0 bits. */
 	pmbidr_el1 &= ~(GENMASK_ULL(63, 48) | GENMASK_ULL(31, 12));
 
-	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP)) {
+	if (!kvm_spe_has_physical_addrmode(kvm)) {
 		pmbidr_el1 &= ~PMBIDR_EL1_AddrMode;
 		pmbidr_el1 |= PMBIDR_EL1_AddrMode_VM_ONLY;
 	}
-- 
2.51.2

