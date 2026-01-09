Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E592BE655
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767970636; cv=none; b=k4TcAA3lDEE50dD0z1lU0S4e4jSGdRu+4FR9fAs47od5LCDxzspaNFSXPObmV7+z15jZKlEdWoNPhBcB3I1QaLOBzXtmgqfte6EghQ8XPrbbSMNnQglDDKIWg7g7AYk6MRWSctbdhaActua6SFMtJ+WsObLl2eOZvbZSL94X9s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767970636; c=relaxed/simple;
	bh=EgVOgppE0QVkNnPDXFr+N84SqaD4XzCNSJ8pyoYn0Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfYhb4WjDuX7u5FOH8vBmoECtNqDbh5Q+5Y3jUkbRB6a0wbYnaOK3iq7hTowrCk3Ey853XNnSAwDem7YKxRgfQz5T2yZ6AskHv7B4DFbeLiTRmcVJk5XM+hdWfhoeBx+F3bTT2H1ZSoT8rsiw7Mc2Rho0VAcy9cB+KrVfpZfCm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZFDYhKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZFDYhKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3F8C4CEF1;
	Fri,  9 Jan 2026 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767970636;
	bh=EgVOgppE0QVkNnPDXFr+N84SqaD4XzCNSJ8pyoYn0Dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sZFDYhKCVm16J/cNJ7SPbLse1ZrRv9Mr8pks+0M//BKfDUx8bM6rEcgjSRxTnwKI5
	 VBVMEiKqV4tGWqTp5sHyQD7BcvOyK3xjAPyuX1DDkmjsBVByLRfxmi8XSAb5gpohgy
	 /Qhn0hQ47jj1JVEN5gykEuphvHJ1OWVoaqGUdfr3gbP5bSoSN/4HDLnrr1llshBPn1
	 +vixNttvCAK5ft2RdKWTqST37jJ5pptdwQ14SiQSaSfn0ngITj1vsZUdrfPyPG0+fF
	 jHkRkCdw9GMTV3d1BTHBCQJ+vlUaJglXXje/T7mf2xvJ/L8ptvkMeaL71Fghn10pkU
	 65BurgfnUJN4Q==
Date: Fri, 9 Jan 2026 14:57:10 +0000
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
Message-ID: <aWEXRgagcULlftqk@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-23-will@kernel.org>
 <s4p2ximtz7pki3waw245jtbl5znuco2ijrzsddlmln5x6rgxee@qbek4vpwn3kl>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s4p2ximtz7pki3waw245jtbl5znuco2ijrzsddlmln5x6rgxee@qbek4vpwn3kl>

On Tue, Jan 06, 2026 at 03:54:06PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:30 (+0000), Will Deacon wrote:
> > +int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > +	kvm_pte_t pte;
> > +	s8 level;
> > +	u64 ipa;
> > +	int ret;
> > +
> > +	switch (kvm_vcpu_trap_get_class(&hyp_vcpu->vcpu)) {
> > +	case ESR_ELx_EC_DABT_LOW:
> > +	case ESR_ELx_EC_IABT_LOW:
> > +		if (kvm_vcpu_trap_is_translation_fault(&hyp_vcpu->vcpu))
> > +			break;
> > +		fallthrough;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	ipa = kvm_vcpu_get_fault_ipa(&hyp_vcpu->vcpu);
> > +	ipa |= kvm_vcpu_get_hfar(&hyp_vcpu->vcpu) & GENMASK(11, 0);
> 
> Why is all the above needed? Could we simplify by having the host pass
> the IPA to the hcall?

I was just a little nervous about exposing an oracle here if we take the
gfn as an argument as it would provide the host with a pretty easy
mechanism to monitor the page access pattern of a guest after the initial
donation had occurred.

> > +	guest_lock_component(vm);
> > +	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	if (level != KVM_PGTABLE_LAST_LEVEL) {
> > +		ret = -EINVAL;
> > +		goto unlock;
> > +	}
> > +
> > +	ret = guest_pte_is_poisoned(pte);
> > +unlock:
> > +	guest_unlock_component(vm);
> > +	return ret;
> > +}
> > +
> >  int __pkvm_host_share_hyp(u64 pfn)
> >  {
> >  	u64 phys = hyp_pfn_to_phys(pfn);
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index d1926cb08c76..14865907610c 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -417,10 +417,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			return -EINVAL;
> >  
> >  		/*
> > -		 * We raced with another vCPU.
> > +		 * We either raced with another vCPU or the guest PTE
> > +		 * has been poisoned by an erroneous host access.
> >  		 */
> > -		if (mapping)
> > -			return -EAGAIN;
> > +		if (mapping) {
> > +			ret = kvm_call_hyp_nvhe(__pkvm_vcpu_in_poison_fault);
> 
> It's not too bad, but it's a shame we now issue that every time we have
> such a race (which is frequent-ish). Could we perhaps only issue it if
> at least one page has been forcefully reclaimed since boot?

On the plus side, it avoids an unconditional walk from the fault path
at EL2 (which is what we have in Android!).

It's a bit fiddly to implement your idea in the host, since the forceful
reclaim happens in a really terrible context but I could track it at EL2
and make __pkvm_vcpu_in_poison_fault() return early instead? It's also
worth bearing in mind that we've already serialised the concurrent fault
and done a GUP by this point, so performance is somewhat of a lost
cause...

WDYT?

Will
