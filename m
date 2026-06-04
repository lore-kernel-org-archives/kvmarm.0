Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9C3DE42F
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 07:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780557872; cv=none; b=Ayx1xV+PHuShu3baIPKoA61ksAJk6YqsBvzJQamimFwS34FUNSV7jDSY9xdhsdHjjmmbqQMeTFfitOojtX5VUjAuBq80eAfh3ItKnhxPM3vbJu7ZYWusWMlJZHOQPnoAzxr68IapGld70ftLTC7UfB3o6gW3EPzkOQYgWmeOT8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780557872; c=relaxed/simple;
	bh=fB7K9r3Trq+v3XcBSrORUDLhFipTTIUjYItY0J3SAYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fixeLMrvuI/mOAXQjnIYWYp0KU3nq1hBm0dvgvKSOzraGxMHDLc8k+fRPa7aEO1jcFT5l5DWUL35Wfordmjriq/eeqKPfa5raFPwro7HPo6+qO9VqEhqY6LNg11fl3CZOHCLa3WsuwT3g46h+WWYwb5oPz8LTy2hdCJqt6/tvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=d6Vvo08L; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="d6Vvo08L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1780557870; x=1812093870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fB7K9r3Trq+v3XcBSrORUDLhFipTTIUjYItY0J3SAYM=;
  b=d6Vvo08LUfI6op6rTT0dljBTXSYXcWnDGfLllFqtgLFN4jlXZ01TPlvP
   nbxyleAAUNyVY44WvlIsrXZR2mLREKLVeysej5v6eJjNyALOtFzsnOUQd
   MVAYwJCf4KVZOf+NOnyN0L4wom90qinYN/Ppj1zaMUb5MSZWq/L+0Uxw2
   tzmGlUrPq6wMUbWKNrZ8aFu63O4dIL4R5QAvVOT+9e5MrB4zaCfwQq5F6
   E5zDaiUhd78/Oldj3Uu2oivPobPFU5Va5ZV4y4MtLBHslxH1rJD925NMi
   acj5rYiWvkrGZP3ylF8RIBJ/VXJ/DQNHSV5irPbVOp48cfgv3k1XwNKdt
   w==;
X-CSE-ConnectionGUID: PIe3CldVSmOO92umvzrMgg==
X-CSE-MsgGUID: BuyUBT5/SDuybWetS/+LSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="229152407"
X-IronPort-AV: E=Sophos;i="6.24,186,1774278000"; 
   d="scan'208";a="229152407"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 16:24:22 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 17017AD86
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 07:24:22 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id C1CE4C0C64A
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 07:24:21 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom4.fujitsu.com (Postfix) with ESMTPS id A69E22000747;
	Thu,  4 Jun 2026 07:24:16 +0000 (UTC)
Date: Thu, 4 Jun 2026 16:24:13 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: nv: Create nested IPA direct map to
 speed up reverse map removal
Message-ID: <aiEoHVeQn5qmxGpP@sm-arm-grace07>
References: <20260510145338.322962-1-weilin.chang@arm.com>
 <20260510145338.322962-6-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510145338.322962-6-weilin.chang@arm.com>

