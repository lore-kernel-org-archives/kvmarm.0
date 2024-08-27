Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA61802
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718187; cv=none; b=r5/eKByHscGj6/bCi0TNN3Z2uDykhJP+NG5FNaxQ0XmS/aeGrIMNxx9HeWDRen4Og2PI+FuDpJ1oG/nhg6SSgd4xRiqXm5Pwvu/KlwuV2X5UsQNMTDIaT/qxRb3sOiZf0gRy2ANlpjzl2egsdFq67eBafNa98ANTyqbnL7LPAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718187; c=relaxed/simple;
	bh=6Z4+nytjOBplphjyE4HRR8cNdFydMUDXkyLjfOifN1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2rv5Apr6EXdIvIAU0z+lJlM5ORaJ2gMiyRR9VXkWVDppHg6FkjIBObG+Jq8Viv1JC7I+9c34ANsJrOjnmV1xBGpjiqUrCjZkoMOb2aGSeUO9lpbLRvvPWqAX3s874EyND2oyvW5KTe4sprQFLt6cnEl/c9kw5ZPWu6bI0tsyRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bkn8ZKrR; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bkn8ZKrR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BYA2q8rwGkohokj+XUvPIp3aiOZwBDqxdsN8T584c4E=;
	b=Bkn8ZKrR9GVO+mkCVJlZnBhI1EkEjfSy8CxqSoRW+viYxnWri/Zo9O6WqUHADZ8Uc5AQDn
	4eWSAG6GGQk8ElsNfkbsTxglboHJrTKgviF5Em5oSDatmzFzaLoD0SQw8BGIjmhpvJ9nMN
	AFhLSqw7VjtblxZCpBqTSPJRxfsbTSI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 08/12] KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
Date: Tue, 27 Aug 2024 00:22:31 +0000
Message-ID: <20240827002235.1753237-9-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/emulate-nested.c | 165 +++++++++++++++++++-------------
 1 file changed, 101 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index afc1e2a0e308..ae183dea79b7 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -104,6 +104,7 @@ enum cgt_group_id {
 	CGT_HCR_TPU_TOCU,
 	CGT_HCR_NV1_nNV2_ENSCXT,
 	CGT_MDCR_TPM_TPMCR,
+	CGT_MDCR_TPM_HPMN,
 	CGT_MDCR_TDE_TDA,
 	CGT_MDCR_TDE_TDOSA,
 	CGT_MDCR_TDE_TDRA,
@@ -118,6 +119,7 @@ enum cgt_group_id {
 	CGT_CNTHCTL_EL1PTEN,
 
 	CGT_CPTR_TTA,
+	CGT_MDCR_HPMN,
 
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
@@ -404,6 +406,7 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
 	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
 	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
+	MCB(CGT_MDCR_TPM_HPMN,		CGT_MDCR_TPM, CGT_MDCR_HPMN),
 	MCB(CGT_MDCR_TDE_TDA,		CGT_MDCR_TDE, CGT_MDCR_TDA),
 	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
 	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
@@ -464,6 +467,39 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 	return BEHAVE_HANDLE_LOCALLY;
 }
 
+static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
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
+		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
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
+	return !(BIT(idx) & mask) ? (BEHAVE_FORWARD_RW | BEHAVE_IN_HOST_EL0) :
+			BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -471,6 +507,7 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
+	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
 };
 
 /*
@@ -885,77 +922,77 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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
-- 
2.46.0.295.g3b9ea8a38a-goog

