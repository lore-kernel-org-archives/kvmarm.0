Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A756604B3
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 08:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706863962; cv=none; b=GNC8fpuN3wZs83r3711DJZSRPJeeuDJTWFdNHTvSsDSYQjmDAbREOi349xTtcvNBCjadKzlL7lJGp31yJBn6uXlJfH9UemCxSf1z+chS2x0/xm4aYEaiXx5A3SRIehI3EF14TR4D2dQ+wghzMXfWGZ8HfejMJOj/1GSZ1Yy0Bks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706863962; c=relaxed/simple;
	bh=a5gsImnAy1C5ga8+jiubvGQTZ2Unn4kchez71EsNth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4WompWogm6ZNFNtAFWoLLGt3+rpe1Wuyk9chrYNKh+fH9K1D3LW7GtifpF92N+2cM6nTOxTvYEPoGNVzYNXyA7+vEOXFQdXexb42/duwSX3Nltp//RqFlXCfJrizBh9VxRiCDTaKwdwMyYWc4C9LImvV/+Qp7v9GwdxRE5CYuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K0ekZaau; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K0ekZaau"
Date: Fri, 2 Feb 2024 08:52:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706863957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2lAMePr/K6lbW7Qik331AA4YHgUfzD7xr04Rpz9q0o=;
	b=K0ekZaauHHiL+/kBICbfivyofXqElkBLsVXqRwtTDm2EryXohT7WCkFI4APeRZETVk/uGz
	01vpTzJ4UA4McJ/D5acMtzlJBBvQl2FSLKBy1+N10kAHnwep0Cdd4BUJr1nL4xYWwKNJTd
	4bZZIns+92eC5dQe+GZ+6oIRHaclPTY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 06/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 HCRX_EL2
Message-ID: <ZbytUKPFYiP2cdd8@linux.dev>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 30, 2024 at 08:45:13PM +0000, Marc Zyngier wrote:
> Just like its little friends, HCRX_EL2 gets the feature set treatment
> when backed by VNCR.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 42 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index cdeef3259193..72db632b115a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -263,6 +263,48 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  		res1 |= HCR_E2H;
>  	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
>  
> +	/* HCRX_EL2 */
> +	res0 = HCRX_EL2_RES0;
> +	res1 = HCRX_EL2_RES1;

I'm a bit worried that we're depending on the meaning of these generated
RES0/RES1 bitmasks not changing behind our backs.

Not like people read anything, but do you think it'd make sense to add a
warning comment to the sysreg file that adding new encodings can have a
functional change on KVM?

> +	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
> +		res0 |= HCRX_EL2_PACMEn;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
> +		res0 |= HCRX_EL2_EnFPM;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +		res0 |= HCRX_EL2_GCSEn;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, SYSREG_128, IMP))
> +		res0 |= HCRX_EL2_EnIDCP128;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ADERR, DEV_ASYNC))
> +		res0 |= (HCRX_EL2_EnSDERR | HCRX_EL2_EnSNERR);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, DF2, IMP))
> +		res0 |= HCRX_EL2_TMEA;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
> +		res0 |= HCRX_EL2_D128En;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> +		res0 |= HCRX_EL2_PTTWI;

Ok, not fair. The latest public version of the ARM ARM doesn't have any
of this. Where are you getting it from?

> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SCTLRX, IMP))
> +		res0 |= HCRX_EL2_SCTLR2En;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
> +		res0 |= HCRX_EL2_TCR2En;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
> +		res0 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, CMOW, IMP))
> +		res0 |= HCRX_EL2_CMOW;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
> +		res0 |= (HCRX_EL2_VFNMI | HCRX_EL2_VINMI | HCRX_EL2_TALLINT);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP) ||
> +	    !(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS))
> +		res0 |= HCRX_EL2_SMPME;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))
> +		res0 |= (HCRX_EL2_FGTnXS | HCRX_EL2_FnXS);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
> +		res0 |= HCRX_EL2_EnASR;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
> +		res0 |= HCRX_EL2_EnALS;
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> +		res0 |= HCRX_EL2_EnAS0;
> +	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
> +
>  	/* HFG[RW]TR_EL2 */
>  	res0 = res1 = 0;
>  	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> -- 
> 2.39.2
> 

-- 
Thanks,
Oliver
