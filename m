Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5DB213E89
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725792; cv=none; b=EVGy5pZrm/m3k/sBCyLFx/HxFiisAtWWeTUHRE7bcPk5LELG4vyVK0J+Tn76x/JHfdDodiS+K3HOGgyyUQJts/UtJdcr2/1k6hdtEBLVLveLnu4n50T3FER/Kaxg7hl80dkRQrC3AO3dcx67lhcNUUTI1ThcLMCneoYpqvUHyRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725792; c=relaxed/simple;
	bh=Zg6U4aQM4UINML7yDa/DB8huf11vBh5Yf/JHAc9IN1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNpvhSbZjYwdlMLejDzmb9Cczn1hkj2zVNttqcOeF0jcB7j6MJoD9973jJyY8RbBbB4JuFObTJk64MIbx4pxJ7xjRH8jA7MI235Qcj1FbTFn5EbjxETEcF1dATm/U487fqJMzvXtBsBeJtJAWvrzStmJo03VvUKVoOBQjR3EqzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IV7YVlv+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IV7YVlv+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDE0B1595;
	Wed, 22 Jul 2026 06:09:36 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDAD93F58B;
	Wed, 22 Jul 2026 06:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784725780; bh=Zg6U4aQM4UINML7yDa/DB8huf11vBh5Yf/JHAc9IN1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IV7YVlv+sr0FwB4OlMRnNfqOumZb0TVG2covLyQVfVmwkZjny4SY/FtNyclzaX9h8
	 hdgttJ29sdYxx5ITqVKlyjUNGViTXXI9+5OB8wry0LQUoIzzsUygrhAHBaaWJ5/fq7
	 uB5W7if/C/dF7ySoJn5DcQMcjGzhFoM/rPwVAGho=
Date: Wed, 22 Jul 2026 14:09:27 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>, Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <ogr4kpysq5dzj6365nnk2cmmi2fe6rzcqvjsf2t4bhxrsuhc46@ukkdfwcbwahl>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
 <20260714115926.2044757-3-weilin.chang@arm.com>
 <aliCuX3ZIvxWlFE-@kernel.org>
 <upkq27f2mo3fy27ubkxxgfwkgn2oamnbxom2o6gce5ocfyauo5@6tfu3ppaw7o6>
 <alkSAyfhI4n_VAok@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alkSAyfhI4n_VAok@kernel.org>

On Thu, Jul 16, 2026 at 10:16:51AM -0700, Oliver Upton wrote:
> On Thu, Jul 16, 2026 at 05:14:46PM +0100, Wei-Lin Chang wrote:
> > On Thu, Jul 16, 2026 at 12:05:29AM -0700, Oliver Upton wrote:
> > > Hey,
> > > 
> > > On Tue, Jul 14, 2026 at 12:59:21PM +0100, Wei-Lin Chang wrote:
> > > > +static bool valid_entry(unsigned long entry)
> > > > +{
> > > > +	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
> > > > +	return entry & VALID_ENTRY;
> > > > +}
> > > > +
> > > > +static bool unknown_ipa_entry(unsigned long entry)
> > > > +{
> > > > +	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
> > > > +	return entry & UNKNOWN_IPA;
> > > > +}
> > > 
> > > These should be WARN_ON_ONCE(), but I find the condition you're
> > > asserting to be a bit confusing. An aliased reverse map entry is still a
> > > valid entry, would you not set the valid bit?
> > 
> > Sorry, VALID_ENTRY might not be the best name for this flag. I used it
> > to mean entries in the maple tree, that are not UNKNOWN_IPA, meaning the
> > canonical IPA <-> nested IPA relation is one-to-one.
> > 
> > So by definition UNKNOWN_IPA and "VALID_ENTRY" should not be set at the
> > same time. Unfortunately they can't be a single flag, as the stored
> > address can be 0, this can make the whole value 0 when being stored if
> > the single flag is also 0, effectively not doing the store.
> > 
> > Maybe it's better with just "KNOWN_IPA"?
> 
> Does anything break with:
> 
> state			{VALID, UNKNOWN}
> 
> invalid entry (NULL)	{0, 0}
> valid IPA		{1, 0}
> aliased IPA		{1, 1}
> 
> It's just the assertion that the bits are mutually exclusive that I find
> confusing, agree that we need to have two bits of state.

