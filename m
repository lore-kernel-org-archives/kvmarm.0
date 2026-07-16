Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F27C3176E0;
	Thu, 16 Jul 2026 07:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784185532; cv=none; b=jIu90PRVh4q4oJmulQ2jhYHq+ARerGROh54s9dVi0VePvujaBd2Oc65beOfuoUv8XTSC3n6q6Y0+ULdfzdzrDYN0QsMeEEOMAB4NvOSgp04ORjvOUt1n+3GTuhuRGiwwwNrTCr6xRIzqCFO7E63xSy6WwDPTbaikNB9f/uMZF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784185532; c=relaxed/simple;
	bh=C9SCho6O4GCo0zlo/lLrXZoQsi9hF2JfVm6MDylRkFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3fpn1N01BcaUJjN09K99fRxSc1Sacdeg0AVFVs6duzodQA7TAP8JcTFR7kQYWaR8WKa6tLDcJpav7btvmys7o+nJdJJOIhICgMGHJxyVygvxul6OUL8MpI84MrMP90G84XFxOk+SS9LiDQy34JoXNkZjDhxJ4H8paQmdRuW+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSjg/wj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSjg/wj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC21F000E9;
	Thu, 16 Jul 2026 07:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784185531;
	bh=YopDoBUX3VUuGxZ98wWXcclxYcbXiMdcqqK+dQPjMV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PSjg/wj8XxdKXdQE3lrWqGi6vaA347qT/KZX2t3fM6cUrLFi8YTAij6RJ+XRsEUrl
	 32WckwFWrDHhE9FALOpwwtJUk+GeqryMmfYEEoVhi9NyNwB3k1PX8vmyYTJwRiNU9z
	 1Uo5XR+vmgwHkJnl95XrN1XdUalNVmEDhm/CR05hsJ/vchr53rIpFsWbG2lzVO3/L2
	 FHbYhufVVPDIqPaZysIhWPW2fOfIuLIjTafjQyWzSBKtfQ80iYb6UoA4MazUyb05LT
	 kbHRs7i9jamucUEZBbpNgMKirqOHqHxVyYZnOhN1XQqC+vAuiVGIjsmbNMpzMguY/3
	 KCh9sAVnCgfWA==
Date: Thu, 16 Jul 2026 00:05:29 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <aliCuX3ZIvxWlFE-@kernel.org>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
 <20260714115926.2044757-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714115926.2044757-3-weilin.chang@arm.com>

Hey,

On Tue, Jul 14, 2026 at 12:59:21PM +0100, Wei-Lin Chang wrote:
> +static bool valid_entry(unsigned long entry)
> +{
> +	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
> +	return entry & VALID_ENTRY;
> +}
> +
> +static bool unknown_ipa_entry(unsigned long entry)
> +{
> +	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
> +	return entry & UNKNOWN_IPA;
> +}

These should be WARN_ON_ONCE(), but I find the condition you're
asserting to be a bit confusing. An aliased reverse map entry is still a
valid entry, would you not set the valid bit?

