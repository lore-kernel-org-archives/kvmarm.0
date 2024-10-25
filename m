Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FBC214416
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880673; cv=none; b=CE5UfhQjdRiz7R9Mh6uvmfA5BeRrGpvQochwlXpgZegIenQyTXYjdwBXFiv/cQyxcuqHCtIeGQoJ9j0U+0wJlq92dqCaHMJY91g+s8/xuIe8Irx0qfoBJVos93fHi0xNYQ/9TwfQ8QgUMfRJkGBZcRDNfywz/dxKZBJ6RnM3YXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880673; c=relaxed/simple;
	bh=ltX2mgpEB6IEDsXh/X1u+xWVkggWg+VB8D07XKoYAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV7eTec38J67m+am811UxXnodsnu/deVVeUha3jyrlpJbwXjWd3HgYCgyyFgIN0uYJxzvYmSRmfBg/2aqTvznFvO01q1P1wB6zHk/C9YVj22O+IkZQQxR+4IpTvhd9q0jjHIgqKwVk/Nlqb1Na2rQy/RFg19B2APjuWVMUjHEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xTAYKlCE; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xTAYKlCE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03U+X0r3TsTKJK2hDl3YaYsZRpw044pn5Clu5ZhImjs=;
	b=xTAYKlCEg66jYYufMomKCrzMyj9DQx9Do6a7sgFexgRLn5UmntQdu9B+2JAyu980NkxTTF
	JT/yeQlixu926B6luxvxCjKWN9BRkYg1BNVVMCX1M9rjyjBjnQpj5BuvHCqUpCqlaZ4n5k
	UspkUBXMQd3g1CUSXuymWm9DzO3CuJ0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 10/18] KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
Date: Fri, 25 Oct 2024 18:23:45 +0000
Message-ID: <20241025182354.3364124-11-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/emulate-nested.c | 160 +++++++++++++++++++-------------
 arch/arm64/kvm/pmu-emul.c       |  18 ++++
 include/kvm/arm_pmu.h           |   6 ++
 3 files changed, 120 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f9594296d69c..162bddbfbe79 100644
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
@@ -504,6 +507,34 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
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
+	if (kvm_pmu_counter_is_hyp(vcpu, idx))
+		return BEHAVE_FORWARD_RW | BEHAVE_IN_HOST_EL0;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -511,6 +542,7 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
+	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
 };
 
 /*
@@ -925,77 +957,77 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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
index ac36c438b8c1..28f938f145ac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -265,6 +265,24 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	unsigned int hpmn;
+
+	if (!vcpu_has_nv(vcpu) || idx == ARMV8_PMU_CYCLE_IDX)
+		return false;
+
+	/*
+	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
+	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
+	 * depend on hardware (all PMU registers are trapped), make the
+	 * implementation choice that all counters are included in the second
+	 * range reserved for EL2/EL3.
+	 */
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
2.47.0.163.g1226f6d8fa-goog