This looks like a better way of representing state, thanks! I think
"valid" now makes more sense.

> 
> > > 
> > > > +void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
> > > > +			      gpa_t nested_ipa, size_t map_size)
> > > > +{
> > > > +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> > > > +	gpa_t canonical_ipa_end;
> > > > +	u64 entry, new_entry = 0;
> > > > +
> > > > +	lockdep_assert_held_read(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
> > > > +
> > > > +	if (mmu->nested_revmap_broken)
> > > > +		return;
> > > > +
> > > > +	if (WARN_ON(!IS_ALIGNED(canonical_ipa, map_size)))
> > > > +		canonical_ipa = ALIGN_DOWN(canonical_ipa, map_size);
> > > > +
> > > > +	canonical_ipa_end = canonical_ipa + map_size - 1;
> > > > +	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
> > > > +
> > > > +	mtree_lock(revmap_mt);
> > > > +	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> > > > +
> > > > +	if (entry) {
> > > > +		/* parallel faults can be adding the same mapping */
> > > > +		if (valid_entry(entry) &&
> > > > +		    mas_rmap.index == canonical_ipa &&
> > > > +		    mas_rmap.last == canonical_ipa_end &&
> > > > +		    nested_ipa == (entry & ADDR_MASK))
> > > > +			goto unlock;
> > > > +		/*
> > > > +		 * Create a "UNKNOWN_IPA" range that spans all the overlapping
> > > > +		 * ranges and store it.
> > > > +		 */
> > > > +		while (entry && mas_rmap.index <= canonical_ipa_end) {
> > > > +			canonical_ipa = min(mas_rmap.index, canonical_ipa);
> > > > +			canonical_ipa_end = max(mas_rmap.last, canonical_ipa_end);
> > > > +			entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> > > > +		}
> > > > +		new_entry |= UNKNOWN_IPA;
> > > > +	} else {
> > > > +		new_entry |= nested_ipa;
> > > > +		new_entry |= VALID_ENTRY;
> > > > +	}
> > > > +
> > > > +	mas_set_range(&mas_rmap, canonical_ipa, canonical_ipa_end);
> > > > +	if (mas_store_gfp(&mas_rmap, xa_mk_value(new_entry),
> > > > +			  GFP_NOWAIT | __GFP_ACCOUNT))
> > > 
> > > The general pattern for handling this situation would be to preallocate
> > > nodes prior to acquiring the lock. If we can preallocate then we can
> > > just outright refuse to create a shadow stage-2 mapping if the update to
> > > the reverse map fails.
> > 
> > Preallocation was thought about, but it was found to be impractical in
> > this case [*], mainly because we must hold the lock in order to know
> > what range to store.
> 
> Could we perform an RCU-protected walk to predict the range we intend to
> store and preallocate based off of that? And if we're not able to
> preallocate from a sleepable context then bailing to userspace seems
> appropriate.

I agree it's much better if we can allocate from a sleepable context,
however I see a few concerns in this case:

1. It needs to happen before kvm_fault_lock(), where some of the fault
   information is still unknown, mostly the THP adjustment is not done
   yet.

2. The nested kvm_s2_mmu array, which contain the maple trees, could be
   freed without holding mmu_lock (kvm_vcpu_init_nested()).

3. If we use RCU, we still can't preallocate with a sleepable flag
   because we would be holding rcu_read_lock().

4. Caching maple tree state while holding rcu_read_lock() and try
   preallocating after dropping the lock would also not work, because
   mas_preallocate() walks the tree therefore it must be protected from
   tree writers. And also (2.).

> 
> > However, we can make this function return an error when storing to the
> > maple tree fails, and just not do the shadow mapping. This ties the
> > wellness of the maple tree to guest progress. For repeated failure I
> > think of these possibilities:
> > 
> >  - The maple tree code is somehow broken that stores never succeed.
> >  - We have so little available memory that maple tree stores don't
> >    succeed.
> > 
> > These cause the guest fault repeatedly, but do we still care about the
> > guest when these happen? Probably not for the OOM case, and it solves
> > itself when the kernel gets back memory. For the first case I'm not so
> > sure, and I might have missed some other important possibilities.
> 
> So there's two failure modes that we need to handle.
> 
> The most common case would be a race to update the maple tree, where the
> preallocation we did outside of the MMU lock is insufficient for the actual
> operation we perform. Typically in the event of a race we restart the faulting
> instruction and re-attempt the fault. So long as you pass gfp=0 to the
> store, you can reinterpret -ENOMEM as -EAGAIN and refault.
> At that point, any non ENOMEM failure to store in the maple tree can be
> treated as fatal for the VM, KVM_BUG_ON() and out to userspace.

From the above, I don't think sleepable preallocation is feasible, at
least without invasive changes. Even if we somehow solve problem 2.
above, we'll probably need a new stateless preallocation API from the
maple tree (to avoid walking the tree without any locks), or start using
an external sleepable lock for the maple tree.

With this information, would the current no preallocation approach be
preferrable, or do we want to pursue sleepable preallocation anyway?

> 
> > > > +static void unmap_mmu_cipa_range(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
> > > > +				  size_t unmap_size, bool may_block)
> > > > +{
> > > > +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> > > > +	gpa_t canonical_ipa_end = canonical_ipa + unmap_size - 1;
> > > > +	size_t entry_size;
> > > > +	gpa_t next_addr;
> > > > +	u64 entry;
> > > > +	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
> > > > +
> > > > +	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
> > > > +
> > > > +	if (mmu->nested_revmap_broken) {
> > > > +		reset_revmap_and_unmap(mmu, may_block);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	if (!mmu->nested_stage2_enabled) {
> > > > +		kvm_stage2_unmap_range(mmu, canonical_ipa, unmap_size, may_block);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	mtree_lock(revmap_mt);
> > > > +	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> > > > +
> > > > +	while (entry && mas_rmap.index <= canonical_ipa_end) {
> > > > +		entry_size = mas_rmap.last - mas_rmap.index + 1;
> > > > +		next_addr = mas_rmap.index + entry_size;
> > > > +		/*
> > > > +		 * Give up and invalidate this s2 mmu if the unmap range
> > > > +		 * touches any UNKNOWN_IPA range.
> > > > +		 */
> > > > +		if (unknown_ipa_entry(entry)) {
> > > > +			mtree_unlock(revmap_mt);
> > > > +			reset_revmap_and_unmap(mmu, may_block);
> > > > +			return;
> > > > +		}
> > > > +
> > > > +		/*
> > > > +		 * Ignore result, it is okay if a reverse mapping erase
> > > > +		 * fails.
> > > > +		 */
> > > > +		mas_store_gfp(&mas_rmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
> > > 
> > > I wonder if we can handle this a bit more gracefully.
> > > 
> > > Ideally we'd be able to place a search mark on the entry flagging it as
> > > stale which could be used to avoid attempting to overinvalidate the
> > > shadow stage-2.
> > > 
> > > Interestingly enough, Liam recently gave the suggestion [*] of storing
> > > XA_ZERO_ENTRY for a similar use case where erasure happens in an atomic
> > > context. We should be able to do the exact same thing here and push the
> > > cleanup to the next insertion.
> > 
> > I see. Not saying I have a better idea, but this is relying on the fact
> > that replacing an existing range with another value does not require
> > memory allocation. I would say this is an obvious assumption and I don't
> > see it becoming false in the future, but still it's an implementation
> > detail and relying on it as a user feels strange...
> > 
> > What do you think?
> 
> I believe there's value in such an approach because it reduces the
> likelihood of a false positive. Since we could be updating the maple
> tree as part of reclaim I think it's safe to assume the system is under
> some amount of memory pressure (and GFP_NOWAIT could fail). Although I
> agree, it'd be good to document this behavior explicitly.

Sure, this is doable.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Oliver
