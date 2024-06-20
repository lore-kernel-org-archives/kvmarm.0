Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C554207F
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 06:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718866749; cv=none; b=tm8x8b4wbl/oDsDoeij/D3ARKNsn7Ja/TskgiZjyHievNp23cA2cGMRMfFoe3YZyYcoDkdtaHwi5N7ysTfdE21M0/LMt2BaZ1BjTMyZbdzVyeUYQuQEzWSV5DZ7Cl/2/UJX60yZIRW0MsXSEgfq+RzHjQGqG91P+oRTzEORiVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718866749; c=relaxed/simple;
	bh=t+0mw7qIdwi4qAz260B1ZFG9jYq0w2o/IK8abKs1pXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNIEIGx261iJCjf3x0PTWdjQaI7L5aJCOWuqznvJy/ms6Vv1NXewIGZCp17ovFkZw9JYKZ6unY9IjBAYrALxOXzrf9h34DYnOYjylp1/MNqAlAM33/BVTRDMK4RmfRYBcayJMXh3xJ22+RW1SpvqI6/FD+N+R74O+QGqxgqvDvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98DF1DA7;
	Wed, 19 Jun 2024 23:59:31 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE5C33F73B;
	Wed, 19 Jun 2024 23:59:02 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 10/10] KVM: arm64: nv: Add new HDFGRTR2_GROUP & HDFGRTR2_GROUP based FGU handling
Date: Thu, 20 Jun 2024 12:28:07 +0530
Message-Id: <20240620065807.151540-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240620065807.151540-1-anshuman.khandual@arm.com>
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds new HDFGRTR2_GROUP and HDFGWTR2_GROUP groups in enum fgt_group_id
for FGU handling managed with HDFGRTR2_EL2 and HDFGWTR2_EL2 registers.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        |  8 +++++
 arch/arm64/include/asm/kvm_host.h       |  2 ++
 arch/arm64/kvm/emulate-nested.c         | 14 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 10 ++++++
 arch/arm64/kvm/nested.c                 | 36 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c               | 45 +++++++++++++++++++++++++
 6 files changed, 115 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b2adc2c6c82a..b3fb368bcadb 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -354,6 +354,14 @@
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
 
+#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
+#define __HDFGRTR2_EL2_MASK	(GENMASK(22, 22) | GENMASK(20, 0))
+#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
+
+#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
+#define __HDFGWTR2_EL2_MASK	(GENMASK(22, 19) | GENMASK(16, 7) | GENMASK(5, 0))
+#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
+
 /*
  * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
  * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7b44e96e7270..d6fbd6ebc32d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,6 +239,8 @@ enum fgt_group_id {
 	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
+	HDFGRTR2_GROUP,
+	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
 
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 54090967a335..bc5ea1e60a0a 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1724,6 +1724,9 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/* HDFGRTR2_EL2 */
+	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 1),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -1979,6 +1982,10 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
 		break;
 
+	case HDFGRTR2_GROUP:
+		sr = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
+		break;
+
 	case HAFGRTR_GROUP:
 		sr = HAFGRTR_EL2;
 		break;
@@ -2053,6 +2060,13 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
+	case HDFGRTR2_GROUP:
+		if (is_read)
+			val = __vcpu_sys_reg(vcpu, HDFGRTR2_EL2);
+		else
+			val = __vcpu_sys_reg(vcpu, HDFGWTR2_EL2);
+		break;
+
 	case HAFGRTR_GROUP:
 		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
 		break;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0c4de44534b7..b5944aa6d9c8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -89,6 +89,10 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		case HDFGWTR_EL2:					\
 			id = HDFGRTR_GROUP;				\
 			break;						\
+		case HDFGRTR2_EL2:					\
+		case HDFGWTR2_EL2:					\
+			id = HDFGRTR2_GROUP;				\
+			break;						\
 		case HAFGRTR_EL2:					\
 			id = HAFGRTR_GROUP;				\
 			break;						\
@@ -160,6 +164,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	CHECK_FGT_MASKS(HDFGWTR_EL2);
 	CHECK_FGT_MASKS(HAFGRTR_EL2);
 	CHECK_FGT_MASKS(HCRX_EL2);
+	CHECK_FGT_MASKS(HDFGRTR2_EL2);
+	CHECK_FGT_MASKS(HDFGWTR2_EL2);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
@@ -171,6 +177,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
@@ -200,6 +208,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index bae8536cbf00..ebe4e3972fed 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -384,6 +384,42 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
 	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
 
+	/* HDFG[RW]TR2_EL2 */
+	res0 = res1 = 0;
+
+	/* FEAT_TRBE_MPAM is not exposed to the guest */
+	res0 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
+
+	/* FEAT_SPE_FDS is not exposed to the guest */
+	res0 |= HDFGRTR2_EL2_nPMSDSFR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		res0 |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		res0 |= HDFGRTR2_EL2_nTRCITECR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		res0 |= (HDFGRTR2_EL2_nSPMDEVAFF_EL1 | HDFGRTR2_EL2_nSPMID |
+			 HDFGRTR2_EL2_nSPMSCR_EL1 | HDFGRTR2_EL2_nSPMACCESSR_EL1 |
+			 HDFGRTR2_EL2_nSPMCR_EL0 | HDFGRTR2_EL2_nSPMOVS |
+			 HDFGRTR2_EL2_nSPMINTEN | HDFGRTR2_EL2_nSPMSELR_EL0 |
+			 HDFGRTR2_EL2_nSPMEVTYPERn_EL0 | HDFGRTR2_EL2_nSPMEVCNTRn_EL0 |
+			 HDFGRTR2_EL2_nPMSSCR_EL1 | HDFGRTR2_EL2_nPMSSDATA);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		res0 |= HDFGRTR2_EL2_nMDSELR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
+		res0 |= HDFGRTR2_EL2_nPMUACR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		res0 |= HDFGRTR2_EL2_nPMICFILTR_EL0;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		res0 |= HDFGRTR2_EL2_nPMICNTR_EL0;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		res0 |= HDFGRTR2_EL2_nPMIAR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res0 |= HDFGRTR2_EL2_nPMECR_EL1;
+	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1);
+
 	/* Reuse the bits from the read-side and add the write-specific stuff */
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
 		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f921af014d0c..8029f408855d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4110,6 +4110,51 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
 						  HAFGRTR_EL2_RES1);
 
+	/* FEAT_TRBE_MPAM is not exposed to the guest */
+	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRBMPAM_EL1);
+
+	/* FEAT_SPE_FDS is not exposed to the guest */
+	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMSDSFR_EL1);
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nMDSTEPOP_EL1);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRCITECR_EL1);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nSPMDEVAFF_EL1		|
+						   HDFGRTR2_EL2_nSPMID			|
+						   HDFGRTR2_EL2_nSPMSCR_EL1		|
+						   HDFGRTR2_EL2_nSPMACCESSR_EL1		|
+						   HDFGRTR2_EL2_nSPMCR_EL0		|
+						   HDFGRTR2_EL2_nSPMOVS			|
+						   HDFGRTR2_EL2_nSPMINTEN		|
+						   HDFGRTR2_EL2_nSPMSELR_EL0		|
+						   HDFGRTR2_EL2_nSPMEVTYPERn_EL0	|
+						   HDFGRTR2_EL2_nSPMEVCNTRn_EL0		|
+						   HDFGRTR2_EL2_nPMSSCR_EL1		|
+						   HDFGRTR2_EL2_nPMSSDATA);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nMDSELR_EL1);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMUACR_EL1);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMICFILTR_EL0);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMICNTR_EL0);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMIAR_EL1);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMECR_EL1);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.25.1

