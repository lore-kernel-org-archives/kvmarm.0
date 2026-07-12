Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3033FE33
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783870165; cv=none; b=cA0byMlOQErMMvD9Y4bbvcoufN3IBkyjx7ozIDVNcqTYAw5oOi19Is+Cmba5VRsJMSH3qcbLHDFr930oz3D4CCwPA7O52H8bTJkcxgSUxdWYqik3nqoI+3n4morogrpSJPXBbVOX3Cq6TjoXWcNYm1UQmu8JoQSHNqdj6VPXCZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783870165; c=relaxed/simple;
	bh=HoZm1K0Vxq8QHY4OY0M4l3Gq05opjZyzIxiVdYJMT64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYk9XYb8lN2xxl5lqNSECQdJ5/+7hPbAbypvYdrhJbCZR1ZLE/8sqd6uLa03qowvddOr0MZNrry2N8EBa+I/ZqY6/nPsMVJJe5Yg1hzAhvOaxfmCxDeJpu1jZDcUWmKGCIzE3oZPrWOYBXYUxBUK0zFFiHygtd6SecftpiB8v+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GDcdk/ls; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GDcdk/ls"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c556ada3so57565e9.0
        for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 08:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783870162; x=1784474962; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EB4yDpb44w+GJHdAYOL5yRV8WP3HkDbon7ZVHvgT3yQ=;
        b=GDcdk/lstbPRrqtei+2HPYtqxHS5vlKveCKG84Q+2qC8Cj6GvWU0ddu/QfuNzwYtXB
         dFyC5p4cVFnO7fmESsn9Wt9Db+aev+SMHQvHDBLZuqQ8Zs+YAh1e+NbW9Qf/idHeY9E1
         J1bth6azhCesJlJ6Gy/Pue0b2kP9B9lqcJnjixvihAQYVYkKvJpEy+HlHRlK4bkuA4tY
         57hoXV3cF8zMapjPdHypLIahFvtfK2RNG2A6kPDQUD0MZoFplB5zrDE10uWIQK6hTUyn
         Rp+VZhI+bpDV5PIwiw78FcrNBnuM5gf+RmpSL1HwcvI9dyzOFyXTJlbCTZ3aHO8hN8VE
         C6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783870162; x=1784474962;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EB4yDpb44w+GJHdAYOL5yRV8WP3HkDbon7ZVHvgT3yQ=;
        b=QxUgylv23L2Zj4EsGSvw9jpOs4jcsJv9ltQjEoj+OpP+hNG/80htvtmeNoljN/GCHe
         gOU4QwMVeOQX77kl+OTz7lD+ve6liF+AgQ5CHxEXpTTyxwhdxxVXEnoRRppzsPSOs7o5
         +0YJg5iEXdpRuKSJ8c2VWGlf4aHmWNQtBhO6nK8ZMsMpZ8nDMIV6TncNIPnZBrrWK8SH
         cEbM+zIqncnHuanKYO+5bdWErde+m5hE5QE++HbW4nl7pMIkc0U+H7eHOhnt/T6UZYrm
         oD66HGihvn23ULypbxGNzaw2DX3AdmL+Ciqo8bQv4p3X1YlhcgksLt6VSoDJqwSGEsT9
         Hu+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrDhruz+mNmZIdDSIAx7OYv9yKTcq3lYN7FRwf/bKozmFTU+uPcB2eC3g0KVIx7z2FngR09TNM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0UxsHlNlYiYlgJsBO8PpvuupYbP4PeVRsKAyFpU0n82om5qjP
	RuELwyeQlMuN83lJpNm9CwoGBHDRMNMy9g+VlLNnY1L2/xmKHZJ7FwYHO/30+pHaUQ==
X-Gm-Gg: AfdE7clvc5MPKugm/gLZV8hp4JA/X5Flwc6Ypfqt+NBOl9DCifb9bPpeM/WHrVntUUV
	7YGXmh0dKFn2wgtdtJGo6qL2xTRAz9DU2br0Tl63t5bib57GSUq/M4yaRWJdJ12qV/Lq2JrTex9
	WwZXSf0F8R5S5jhd/nVgBymH2/GbLzHPt4c5RfL7uz3RJB4rU6nyX65n2gnU1D3wrVqXtmbDBh4
	mWQovc3QTfsAohChVeCI7pC78KNknHDeSfvy3bsXZmLVOq7hGAYfPchDFL9UXZ0OGeMIGe1Cthk
	vweLW7oycq2slLpfMfdhl78kftscRcdxz/F5JHMgbKMzVLQcdTCaxwbxc7e1G/TVxIjYk3k+6O0
	EgkNI4EUoc6jAHSclPxJq4wHxZFid6vqmItaYtMNagTB8iq4DIVwU9G9kekeZbTHsRUmelCKwmN
	MJ/b8nJso7iFr0oKSN/TliBPfi/OkFay9p+bwlIAVzOhtAJjlH
