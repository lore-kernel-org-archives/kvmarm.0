Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BE01AD9DD
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750834; cv=none; b=ofQ3eMb8bTIUIEcqjpelSeTVrLMT4uP248PdpVomCtfq04bYZ9GKw3GotYRxD0z/7XA/FXib8isoK1GMZyshL093VppUwmUdRvYyxrw4Qz5KyzUIzXcJC3shyY4iQXsxmW8bwS/JalnUkTDNrxfOEuQ02UoJ/6jsQdZQzY9XZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750834; c=relaxed/simple;
	bh=Ei3DxqlT3jREz9xxE3O0Y4ZXLaO4De/GmBWbRemKh44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DoLFOnskkrz/yAHa01Y9Ya1/F0iPWpiXA4NbINIC4TSdFJZXfCIqXXlssDIQDGPpJV84g7M8u9ToFXC3F+CSwbJh5wOOF8hq3AGdLswllmQt1cpfwa92WJ5S6oMfuCPw3wg3okVK9Ph9gtGSLm5qVV0CIXQ/H2kTMQWJ5/r5uxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB1B9367;
	Mon, 30 Sep 2024 19:47:41 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C37EC3F58B;
	Mon, 30 Sep 2024 19:47:08 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 47/47] KVM: arm64: nv: Add trap forwarding for FEAT_FGT2 described registers
Date: Tue,  1 Oct 2024 08:13:56 +0530
Message-Id: <20241001024356.1096072-48-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe remaining MDCR_EL2 register, and associate that with all FEAT_FGT2
exposed system registers it allows to trap.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h  |   2 +
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/emulate-nested.c   | 262 ++++++++++++++++++++++++++++++
 3 files changed, 266 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 449bccffd529..850fac9a7840 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -323,6 +323,7 @@
 #define MDCR_EL2_TTRF		(UL(1) << 19)
 #define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
+#define MDCR_EL2_EnSPM		(UL(1) << 15)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
 #define MDCR_EL2_TDRA		(UL(1) << 11)
