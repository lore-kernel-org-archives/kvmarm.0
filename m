Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548612DC78D
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767980121; cv=none; b=PuPO/1PwsuLwBTbi6/U+0QcZPyRA9WbtGzN3GJDGAY6EdS4HO2a1dZ2J/s5I0j/Ll65eC5VZ8a699vjV5cr6oLYBUg5y5lT01H7b9PpXEkj+1+XASU8nla1rUiUseJWiOZVuqGlKK8rOHkNPu9neE4fd4a2PNqvPK9wxwVmm1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767980121; c=relaxed/simple;
	bh=6AWsDeYymU1uIp2ik74l/pNTTqrSRlBKEBODIVwNn7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWSVMRxyKJdFSYKKYeAcfk7OetQjCEVT7XrjtA723/JX89bK920etKy+6lBUswsmzBC8kSVG1R1+ks6w6zbaU5uvBQ5ejZ6BAszl0KyNQZTm1XCdcBL6ezjD0uUsVM5qvJbTk9dU5kb1KitZmBE5VzDyA3WJVgw7XdYU5oBE8Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Osfv6+a0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Osfv6+a0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D4C4CEF1;
	Fri,  9 Jan 2026 17:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767980121;
	bh=6AWsDeYymU1uIp2ik74l/pNTTqrSRlBKEBODIVwNn7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Osfv6+a01A/EvgTnC3g5JXiMANFu2/qTGFvuY662F325idunISqC3XkkhXXjIrQ02
	 +RcyTn/oJf2kfeSW/6tOWjb3g1lqkf8O3xZP2FaTGxmFAQPuMK0wsQXlZeGMwr01l5
	 QTBjqiaXG5yrN8q27mQxacxEe5ytAn7xskwDKy3S+ZUzjRd8eP8rFAeI+4znXk4zkH
	 UzPMFu17PcEGaG0YS6OuFA34gPmRJFwbch4IpVHgjVzUBXVfnUlMoUrKWbp+A3abSq
	 OwyJGJVWbC2Y7SSyphCmoj8R2BQOziyoIvVQa7gzTVvKGLkjtLSpzPQB/avOor2ih6
	 vw1m795Ke8gXQ==
Date: Fri, 9 Jan 2026 17:35:15 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 22/30] KVM: arm64: Return -EFAULT from VCPU_RUN on access
 to a poisoned pte
Message-ID: <aWE8U2JsGozpYZCA@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-23-will@kernel.org>
 <s4p2ximtz7pki3waw245jtbl5znuco2ijrzsddlmln5x6rgxee@qbek4vpwn3kl>
 <aWEXRgagcULlftqk@willie-the-truck>
 <vs26wb435olhc4p5b4owotm5zzwr2znwafsgfskkicymj25mbj@nllj54ubgtgl>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vs26wb435olhc4p5b4owotm5zzwr2znwafsgfskkicymj25mbj@nllj54ubgtgl>

On Fri, Jan 09, 2026 at 03:29:38PM +0000, Quentin Perret wrote:
> On Friday 09 Jan 2026 at 14:57:10 (+0000), Will Deacon wrote:
> > On Tue, Jan 06, 2026 at 03:54:06PM +0000, Quentin Perret wrote:
> > > On Monday 05 Jan 2026 at 15:49:30 (+0000), Will Deacon wrote:
> > > > +int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > > +{
> > > > +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > > > +	kvm_pte_t pte;
> > > > +	s8 level;
> > > > +	u64 ipa;
> > > > +	int ret;
> > > > +
> > > > +	switch (kvm_vcpu_trap_get_class(&hyp_vcpu->vcpu)) {
> > > > +	case ESR_ELx_EC_DABT_LOW:
> > > > +	case ESR_ELx_EC_IABT_LOW:
> > > > +		if (kvm_vcpu_trap_is_translation_fault(&hyp_vcpu->vcpu))
> > > > +			break;
> > > > +		fallthrough;
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	ipa = kvm_vcpu_get_fault_ipa(&hyp_vcpu->vcpu);
> > > > +	ipa |= kvm_vcpu_get_hfar(&hyp_vcpu->vcpu) & GENMASK(11, 0);
> > > 
> > > Why is all the above needed? Could we simplify by having the host pass
> > > the IPA to the hcall?
> > 
> > I was just a little nervous about exposing an oracle here if we take the
> > gfn as an argument as it would provide the host with a pretty easy
> > mechanism to monitor the page access pattern of a guest after the initial
> > donation had occurred.
> 
> Aha, I see what you mean. I guess if we scope that hcall to only
> discover if a gfn is poisoned we're not exposing too much, but
> contextualizing the call to the fault also sounds good to me. Perhaps a
> small comment would help?

Good idea, I'll add something to the hypercall.

> > > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > > index d1926cb08c76..14865907610c 100644
> > > > --- a/arch/arm64/kvm/pkvm.c
> > > > +++ b/arch/arm64/kvm/pkvm.c
> > > > @@ -417,10 +417,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > >  			return -EINVAL;
> > > >  
> > > >  		/*
> > > > -		 * We raced with another vCPU.
> > > > +		 * We either raced with another vCPU or the guest PTE
> > > > +		 * has been poisoned by an erroneous host access.
> > > >  		 */
> > > > -		if (mapping)
> > > > -			return -EAGAIN;
> > > > +		if (mapping) {
> > > > +			ret = kvm_call_hyp_nvhe(__pkvm_vcpu_in_poison_fault);
> > > 
> > > It's not too bad, but it's a shame we now issue that every time we have
> > > such a race (which is frequent-ish). Could we perhaps only issue it if
> > > at least one page has been forcefully reclaimed since boot?
> > 
> > On the plus side, it avoids an unconditional walk from the fault path
> > at EL2 (which is what we have in Android!).
> > 
> > It's a bit fiddly to implement your idea in the host, since the forceful
> > reclaim happens in a really terrible context but I could track it at EL2
> > and make __pkvm_vcpu_in_poison_fault() return early instead?
> 
> I guess EL2 could easily publish something in the host kvm struct as
> well if we really wanted to, it's pinned as shared with EL2 and
> accessible from the hyp_vm, which we retrieve in the force reclaim path.

Ah yeah, that sounds do-able.

> > It's also
> > worth bearing in mind that we've already serialised the concurrent fault
> > and done a GUP by this point, so performance is somewhat of a lost
> > cause...
> 
> That is very true, so happy to keep all these micro-optimization for
> later.

Sounds good to me. We'll have a bunch of performance work once the
functionality is there, so I'll leave this part as-is for now.

Will