X-Received: by 2002:a05:600c:8889:20b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-493f856ecc9mr2162265e9.4.1783870161311;
        Sun, 12 Jul 2026 08:29:21 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm297830905e9.13.2026.07.12.08.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:29:20 -0700 (PDT)
Date: Sun, 12 Jul 2026 15:29:16 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 02/25] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <alOyzOL16dhYk724@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-3-smostafa@google.com>
 <alEnH98wFppYjmnE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alEnH98wFppYjmnE@google.com>

On Fri, Jul 10, 2026 at 06:08:47PM +0100, Vincent Donnefort wrote:
> On Fri, May 01, 2026 at 11:19:04AM +0000, Mostafa Saleh wrote:
> > Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> > drivers can protect and access the MMIO of IOMMUs.
> > 
> > As donating MMIO is very rare, and we don’t need to encode the full
> > state, it’s reasonable to have a separate function to do this.
> > It will init the host s2 page table with an invalid leaf with the owner ID
> > to prevent the host from mapping the page on faults.
> > 
> > Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> > stage-2 PTEs, as this can be triggered from recycle logic under memory
> > pressure. There is no code relying on this, as all ownership changes is
> > done via kvm_pgtable_stage2_set_owner()
> > 
> > For the error path in IOMMU drivers, add a function to donate MMIO
> > back from hyp to host. However, that leaks the hypervisor virtual
> > address range which should be acceptable as this is quite rare and
> > it matches the behaviour of fix_map/block.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 119 +++++++++++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c                  |   9 +-
> >  3 files changed, 121 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 3cbfae0e3dda..ff440204d2c7 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -36,6 +36,8 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> >  int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> >  int __pkvm_host_unshare_hyp(u64 pfn);
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr);
> > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
> 
> Can we have u64 pfn, u64 nr_pages here to match all the other functions?
> 

I see the convention is that phys_addr_t is used for physical addresses
as (addr_is_memory(), host_stage2_idmap_locked(()...) while u64 is used
for pfn.

> Also, as this is used by a "module" perhaps a sort of kerneldoc would be nice,
> especially to explain this isn't mapped into the hyp idmap range.

Sure I can add a comment.

> 
> >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 28a471d1927c..2fb20a63a417 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -353,6 +353,38 @@ int __pkvm_prot_finalize(void)
> >  	return 0;
> >  }
> >  
> > +/* Unmap MMIO region while skipping donated PTEs. */
> > +static int host_stage2_unmap_mmio_region(u64 start, u64 size)
> > +{
> > +	struct kvm_pgtable *pgt = &host_mmu.pgt;
> > +	u64 unmap_start = start;
> > +	u64 addr = start;
> > +	kvm_pte_t pte;
> > +	int ret = 0;
> > +	u8 level;
> > +
> > +	while (addr < start + size) {
> > +		ret = kvm_pgtable_get_leaf(pgt, addr, &pte, &level);
> > +		if (ret)
> > +			return ret;
> > +		if (!kvm_pte_valid(pte) && pte != 0) {
> > +			if (addr > unmap_start) {
> > +				ret = kvm_pgtable_stage2_unmap(pgt, unmap_start,
> > +							       addr - unmap_start);
> > +				if (ret)
> > +					return ret;
> > +			}
> > +			addr += kvm_granule_size(level);
> > +			unmap_start = addr;
> > +		} else {
> > +			addr += kvm_granule_size(level);
> > +		}
> > +	}
> > +	if (addr > unmap_start)
> > +		ret = kvm_pgtable_stage2_unmap(pgt, unmap_start, addr - unmap_start);
> 
> Ah shame, that's a lot of table walking. I guess we could:
> 
>  * create our own custom walker here but that would duplicate a lot of logic
>    from pgtable.c. So doesn't look great.

Yes, that seems too complicated.

> 
>  * Retry kvm_pgtable_stage2_unmap() as long as it return -EPERM... but then we
>    it needs to return where it has stopped?

Yes, that is not possible with its current interface.

> 
>  * Modify kvm_pgtable_stage2_unmap() to just skip the refcounted entries?
>    There's already a flag something that looks like this: KVM_PGTABLE_WALK_IGNORE_EAGAIN
> 

I thought about this, my main concern is that now any unmap will fail
silently if it hits a refcounted page. Propably not too bad as that only
is used in recycling.

> I am not so convinced by the first two points but the last one is probably worth
> exploring.
>  
> > +	return ret;
> > +}
> > +
> >  static int host_stage2_unmap_dev_all(void)
> >  {
> >  	struct kvm_pgtable *pgt = &host_mmu.pgt;
> > @@ -363,11 +395,11 @@ static int host_stage2_unmap_dev_all(void)
> >  	/* Unmap all non-memory regions to recycle the pages */
> >  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> >  		reg = &hyp_memory[i];
> > -		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> > +		ret = host_stage2_unmap_mmio_region(addr, reg->base - addr);
> >  		if (ret)
> >  			return ret;
> >  	}
> > -	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
> > +	return host_stage2_unmap_mmio_region(addr, BIT(pgt->ia_bits) - addr);
> >  }
> >  
> >  /*
> > @@ -1087,6 +1119,89 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  	return ret;
> >  }
> >  
> > +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr)
> > +{
> > +	kvm_pte_t pte;
> > +	u64 offset;
> > +	int ret;
> > +
> > +	/* Only before de-privilege. */
> > +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > +		return -EPERM;
> > +
> > +	if (!PAGE_ALIGNED(addr | size))
> > +		return -EINVAL;
> 
> Would be nice here to have pfn_range_is_valid() even though this is only
> used by modules? (ditto __pkvm_hyp_donate_host_mmio())

