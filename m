Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B4A6E2A5
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647548; cv=none; b=WVcLC63OR0dTbkh09EZxPDz1ZCTKqCTCmAUybdIu7DhEe4RgqOsuccFtq+mh786ugXhB0nmWPYNcCIXUfvCif3KMiN5OICkheRs5bitEBmO6O9aFLNHLq0aNQDX+xzQ0UykXjIEDGQ0QzorULIPC6VdPjc6y7kpW++Xt2gBpEcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647548; c=relaxed/simple;
	bh=taGXR62xEtiSqFGt6bk8ioc+y5aIctquWgYkAB/idno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R4FWqhY0RZ9BXauAyqZ2S6AgbwD3jUHkqJ0CDzYN+lASoxzEnnr2tGms1or/lP9H/Pgqd2Ltiu3vbPthiS5eJxChIukAHe6RJDuIr1mcJf6QvUfNNQfI9jr3S2d4TWuCqhsz64zmzyZM9nYpICxN7uqHfIQPqU+/1Imk+8gonm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WY761QKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WY761QKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD52BC433F1;
	Tue, 30 Jan 2024 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647547;
	bh=taGXR62xEtiSqFGt6bk8ioc+y5aIctquWgYkAB/idno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WY761QKhpIIgIJMYuMrusEdc9hYdR8mHcEhcnbhGzTFHJVjl4Agwpq17z0RSYof+y
	 AmOBoTBom6/0me+VWooeTfgMqbo5YAzalLLk+lZqmucf34t5llEohqu+qrhrjwdIdd
	 5MhriZ5bsBrosjDrLVIQyCQSm/PJTPY2hY4PGDDEbiV8MYhug819fMEpagS44VoF1i
	 3K57dP+aF6waSClLuxQiPl7mGsDM+VjPXrAWf/qIfWx9cENXN+x6IcAqPXSqPlaRHM
	 lydK+52kQV01nQMBfn10A7NFDnsI1f/Go4F1X+YSq7RYkZ9fv8hPPe/v+Oej9rnOpt
	 V/Ym5WIwsARMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzJ-00GNsE-QX;
	Tue, 30 Jan 2024 20:45:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 05/25] KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
Date: Tue, 30 Jan 2024 20:45:12 +0000
Message-Id: <20240130204533.693853-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Fine Grained Traps are controlled by a whole bunch of features.
Each one of them must be checked and the corresponding masks
computed so that we don't let the guest apply traps it shouldn't
be using.

This takes care of HFGxTR_EL2, HDFGxTR_EL2, and HAFGRTR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 128 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ee461e630527..cdeef3259193 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -263,6 +263,134 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res1 |= HCR_E2H;
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
 
