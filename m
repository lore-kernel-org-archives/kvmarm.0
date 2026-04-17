Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FA136AB77
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776462022; cv=none; b=rPn+r5LB7utvJeqybQednT6VmXCrSncrN2STgs/m2BKRYdA6i4Nx2UKE7obo5Zl6txzp59ybmEwSiVpPO/J50XVxj1nKx3129BOXzZT6+fwhupNR16WKdK85nMtqJhQnW8dtbXU9jLMrTqxdWTPIzO1MustwLhnlTCwcPwWKRXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776462022; c=relaxed/simple;
	bh=WsfNRJHIMag1juS0hfrqDkFPrRUI7x7lEdf+xWkiknE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bq08bIlV24BdBo0PCwT7muO7G06LItru4Yk/aLoEZRv5Ggx61ZUsNm8+poRMAhzsUwd13hXvQ6bIC1MRv2KLJBUnHIamRTHdOnzsq02PdCLCYzp7zNzvBxyAJBzKLbWcBsxTM+j/Ns0H8A8F+sPwwEt2HbU5Ct9844V9YKjoRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pc+EUiD3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pc+EUiD3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BE3E1BD0;
	Fri, 17 Apr 2026 14:40:13 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B76C3F7D8;
	Fri, 17 Apr 2026 14:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776462018; bh=WsfNRJHIMag1juS0hfrqDkFPrRUI7x7lEdf+xWkiknE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pc+EUiD3wlJxc/vsBETzbSJ479fmYwh7QWAdV0IK19uLVoUlIY5lAuT7djwCfzUi6
	 m7b1UCEv8E4vaEac0PaznxiR1gPJNsQ/hAnClRS6oL0WCTp4G7OTjyzoXQ6fEpcqlo
	 WLmAI4hOGY/0LEgAB6f9pt61sU99aWO+kqphqpG8=
Date: Fri, 17 Apr 2026 22:40:05 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/1] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <cy4rd5q4t6pgcjthv4c6f2e2nzm5gum5omc273jewbukteye4a@ocfvy6rsyisf>
References: <20260411125024.3735989-1-weilin.chang@arm.com>
 <20260411125024.3735989-2-weilin.chang@arm.com>
 <86eckg39eo.wl-maz@kernel.org>
 <tozhyzmwfddgx5fgfejracv6tskgs7xhs4fs6yvmvff74m7gwy@eq3oh35tokj4>
 <867bq72n7l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bq72n7l.wl-maz@kernel.org>

On Thu, Apr 16, 2026 at 11:50:38AM +0100, Marc Zyngier wrote:
> On Thu, 16 Apr 2026 00:05:40 +0100,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > On Wed, Apr 15, 2026 at 09:38:55AM +0100, Marc Zyngier wrote:
> 
> [...]
> 
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 851f6171751c..a97bd461c1e1 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
> > > >  	 */
> > > >  	bool	nested_stage2_enabled;
> > > >  
> > > > +	/* canonical IPA to nested IPA range lookup */
> > > > +	struct maple_tree nested_revmap_mt;
> > > > +	bool	nested_revmap_broken;
> > > > +
> > > 
> > > Consider moving this boolean next to the other ones so that you don't
> > > create too many holes in the kvm_s2_mmu structure (use pahole to find out).
> > > 
> > > But I have some misgivings about the way things are structured
> > > here. Only NV needs a revmap, yet this is present irrelevant of the
> > > nature of the VM and bloats the data structure a bit.
> > > 
> > > My naive approach would have been to only keep a pointer to the
> > > revmap, and make that pointer NULL when the tree is "broken", and
> > > freed under RCU if the context isn't the correct one.
> > 
> > Can you explain what you mean by "if the context isn't the correct one"?
> > If this refers to when selecting a specific kvm_s2_mmu instance for
> > another context, then IIUC refcnt would already be 0 and there would be
> > no other user of the tree.
> 
> Sorry, "context" is an overloaded word. I meant a situation in which
> you couldn't immediately free the maple-tree because you're holding
> locks and freeing (hypothetically) requires a sleeping "context". in
> this case, freeing under RCU, purely as a deferring mechanism, might
> be useful.

Oh ok! I get your point now.

