Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87302B9AC
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706798293; cv=none; b=cz3BnIsfGDn5TvzR93Qszm2kf80jw+3KPFW1LfR0adezQJLUpx7rIGoRt+yV6p+mhZ3L0Xs5/nA4xhjhiKxL/7oL8CddC9J8/VR+QY+jbNMGBtxgkNdaD1D3W3Iw+wG20Z7lokuMN4d9wKiO4gvQuZsxQxieP+fDJRqQqg7SQAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706798293; c=relaxed/simple;
	bh=ltd+rAc4NbcBxxQVqq5zqXdz5QhNfPtIt4c3vu/8XRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN7hP+z7afD4te6/Yqke10pGfUEFnyxGM2VfEpPESoiaxSvYQcR7AIibtAVBlFxc3xb1pn/whhfs92WXWGpQdqZxxWMu891bD1yP+025sL3OaNr/kbC9cSGyelXAxru+vKeC0MoyJQlxSn/11SHNz2zV04H/GtA1gu+EVcP6ZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0E25DA7;
	Thu,  1 Feb 2024 06:38:52 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B3C3F762;
	Thu,  1 Feb 2024 06:38:08 -0800 (PST)
Date: Thu, 1 Feb 2024 14:38:06 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 05/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 FGT sysregs
Message-ID: <20240201143806.GG2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-6-maz@kernel.org>

