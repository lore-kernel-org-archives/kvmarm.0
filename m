Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD293B993A
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729551; cv=none; b=SpdnMwTtna9YbtDIDJigAgPrLCndFXnkKcwo0PckFFY0DpdXe/oIPRYiXPH68xTbrKxllfb8mSJ+f1tLGp3DBiC+BI3/xvJauhOnB8nnTywm90VzpT12hEr29rl9FBKFDhk/y9DjR7rvrjT9klazprT1ajDvZUDy9ljIDs8iSbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729551; c=relaxed/simple;
	bh=5t7qu9IcNuS8J8E9a4etz5XNwuttdUNRUE+XETA47pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdIDN16hpPV0GvNT9vN0Z7ZMLXZlb0utQsPYzPuMtSIJ3jmH5QoxtqTxhCmgDLIg4ejYWjV18aoGJBm2832FpNOW4EwpxbKQh3YGFLvDGo5L5oLk+tFyhLs2vP52AaBTwHBAae10c+mRZQtGiXBKsHPDum29yvUXe5UUdkFuSU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uWdJ4jlj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uWdJ4jlj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31058176C;
	Mon, 29 Jun 2026 03:39:04 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3237E3F836;
	Mon, 29 Jun 2026 03:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782729548; bh=5t7qu9IcNuS8J8E9a4etz5XNwuttdUNRUE+XETA47pM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWdJ4jljL8LE6B1uF6rvS8kHKh3gG3t+xJVm+Ufn/UMPhSfA/05l4Ou8/tAJ6Bn6L
	 p24Ea2DiahsxPC1U8ScjT6LzYRoF8/GLJDk6l2ASYyW+WjUXHkF7qd9R7r+rSclGxC
	 pxHS1PO/1cSPdjzNbt2pIZF5Dy5EzKJAc/b9d6ms=
Date: Mon, 29 Jun 2026 11:38:51 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 3/5] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <iaosk4wfl45gajjgq5px7azzpsjthps5auqlxfey74dlcltndc@abua7k74njdb>
References: <20260510145338.322962-1-weilin.chang@arm.com>
 <20260510145338.322962-4-weilin.chang@arm.com>
 <86cxyfvgf4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cxyfvgf4.wl-maz@kernel.org>

Hi Marc,

Sorry for the late reply.

On Thu, May 28, 2026 at 01:59:11PM +0100, Marc Zyngier wrote:
> On Sun, 10 May 2026 15:53:36 +0100,
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
> > this new spanning canonical IPA range with an "UNKNOWN_IPA" bit,
> > indicating we give up tracking the nested IPA ranges that map to this
> > canonical IPA range.
> > 
> > The maple tree's 64 bit entry is enough to store the nested IPA and
> > the UNKNOWN_IPA status, therefore besides maple tree's internal
> > operation, memory allocation is avoided.
> > 
> > Example:
> > |||| means existing range, ---- means empty range
> > 
> > input:            $$$$$$$$$$$$$$$$$$$$$$$$$$
> > tree:  --||||-----|||||||---------||||||||||-----------
> > 
> > insert spanning range and replace overlapping ones:
> >        --||||-----||||||||||||||||||||||||||-----------
> >                   ^^^^marked UNKNOWN_IPA^^^^
> > 
> > With the reverse map created, when a canonical IPA range gets unmapped,
> > look into each s2 mmu's maple tree and look for canonical IPA ranges
> > affected, and base on their UNKNOWN_IPA status:
> > 
> > UNKNOWN_IPA     -> fall back and fully unmap the current shadow
> >                    stage-2, also clear the tree
> > 
> > not UNKNOWN_IPA -> unmap the nested IPA range, and remove the reverse
> >                    map entry
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h   |   4 +
> >  arch/arm64/include/asm/kvm_nested.h |   4 +
> >  arch/arm64/kvm/mmu.c                |  27 ++++--
> >  arch/arm64/kvm/nested.c             | 140 +++++++++++++++++++++++++++-
> >  4 files changed, 167 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 1a56d137df10..dc4c0bce1bbb 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -223,6 +223,10 @@ struct kvm_s2_mmu {
> >  	 */
> >  	bool	pending_unmap;
> >  
> > +	bool	nested_revmap_broken;
> > +	/* canonical IPA to nested IPA range lookup */
> > +	struct maple_tree nested_revmap_mt;
> > +
> >  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> >  	struct dentry *shadow_pt_debugfs_dentry;
> >  #endif
> > diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > index 091544e6af44..5cbf78dfc685 100644
> > --- a/arch/arm64/include/asm/kvm_nested.h
> > +++ b/arch/arm64/include/asm/kvm_nested.h
> > @@ -76,6 +76,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
> >  				       const union tlbi_info *info,
> >  				       void (*)(struct kvm_s2_mmu *,
> >  						const union tlbi_info *));
> > +extern void kvm_record_nested_revmap(gpa_t gpa, struct kvm_s2_mmu *mmu,
> > +				     gpa_t fault_ipa, size_t map_size);
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
> > index e4becd5cdf36..ce0bd88cd3c1 100644
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
> > +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> >  
> >  	write_lock(&kvm->mmu_lock);
> >  	pgt = mmu->pgt;
> > @@ -1108,8 +1110,11 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >  		free_percpu(mmu->last_vcpu_ran);
> >  	}
> >  
> > -	if (kvm_is_nested_s2_mmu(kvm, mmu))
> > +	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
> > +		if (!mtree_empty(revmap_mt))
> > +			mtree_destroy(revmap_mt);
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
> > @@ -2034,6 +2043,10 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> >  		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
> >  								 prot, flags);
> >  	} else {
> > +		if (s2fd->nested)
> > +			kvm_record_nested_revmap(canonical_gpa, pgt->mmu,
> > +						 gfn_to_gpa(gfn), mapping_size);
> > +
> >  		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
> >  							 __pfn_to_phys(pfn), prot,
> >  							 memcache, flags);
> > @@ -2389,14 +2402,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
> 
> This sort of cleanups could be in a separate patch.

