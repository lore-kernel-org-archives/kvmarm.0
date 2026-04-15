Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D16D3815CB
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776294354; cv=none; b=EEmuE4/QbhLCs0slViwJc0pG5W7XAH8yHSppu2BgviyVKq/PmQYAeckHKRUxAKLp6GExO8bXknB2lSlG1UGWbAf+kDQs+FSGeAFtftaYq541/g0UZYAfp9TA+4yqgxhtf+NIND6oG6+Rh4osR6MxDUgEsWENrNfYbX1zbGGmwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776294354; c=relaxed/simple;
	bh=zp/tj0/D7dSZJ67oCxqEQA0wGITQUows+Ww+oXg49/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1/lsJBtg+GJ6mhE2ftBF5W9yi4z3ESLGVqI3EeOpX1CMa9n7PYLSK6ZSVX5/s5DZZZXkaQ05qUPBiFdC6MkSKhfZZYxine8BBCztOJcDYOt0uu9kMBjwxFY7RYJOyWX58DfOYeBigzxmU/U+DcpyRJDzJ94o7JHR2fYCfvFlvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XVf/yyE6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XVf/yyE6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B57BB28C7;
	Wed, 15 Apr 2026 16:05:45 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 366E83F641;
	Wed, 15 Apr 2026 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776294351; bh=zp/tj0/D7dSZJ67oCxqEQA0wGITQUows+Ww+oXg49/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVf/yyE64Y533FCOM7lax9oAz7HGFW8QnILhJCG6Mo0IOC0WW3d5VdTClHeLH+pM2
	 lWvKUUTZ7+N5zgKIkzPckxSXopxvA1EULWbyJHeR/C/UBVuWXTF2/7IaDcDkT68TUO
	 tYr+LvO/KY2cYUgbFCtoUQUxCSBVXfiY8L8FK6l0=
Date: Thu, 16 Apr 2026 00:05:40 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/1] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <tozhyzmwfddgx5fgfejracv6tskgs7xhs4fs6yvmvff74m7gwy@eq3oh35tokj4>
References: <20260411125024.3735989-1-weilin.chang@arm.com>
 <20260411125024.3735989-2-weilin.chang@arm.com>
 <86eckg39eo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86eckg39eo.wl-maz@kernel.org>

On Wed, Apr 15, 2026 at 09:38:55AM +0100, Marc Zyngier wrote:
> On Sat, 11 Apr 2026 13:50:24 +0100,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > Currently we are forced to fully unmap all shadow stage-2 for a VM when
> > unmapping a page from the canonical stage-2, for example during an MMU
> > notifier call. This is because we are not tracking what canonical IPA
> > are mapped in the shadow stage-2 page tables hence there is no way to
> > know what to unmap.
> > 
> > Create a per kvm_s2_mmu maple tree to track canonical IPA range ->
> > nested IPA range, so that it is possible to partially unmap shadow
> > stage-2 when a canonical IPA range is unmapped. The algorithm is simple
> > and conservative:
> > 
> > At each shadow stage-2 map, insert the nested IPA range into the maple
> > tree, with the canonical IPA range as the key. If the canonical IPA
> > range doesn't overlap with existing ranges in the tree, insert as is,
> > and a reverse mapping for this range is established. But if the
> > canonical IPA range overlaps with any existing ranges in the tree,
> > create a new range that spans all the overlapping ranges including the
> > input range and replace those existing ranges. In the mean time, mark
> > this new spanning canonical IPA range as "polluted" indicating we lost
> > track of the nested IPA ranges that map to this canonical IPA range.
> > 
> > The maple tree's 64 bit entry is enough to store the nested IPA and
> > polluted status (stored as a bit called UNKNOWN_IPA), therefore besides
> > maple tree's internal operation, memory allocation is avoided.
> > 
> > Example:
> > |||| means existing range, ---- means empty range
> > 
> > input:            $$$$$$$$$$$$$$$$$$$$$$$$$$
> > tree:  --||||-----|||||||---------||||||||||-----------
> > 
> > insert spanning range and replace overlapping ones:
> >        --||||-----||||||||||||||||||||||||||-----------
> >                   ^^^^^^^^polluted!^^^^^^^^^
> 
> I think you should stick to a single terminology. It is either
> "polluted", or "unknown IPA". My preference goes to the latter, as the
> former is not very descriptive in this context.

