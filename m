Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88573CCFC1
	for <kvmarm@lists.linux.dev>; Thu,  9 Apr 2026 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775739266; cv=none; b=Mjnhfg8ycOCUZlJAO5Jl5Z7TdVdS2CbWt1Qx7dnY33DMNNMfpckOFIqn4w5XNQ5BCp4B6tj+wCvE1/dang7YFIFsmGBOmPubrFG0Qp+ImUcKCqDE4a8s46/Wu64POdckjZb9+KN8nTnMJZ2e2RU+aNOehHb+dgcDzREh9+k/HNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775739266; c=relaxed/simple;
	bh=k8ZUgvOzjim9OThXmOBWSyqAsKksMfP+omJoVQBMvf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmO9CD0wbNMzTFuefru7nitPT1xcQPb8iDaE+y5eN5/5G5QsFyYdVRmtsvG/cIABy8E03o87UJfnbVMGC9ZdpCe4u1icKpK6kDlZvpmA9TnFnKsqgyEW11Eowj/4rYn/OQjLd9dOl6oaR9plokEMX+Mw02LbAdoXTFEciRfw0Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T4DRxAJa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T4DRxAJa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29E252E98;
	Thu,  9 Apr 2026 05:54:14 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ACA63F641;
	Thu,  9 Apr 2026 05:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775739259; bh=k8ZUgvOzjim9OThXmOBWSyqAsKksMfP+omJoVQBMvf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T4DRxAJa20Q/Z+ePjJG9rU1tQb9LKDvcAJhlwsf4E7FJt+EA0qfPxYDfddYY7AKd1
	 iUP1pvoSu1avRX5MvVxqn/wXLj23ddV8tNwJ+S+rOd9SST3UHzI7yU9sHTypnCFnxh
	 /NuUkYtbeC5sFocK1OEMT4HjmbOZeClf/VmCp2Tg=
Date: Thu, 9 Apr 2026 13:54:06 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
Message-ID: <r2p37beybkrhqw6omsx27bjgsqbd4fml447onbk4g446k3wo7b@dd2hvqetmzjc>
References: <20260406164618.3312473-1-weilin.chang@arm.com>
 <20260406164618.3312473-2-weilin.chang@arm.com>
 <87y0izb5o6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0izb5o6.wl-maz@kernel.org>

On Tue, Apr 07, 2026 at 08:17:29AM +0100, Marc Zyngier wrote:
> On Mon, 06 Apr 2026 17:46:17 +0100,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > The current code decodes TCR.TG0/TG1 and VTCR.TG0 inline at several
> > places. Extract this logic into helpers so the granule size is derived
> > in one place. This enables us to alter the effective granule size in
> > the same place, which we will need in a later patch.
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/kvm/at.c     | 73 +++++++++++++++++++++++++----------------
> >  arch/arm64/kvm/nested.c | 70 ++++++++++++++++++++++++---------------
> >  2 files changed, 89 insertions(+), 54 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index c5c5644b1878..ff8ba30e917b 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> > @@ -135,14 +135,54 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
> >  	wi->e0poe = (wi->regime != TR_EL2) && (val & TCR2_EL1_E0POE);
> >  }
> >  
> > +static unsigned int tg0_to_shift(u64 tg0)
> > +{
> 
> It'd be better to abstract these helpers a bit more by making them
> take the full TCR_ELx value, and to give them a slightly better name.
> 
> I'd suggest something like:
> 
> static unsigned int tcr_to_tg0_pgshift(u64 tcr)
> {
> 	u64 tg0 = tcr & TCR_TG0_MASK, tcr;
> 
> which makes it clear that the result is a page shift, as required by
> wi->pgshift.

Makes sense, I'll change it.

> 
> > +	switch (tg0) {
> > +	case TCR_EL1_TG0_4K:
> > +		return 12;
> > +	case TCR_EL1_TG0_16K:
> > +		return 14;
> > +	case TCR_EL1_TG0_64K:
> 
> Please don't mix the _EL1 definition and those without _EL1 in the
> same file. For a start, that's not always EL1. Also, this makes very
> hard to reason about what is shifted and what is not.

Thanks for pointing this out, will fix.

> 
> > +	default:	/* IMPDEF: treat any other value as 64k */
> > +		return 16;
> > +	}
> > +}
> > +
> > +static unsigned int tg1_to_shift(u64 tg1)
> > +{
> > +	switch (tg1) {
> > +	case TCR_EL1_TG1_4K:
> > +		return 12;
> > +	case TCR_EL1_TG1_16K:
> > +		return 14;
> > +	case TCR_EL1_TG1_64K:
> > +	default:	/* IMPDEF: treat any other value as 64k */
> > +		return 16;
> > +	}
> > +}
> > +
> > +static u64 tcr_tg_shift(struct kvm *kvm, u64 tcr, bool upper_range)
> > +{
> > +	unsigned int shift;
> > +
> > +	/* Someone was silly enough to encode TG0/TG1 differently */
> > +	if (upper_range)
> > +		shift = tg1_to_shift(FIELD_GET(TCR_EL1_TG1_MASK, tcr));
> > +	else
> > +		shift = tg0_to_shift(FIELD_GET(TCR_EL1_TG0_MASK, tcr));
> > +
> > +	return shift;
> > +}
> > +
> >  static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> >  			 struct s1_walk_result *wr, u64 va)
> >  {
> > -	u64 hcr, sctlr, tcr, tg, ps, ia_bits, ttbr;
> > +	u64 hcr, sctlr, tcr, ps, ia_bits, ttbr;
> >  	unsigned int stride, x;
> > -	bool va55, tbi, lva;
> > +	bool va55, tbi, lva, upper_range;
> >  
> >  	va55 = va & BIT(55);
> > +	upper_range = va55 && wi->regime != TR_EL2;
> >  
> >  	if (vcpu_has_nv(vcpu)) {
> >  		hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
> > @@ -173,35 +213,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> >  		BUG();
> >  	}
> >  
> > -	/* Someone was silly enough to encode TG0/TG1 differently */
> > -	if (va55 && wi->regime != TR_EL2) {
> > +	if (upper_range)
> >  		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
> > -		tg = FIELD_GET(TCR_TG1_MASK, tcr);
> > -
> > -		switch (tg << TCR_TG1_SHIFT) {
> > -		case TCR_TG1_4K:
> > -			wi->pgshift = 12;	 break;
> > -		case TCR_TG1_16K:
> > -			wi->pgshift = 14;	 break;
> > -		case TCR_TG1_64K:
> > -		default:	    /* IMPDEF: treat any other value as 64k */
> > -			wi->pgshift = 16;	 break;
> > -		}
> > -	} else {
> > +	else
> >  		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
> > -		tg = FIELD_GET(TCR_TG0_MASK, tcr);
> > -
> > -		switch (tg << TCR_TG0_SHIFT) {
> > -		case TCR_TG0_4K:
> > -			wi->pgshift = 12;	 break;
> > -		case TCR_TG0_16K:
> > -			wi->pgshift = 14;	 break;
> > -		case TCR_TG0_64K:
> > -		default:	    /* IMPDEF: treat any other value as 64k */
> > -			wi->pgshift = 16;	 break;
> > -		}
> > -	}
> >  
> > +	wi->pgshift = tcr_tg_shift(vcpu->kvm, tcr, upper_range);
> >  	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
> >
> >  	ia_bits = get_ia_size(wi);
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 883b6c1008fb..2bfab3007cb3 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -378,20 +378,36 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> >  	return 0;
> >  }
> >  
> > -static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
> > +static unsigned int tg0_to_shift(u64 tg0)
> 
> Same comments as above.