Ack.

> 
> > +	kvm_unmap_gfn_range_nested(kvm, gpa, size, may_block);
> >  
> > -	kvm_nested_s2_unmap(kvm, range->may_block);
> >  	return false;
> >  }
> >  
> > @@ -2674,7 +2689,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >  
> >  	write_lock(&kvm->mmu_lock);
> >  	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
> > -	kvm_nested_s2_unmap(kvm, true);
> > +	kvm_unmap_gfn_range_nested(kvm, gpa, size, true);
> >  	write_unlock(&kvm->mmu_lock);
> >  }
> >  
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 883b6c1008fb..35b5d5f21a23 100644
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
> > @@ -43,6 +44,20 @@ struct vncr_tlb {
> >   */
> >  #define S2_MMU_PER_VCPU		2
> >  
> > +/*
> > + * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
> > + * layout:
> > + *
> > + * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
> > + *              the whole value to 0
> > + * bits 55-12:  nested IPA bits 55-12
> > + * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
> > + *              IPA maps to this canonical IPA in the shadow stage-2
> > + */
> > +#define VALID_ENTRY		BIT(62)
> > +#define ADDR_MASK		GENMASK_ULL(55, 12)
> > +#define UNKNOWN_IPA		BIT(0)
> > +
> >  void kvm_init_nested(struct kvm *kvm)
> >  {
> >  	kvm->arch.nested_mmus = NULL;
> > @@ -769,12 +784,57 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	return s2_mmu;
> >  }
> >  
> > +void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
> > +			      gpa_t fault_ipa, size_t map_size)
> 
> The name fault_ipa doesn't really make sense here. This is the IPA as
> seen from L1 (the input to the L1 S2 tables). We indeed obtain it from
> a fault, but that should not influence the naming here.
> 
> Similarly, 'ipa' should be qualified a bit better to reflect that this
> is the L0 IPA.

Yeah these names aren't very clear. I'll change to use 'canonical IPA',
and 'nested IPA'.