Sure, I agree.

> 
> > 
> > With the reverse map created, when a canonical IPA range gets unmapped,
> > look into each s2 mmu's maple tree and look for canonical IPA ranges
> > affected, and base on their polluted status:
> > 
> > polluted -> fall back and fully invalidate the current shadow stage-2,
> >             also clear the tree
> > not polluted -> unmap the nested IPA range, and remove the reverse map
> >                 entry
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h   |   4 +
> >  arch/arm64/include/asm/kvm_nested.h |   4 +
> >  arch/arm64/kvm/mmu.c                |  30 ++++--
> >  arch/arm64/kvm/nested.c             | 147 +++++++++++++++++++++++++++-
> >  4 files changed, 177 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 851f6171751c..a97bd461c1e1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
> >  	 */
> >  	bool	nested_stage2_enabled;
> >  
> > +	/* canonical IPA to nested IPA range lookup */
> > +	struct maple_tree nested_revmap_mt;
> > +	bool	nested_revmap_broken;
> > +
> 
> Consider moving this boolean next to the other ones so that you don't
> create too many holes in the kvm_s2_mmu structure (use pahole to find out).
> 
> But I have some misgivings about the way things are structured
> here. Only NV needs a revmap, yet this is present irrelevant of the
> nature of the VM and bloats the data structure a bit.
> 
> My naive approach would have been to only keep a pointer to the
> revmap, and make that pointer NULL when the tree is "broken", and
> freed under RCU if the context isn't the correct one.

Can you explain what you mean by "if the context isn't the correct one"?
If this refers to when selecting a specific kvm_s2_mmu instance for
another context, then IIUC refcnt would already be 0 and there would be
no other user of the tree.

However I do see RCU can be used for parallel accesses to the tree from
parallel s2 faults, and when one fault's revmap store fails RCU defers
freeing the tree until the other fault finishes using it.

> 
> This would have multiple benefits: no large-ish structure embedded in
> the s2_mmu structure, no extra boolean to indicate an error condition,
> memory reclaimed earlier.

Yes I see.