On Sun, May 10, 2026 at 03:53:38PM +0100, Wei-Lin Chang wrote:
> Iterating through the whole reverse map to find which entries to remove
> when handling guest hypervisor TLBIs is not efficient. Create a direct
> map that goes from nested IPA to canonical IPA so that the canonical
> IPA range affected by the TLBI can be quickly determined, then remove
> the entries in the reverse map accordingly.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |   5 ++
>  arch/arm64/kvm/mmu.c              |   9 ++-
>  arch/arm64/kvm/nested.c           | 124 ++++++++++++++++++++++--------
>  3 files changed, 104 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dc4c0bce1bbb..f9e95a023ec4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -226,6 +226,11 @@ struct kvm_s2_mmu {
>  	bool	nested_revmap_broken;
>  	/* canonical IPA to nested IPA range lookup */
>  	struct maple_tree nested_revmap_mt;
> +	/*
> +	 * Nested IPA to canonical IPA range lookup, essentially a cache of
> +	 * the guest's stage-2.
> +	 */
> +	struct maple_tree nested_direct_mt;
>  
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  	struct dentry *shadow_pt_debugfs_dentry;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ce0bd88cd3c1..77146431be6d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1101,6 +1101,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	struct kvm_pgtable *pgt = NULL;
>  	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;

Naming, do you prefer revmap over rmap?

> +	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
>  
>  	write_lock(&kvm->mmu_lock);
>  	pgt = mmu->pgt;
> @@ -1111,8 +1112,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	}
>  
>  	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
> -		if (!mtree_empty(revmap_mt))
> -			mtree_destroy(revmap_mt);
> +		if (!mtree_empty(revmap_mt) || !mtree_empty(direct_mt)) {
> +			mtree_lock(revmap_mt);
> +			__mt_destroy(revmap_mt);
> +			__mt_destroy(direct_mt);
> +			mtree_unlock(revmap_mt);
> +		}
>  		kvm_init_nested_s2_mmu(mmu);
>  	}
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 96b88d9c0c2a..fcb6a88047e1 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -45,14 +45,14 @@ struct vncr_tlb {
>  #define S2_MMU_PER_VCPU		2
>  
>  /*
> - * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
> - * layout:
> + * Per shadow S2 reverse & direct map maple tree payload layout:
>   *
> - * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
> + * bit  62:     valid, prevents the case where the address is 0 and turning
>   *              the whole value to 0
> - * bits 55-12:  nested IPA bits 55-12
> + * bits 55-12:  {nested, canonical} IPA bits 55-12
>   * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
> - *              IPA maps to this canonical IPA in the shadow stage-2
> + *              IPA maps to this canonical IPA in the shadow stage-2, only used
> + *              in reverse map
>   */
>  #define VALID_ENTRY		BIT(62)
>  #define ADDR_MASK		GENMASK_ULL(55, 12)
> @@ -787,37 +787,67 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 nested_ipa, size_t size)
>  {
>  	/*
> -	 * Iterate through the mt of this mmu, remove all canonical ipa ranges
> -	 * with !UNKNOWN_IPA that maps to ranges that are strictly within
> -	 * [addr, addr + size).
> +	 * For all ranges in direct_mt that are completely covered by the range
> +	 * we are TLBIing [gpa, gpa + size), remove the reverse map and its
> +	 * corresponding direct map together, when these conditions are met:
> +	 *
> +	 * 1. The reverse map is not UNKNOWN_IPA.
> +	 * 2. The reverse map is completely covered by the TLBI range.
> +	 * 3. The reverse map and the direct map are symmetric i.e. they map to
> +	 *    each other, with the same size.
> +	 *
> +	 * Symmetry must be checked because there are three places where the
> +	 * direct map could become inconsistent:
> +	 *
> +	 * 1. Direct map removal failure during an mmu notifier in
> +	 *    unmap_mmu_ipa_range().
> +	 * 2. Direct map insertion failure during an s2 fault in
> +	 *    kvm_record_nested_revmap().
> +	 * 3. Direct map removal failure during a previous call of this very
> +	 *    function.
>  	 */
>  	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> -	void *entry;
> -	u64 entry_val, nested_ipa_end = nested_ipa + size;
> -	u64 this_nested_ipa, this_nested_ipa_end;
> -	size_t revmap_size;
> -
> -	MA_STATE(mas_rev, revmap_mt, 0, ULONG_MAX);
> -
> +	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
> +	gpa_t nested_ipa_end = nested_ipa + size - 1;
> +	u64 entry_dir;
> +	struct mapping {
> +		u64 from;
> +		u64 to;
> +		size_t size;

entry_dir sounds like a directory related one, if entry_drect is too
long, perhaps entry_d? But it's up to you and Marc and Oliver.

Thanks,
Itaru.

> +	};
> +
> +	MA_STATE(mas_dir, direct_mt, nested_ipa, nested_ipa_end);
>  	mtree_lock(revmap_mt);
> -	mas_for_each(&mas_rev, entry, ULONG_MAX) {
> -		entry_val = xa_to_value(entry);
> -		if (entry_val & UNKNOWN_IPA)
> -			continue;
> -
> -		revmap_size = mas_rev.last - mas_rev.index + 1;
> -		this_nested_ipa = entry_val & ADDR_MASK;
> -		this_nested_ipa_end = this_nested_ipa + revmap_size;
> -
> -		if (this_nested_ipa >= nested_ipa &&
> -		    this_nested_ipa_end <= nested_ipa_end) {
> -			/*
> -			 * As the shadow stage-2 is about to be unmapped
> -			 * after this function, it doesn't matter whether the
> -			 * removal of the reverse map failed or not.
> -			 */
> +	entry_dir = xa_to_value(mas_find_range(&mas_dir, nested_ipa_end));
> +
> +	while (entry_dir && mas_dir.index <= nested_ipa_end) {
> +		struct mapping dir, rev;
> +		u64 entry_rev;
> +
> +		dir.from = mas_dir.index;
> +		dir.to   = entry_dir & ADDR_MASK;
> +		dir.size = mas_dir.last - mas_dir.index + 1;
> +
> +		/* Use ipa range to find the corresponding entry in revmap. */
> +		MA_STATE(mas_rev, revmap_mt, dir.to, dir.to + dir.size - 1);
> +		entry_rev = xa_to_value(mas_find_range(&mas_rev,
> +						       dir.to + dir.size - 1));
> +
> +		rev.from = mas_rev.index;
> +		rev.to   = entry_rev & ADDR_MASK;
> +		rev.size = mas_rev.last - mas_rev.index + 1;
> +
> +		/* The three conditions outlined above. */
> +		if (entry_rev && !(entry_rev & UNKNOWN_IPA) &&
> +		    dir.from >= nested_ipa &&
> +		    dir.from + dir.size - 1 <= nested_ipa_end &&
> +		    dir.from == rev.to &&
> +		    rev.from == dir.to &&
> +		    dir.size == rev.size) {
> +			mas_store_gfp(&mas_dir, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
>  			mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
>  		}
> +		entry_dir = xa_to_value(mas_find_range(&mas_dir, nested_ipa_end));
>  	}
>  	mtree_unlock(revmap_mt);
>  }
> @@ -826,9 +856,12 @@ void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
>  			      gpa_t fault_ipa, size_t map_size)
>  {
>  	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> +	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
>  	gpa_t ipa_end = ipa + map_size - 1;
> +	gpa_t fault_ipa_end = fault_ipa + map_size - 1;
>  	u64 entry, new_entry = 0;
>  	MA_STATE(mas_rev, revmap_mt, ipa, ipa_end);
> +	MA_STATE(mas_dir, direct_mt, fault_ipa, fault_ipa_end);
>  
>  	if (mmu->nested_revmap_broken)
>  		return;
> @@ -861,6 +894,15 @@ void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
>  	if (mas_store_gfp(&mas_rev, xa_mk_value(new_entry),
>  			  GFP_NOWAIT | __GFP_ACCOUNT))
>  		mmu->nested_revmap_broken = true;
> +
> +	/*
> +	 * Add direct map but ignore the result, missing a direct map does not
> +	 * affect correctness.
> +	 */
> +	if (new_entry & VALID_ENTRY && !mmu->nested_revmap_broken)
> +		mas_store_gfp(&mas_dir, xa_mk_value(ipa | VALID_ENTRY),
> +			      GFP_NOWAIT | __GFP_ACCOUNT);
> +
>  unlock:
>  	mtree_unlock(revmap_mt);
>  }
> @@ -872,6 +914,8 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>  	mmu->nested_stage2_enabled = false;
>  	atomic_set(&mmu->refcnt, 0);
>  	mt_init(&mmu->nested_revmap_mt);
> +	mt_init_flags(&mmu->nested_direct_mt, MT_FLAGS_LOCK_EXTERN);
> +	mt_set_external_lock(&mmu->nested_direct_mt, &mmu->nested_revmap_mt.ma_lock);
>  	mmu->nested_revmap_broken = false;
>  }
>  
> @@ -1250,7 +1294,10 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>  
>  static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
>  {
> -	mtree_destroy(&mmu->nested_revmap_mt);
> +	mtree_lock(&mmu->nested_revmap_mt);
> +	__mt_destroy(&mmu->nested_revmap_mt);
> +	__mt_destroy(&mmu->nested_direct_mt);
> +	mtree_unlock(&mmu->nested_revmap_mt);
>  	mmu->nested_revmap_broken = false;
>  	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
>  }
> @@ -1259,11 +1306,14 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
>  				  size_t unmap_size, bool may_block)
>  {
>  	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
> +	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
>  	gpa_t ipa = gpa;
>  	gpa_t ipa_end = gpa + unmap_size - 1;
> +	gpa_t nested_ipa, nested_ipa_end;
>  	u64 entry;
>  	size_t entry_size;
>  	MA_STATE(mas_rev, revmap_mt, gpa, ipa_end);
> +	MA_STATE(mas_dir, direct_mt, 0, ULONG_MAX);
>  
>  	if (mmu->nested_revmap_broken) {
>  		reset_revmap_and_unmap(mmu, may_block);
> @@ -1292,6 +1342,16 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
>  		 */
>  		mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
>  
> +		/*
> +		 * Try to also remove the direct map, it is okay if this fails,
> +		 * as we check for direct map consistency in
> +		 * kvm_remove_nested_revmap().
> +		 */
> +		nested_ipa = entry & ADDR_MASK;
> +		nested_ipa_end = nested_ipa + entry_size - 1;
> +		mas_set_range(&mas_dir, nested_ipa, nested_ipa_end);
> +		mas_store_gfp(&mas_dir, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
> +
>  		mtree_unlock(revmap_mt);
>  		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
>  				       may_block);
> -- 
> 2.43.0
> 
