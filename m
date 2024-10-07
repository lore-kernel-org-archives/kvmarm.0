Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F121DDA06
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323194; cv=none; b=qS3RPO1EkkqPS8noiJ2pA0/m7/G9xyGhG9PWd85mvMWbmhqH11ZCNrFPdOD6K0x2der2Kqm4BksRuUXIc1jPPuMc11B+JzTs4SYqpw8SZNmEyOS3xNQxZpXoZop/J2s10imIaCPyoxTiycO6Wbt94kmALsJGrOqYLy4KWkkiDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323194; c=relaxed/simple;
	bh=wg47OHGiy+eqcFPR4XqFcPqRQgplzynT2Qg2BIxhBY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+plwG3UhxFKpvLagTOALX3fKKpBZfkNxEKGaz7S3SvC2Xbxh4+OReULJSFGNDPun6QkvicHwQ5f7UKk/hFuC6amq3VoA8hhaC3M2flusMjPvvYWSlc+ox99IurFt+svIKzZUnnnRhRzeESf30KqHIAZfEZMKxVzXOuWslZW0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KposFP1m; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KposFP1m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ae+ScB+umMzruaYBwWVrUDMEyF+lC0TJXmeKCkOMrug=;
	b=KposFP1mZm6DkR++gM52nOwyt4KM3lWdmSzpwKhr3AsajbDaFO4+0JT4nOt8TTBzRQT7Ym
	OCtFmP8G1uyOBJUmuKoFVsfz7xoVdaLVA0JjMGnvFYmyFqupJf4dBm+V7Pz7r+mh3eenfl
	VCJvjHOtqutOUTlfZcdxX6Zy+iFxGC0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 09/17] KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
Date: Mon,  7 Oct 2024 17:45:51 +0000
Message-ID: <20241007174559.1830205-10-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

MDCR_EL2.HPMN splits the PMU event counters into two ranges: the first
range is accessible from all ELs, and the second range is accessible
only to EL2/3. Supposing the guest hypervisor allows direct access to
the PMU counters from the L2, KVM needs to locally handle those
accesses.

Add a new complex trap configuration for HPMN that checks if the counter
index is accessible to the current context. As written, the architecture
suggests HPMN only causes PMEVCNTR<n>_EL0 to trap, though intuition (and
the pseudocode) suggest that the trap applies to PMEVTYPER<n>_EL0 as
well.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 167 ++++++++++++++++++++------------
 arch/arm64/kvm/pmu-emul.c       |  11 +++
 include/kvm/arm_pmu.h           |   6 ++
 3 files changed, 120 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f9594296d69c..2d7a8b1f40fa 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -110,6 +110,7 @@ enum cgt_group_id {
 	CGT_HCR_TPU_TOCU,
 	CGT_HCR_NV1_nNV2_ENSCXT,
 	CGT_MDCR_TPM_TPMCR,
+	CGT_MDCR_TPM_HPMN,
 	CGT_MDCR_TDE_TDA,
 	CGT_MDCR_TDE_TDOSA,
 	CGT_MDCR_TDE_TDRA,
@@ -126,6 +127,7 @@ enum cgt_group_id {
 	CGT_CNTHCTL_EL1PTEN,
 
 	CGT_CPTR_TTA,
+	CGT_MDCR_HPMN,
 
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
@@ -441,6 +443,7 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
 	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
 	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
+	MCB(CGT_MDCR_TPM_HPMN,		CGT_MDCR_TPM, CGT_MDCR_HPMN),
 	MCB(CGT_MDCR_TDE_TDA,		CGT_MDCR_TDE, CGT_MDCR_TDA),
 	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
 	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
@@ -504,6 +507,41 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 	return BEHAVE_HANDLE_LOCALLY;
 }
 
+static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	unsigned int idx;
+
+
+	switch (sysreg) {
+	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
+	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
+		idx = (sys_reg_CRm(sysreg) & 0x3) << 3 | sys_reg_Op2(sysreg);
+		break;
+	case SYS_PMXEVTYPER_EL0:
+	case SYS_PMXEVCNTR_EL0:
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
+				    __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		break;
+	default:
+		/* Someone used this trap helper for something else... */
+		KVM_BUG_ON(1, vcpu->kvm);
+		return BEHAVE_HANDLE_LOCALLY;
+	}
+
+	/*
+	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
+	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
+	 * depend on hardware (all PMU registers are trapped), make the
+	 * implementation choice that all counters are included in the second
+	 * range reserved for EL2/EL3.
+	 */
+	if (kvm_pmu_counter_is_hyp(vcpu, idx))
+		return BEHAVE_FORWARD_RW | BEHAVE_IN_HOST_EL0;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -511,6 +549,7 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
+	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
 };
 
 /*
@@ -925,77 +964,77 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMOVSCLR_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMCEID0_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMCEID1_EL0,	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMXEVTYPER_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMXEVTYPER_EL0,	CGT_MDCR_TPM_HPMN),
 	SR_TRAP(SYS_PMSWINC_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMSELR_EL0,		CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMXEVCNTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMXEVCNTR_EL0,	CGT_MDCR_TPM_HPMN),
 	SR_TRAP(SYS_PMCCNTR_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMUSERENR_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMINTENSET_EL1,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMINTENCLR_EL1,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_PMMIR_EL1,		CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(0),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(1),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(2),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(3),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(4),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(5),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(6),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(7),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(8),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(9),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(10),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(11),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(12),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(13),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(14),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(15),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(16),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(17),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(18),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(19),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(20),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(21),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(22),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(23),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(24),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(25),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(26),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(27),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(28),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(29),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVCNTRn_EL0(30),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(0),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(1),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(2),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(3),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(4),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(5),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(6),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(7),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(8),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(9),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(10),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(11),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(12),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(13),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(14),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(15),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(16),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(17),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(18),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(19),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(20),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(21),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(22),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(23),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(24),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(25),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(26),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(27),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(28),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(29),	CGT_MDCR_TPM),
-	SR_TRAP(SYS_PMEVTYPERn_EL0(30),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(0),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(1),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(2),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(3),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(4),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(5),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(6),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(7),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(8),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(9),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(10),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(11),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(12),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(13),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(14),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(15),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(16),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(17),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(18),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(19),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(20),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(21),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(22),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(23),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(24),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(25),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(26),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(27),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(28),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(29),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(30),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(0),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(1),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(2),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(3),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(4),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(5),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(6),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(7),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(8),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(9),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(10),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(11),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(12),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(13),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(14),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(15),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(16),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(17),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(18),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(19),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(20),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(21),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(22),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(23),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(24),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(25),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(26),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(27),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(28),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(29),	CGT_MDCR_TPM_HPMN),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(30),	CGT_MDCR_TPM_HPMN),
 	SR_TRAP(SYS_PMCCFILTR_EL0,	CGT_MDCR_TPM),
 	SR_TRAP(SYS_MDCCSR_EL0,		CGT_MDCR_TDCC_TDE_TDA),
 	SR_TRAP(SYS_MDCCINT_EL1,	CGT_MDCR_TDCC_TDE_TDA),
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ac36c438b8c1..937405e8dbec 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -265,6 +265,17 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	unsigned int hpmn;
+
+	if (!vcpu_has_nv(vcpu) || idx == ARMV8_PMU_CYCLE_IDX)
+		return false;
+
+	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	return idx >= hpmn;
+}
+
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e08aeec5d936..e6103df9ef5d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,7 @@ int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
 #else
 struct kvm_pmu {
 };
@@ -187,6 +188,11 @@ static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif
 
 #endif
-- 
2.47.0.rc0.187.ge670bccf7e-goog

