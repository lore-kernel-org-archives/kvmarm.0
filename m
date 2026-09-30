Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3F2F87B;
	Wed, 30 Sep 2026 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728518; cv=none; b=E5XF6CjzKV5t9jZ7nj1WLYhHHd8snPTKZj2D6GAV/ILIlJ2b2T/1MVqKM6N2PAYLNt9fZor/7W76YEpnN5HnT6mcOY0KATeQ6ZIL32o3ndJPDd2iRSaCQSssd7s/g0V2Muy0BZE+dLKOEJ30JksQ9p15di9Q6pfltzF1uW4JhLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728518; c=relaxed/simple;
	bh=zjkiyRqLL547noCZTyaXMFL+DbNJLuxp50YmxD4PJ2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+KdFo5YGGQ/to1eDxeiL7XDKU5L8Kp7p8jY79dtiU3xZ7DjfINDMrWHlBJC2zd+AIWvp6FeKNMUck64M1lxxpmob4BIfOBhj489B6EsWuxrpyD5Som7Yb2B79sLKiva6nSy8xT3JDkR7yOkdOPNnctRlLwHRhAS/y3gAKZsvE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7R0imuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7R0imuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C5E1F000FF;
	Wed, 30 Sep 2026 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790728517;
	bh=Cr6UdQKdI0xls4OlaLkP7rmWD8zhk3VYrwsH9krw7jM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y7R0imuU10TDOyA5h5xY8NunTH92rKR594grKtQDyTajkI0sTgxH0QtQqcpBT27uK
	 v/jDcULaKuymQGkyFvycV2q25HWMoizg99vQU9Ktr08NMf/k6gMLY7jzNc0T+/UEeV
	 9KMQ5hsKDvYFsxePGoJC5mTkxMk7mT1/w+3SYdIJc7Kuz/Ogzq74/VIHss+BdgO+Vg
	 vliQ6n3zIZJcT11CWqF7ymubvoOv5TXY6cpYQHc1LIJ70Bn9e5yvzlhDACFxCtMP9T
	 ilwweYwv9xkWcYcYpQ9cZjp6kp2+fUaixo6Z4pK8YLv3Ng4Nbkul7R6rHI9ANhZdSp
	 +ELyy7HJgVzpA==
Date: Tue, 29 Sep 2026 17:35:15 -0700
From: Oliver Upton <oupton@kernel.org>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	corbet@lwn.net, pbonzini@redhat.com, leo.bras@arm.com,
	yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com, caijian11@h-partners.com,
	liuyonglong@huawei.com, tangchengchang@huawei.com,
	yezhenyu2@huawei.com, yubihong@huawei.com, linuxarm@huawei.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, fuad.tabba@linux.dev,
	mark.rutland@arm.com, seanjc@google.com, rdunlap@infradead.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 02/15] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Message-ID: <arxZQwkLCLBnITzH@kernel.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-3-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929103655.85107-3-zhengtian10@huawei.com>

On Tue, Sep 29, 2026 at 06:36:42PM +0800, Tian Zheng wrote:
> @@ -731,8 +731,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> 
> -	if (prot & KVM_PGTABLE_PROT_W)
> -		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	if (prot & KVM_PGTABLE_PROT_W) {
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
> +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> +			attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	}

Can you introduce the dirty state first? You're temporarily setting
DBM+S2AP[1] as a workaround in the preceding patch.

Then we can have it encoded such that when FEAT_HAFDBS is implemented:

	KVM_PGTABLE_PROT_W	=> KVM_PTE_LEAF_ATTR_HI_S2_DBM
	KVM_PGTABLE_PROT_DIRTY	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W

And if FEAT_HAFDBS is *not* implemented:

	KVM_PGTABLE_PROT_W	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W
	KVM_PGTABLE_PROT_DIRTY	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W

i.e. aliasing both to bit 7.

Thanks,
Oliver