> +void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
> +			      gpa_t nested_ipa, size_t map_size)
> +{
> +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> +	gpa_t canonical_ipa_end;
> +	u64 entry, new_entry = 0;
> +
> +	lockdep_assert_held_read(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
> +
> +	if (mmu->nested_revmap_broken)
> +		return;
> +
> +	if (WARN_ON(!IS_ALIGNED(canonical_ipa, map_size)))
> +		canonical_ipa = ALIGN_DOWN(canonical_ipa, map_size);
> +
> +	canonical_ipa_end = canonical_ipa + map_size - 1;
> +	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
> +
> +	mtree_lock(revmap_mt);
> +	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> +
> +	if (entry) {
> +		/* parallel faults can be adding the same mapping */
> +		if (valid_entry(entry) &&
> +		    mas_rmap.index == canonical_ipa &&
> +		    mas_rmap.last == canonical_ipa_end &&
> +		    nested_ipa == (entry & ADDR_MASK))
> +			goto unlock;
> +		/*
> +		 * Create a "UNKNOWN_IPA" range that spans all the overlapping
> +		 * ranges and store it.
> +		 */
> +		while (entry && mas_rmap.index <= canonical_ipa_end) {
> +			canonical_ipa = min(mas_rmap.index, canonical_ipa);
> +			canonical_ipa_end = max(mas_rmap.last, canonical_ipa_end);
> +			entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> +		}
> +		new_entry |= UNKNOWN_IPA;
> +	} else {
> +		new_entry |= nested_ipa;
> +		new_entry |= VALID_ENTRY;
> +	}
> +
> +	mas_set_range(&mas_rmap, canonical_ipa, canonical_ipa_end);
> +	if (mas_store_gfp(&mas_rmap, xa_mk_value(new_entry),
> +			  GFP_NOWAIT | __GFP_ACCOUNT))

The general pattern for handling this situation would be to preallocate
nodes prior to acquiring the lock. If we can preallocate then we can
just outright refuse to create a shadow stage-2 mapping if the update to
the reverse map fails.

> +		mmu->nested_revmap_broken = true;
> +unlock:
> +	mtree_unlock(revmap_mt);
> +}
> +
>  void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>  {
>  	/* CnP being set denotes an invalid entry */
>  	mmu->tlb_vttbr = VTTBR_CNP_BIT;
>  	mmu->nested_stage2_enabled = false;
>  	atomic_set(&mmu->refcnt, 0);
> +	mt_init(&mmu->nested_revmap_mt);
> +	mmu->nested_revmap_broken = false;
>  }
>  
>  void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> @@ -1225,6 +1305,89 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>  	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
>  }
>  
> +static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
> +{
> +	mtree_destroy(&mmu->nested_revmap_mt);
> +	mmu->nested_revmap_broken = false;
> +	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> +}
> +
> +static void unmap_mmu_cipa_range(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
> +				  size_t unmap_size, bool may_block)
> +{
> +	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> +	gpa_t canonical_ipa_end = canonical_ipa + unmap_size - 1;
> +	size_t entry_size;
> +	gpa_t next_addr;
> +	u64 entry;
> +	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
> +
> +	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
> +
> +	if (mmu->nested_revmap_broken) {
> +		reset_revmap_and_unmap(mmu, may_block);
> +		return;
> +	}
> +
> +	if (!mmu->nested_stage2_enabled) {
> +		kvm_stage2_unmap_range(mmu, canonical_ipa, unmap_size, may_block);
> +		return;
> +	}
> +
> +	mtree_lock(revmap_mt);
> +	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
> +
> +	while (entry && mas_rmap.index <= canonical_ipa_end) {
> +		entry_size = mas_rmap.last - mas_rmap.index + 1;
> +		next_addr = mas_rmap.index + entry_size;
> +		/*
> +		 * Give up and invalidate this s2 mmu if the unmap range
> +		 * touches any UNKNOWN_IPA range.
> +		 */
> +		if (unknown_ipa_entry(entry)) {
> +			mtree_unlock(revmap_mt);
> +			reset_revmap_and_unmap(mmu, may_block);
> +			return;
> +		}
> +
> +		/*
> +		 * Ignore result, it is okay if a reverse mapping erase
> +		 * fails.
> +		 */
> +		mas_store_gfp(&mas_rmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);

I wonder if we can handle this a bit more gracefully.

Ideally we'd be able to place a search mark on the entry flagging it as
stale which could be used to avoid attempting to overinvalidate the
shadow stage-2.

Interestingly enough, Liam recently gave the suggestion [*] of storing
XA_ZERO_ENTRY for a similar use case where erasure happens in an atomic
context. We should be able to do the exact same thing here and push the
cleanup to the next insertion.

[*] https://lore.kernel.org/all/iv7sxqezzz42xieytbf3lskutricz7ltkr3wii3w4jbnbzto7f@2tz5hwa43l37/

Thanks,
Oliver