Will do.

> 
> > +
> > +	ret = __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr);
> > +	if (ret)
> > +		return ret;
> 
> Perhaps better to do it once it's been annotated into the host s2, so that we
> don't burn the private range in case of failure.

This really should not fail, or the system is already have bigger
problems, and that also does not allocate much space (128K), I see
that is easier to do this way than having to fix the host stage-2
if the allocation fails.

> 
> > +
> > +	host_lock_component();
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> > +		if (addr_is_memory(addr + offset)) {
> > +			ret = -EINVAL;
> > +			goto unlock;
> > +		}
> > +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> > +		if (ret)
> > +			goto unlock;
> > +		if (pte && !kvm_pte_valid(pte)) {
> > +			ret = -EPERM;
> > +			goto unlock;
> > +		}
> > +	}
> > +	/*
> > +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> > +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> > +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> > +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> > +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> > +	 */
> > +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > +			      addr, size, &host_s2_pool,
> > +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> > +unlock:
> > +	host_unlock_component();
> > +	return ret;
> > +}
> > +
> > +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> > +{
> > +	kvm_pte_t pte;
> > +	u64 offset;
> > +	int ret = 0;
> > +
> > +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > +		return -EPERM;
> > +
> > +	if (!PAGE_ALIGNED(addr | size))
> > +		return -EINVAL;
> > +
> > +	host_lock_component();
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> > +		if (addr_is_memory(addr + offset)) {
> > +			ret = -EINVAL;
> > +			goto unlock;
> > +		}
> > +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> > +		if (ret)
> > +			goto unlock;
> > +		if (!pte || kvm_pte_valid(pte)) {
> > +			ret = -EINVAL;
> > +			goto unlock;
> > +		}
> 
> It should probably verify it is also mapped as we expect into the hyp.

I thought about that, but the caller is be trusted and I was aiming
for simplicity, so the check for PKVM_ID_HYP seemed enough, but no
strong opinion.

> 
> 
> > +		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
> > +			ret = -EPERM;
> > +			goto unlock;
> > +		}
> > +	}
> > +	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
> 
> Perhaps we are better of simply zapping the entry and not map it proactively?

I do not think it matters that much, this is a failure path, and the
space is too small anyway. But no strong opinion also.

> 
> And even if we can't "reclaim" the VA-space from the private range, it would be
> good to unmap it. I have made a function for that as part of the allocator
> series:
> 
> https://lore.kernel.org/all/20260706175415.2604046-3-vdonnefort@google.com/
>
I do not think that is a big problem at the moment all the other
users of the VA space leak it on failure, I can re-use this logic
when the allocator seires lands, otherwise I'd avoid adding more code.

Thanks,
Mostafa