> 
> [...]
> 
> > > > +/*
> > > > + * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
> > > > + * layout:
> > > > + *
> > > > + * bit 63: valid, 1 for non-polluted entries, prevents the case where the
> > > > + *         nested IPA is 0 and turns the whole value to 0
> > > > + * bits 55-12: nested IPA bits 55-12
> > > > + * bit 0: polluted, 1 for polluted, 0 for not
> > > > + */
> > > > +#define VALID_ENTRY		BIT(63)
> > > > +#define NESTED_IPA_MASK		GENMASK_ULL(55, 12)
> > > > +#define UNKNOWN_IPA		BIT(0)
> > > > +
> > > 
> > > This only works because you are using the "advanced" API, right?
> > > Otherwise, you'd be losing the high bit. It'd be good to add a comment
> > > so that people keep that in mind.
> > 
> > Sorry, I can't find any relationship between the advanced API and the
> > top most bit of the maple tree value, what am I missing?
> 
> From Documentation/core-api/maple_tree.rst:
> 
> <quote>
> The Maple Tree can store values between ``0`` and ``ULONG_MAX``.  The Maple
> Tree reserves values with the bottom two bits set to '10' which are below 4096
> (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
> entries then the users can convert the entries using xa_mk_value() and convert
> them back by calling xa_to_value().  If the user needs to use a reserved
> value, then the user can convert the value when using the
> :ref:`maple-tree-advanced-api`, but are blocked by the normal API.
> </quote>
> 
> So depending how you read this, you can conclude that the bit patterns
> you encode in the MT may be considered as invalid. xa_mk_value() would
> make things always work, but that shifts the value left by one bit,
> hence you'd lose bit 63 (see how we use trap_config in
> emulate-nested.c to deal with this).

Thanks! I haven't looked at what xa_{mk, to}_value do until now.

> 
> I think you are lucky that bits [11:1] are always 0 here, but that
> looks extremely fragile to me, so you never hit the [1:0]==10
> condition, but that's really fragile.

I'll change the bits and switch to using xa_{mk, to}_value consistently.

> 
> > 
> > > 
> > > >  void kvm_init_nested(struct kvm *kvm)
> > > >  {
> > > >  	kvm->arch.nested_mmus = NULL;
> > > > @@ -769,12 +783,57 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> > > >  	return s2_mmu;
> > > >  }
> > > >  
> > > > +void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
> > > > +			      gpa_t fault_ipa, size_t map_size)
> > > > +{
> > > > +	struct maple_tree *mt = &mmu->nested_revmap_mt;
> > > > +	gpa_t start = ipa;
> > > > +	gpa_t end = ipa + map_size - 1;
> > > > +	u64 entry, new_entry = 0;
> > > > +	MA_STATE(mas, mt, start, end);
> > > > +
> > > > +	if (mmu->nested_revmap_broken)
> > > > +		return;
> > > > +
> > > > +	mtree_lock(mt);
> > > > +	entry = (u64)mas_find_range(&mas, end);
> > > > +
> > > > +	if (entry) {
> > > > +		/* maybe just a perm update... */
> > > > +		if (!(entry & UNKNOWN_IPA) && mas.index == start &&
> > > > +		    mas.last == end &&
> > > > +		    fault_ipa == (entry & NESTED_IPA_MASK))
> > > > +			goto unlock;
> > > > +		/*
> > > > +		 * Create a "polluted" range that spans all the overlapping
> > > > +		 * ranges and store it.
> > > > +		 */
> > > > +		while (entry && mas.index <= end) {
> > > > +			start = min(mas.index, start);
> > > > +			end = max(mas.last, end);
> > > > +			entry = (u64)mas_find_range(&mas, end);
> > > > +		}
> > > > +		new_entry |= UNKNOWN_IPA;
> > > > +	} else {
> > > > +		new_entry |= fault_ipa;
> > > > +		new_entry |= VALID_ENTRY;
> > > > +	}
> > > > +
> > > > +	mas_set_range(&mas, start, end);
> > > > +	if (mas_store_gfp(&mas, (void *)new_entry, GFP_NOWAIT | __GFP_ACCOUNT))
> > > > +		mmu->nested_revmap_broken = true;
> > > 
> > > Can we try and minimise the risk of allocation failure here?
> > > 
> > > user_mem_abort() tries very hard to pre-allocate pages for page
> > > tables by maintaining an memcache. Can we have a similar approach for
> > > the revmap?
> > 
> > Unfortunately, as I understand the maple tree can only pre-allocate for
> > a store when the range and the entry to be stored is given, but in this
> > case we must inspect the tree to get that information after we hold the
> > mmu and maple tree locks. It is possible to do a two pass approach:
> > 
> > pre-allocate -> take MMU lock -> take maple tree lock -> revalidate what
> > we pre-allocated is still usable (nobody changed the tree before we took
> > the maple tree lock)
> > 
> > But I am not fond of this extra complexity..
> 
> Fair enough. It would at least be interesting to get a feel for how
> often this happens, because if we fail often, it won't help much.

Ack. I agree.

Thanks,
Wei-Lin Chang

> 
> [...]
> 
> > > My other concern here is related to TLB invalidation. As the guest
> > > performs TLB invalidations that remove entries from the shadow S2,
> > > there is no way to update the revmap to account for this.
> > > 
> > > This obviously means that the revmap becomes more and more inaccurate
> > > over time, and that is likely to accumulate conflicting entries.
> > > 
> > > What is the plan to improve the situation on this front?
> > 
> > Right now I think using a direct map which goes from nested IPA to
> > canonical IPA could work while not generating too much complexity, if we
> > keep the reverse map and direct map in lockstep (direct map keeping the
> > same mappings as the reverse map but just in reverse).
> 
> Right, so that'd effectively a mirror of the guest's page tables at
> the point of taking the fault.
> 
> > I'll try to do that and include it in the next iteration.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
