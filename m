Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D66624B2F
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 11:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707304155; cv=none; b=EqdD5Csjd0ACA33mXhHtb3VViEsKo2qX8CueTF7ARilU/JepW2xD+e2F1HPMMcseBcFHkcbzQKlsTLtG5Df8EBYWtQkZEQLNf6xGfgiSUD4m14DmDOe1IJRfTVara05FG4Ap3LcU5oRdl1v+mFuLSizjhqHSOfy7AhQ5J97jo2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707304155; c=relaxed/simple;
	bh=/J8yceI8GT5n2RXqzXjZFByFkCr1ZRlFL5mXAW6VUpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFx/8wBWNgBZKNGvvEo14uSVEC/58khnK6e3q4eoh3w9/CmoQaaD+oBp4U0A9tEpUb2P3aobOVErk5Ctr4zMdiXqZYXQciw0kc/qna2H0TNl/BeRlQ+olgZE/L+lYjeGh+iXSluPu/W0BFI+uNLdzj/decU3YB0KrHdmxvD3S70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QOuUVFYv; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QOuUVFYv"
Date: Wed, 7 Feb 2024 11:09:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707304151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9PKbDme2EtSnW8TSyhiEojEXsG/9UfsSaPW9I6BBZa0=;
	b=QOuUVFYv7IsVjrFFS/dAvc67P6nAORyhWM617B06BniVBCpH9g/ssPUIBe8lhRUAVsElnF
	cCzZhFwfp7zFL8nm07k1Td+yogqJiAGGrVcsVVW6XWF28Pu8gdqMiiu0O4V8gNWjY0mvfc
	jwmf+14Hz+FoFlu2yIHT0Q+HFVsxOmQ=
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
Subject: Re: [PATCH v3 05/26] KVM: arm64: nv: Add sanitising to VNCR-backed
 FGT sysregs
Message-ID: <ZcNk1OC-qGcdF1fl@linux.dev>
References: <20240205103431.1104133-1-maz@kernel.org>
 <20240205103431.1104133-6-maz@kernel.org>
 <ZcNiLYCbacgnRuaw@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcNiLYCbacgnRuaw@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 07, 2024 at 10:57:49AM +0000, Oliver Upton wrote:
> On Mon, Feb 05, 2024 at 10:34:10AM +0000, Marc Zyngier wrote:
> > Fine Grained Traps are controlled by a whole bunch of features.
> > Each one of them must be checked and the corresponding masks
> > computed so that we don't let the guest apply traps it shouldn't
> > be using.
> > 
> > This takes care of HFG[IRW]TR_EL2, HDFG[RW]TR_EL2, and HAFGRTR_EL2.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  arch/arm64/kvm/nested.c | 128 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 128 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index a8fe0f970e04..31c4ce0439d6 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -265,6 +265,134 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
> >  		res1 |= HCR_E2H;
> >  	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> >  
> > +	/* HFG[RW]TR_EL2 */
> > +	res0 = res1 = 0;
> > +	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> > +	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
> 
> Same thing here w/ the different flags.
> 
> > +	/* HDFG[RW]TR_EL2 */
> > +	res0 = res1 = 0;
> > +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
> > +		res0 |= HDFGRTR_EL2_OSDLR_EL1;
> > +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
> > +		res0 |= (HDFGRTR_EL2_PMEVCNTRn_EL0 | HDFGRTR_EL2_PMEVTYPERn_EL0 |
> > +			 HDFGRTR_EL2_PMCCFILTR_EL0 | HDFGRTR_EL2_PMCCNTR_EL0 |
> > +			 HDFGRTR_EL2_PMCNTEN | HDFGRTR_EL2_PMINTEN |
> > +			 HDFGRTR_EL2_PMOVS | HDFGRTR_EL2_PMSELR_EL0 |
> > +			 HDFGRTR_EL2_PMMIR_EL1 | HDFGRTR_EL2_PMUSERENR_EL0 |
> > +			 HDFGRTR_EL2_PMCEIDn_EL0);
> 
> I think you're missing HDFGWTR_EL2_PMSWINC_EL0 and HDFGWTR_EL2_PMCR_EL0
> here. Silly write-only and read-only registers...

I can't read. Looks like you're doing this a few lines down.

-- 
Thanks,
Oliver
