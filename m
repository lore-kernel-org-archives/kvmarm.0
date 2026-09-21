Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCAE3ACA41
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790026765; cv=none; b=c+C4vKp3pB9DcaxrhxZKvpYeLX/bI963vWpcWZCwPrjLan1fzMjkwk1GvbOwTOYoUR9SYrd1qyw4m1pFxejJmLlm/djJeA++jINb0ksLg/z2DfauPw9eXwFXdDIZdaF35xXq8tlMsKPZP2cDpf0I67K3w/HoH42LuA8W8USpIMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790026765; c=relaxed/simple;
	bh=7HmB5E9Kkb2XwauB1xFGvf7iXuyKTx3AnwkrAk/XIC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtCen1Ax1e7HeLqdzbqXBZyf99q21o5LfdpTL6+UakLDohensrGATKM5olHyMTszZUzwO6SJW1jj/C645GRj6gRaNs6NP5vb4IU9EtlgEszyKklG0dM1sPIBIX0hZ3fKAmLYNGAt00AL2UCE/HtUvaNRThbGlh+/vBnvbdOa+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khAYui0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khAYui0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4110C1F000FF;
	Mon, 21 Sep 2026 21:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790026764;
	bh=YpSVBfoqkRWt04knD39tI67oaiJaEXa8F0suBNRjvOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=khAYui0bZov46VF5IqDL3khrtHcJvp2WBFft+D62enzCXe3elYnx6lBguzl33XCFe
	 eNtt11VjxOE60XeCLWbJ/WOpP9htsJ4UUX/nSOXrqVKRmgM8WtaSy71NNu51sbfqIy
	 DF8RAAfMymxjUUJ25ZEYV05ag5IAojGH1k+zRNZ5Xu/5PA4vGeU6Ta5xddbagg4NLA
	 dIIroXfTQQmodBoezZhwWrW8xtnJmQBZkODlI0Ziq7exrd0TluDIAIQ/dANwfTxHkP
	 VfqzTZZUUtvekI2ZR8mE8HklGsNoZCBLErgpajo40yVWI6sY7Y3UKLLJISiPVlqUO/
	 BXvLl9rLb7ahQ==
Date: Mon, 21 Sep 2026 14:39:23 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 04/22] KVM: arm64: nv: Only shadow writable-dirty guest
 descs as writable
Message-ID: <arGkC3uv6z7z5d8K@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-5-oupton@kernel.org>
 <arFgiKnNTds9p1a7@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFgiKnNTds9p1a7@LeoBrasDK>

On Mon, Sep 21, 2026 at 05:51:20PM +0100, Leonardo Bras wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 07bd1e3ae9fb..f35c4ce95473 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1572,7 +1572,7 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
> >  static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >  						       enum kvm_pgtable_prot prot)
> >  {
> > -	if (!nested->writable)
> > +	if (!(nested->writable && nested->dirty))
> >  		prot &= ~KVM_PGTABLE_PROT_W;
> 
> So if the page gets prot_w if it's either writable or dirty, or both.
> Humm, since we should _not_ have a dirty page that is not writable, that 
> could be fine. But then, why test the dirty?
> 
> Maybe we should have a KVM_PGTABLE_PROT_D (dirty) as well? 

The reasoning here requires zooming out and looking at the full flow of
a nested stage-2 abort.

Suppose an L2 takes a translation fault for an address that is missing
from the shadow stage-2. L0 KVM walks the L1 page tables and arrives at
a writable-clean descriptor for the fault address. That descriptor gets
shadowed into L0 KVM's shadow stage-2 MMU. Since L0 KVM relies on taking
a permission fault to set the dirty state in the L1 page tables, we can
only install a read-only translation in the shadow stage-2.

Prematurely granting write access would be architecturally incorrect
since the L1 descriptor would remain in a writable-clean state. In the
same vein, setting the page with DBM=1 in the shadow stage-2 would be
incorrect since hardware will relax it to writable-dirty without an
intervening fault that can be used to fix the L1 descriptor.

> >  	if (!nested->readable)
> >  		prot &= ~KVM_PGTABLE_PROT_R;
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index b247bc1d83fa..dcc7d0cc7c95 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -269,6 +269,8 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
> >  
> >  	trans->readable = s2ap & BIT(0);
> >  	trans->writable = s2ap & BIT(1);
> > +
> > +	trans->dirty = ws->desc & BIT(7);
> >  }
> 
> IIUC, both writable and dirty here will always have the same value, as they 
> both are set based in the same bit in ws->desc.
> 
> Maybe this is intended, but then it's a bit confusing they are not 
> both using the s2ap variable.

This is intentional, although this series gives an incomplete picture.

I am separately tracking the dirty state of the descriptor in
anticipation of FEAT_S2PIE support for nested. It just so happens that
in the direct permission model the 'write' and 'dirty' bits are aliased
to the same single bit.

> Another point here is that the actual writable bit should be DBM, at least 
> in some scenarios, but this discussion can be contended in the New PTE 
> patchset. 
> 
> Also, nits: 
> - any reason for the newline between writable and dirty?
> - should not KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W be used instead of BIT[7] in 
> this patch, as it makes more clear what we are checking?

Same thing here: these are both intentional changes in preparation for
supporting direct and indirect permission models at stage-2.

Thanks,
Oliver