+	/* HFG[RW]TR_EL2 */
+	res0 = res1 = 0;
+	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
+	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
+		res0 |= (HFGxTR_EL2_APDAKey | HFGxTR_EL2_APDBKey |
+			 HFGxTR_EL2_APGAKey | HFGxTR_EL2_APIAKey |
+			 HFGxTR_EL2_APIBKey);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
+		res0 |= (HFGxTR_EL2_LORC_EL1 | HFGxTR_EL2_LOREA_EL1 |
+			 HFGxTR_EL2_LORID_EL1 | HFGxTR_EL2_LORN_EL1 |
+			 HFGxTR_EL2_LORSA_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
+	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
+		res0 |= (HFGxTR_EL2_SCXTNUM_EL1 | HFGxTR_EL2_SCXTNUM_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP))
+		res0 |= HFGxTR_EL2_ICC_IGRPENn_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
+		res0 |= (HFGxTR_EL2_ERRIDR_EL1 | HFGxTR_EL2_ERRSELR_EL1 |
+			 HFGxTR_EL2_ERXFR_EL1 | HFGxTR_EL2_ERXCTLR_EL1 |
+			 HFGxTR_EL2_ERXSTATUS_EL1 | HFGxTR_EL2_ERXMISCn_EL1 |
+			 HFGxTR_EL2_ERXPFGF_EL1 | HFGxTR_EL2_ERXPFGCTL_EL1 |
+			 HFGxTR_EL2_ERXPFGCDN_EL1 | HFGxTR_EL2_ERXADDR_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		res0 |= HFGxTR_EL2_nACCDATA_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
+		res0 |= (HFGxTR_EL2_nGCS_EL0 | HFGxTR_EL2_nGCS_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
+		res0 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
+		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+		res0 |= HFGxTR_EL2_nS2POR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
+		res0 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
+	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
+
+	/* HDFG[RW]TR_EL2 */
+	res0 = res1 = 0;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
+		res0 |= HDFGRTR_EL2_OSDLR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
+		res0 |= (HDFGRTR_EL2_PMEVCNTRn_EL0 | HDFGRTR_EL2_PMEVTYPERn_EL0 |
+			 HDFGRTR_EL2_PMCCFILTR_EL0 | HDFGRTR_EL2_PMCCNTR_EL0 |
+			 HDFGRTR_EL2_PMCNTEN | HDFGRTR_EL2_PMINTEN |
+			 HDFGRTR_EL2_PMOVS | HDFGRTR_EL2_PMSELR_EL0 |
+			 HDFGRTR_EL2_PMMIR_EL1 | HDFGRTR_EL2_PMUSERENR_EL0 |
+			 HDFGRTR_EL2_PMCEIDn_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
+		res0 |= (HDFGRTR_EL2_PMBLIMITR_EL1 | HDFGRTR_EL2_PMBPTR_EL1 |
+			 HDFGRTR_EL2_PMBSR_EL1 | HDFGRTR_EL2_PMSCR_EL1 |
+			 HDFGRTR_EL2_PMSEVFR_EL1 | HDFGRTR_EL2_PMSFCR_EL1 |
+			 HDFGRTR_EL2_PMSICR_EL1 | HDFGRTR_EL2_PMSIDR_EL1 |
+			 HDFGRTR_EL2_PMSIRR_EL1 | HDFGRTR_EL2_PMSLATFR_EL1 |
+			 HDFGRTR_EL2_PMBIDR_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
+		res0 |= (HDFGRTR_EL2_TRC | HDFGRTR_EL2_TRCAUTHSTATUS |
+			 HDFGRTR_EL2_TRCAUXCTLR | HDFGRTR_EL2_TRCCLAIM |
+			 HDFGRTR_EL2_TRCCNTVRn | HDFGRTR_EL2_TRCID |
+			 HDFGRTR_EL2_TRCIMSPECn | HDFGRTR_EL2_TRCOSLSR |
+			 HDFGRTR_EL2_TRCPRGCTLR | HDFGRTR_EL2_TRCSEQSTR |
+			 HDFGRTR_EL2_TRCSSCSRn | HDFGRTR_EL2_TRCSTATR |
+			 HDFGRTR_EL2_TRCVICTLR);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
+		res0 |= (HDFGRTR_EL2_TRBBASER_EL1 | HDFGRTR_EL2_TRBIDR_EL1 |
+			 HDFGRTR_EL2_TRBLIMITR_EL1 | HDFGRTR_EL2_TRBMAR_EL1 |
+			 HDFGRTR_EL2_TRBPTR_EL1 | HDFGRTR_EL2_TRBSR_EL1 |
+			 HDFGRTR_EL2_TRBTRG_EL1);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
+		res0 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
+			 HDFGRTR_EL2_nBRBDATA);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
+		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
+	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
+
+	/* Reuse the bits from the read-side and add the write-specific stuff */
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
+		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
+		res0 |= HDFGWTR_EL2_TRCOSLAR;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
+		res0 |= HDFGWTR_EL2_TRFCR_EL1;
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | HDFGWTR_EL2_RES0, res1);
+
+	/* HFGITR_EL2 */
+	res0 = HFGITR_EL2_RES0;
+	res1 = HFGITR_EL2_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
+		res0 |= HFGITR_EL2_DCCVADP;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
+		res0 |= (HFGITR_EL2_ATS1E1RP | HFGITR_EL2_ATS1E1WP);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		res0 |= (HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
+			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS |
+			 HFGITR_EL2_TLBIVAALE1OS | HFGITR_EL2_TLBIVALE1OS |
+			 HFGITR_EL2_TLBIVAAE1OS | HFGITR_EL2_TLBIASIDE1OS |
+			 HFGITR_EL2_TLBIVAE1OS | HFGITR_EL2_TLBIVMALLE1OS);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		res0 |= (HFGITR_EL2_TLBIRVAALE1 | HFGITR_EL2_TLBIRVALE1 |
+			 HFGITR_EL2_TLBIRVAAE1 | HFGITR_EL2_TLBIRVAE1 |
+			 HFGITR_EL2_TLBIRVAALE1IS | HFGITR_EL2_TLBIRVALE1IS |
+			 HFGITR_EL2_TLBIRVAAE1IS | HFGITR_EL2_TLBIRVAE1IS |
+			 HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
+			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, IMP))
+		res0 |= (HFGITR_EL2_CFPRCTX | HFGITR_EL2_DVPRCTX |
+			 HFGITR_EL2_CPPRCTX);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
+		res0 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
+		res0 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
+			 HFGITR_EL2_nGCSEPP);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX))
+		res0 |= HFGITR_EL2_COSPRCTX;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
+		res0 |= HFGITR_EL2_ATS1E1A;
+	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
+
+	/* HAFGRTR_EL2 - not a lot to see here*/
+	res0 = HAFGRTR_EL2_RES0;
+	res1 = HAFGRTR_EL2_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
+		res0 |= ~(res0 | res1);
+	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.39.2