On Tue, Jan 30, 2024 at 08:45:12PM +0000, Marc Zyngier wrote:
> Fine Grained Traps are controlled by a whole bunch of features.
> Each one of them must be checked and the corresponding masks
> computed so that we don't let the guest apply traps it shouldn't
> be using.
> 
> This takes care of HFGxTR_EL2, HDFGxTR_EL2, and HAFGRTR_EL2.

 ^^ and HFGITR_EL2

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 128 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index ee461e630527..cdeef3259193 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -263,6 +263,134 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  		res1 |= HCR_E2H;
>  	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
>  
> +	/* HFG[RW]TR_EL2 */
> +	res0 = res1 = 0;
> +	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> +	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
> +		res0 |= (HFGxTR_EL2_APDAKey | HFGxTR_EL2_APDBKey |
> +			 HFGxTR_EL2_APGAKey | HFGxTR_EL2_APIAKey |
> +			 HFGxTR_EL2_APIBKey);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> +		res0 |= (HFGxTR_EL2_LORC_EL1 | HFGxTR_EL2_LOREA_EL1 |
> +			 HFGxTR_EL2_LORID_EL1 | HFGxTR_EL2_LORN_EL1 |
> +			 HFGxTR_EL2_LORSA_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
> +	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
> +		res0 |= (HFGxTR_EL2_SCXTNUM_EL1 | HFGxTR_EL2_SCXTNUM_EL0);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP))
> +		res0 |= HFGxTR_EL2_ICC_IGRPENn_EL1;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
> +		res0 |= (HFGxTR_EL2_ERRIDR_EL1 | HFGxTR_EL2_ERRSELR_EL1 |
> +			 HFGxTR_EL2_ERXFR_EL1 | HFGxTR_EL2_ERXCTLR_EL1 |
> +			 HFGxTR_EL2_ERXSTATUS_EL1 | HFGxTR_EL2_ERXMISCn_EL1 |
> +			 HFGxTR_EL2_ERXPFGF_EL1 | HFGxTR_EL2_ERXPFGCTL_EL1 |
> +			 HFGxTR_EL2_ERXPFGCDN_EL1 | HFGxTR_EL2_ERXADDR_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> +		res0 |= HFGxTR_EL2_nACCDATA_EL1;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +		res0 |= (HFGxTR_EL2_nGCS_EL0 | HFGxTR_EL2_nGCS_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
> +		res0 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> +		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
> +		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
> +		res0 |= HFGxTR_EL2_nS2POR_EL1;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
> +		res0 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
> +	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
> +	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
> +
> +	/* HDFG[RW]TR_EL2 */
> +	res0 = res1 = 0;
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
> +		res0 |= HDFGRTR_EL2_OSDLR_EL1;
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
> +		res0 |= (HDFGRTR_EL2_PMEVCNTRn_EL0 | HDFGRTR_EL2_PMEVTYPERn_EL0 |
> +			 HDFGRTR_EL2_PMCCFILTR_EL0 | HDFGRTR_EL2_PMCCNTR_EL0 |
> +			 HDFGRTR_EL2_PMCNTEN | HDFGRTR_EL2_PMINTEN |
> +			 HDFGRTR_EL2_PMOVS | HDFGRTR_EL2_PMSELR_EL0 |
> +			 HDFGRTR_EL2_PMMIR_EL1 | HDFGRTR_EL2_PMUSERENR_EL0 |
> +			 HDFGRTR_EL2_PMCEIDn_EL0);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
> +		res0 |= (HDFGRTR_EL2_PMBLIMITR_EL1 | HDFGRTR_EL2_PMBPTR_EL1 |
> +			 HDFGRTR_EL2_PMBSR_EL1 | HDFGRTR_EL2_PMSCR_EL1 |
> +			 HDFGRTR_EL2_PMSEVFR_EL1 | HDFGRTR_EL2_PMSFCR_EL1 |
> +			 HDFGRTR_EL2_PMSICR_EL1 | HDFGRTR_EL2_PMSIDR_EL1 |
> +			 HDFGRTR_EL2_PMSIRR_EL1 | HDFGRTR_EL2_PMSLATFR_EL1 |
> +			 HDFGRTR_EL2_PMBIDR_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
> +		res0 |= (HDFGRTR_EL2_TRC | HDFGRTR_EL2_TRCAUTHSTATUS |
> +			 HDFGRTR_EL2_TRCAUXCTLR | HDFGRTR_EL2_TRCCLAIM |
> +			 HDFGRTR_EL2_TRCCNTVRn | HDFGRTR_EL2_TRCID |
> +			 HDFGRTR_EL2_TRCIMSPECn | HDFGRTR_EL2_TRCOSLSR |
> +			 HDFGRTR_EL2_TRCPRGCTLR | HDFGRTR_EL2_TRCSEQSTR |
> +			 HDFGRTR_EL2_TRCSSCSRn | HDFGRTR_EL2_TRCSTATR |
> +			 HDFGRTR_EL2_TRCVICTLR);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> +		res0 |= (HDFGRTR_EL2_TRBBASER_EL1 | HDFGRTR_EL2_TRBIDR_EL1 |
> +			 HDFGRTR_EL2_TRBLIMITR_EL1 | HDFGRTR_EL2_TRBMAR_EL1 |
> +			 HDFGRTR_EL2_TRBPTR_EL1 | HDFGRTR_EL2_TRBSR_EL1 |
> +			 HDFGRTR_EL2_TRBTRG_EL1);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
> +		res0 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
> +			 HDFGRTR_EL2_nBRBDATA);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
> +		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
> +	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
> +
> +	/* Reuse the bits from the read-side and add the write-specific stuff */
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
> +		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
> +		res0 |= HDFGWTR_EL2_TRCOSLAR;
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
> +		res0 |= HDFGWTR_EL2_TRFCR_EL1;
> +	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | HDFGWTR_EL2_RES0, res1);
> +
> +	/* HFGITR_EL2 */
> +	res0 = HFGITR_EL2_RES0;
> +	res1 = HFGITR_EL2_RES1;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
> +		res0 |= HFGITR_EL2_DCCVADP;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
> +		res0 |= (HFGITR_EL2_ATS1E1RP | HFGITR_EL2_ATS1E1WP);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +		res0 |= (HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
> +			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS |
> +			 HFGITR_EL2_TLBIVAALE1OS | HFGITR_EL2_TLBIVALE1OS |
> +			 HFGITR_EL2_TLBIVAAE1OS | HFGITR_EL2_TLBIASIDE1OS |
> +			 HFGITR_EL2_TLBIVAE1OS | HFGITR_EL2_TLBIVMALLE1OS);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
> +		res0 |= (HFGITR_EL2_TLBIRVAALE1 | HFGITR_EL2_TLBIRVALE1 |
> +			 HFGITR_EL2_TLBIRVAAE1 | HFGITR_EL2_TLBIRVAE1 |
> +			 HFGITR_EL2_TLBIRVAALE1IS | HFGITR_EL2_TLBIRVALE1IS |
> +			 HFGITR_EL2_TLBIRVAAE1IS | HFGITR_EL2_TLBIRVAE1IS |
> +			 HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
> +			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, IMP))
> +		res0 |= (HFGITR_EL2_CFPRCTX | HFGITR_EL2_DVPRCTX |
> +			 HFGITR_EL2_CPPRCTX);
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
> +		res0 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +		res0 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
> +			 HFGITR_EL2_nGCSEPP);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX))
> +		res0 |= HFGITR_EL2_COSPRCTX;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
> +		res0 |= HFGITR_EL2_ATS1E1A;
> +	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
> +
> +	/* HAFGRTR_EL2 - not a lot to see here*/

*very* minor nitpick: add a space before the */

> +	res0 = HAFGRTR_EL2_RES0;
> +	res1 = HAFGRTR_EL2_RES1;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
> +		res0 |= ~(res0 | res1);
> +	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
>  

Looked through every trap bit, that was tedious! and I just realised HCRX_EL2
is still left to do...

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
