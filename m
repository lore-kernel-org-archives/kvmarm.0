Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24886191F84
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136499; cv=none; b=S7XFd/KY9eDfe+Cm/Nv5NU6HbHqNsvo9znQzk84c1D0LRADodKbk5kXajaDcq7V/4toq3g1yBs3Q42IerKncsuqJGTD97xZB0Plfm0XeeE4YuTpLxGusFjYr+32sDzFF6Vy4jUTXHzepc0btnyrpteth9JbfWwH5a+jDnjQbh20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136499; c=relaxed/simple;
	bh=T4qUQBQTUnLp2fHtzJHSgf7SDkQkJ3Y1cEz/SwDA2ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIwv4f76IijEWGVzFxkX1gLsGbcVs4kEdXq8tnXo7ZJwKiZ+4f808gOkDaxHDSkq5RH5eIFGqvkXFvB0PcDakN4W6Z9G/DTA3FMWUiBWgWfFtnCZENH81cX+CHSLm4XnUEsiHgwKDm4UfrrfY90xs0+anOQFnvARyZgxLawZ4ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD01B1BB2;
	Fri, 14 Nov 2025 08:08:09 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AC923F5A1;
	Fri, 14 Nov 2025 08:08:15 -0800 (PST)
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
Subject: [RFC PATCH v6 17/35] KVM: arm64: Add writable SPE system registers to VCPU context
Date: Fri, 14 Nov 2025 16:06:58 +0000
Message-ID: <20251114160717.163230-18-alexandru.elisei@arm.com>
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

Add the writable SPE registers to the VCPU context. The registers for now
have generic accessors, with proper handling to be added. PMSIDR_EL1 and
PMBIDR_EL1 are not part of the VCPU context because they are read-only
registers.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++++
 arch/arm64/include/asm/kvm_spe.h  | 11 ++++++
 arch/arm64/kvm/debug.c            | 19 ++++++++---
 arch/arm64/kvm/spe.c              | 13 +++++++
 arch/arm64/kvm/sys_regs.c         | 56 ++++++++++++++++++++++++-------
 5 files changed, 94 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 373d22ec4783..876957320672 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -464,6 +464,19 @@ enum vcpu_sysreg {
 	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
+	/* SPE registers */
+	PMSCR_EL1,
+	PMSNEVFR_EL1,
+	PMSICR_EL1,
+	PMSIRR_EL1,
+	PMSFCR_EL1,
+	PMSEVFR_EL1,
+	PMSLATFR_EL1,
+	PMBLIMITR_EL1,
+	PMBPTR_EL1,
+	PMBSR_EL1,
+	PMSDSFR_EL1,
+
 	/* Pointer Authentication Registers in a strict increasing order. */
 	APIAKEYLO_EL1,
 	APIAKEYHI_EL1,
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 5e6d7e609a48..3506d8c4c661 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -38,6 +38,9 @@ u8 kvm_spe_get_pmsver_limit(void);
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+
+bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
+u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
 #else
 struct kvm_spe {
 };
@@ -71,6 +74,14 @@ static inline int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr
 {
 	return -ENXIO;
 }
+static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
+{
+	return true;
+}
+static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
+{
+	return 0;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba..0821ebfb03fa 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -38,19 +38,28 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
-	/*
-	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
-	 * to disable guest access to the profiling and trace buffers
-	 */
 	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
 					 *host_data_ptr(nr_event_counters));
+	/*
+	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access to the
+	 * trace buffer.
+	 */
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
 
+	if (vcpu_has_spe(vcpu)) {
+		/* Set buffer owner to EL1 and trap the buffer registers. */
+		vcpu->arch.mdcr_el2 |= FIELD_PREP(MDCR_EL2_E2PB, MDCR_EL2_E2PB_EL1_TRAP);
+		/* Leave TPMS zero and don't trap the sampling registers. */
+	} else {
+		/* Trap the sampling registers. */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TPMS;
+		/* Leave E2PB zero and trap the buffer registers. */
+	}
+
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
 		/* Route all software debug exceptions to EL2 */
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 0c4896c6a873..5b3dc622cf82 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -8,6 +8,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_spe.h>
 #include <asm/sysreg.h>
 
@@ -78,6 +79,18 @@ u8 kvm_spe_get_pmsver_limit(void)
 	return min(pmsver, ID_AA64DFR0_EL1_PMSVer_V1P5);
 }
 
+bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
+{
+	__vcpu_assign_sys_reg(vcpu, val, reg);
+
+	return true;
+}
+
+u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
+{
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
 static u64 max_buffer_size_to_pmbidr_el1(u64 size)
 {
 	u64 msb_idx, num_bits;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ac859c39c2be..5eeea229b46e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1374,6 +1374,28 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	if (vcpu_has_spe(vcpu))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 val = p->regval;
+	int reg = r->reg;
+
+	if (p->is_write)
+		return kvm_spe_write_sysreg(vcpu, reg, val);
+
+	p->regval = kvm_spe_read_sysreg(vcpu, reg);
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1406,6 +1428,14 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	  .reset = reset_pmevtyper,					\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
+#define SPE_TRAPPED_REG(name)						\
+	SYS_DESC(SYS_##name), .reg = name, .access = access_spe_reg,	\
+	.reset = reset_val, .val = 0, .visibility = spe_visibility
+
+#define SPE_UNTRAPPED_REG(name)						\
+	SYS_DESC(SYS_##name), .reg = name, .access = undef_access,	\
+	.reset = reset_val, .val = 0, .visibility = spe_visibility
+
 /* Macro to expand the AMU counter and type registers*/
 #define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), undef_access }
 #define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), undef_access }
@@ -3323,19 +3353,19 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-	{ SYS_DESC(SYS_PMSCR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSNEVFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSICR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSIRR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSFCR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSEVFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSLATFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSIDR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
-	/* PMBIDR_EL1 is not trapped */
+	{ SPE_UNTRAPPED_REG(PMSCR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSNEVFR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSICR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSIRR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSFCR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSEVFR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSLATFR_EL1) },
+	{ SYS_DESC(SYS_PMSIDR_EL1), .access = undef_access },
+	{ SPE_TRAPPED_REG(PMBLIMITR_EL1) },
+	{ SPE_TRAPPED_REG(PMBPTR_EL1) },
+	{ SPE_TRAPPED_REG(PMBSR_EL1) },
+	{ SPE_UNTRAPPED_REG(PMSDSFR_EL1) },
+	{ SYS_DESC(SYS_PMBIDR_EL1), .access = undef_access },
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1,
-- 
2.51.2