@@ -333,6 +334,7 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_HPMN_SHIFT	(UL(0))
 #define MDCR_EL2_RES0		(GENMASK(63, 37) |	\
 				 GENMASK(35, 30) |	\
 				 GENMASK(25, 24) |	\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ca98f6d810c2..802ad88235af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -433,6 +433,7 @@ enum vcpu_sysreg {
 	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
 	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
 	PMUSERENR_EL0,	/* User Enable Register */
+	SPMSELR_EL0,	/* System PMU Select Register */
 
 	/* Pointer Authentication Registers in a strict increasing order. */
 	APIAKEYLO_EL1,
@@ -491,6 +492,7 @@ enum vcpu_sysreg {
 	CNTHP_CVAL_EL2,
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
+	SPMACCESSR_EL2, /* System PMU Access Register */
 
 	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f22a5f10ffe5..d66722c71b45 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -75,6 +75,7 @@ enum cgt_group_id {
 	CGT_MDCR_TDRA,
 	CGT_MDCR_E2PB,
 	CGT_MDCR_TPMS,
+	CGT_MDCR_EnSPM,
 	CGT_MDCR_TTRF,
 	CGT_MDCR_E2TB,
 	CGT_MDCR_TDCC,
@@ -120,6 +121,38 @@ enum cgt_group_id {
 	__COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PTEN,
+	CGT_SPMSEL_SPMACCESS,
+	CGT_CNTR_ACCESSIBLE_0,
+	CGT_CNTR_ACCESSIBLE_1,
+	CGT_CNTR_ACCESSIBLE_2,
+	CGT_CNTR_ACCESSIBLE_3,
+	CGT_CNTR_ACCESSIBLE_4,
+	CGT_CNTR_ACCESSIBLE_5,
+	CGT_CNTR_ACCESSIBLE_6,
+	CGT_CNTR_ACCESSIBLE_7,
+	CGT_CNTR_ACCESSIBLE_8,
+	CGT_CNTR_ACCESSIBLE_9,
+	CGT_CNTR_ACCESSIBLE_10,
+	CGT_CNTR_ACCESSIBLE_11,
+	CGT_CNTR_ACCESSIBLE_12,
+	CGT_CNTR_ACCESSIBLE_13,
+	CGT_CNTR_ACCESSIBLE_14,
+	CGT_CNTR_ACCESSIBLE_15,
+	CGT_CNTR_ACCESSIBLE_16,
+	CGT_CNTR_ACCESSIBLE_17,
+	CGT_CNTR_ACCESSIBLE_18,
+	CGT_CNTR_ACCESSIBLE_19,
+	CGT_CNTR_ACCESSIBLE_20,
+	CGT_CNTR_ACCESSIBLE_21,
+	CGT_CNTR_ACCESSIBLE_22,
+	CGT_CNTR_ACCESSIBLE_23,
+	CGT_CNTR_ACCESSIBLE_24,
+	CGT_CNTR_ACCESSIBLE_25,
+	CGT_CNTR_ACCESSIBLE_26,
+	CGT_CNTR_ACCESSIBLE_27,
+	CGT_CNTR_ACCESSIBLE_28,
+	CGT_CNTR_ACCESSIBLE_29,
+	CGT_CNTR_ACCESSIBLE_30,
 
 	CGT_CPTR_TTA,
 
@@ -344,6 +377,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= MDCR_EL2_TPMS,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_MDCR_EnSPM] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_EnSPM,
+		.mask		= MDCR_EL2_EnSPM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 	[CGT_MDCR_TTRF] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TTRF,
@@ -498,6 +537,65 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 	return BEHAVE_HANDLE_LOCALLY;
 }
 
+static enum trap_behaviour check_spmsel_spmaccess(struct kvm_vcpu *vcpu)
+{
+	u64 spmaccessr_el2, spmselr_el2;
+	int syspmusel;
+
+	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_EnSPM) {
+		spmselr_el2 = __vcpu_sys_reg(vcpu, SPMSELR_EL0);
+		spmaccessr_el2 = __vcpu_sys_reg(vcpu, SPMACCESSR_EL2);
+		syspmusel = FIELD_GET(SPMSELR_EL0_SYSPMUSEL_MASK, spmselr_el2);
+
+		if (((spmaccessr_el2 >> (syspmusel * 2)) & 0x3) == 0x0)
+			return BEHAVE_FORWARD_ANY;
+	}
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
+#define check_cntr_accessible(num)						\
+static enum trap_behaviour check_cntr_accessible_##num(struct kvm_vcpu *vcpu)	\
+{										\
+	u64 mdcr_el2 = __vcpu_sys_reg(vcpu, MDCR_EL2);				\
+	int cntr = FIELD_GET(MDCR_EL2_HPMN_MASK, mdcr_el2);			\
+										\
+	if (num >= cntr)							\
+		return BEHAVE_FORWARD_ANY;					\
+	return BEHAVE_HANDLE_LOCALLY;						\
+}										\
+
+check_cntr_accessible(0)
+check_cntr_accessible(1)
+check_cntr_accessible(2)
+check_cntr_accessible(3)
+check_cntr_accessible(4)
+check_cntr_accessible(5)
+check_cntr_accessible(6)
+check_cntr_accessible(7)
+check_cntr_accessible(8)
+check_cntr_accessible(9)
+check_cntr_accessible(10)
+check_cntr_accessible(11)
+check_cntr_accessible(12)
+check_cntr_accessible(13)
+check_cntr_accessible(14)
+check_cntr_accessible(15)
+check_cntr_accessible(16)
+check_cntr_accessible(17)
+check_cntr_accessible(18)
+check_cntr_accessible(19)
+check_cntr_accessible(20)
+check_cntr_accessible(21)
+check_cntr_accessible(22)
+check_cntr_accessible(23)
+check_cntr_accessible(24)
+check_cntr_accessible(25)
+check_cntr_accessible(26)
+check_cntr_accessible(27)
+check_cntr_accessible(28)
+check_cntr_accessible(29)
+check_cntr_accessible(30)
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -505,6 +603,38 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
+	CCC(CGT_SPMSEL_SPMACCESS, check_spmsel_spmaccess),
+	CCC(CGT_CNTR_ACCESSIBLE_0, check_cntr_accessible_0),
+	CCC(CGT_CNTR_ACCESSIBLE_1, check_cntr_accessible_1),
+	CCC(CGT_CNTR_ACCESSIBLE_2, check_cntr_accessible_2),
+	CCC(CGT_CNTR_ACCESSIBLE_3, check_cntr_accessible_3),
+	CCC(CGT_CNTR_ACCESSIBLE_4, check_cntr_accessible_4),
+	CCC(CGT_CNTR_ACCESSIBLE_5, check_cntr_accessible_5),
+	CCC(CGT_CNTR_ACCESSIBLE_6, check_cntr_accessible_6),
+	CCC(CGT_CNTR_ACCESSIBLE_7, check_cntr_accessible_7),
+	CCC(CGT_CNTR_ACCESSIBLE_8, check_cntr_accessible_8),
+	CCC(CGT_CNTR_ACCESSIBLE_9, check_cntr_accessible_9),
+	CCC(CGT_CNTR_ACCESSIBLE_10, check_cntr_accessible_10),
+	CCC(CGT_CNTR_ACCESSIBLE_11, check_cntr_accessible_11),
+	CCC(CGT_CNTR_ACCESSIBLE_12, check_cntr_accessible_12),
+	CCC(CGT_CNTR_ACCESSIBLE_13, check_cntr_accessible_13),
+	CCC(CGT_CNTR_ACCESSIBLE_14, check_cntr_accessible_14),
+	CCC(CGT_CNTR_ACCESSIBLE_15, check_cntr_accessible_15),
+	CCC(CGT_CNTR_ACCESSIBLE_16, check_cntr_accessible_16),
+	CCC(CGT_CNTR_ACCESSIBLE_17, check_cntr_accessible_17),
+	CCC(CGT_CNTR_ACCESSIBLE_18, check_cntr_accessible_18),
+	CCC(CGT_CNTR_ACCESSIBLE_19, check_cntr_accessible_19),
+	CCC(CGT_CNTR_ACCESSIBLE_20, check_cntr_accessible_20),
+	CCC(CGT_CNTR_ACCESSIBLE_21, check_cntr_accessible_21),
+	CCC(CGT_CNTR_ACCESSIBLE_22, check_cntr_accessible_22),
+	CCC(CGT_CNTR_ACCESSIBLE_23, check_cntr_accessible_23),
+	CCC(CGT_CNTR_ACCESSIBLE_24, check_cntr_accessible_24),
+	CCC(CGT_CNTR_ACCESSIBLE_25, check_cntr_accessible_25),
+	CCC(CGT_CNTR_ACCESSIBLE_26, check_cntr_accessible_26),
+	CCC(CGT_CNTR_ACCESSIBLE_27, check_cntr_accessible_27),
+	CCC(CGT_CNTR_ACCESSIBLE_28, check_cntr_accessible_28),
+	CCC(CGT_CNTR_ACCESSIBLE_29, check_cntr_accessible_29),
+	CCC(CGT_CNTR_ACCESSIBLE_30, check_cntr_accessible_30),
 };
 
 /*
@@ -912,6 +1042,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_ERXPFGF_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_nFIEN),
 	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_nFIEN),
+
 	SR_TRAP(SYS_PMCR_EL0,		CGT_MDCR_TPM_TPMCR),
 	SR_TRAP(SYS_PMCNTENSET_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMCNTENCLR_EL0,	CGT_MDCR_TPM),
@@ -1085,6 +1216,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+
 	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
 	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
@@ -1092,6 +1224,136 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
+
+	SR_TRAP(SYS_MDSTEPOP_EL1,	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_TRBMPAM_EL1,	CGT_MDCR_E2TB),
+	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
+
+	SR_TRAP(SYS_SPMDEVAFF_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMCGCR0_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMCGCR1_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMIIDR_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMDEVARCH_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMCFGR_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMSCR_EL1,		CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMACCESSR_EL1,	CGT_MDCR_EnSPM),
+	SR_TRAP(SYS_SPMCR_EL0,		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMOVSCLR_EL0,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMOVSSET_EL0,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMINTENCLR_EL1,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMINTENSET_EL1,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMCNTENCLR_EL0,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMCNTENSET_EL0,	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMSELR_EL0,	CGT_MDCR_EnSPM),
+
+	SR_TRAP(SYS_SPMEVTYPER_EL0(0),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(1),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(2),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(3),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(4),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(5),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(6),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(7),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(8),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(9),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(10),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(11),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(12),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(13),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(14),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVTYPER_EL0(15),	CGT_SPMSEL_SPMACCESS),
+
+	SR_TRAP(SYS_SPMEVFILTR_EL0(0),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(1),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(2),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(3),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(4),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(5),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(6),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(7),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(8),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(9),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(10), CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(11),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(12),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(13),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(14),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILTR_EL0(15),	CGT_SPMSEL_SPMACCESS),
+
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(0),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(1),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(2),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(3),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(4),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(5),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(6),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(7),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(8),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(9),		CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(10),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(11),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(12),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(13),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(14),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVFILT2R_EL0(15),	CGT_SPMSEL_SPMACCESS),
+
+	SR_TRAP(SYS_SPMEVCNTR_EL0(0),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(1),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(2),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(3),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(4),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(5),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(6),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(7),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(8),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(9),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(10),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(11),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(12),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(13),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(14),	CGT_SPMSEL_SPMACCESS),
+	SR_TRAP(SYS_SPMEVCNTR_EL0(15),	CGT_SPMSEL_SPMACCESS),
+
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(0),	CGT_CNTR_ACCESSIBLE_0),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(1),	CGT_CNTR_ACCESSIBLE_1),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(2),	CGT_CNTR_ACCESSIBLE_2),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(3),	CGT_CNTR_ACCESSIBLE_3),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(4),  CGT_CNTR_ACCESSIBLE_4),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(5),	CGT_CNTR_ACCESSIBLE_5),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(6),	CGT_CNTR_ACCESSIBLE_6),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(7),	CGT_CNTR_ACCESSIBLE_7),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(8),	CGT_CNTR_ACCESSIBLE_8),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(9),	CGT_CNTR_ACCESSIBLE_9),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(10),	CGT_CNTR_ACCESSIBLE_10),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(11),	CGT_CNTR_ACCESSIBLE_11),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(12),	CGT_CNTR_ACCESSIBLE_12),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(13),	CGT_CNTR_ACCESSIBLE_13),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(14),	CGT_CNTR_ACCESSIBLE_14),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(15),	CGT_CNTR_ACCESSIBLE_15),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(16),	CGT_CNTR_ACCESSIBLE_16),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(17),	CGT_CNTR_ACCESSIBLE_17),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(18),	CGT_CNTR_ACCESSIBLE_18),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(19),	CGT_CNTR_ACCESSIBLE_19),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(20),	CGT_CNTR_ACCESSIBLE_20),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(21),	CGT_CNTR_ACCESSIBLE_21),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(22),	CGT_CNTR_ACCESSIBLE_22),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(23),	CGT_CNTR_ACCESSIBLE_23),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(24),	CGT_CNTR_ACCESSIBLE_24),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(25),	CGT_CNTR_ACCESSIBLE_25),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(26),	CGT_CNTR_ACCESSIBLE_26),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(27),	CGT_CNTR_ACCESSIBLE_27),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(28),	CGT_CNTR_ACCESSIBLE_28),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(29),	CGT_CNTR_ACCESSIBLE_29),
+	SR_TRAP(SYS_PMEVCNTSVR_EL1(30),	CGT_CNTR_ACCESSIBLE_30),
+
+	SR_TRAP(SYS_MDSELR_EL1,		CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_PMUACR_EL1,		CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMICFILTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMICNTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMIAR_EL1,		CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMECR_EL1,		CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMZR_EL0,		CGT_MDCR_TPM),
+
 	SR_TRAP(SYS_CPACR_EL1,		CGT_CPTR_TCPAC),
 	SR_TRAP(SYS_AMUSERENR_EL0,	CGT_CPTR_TAM),
 	SR_TRAP(SYS_AMCFGR_EL0,		CGT_CPTR_TAM),
-- 
2.25.1