> 
> > +{
> > +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> > +	gpa_t ipa_end = ipa + map_size - 1;
> 
> Are you always guaranteed that ipa is aligned on map_size?

From what I see in kvm_s2_fault_map() and gmem_abort(), yes, the ipa is
aligned to map_size.

What about adding

	if (WARN_ON(!IS_ALIGNED(canonical_ipa, map_size))) {
		ALIGN_DOWN(canonical_ipa, map_size);
		canonical_ipa_end = canonical_ipa + map_size;
	}

to be safe?

> 
> > +	u64 entry, new_entry = 0;
> > +	MA_STATE(mas_rev, revmap_mt, ipa, ipa_end);
> > +
> > +	if (mmu->nested_revmap_broken)
> > +		return;
> > +
> > +	mtree_lock(revmap_mt);
> > +	entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
> > +
> > +	if (entry) {
> > +		/* maybe just a perm update... */
> > +		if (!(entry & UNKNOWN_IPA) && mas_rev.index == ipa &&
> 
> Shouldn't you check that VALID_ENTRY is set? Is the index guaranteed
> to match the L0 IPA?

Right now either VALID_ENTRY or UNKNOWN_IPA is set for an exising entry
in the tree, having both set is not expected. I think we can turn
VALID_ENTRY and UNKNOWN_IPA tests into helpers and warn if they are both
set in the helpers?

> 
> > +		    mas_rev.last == ipa_end &&
> > +		    fault_ipa == (entry & ADDR_MASK))
> 
> Again, I think there is a potential alignment issue here.
> 
> > +			goto unlock;
> > +		/*
> > +		 * Create a "UNKNOWN_IPA" range that spans all the overlapping
> > +		 * ranges and store it.
> > +		 */
> > +		while (entry && mas_rev.index <= ipa_end) {
> > +			ipa = min(mas_rev.index, ipa);
> > +			ipa_end = max(mas_rev.last, ipa_end);
> > +			entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
> > +		}
> > +		new_entry |= UNKNOWN_IPA;
> > +	} else {
> > +		new_entry |= fault_ipa;
> > +		new_entry |= VALID_ENTRY;
> > +	}
> > +
> > +	mas_set_range(&mas_rev, ipa, ipa_end);
> > +	if (mas_store_gfp(&mas_rev, xa_mk_value(new_entry),
> > +			  GFP_NOWAIT | __GFP_ACCOUNT))
> > +		mmu->nested_revmap_broken = true;
> 
> I really think we ought to track this event happening. Maybe a trace
> point.

Will do.

> 
> > +unlock:
> > +	mtree_unlock(revmap_mt);
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
> > @@ -1150,6 +1210,82 @@ void kvm_nested_s2_wp(struct kvm *kvm)
> >  	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> >  }
> >  
> > +static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
> > +{
> > +	mtree_destroy(&mmu->nested_revmap_mt);
> > +	mmu->nested_revmap_broken = false;
> > +	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> > +}
> > +
> > +static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
> > +				  size_t unmap_size, bool may_block)
> 
> Same comment as above about the nature of 'gpa'. I *think* this is the
> L0 IPA, but please clarify.

Will use clearer names from now.

> 
> > +{
> > +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> > +	gpa_t ipa = gpa;
> > +	gpa_t ipa_end = gpa + unmap_size - 1;
> 
> Similar concerns about alignments.

For this function, I don't think there are any guarantees on alignment
for sizes > PAGE_SIZE, but I think if we make sure the range we unmap
completely covers the input range then things should be fine.

> 
> > +	u64 entry;
> > +	size_t entry_size;
> > +	MA_STATE(mas_rev, revmap_mt, gpa, ipa_end);
> > +
> > +	if (mmu->nested_revmap_broken) {
> > +		reset_revmap_and_unmap(mmu, may_block);
> > +		return;
> > +	}
> > +
> > +	mtree_lock(revmap_mt);
> > +	entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
> > +
> > +	while (entry && mas_rev.index <= ipa_end) {
> 
> I'm again concerned that the VALID bit is never checked.
> 
> > +		ipa = mas_rev.last + 1;
> > +		entry_size = mas_rev.last - mas_rev.index + 1;
> > +		/*
> > +		 * Give up and invalidate this s2 mmu if the unmap range
> > +		 * touches any UNKNOWN_IPA range.
> > +		 */
> > +		if (entry & UNKNOWN_IPA) {
> > +			mtree_unlock(revmap_mt);
> > +			reset_revmap_and_unmap(mmu, may_block);
> > +			return;
> > +		}
> > +
> > +		/*
> > +		 * Ignore result, it is okay if a reverse mapping erase
> > +		 * fails.
> > +		 */
> > +		mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
> > +
> > +		mtree_unlock(revmap_mt);
> > +		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
> > +				       may_block);
> > +		mtree_lock(revmap_mt);
> > +		/*
> > +		 * Other maple tree operations during preemption could render
> > +		 * this ma_state invalid, so reset it.
> > +		 */
> > +		mas_set_range(&mas_rev, ipa, ipa_end);
> > +		entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
> > +	}
> > +	mtree_unlock(revmap_mt);
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
> > +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> > +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> > +
> > +		if (kvm_s2_mmu_valid(mmu))
> > +			unmap_mmu_ipa_range(mmu, gpa, size, may_block);
> > +	}
> > +
> > +	kvm_invalidate_vncr_ipa(kvm, gpa, gpa + size);
> 
> I'm not overly fond of propagating the VNCR invalidation in all the S2
> manipulations. I understand why you are doing it here, but I think we
> need to have a better solution.

I agree. I think moving kvm_invalidate_vncr_ipa() up one level, to the
places where canonical IPA are being invalidated, is slightly more
sensible.

> 
> Fundamentally, VNCR invalidation has nothing to do with S2. This
> really is a EL2 S1 thing. And given that you have a reverse map per
> s2_mmu, it would be easy enough to track VNCR TLBs through that.
> 
> It doesn't have to be part of this patch, but that would be a good
> thing to disentangle as a subsequent patch.

I'll have a think, thanks!

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