> 
> >  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> >  	struct dentry *shadow_pt_debugfs_dentry;
> >  #endif
> > diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > index 091544e6af44..f039220e87a6 100644
> > --- a/arch/arm64/include/asm/kvm_nested.h
> > +++ b/arch/arm64/include/asm/kvm_nested.h
> > @@ -76,6 +76,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
> >  				       const union tlbi_info *info,
> >  				       void (*)(struct kvm_s2_mmu *,
> >  						const union tlbi_info *));
> > +extern void kvm_record_nested_revmap(gpa_t gpa, struct kvm_s2_mmu *mmu,
> > +				    gpa_t fault_gpa, size_t map_size);
> >  extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> >  extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
> >  
> > @@ -164,6 +166,8 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> >  				    struct kvm_s2_trans *trans);
> >  extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
> >  extern void kvm_nested_s2_wp(struct kvm *kvm);
> > +extern void kvm_unmap_gfn_range_nested(struct kvm *kvm, gpa_t gpa, size_t size,
> > +				       bool may_block);
> >  extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
> >  extern void kvm_nested_s2_flush(struct kvm *kvm);
> >  
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d089c107d9b7..4c9b9cf6dc43 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -5,6 +5,7 @@
> >   */
> >  
> >  #include <linux/acpi.h>
> > +#include <linux/maple_tree.h>
> >  #include <linux/mman.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/io.h>
> > @@ -1099,6 +1100,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  {
> >  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> >  	struct kvm_pgtable *pgt = NULL;
> > +	struct maple_tree *mt = &mmu->nested_revmap_mt;
> >  
> >  	write_lock(&kvm->mmu_lock);
> >  	pgt = mmu->pgt;
> > @@ -1108,8 +1110,11 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  		free_percpu(mmu->last_vcpu_ran);
> >  	}
> >  
> > -	if (kvm_is_nested_s2_mmu(kvm, mmu))
> > +	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
> > +		if (!mtree_empty(mt))
> > +			mtree_destroy(mt);
> >  		kvm_init_nested_s2_mmu(mmu);
> > +	}
> >  
> >  	write_unlock(&kvm->mmu_lock);
> >  
> > @@ -1631,6 +1636,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  		goto out_unlock;
> >  	}
> >  
> > +	if (s2fd->nested)
> > +		kvm_record_nested_revmap(gfn << PAGE_SHIFT, pgt->mmu,
> > +					 s2fd->fault_ipa, PAGE_SIZE);
> > +
> >  	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> >  						 __pfn_to_phys(pfn), prot,
> >  						 memcache, flags);
> > @@ -2031,6 +2040,13 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> >  		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
> >  								 prot, flags);
> >  	} else {
> > +		if (s2fd->nested) {
> > +			phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
> > +
> > +			ipa &= ~(mapping_size - 1);
> 
> I guess it'd be worth adding a helper for this instead of duplicating
> the existing code.

Ack.

> 
> > +			kvm_record_nested_revmap(ipa, pgt->mmu, gfn_to_gpa(gfn),
> > +						 mapping_size);
> 
> This worries me a bit, see below.
> 
> > +		}
> >  		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
> >  							 __pfn_to_phys(pfn), prot,
> >  							 memcache, flags);
> > @@ -2388,14 +2404,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> > +	gpa_t gpa = range->start << PAGE_SHIFT;
> > +	size_t size = (range->end - range->start) << PAGE_SHIFT;
> > +	bool may_block = range->may_block;
> > +
> >  	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> >  		return false;
> >  
> > -	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> > -			     (range->end - range->start) << PAGE_SHIFT,
> > -			     range->may_block);
> > +	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
> > +	kvm_unmap_gfn_range_nested(kvm, gpa, size, may_block);
> >  
> > -	kvm_nested_s2_unmap(kvm, range->may_block);
> >  	return false;
> >  }
> >  
> > @@ -2673,7 +2691,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >  
> >  	write_lock(&kvm->mmu_lock);
> >  	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
> > -	kvm_nested_s2_unmap(kvm, true);
> > +	kvm_unmap_gfn_range_nested(kvm, gpa, size, true);
> >  	write_unlock(&kvm->mmu_lock);
> >  }
> >  
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 883b6c1008fb..c9ebe969b453 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/bitfield.h>
> >  #include <linux/kvm.h>
> >  #include <linux/kvm_host.h>
> > +#include <linux/maple_tree.h>
> >  
> >  #include <asm/fixmap.h>
> >  #include <asm/kvm_arm.h>
> > @@ -43,6 +44,19 @@ struct vncr_tlb {
> >   */
> >  #define S2_MMU_PER_VCPU		2
> >  
> > +/*
> > + * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
> > + * layout:
> > + *
> > + * bit 63: valid, 1 for non-polluted entries, prevents the case where the
> > + *         nested IPA is 0 and turns the whole value to 0
> > + * bits 55-12: nested IPA bits 55-12
> > + * bit 0: polluted, 1 for polluted, 0 for not
> > + */
> > +#define VALID_ENTRY		BIT(63)
> > +#define NESTED_IPA_MASK		GENMASK_ULL(55, 12)
> > +#define UNKNOWN_IPA		BIT(0)
> > +
> 
> This only works because you are using the "advanced" API, right?
> Otherwise, you'd be losing the high bit. It'd be good to add a comment
> so that people keep that in mind.

Sorry, I can't find any relationship between the advanced API and the
top most bit of the maple tree value, what am I missing?

> 
> >  void kvm_init_nested(struct kvm *kvm)
> >  {
> >  	kvm->arch.nested_mmus = NULL;
> > @@ -769,12 +783,57 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	return s2_mmu;
> >  }
> >  
> > +void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
> > +			      gpa_t fault_ipa, size_t map_size)
> > +{
> > +	struct maple_tree *mt = &mmu->nested_revmap_mt;
> > +	gpa_t start = ipa;
> > +	gpa_t end = ipa + map_size - 1;
> > +	u64 entry, new_entry = 0;
> > +	MA_STATE(mas, mt, start, end);
> > +
> > +	if (mmu->nested_revmap_broken)
> > +		return;
> > +
> > +	mtree_lock(mt);
> > +	entry = (u64)mas_find_range(&mas, end);
> > +
> > +	if (entry) {
> > +		/* maybe just a perm update... */
> > +		if (!(entry & UNKNOWN_IPA) && mas.index == start &&
> > +		    mas.last == end &&
> > +		    fault_ipa == (entry & NESTED_IPA_MASK))
> > +			goto unlock;
> > +		/*
> > +		 * Create a "polluted" range that spans all the overlapping
> > +		 * ranges and store it.
> > +		 */
> > +		while (entry && mas.index <= end) {
> > +			start = min(mas.index, start);
> > +			end = max(mas.last, end);
> > +			entry = (u64)mas_find_range(&mas, end);
> > +		}
> > +		new_entry |= UNKNOWN_IPA;
> > +	} else {
> > +		new_entry |= fault_ipa;
> > +		new_entry |= VALID_ENTRY;
> > +	}
> > +
> > +	mas_set_range(&mas, start, end);
> > +	if (mas_store_gfp(&mas, (void *)new_entry, GFP_NOWAIT | __GFP_ACCOUNT))
> > +		mmu->nested_revmap_broken = true;
> 
> Can we try and minimise the risk of allocation failure here?
> 
> user_mem_abort() tries very hard to pre-allocate pages for page
> tables by maintaining an memcache. Can we have a similar approach for
> the revmap?

Unfortunately, as I understand the maple tree can only pre-allocate for
a store when the range and the entry to be stored is given, but in this
case we must inspect the tree to get that information after we hold the
mmu and maple tree locks. It is possible to do a two pass approach:

pre-allocate -> take MMU lock -> take maple tree lock -> revalidate what
we pre-allocated is still usable (nobody changed the tree before we took
the maple tree lock)

But I am not fond of this extra complexity..

> 
> > +unlock:
> > +	mtree_unlock(mt);
> > +}
> > +
> >  void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
> >  {
> >  	/* CnP being set denotes an invalid entry */
> >  	mmu->tlb_vttbr = VTTBR_CNP_BIT;
> >  	mmu->nested_stage2_enabled = false;
> >  	atomic_set(&mmu->refcnt, 0);
> > +	mt_init(&mmu->nested_revmap_mt);
> > +	mmu->nested_revmap_broken = false;
> >  }
> >  
> >  void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> > @@ -1150,6 +1209,90 @@ void kvm_nested_s2_wp(struct kvm *kvm)
> >  	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> >  }
> >  
> > +static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
> > +{
> > +	mtree_destroy(&mmu->nested_revmap_mt);
> > +	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> > +	mmu->nested_revmap_broken = false;
> > +}
> > +
> > +static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
> > +				  size_t unmap_size, bool may_block)
> > +{
> > +	struct maple_tree *mt = &mmu->nested_revmap_mt;
> > +	gpa_t start = gpa;
> > +	gpa_t end = gpa + unmap_size - 1;
> > +	u64 entry;
> > +	size_t entry_size;
> > +	bool unlock, fallback;
> > +	MA_STATE(mas, mt, gpa, end);
> > +
> > +	if (mmu->nested_revmap_broken) {
> > +		unlock = false;
> > +		fallback = true;
> > +		goto fin;
> > +	}
> 
> Using booleans to affect the control flow reads really badly. I'd
> expect this to simply be:
> 
> 	if (...) {
> 		reset_revmap_and_unmap(mmu, may_block);
> 		return;
> 	}
> 
> > +
> > +	mtree_lock(mt);
> > +	entry = (u64)mas_find_range(&mas, end);
> > +
> > +	while (entry && mas.index <= end) {
> > +		start = mas.last + 1;
> > +		entry_size = mas.last - mas.index + 1;
> > +		/*
> > +		 * Give up and invalidate this s2 mmu if the unmap range
> > +		 * touches any polluted range.
> > +		 */
> > +		if (entry & UNKNOWN_IPA) {
> > +			unlock = true;
> > +			fallback = true;
> > +			goto fin;
> > +		}
> 
> and this to be:
> 
> 		if (entry & UNKNOWN_IPA) {
> 			mtree_unlock(mt);
> 			reset_revmap_and_unmap(mmu, may_block);
> 			return;
> 		}
> 
> > +
> > +		/*
> > +		 * Ignore result, it is okay if a reverse mapping erase
> > +		 * fails.
> > +		 */
> > +		mas_store_gfp(&mas, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
> > +
> > +		mtree_unlock(mt);
> > +		kvm_stage2_unmap_range(mmu, entry & NESTED_IPA_MASK, entry_size,
> > +				       may_block);
> > +		mtree_lock(mt);
> > +		/*
> > +		 * Other maple tree operations during preemption could render
> > +		 * this ma_state invalid, so reset it.
> > +		 */
> > +		mas_set_range(&mas, start, end);
> > +		entry = (u64)mas_find_range(&mas, end);
> > +	}
> > +	unlock = true;
> > +	fallback = false;
> > +
> > +fin:
> > +	if (unlock)
> > +		mtree_unlock(mt);
> > +	if (fallback)
> > +		reset_revmap_and_unmap(mmu, may_block);
> 
> and this can eventually be greatly simplified.

Sure, I agree.

> 
> > +}
> > +
> > +void kvm_unmap_gfn_range_nested(struct kvm *kvm, gpa_t gpa, size_t size,
> > +				bool may_block)
> > +{
> > +	int i;
> > +
> > +	if (!kvm->arch.nested_mmus_size)
> > +		return;
> > +
> > +	/* TODO: accelerate this using mt of canonical s2 mmu */
> > +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> > +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> > +
> > +		if (kvm_s2_mmu_valid(mmu))
> > +			unmap_mmu_ipa_range(mmu, gpa, size, may_block);
> > +	}
> > +}
> > +
> >  void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
> >  {
> >  	int i;
> > @@ -1163,7 +1306,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
> >  		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> >  
> >  		if (kvm_s2_mmu_valid(mmu))
> > -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> > +			reset_revmap_and_unmap(mmu, may_block);
> >  	}
> >  
> >  	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> > @@ -1848,7 +1991,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
> >  
> >  		write_lock(&vcpu->kvm->mmu_lock);
> >  		if (mmu->pending_unmap) {
> > -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
> > +			reset_revmap_and_unmap(mmu, true);
> >  			mmu->pending_unmap = false;
> >  		}
> >  		write_unlock(&vcpu->kvm->mmu_lock);
> 
> My other concern here is related to TLB invalidation. As the guest
> performs TLB invalidations that remove entries from the shadow S2,
> there is no way to update the revmap to account for this.
> 
> This obviously means that the revmap becomes more and more inaccurate
> over time, and that is likely to accumulate conflicting entries.
> 
> What is the plan to improve the situation on this front?

Right now I think using a direct map which goes from nested IPA to
canonical IPA could work while not generating too much complexity, if we
keep the reverse map and direct map in lockstep (direct map keeping the
same mappings as the reverse map but just in reverse).

I'll try to do that and include it in the next iteration.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