>  	if (!kvm_lpa2_is_enabled())
>  		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> @@ -753,9 +757,13 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
> 
>  	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
>  		prot |= KVM_PGTABLE_PROT_R;
> -	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> +	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM) {
>  		prot |= KVM_PGTABLE_PROT_W;
> 
> +		if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
> +			prot |= KVM_PGTABLE_PROT_DIRTY;
> +	}
> +
>  	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
>  	case 0b00:
>  		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
> @@ -1288,7 +1296,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>  int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> -					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
>  					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>  					NULL, NULL,
>  					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> @@ -1368,8 +1375,12 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> 
> -	if (prot & KVM_PGTABLE_PROT_W)
> -		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	if (prot & KVM_PGTABLE_PROT_W) {
> +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
> +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> +			set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	}
> 
>  	if (prot & KVM_PGTABLE_PROT_X) {
>  		ret = stage2_set_xn_attr(prot, &xn);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2d44cd6a5aed..698a87e85a6d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1221,7 +1221,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	struct kvm_pgtable *pgt = mmu->pgt;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>  				     KVM_PGTABLE_PROT_R |
> -				     (writable ? KVM_PGTABLE_PROT_W : 0);
> +				     (writable ?
> +				      (KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY) :
> +				      0);
> 
>  	if (is_protected_kvm_enabled())
>  		return -EPERM;
> @@ -1587,7 +1589,7 @@ static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nest
>  						       enum kvm_pgtable_prot prot)
>  {
>  	if (!kvm_s2_trans_writable(nested))
> -		prot &= ~KVM_PGTABLE_PROT_W;
> +		prot &= ~(KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY);
>  	if (!kvm_s2_trans_readable(nested))
>  		prot &= ~KVM_PGTABLE_PROT_R;
> 
> @@ -1658,7 +1660,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	}
> 
>  	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
> -		prot |= KVM_PGTABLE_PROT_W;
> +		prot |= KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY;
> 
>  	if (s2fd->nested)
>  		prot = adjust_nested_fault_perms(s2fd->nested, prot);
> @@ -1690,10 +1692,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	}
> 
>  out_unlock:
> +	/*
> +	 * Dirty the folio for any write-permitting mapping: hardware can
> +	 * promote a writable-clean entry to writable-dirty without a VM
> +	 * exit, so a clean release could lose a guest write at reclaim.
> +	 * The dirty bitmap is only marked for mappings installed dirty,
> +	 * or pre-copy would treat every writable page as dirty.
> +	 */
>  	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>  	kvm_fault_unlock(kvm);
> 
> -	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
> +	if ((prot & KVM_PGTABLE_PROT_DIRTY) && !ret)
>  		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
> 
>  	return ret != -EAGAIN ? ret : 0;
> @@ -1993,11 +2002,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> 
>  	*prot = KVM_PGTABLE_PROT_R;
> 
> -	if (s2vi->map_writable && (s2vi->device ||
> -				   !memslot_is_logging(s2fd->memslot) ||
> -				   kvm_is_write_fault(s2fd->vcpu)))
> +	if (s2vi->map_writable) {
>  		*prot |= KVM_PGTABLE_PROT_W;
> 
> +		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> +		    kvm_is_write_fault(s2fd->vcpu))
> +			*prot |= KVM_PGTABLE_PROT_DIRTY;
> +	}
> +
>  	if (s2fd->nested)
>  		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
> 
> @@ -2028,7 +2040,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  			    void *memcache)
>  {
>  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> -	bool writable = prot & KVM_PGTABLE_PROT_W;
> +	bool dirty = prot & KVM_PGTABLE_PROT_DIRTY;
>  	struct kvm *kvm = s2fd->vcpu->kvm;
>  	struct kvm_pgtable *pgt;
>  	long perm_fault_granule;
> @@ -2091,7 +2103,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  	}
> 
>  out_unlock:
> -	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> +	/*
> +	 * Speculative folio dirtying: W, not DIRTY, per the contract
> +	 * documented in kvm_release_faultin_page().
> +	 */
> +	kvm_release_faultin_page(kvm, s2vi->page, !!ret, prot & KVM_PGTABLE_PROT_W);
>  	kvm_fault_unlock(kvm);
> 
>  	/*
> @@ -2099,7 +2115,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  	 * making sure we adjust the canonical IPA if the mapping size has
>  	 * been updated (via a THP upgrade, for example).
>  	 */
> -	if (writable && !ret) {
> +	if (dirty && !ret) {
>  		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
>  		ipa &= ~(mapping_size - 1);
>  		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index b0cb8d84a9e9..a1251e252b4f 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -45,6 +45,12 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>  		.set	= "W",
>  		.clear	= " ",
>  	},
> +	{
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> +		.set	= "D",
> +		.clear	= "C",
> +	},
>  	{
>  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
>  		.val	= 0b00UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
> --
> 2.43.0
> 