Ack.

> 
> > +{
> > +	switch (tg0) {
> > +	case VTCR_EL2_TG0_4K:
> > +		return 12;
> > +	case VTCR_EL2_TG0_16K:
> > +		return 14;
> > +	case VTCR_EL2_TG0_64K:
> > +	default:	/* IMPDEF: treat any other value as 64k */
> > +		return 16;
> > +	}
> > +}
> > +
> > +static u64 vtcr_tg0_shift(struct kvm *kvm, u64 vtcr)
> > +{
> > +	u64 tg0 = FIELD_GET(VTCR_EL2_TG0_MASK, vtcr);
> > +	unsigned int shift = tg0_to_shift(tg0);
> > +
> > +	return shift;
> 
> shift is an unsigned int. Why is the return value a u64? Try and make
> sure that types are consistent, even if they cast nicely in C.

This is an error from me, I'll fix this.

> 
> > +}
> > +
> > +static size_t vtcr_tg0_size(struct kvm *kvm, u64 vtcr)
> > +{
> > +	return BIT(vtcr_tg0_shift(kvm, vtcr));
> > +}
> > +
> > +static void vtcr_to_walk_info(struct kvm *kvm, u64 vtcr, struct s2_walk_info *wi)
> 
> This prototype reads bizarrely. vtcr is per CPU, the walk info is
> evidently per CPU, and yet you pass a kvm struct.
> 
> Instead, rename this to:
> 
> static void setup_s2_walk(struct kvm_vcpu *vcpu,
> 			  struct s2_walk_info *wi)
> {
> 	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> 
> and call that directly. You can then extract vcpu->kvm as needed. It
> also aligns the naming on the s1 part, which isn't a bad thing to do.

Agreed, makes sense.

> 
> >  {
> >  	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
> > -
> > -	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
> > -	case VTCR_EL2_TG0_4K:
> > -		wi->pgshift = 12;	 break;
> > -	case VTCR_EL2_TG0_16K:
> > -		wi->pgshift = 14;	 break;
> > -	case VTCR_EL2_TG0_64K:
> > -	default:	    /* IMPDEF: treat any other value as 64k */
> > -		wi->pgshift = 16;	 break;
> > -	}
> > -
> > +	wi->pgshift = vtcr_tg0_shift(kvm, vtcr);
> >  	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
> >  	/* Global limit for now, should eventually be per-VM */
> >  	wi->max_oa_bits = min(get_kvm_ipa_limit(),
> > @@ -414,7 +430,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
> >  
> >  	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> >  
> > -	vtcr_to_walk_info(vtcr, &wi);
> > +	vtcr_to_walk_info(vcpu->kvm, vtcr, &wi);
> >  
> >  	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
> >  
> > @@ -515,17 +531,19 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
> >  	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
> >  	kvm_pte_t pte;
> >  	u8 ttl, level;
> > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> > +	size_t tg0_size = vtcr_tg0_size(kvm, vtcr);
> >  
> > -	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> >  
> > -	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
> > -	case VTCR_EL2_TG0_4K:
> > +	switch (tg0_size) {
> > +	case SZ_4K:
> >  		ttl = (TLBI_TTL_TG_4K << 2);
> >  		break;
> > -	case VTCR_EL2_TG0_16K:
> > +	case SZ_16K:
> >  		ttl = (TLBI_TTL_TG_16K << 2);
> >  		break;
> > -	case VTCR_EL2_TG0_64K:
> > +	case SZ_64K:
> 
> All these unit changes make the patch harder to read than it should
> be. Consider having a separate patch to do that.

Understood, sure.

Thanks for the feedback!
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
