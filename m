Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3258481237
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136411; cv=none; b=bQ7r3zQTKCKdbd3d0lbFpkAyC0EOt3QpZs6G4XukyTZsYJ+viR2JuxomiWKpUNTedpdAaFRLbFH5hURJpB1k1XuPcuVJyqoz+D2a5uYVzCxeWU2ypNoPmeuQtn8mnuo82/EN1RjZapgRJFPeYMEzAmfSdz++Ks3pAqiT8u3LdOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136411; c=relaxed/simple;
	bh=tUcctyRTwkofjhoYeQq7+fPu2JUFAkLpOtqHV4sXxVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VI4FUHOsporMjgzcY60cdUBO6OjRZlk7DoBTVntSH2jzlmD+Xth/EOvZ1RNttIkiLwA/YcaqBJXFzy5sXjAZT4pYoZXNtKw+QppdTFdjqiLTeyjBXuWz38ABY7do6wSyZ9kLXuZHv/etTU4ZbnVAYKeDdAFMKMTfnRKjYPLPwPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EQADBJiL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EQADBJiL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so41172935e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784136404; x=1784741204; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PYuefCM79gXuAodISgJJBncvBoTe4PB5cbdqzkO39pc=;
        b=EQADBJiLK8QK6H0JmmtjXQbDFX8+mCvqkoUDLeaOxRC3aMaENr0zC0nn/u6yMD0Z43
         eK7SwjfzjbcsPqnmtyx84XaVvOmGFUgMjRVTF2WrWDfxW6KXrNm65mJYQ+iIzwmxFbwc
         QH6+QlXiD/zHaNaPWYMRa7i9QRD4QFl3x/edorHU4VreL8m0/RzbuUnghxzd23E4Jlo5
         CiO1OIOfGQqw8yaIwU/e+wdQse+1Se6vtXGimkRu+7zcIwy5/7Ei52+ynoILcOnlGUHa
         kdqTaH7nJNEunNddDwZsOtRFea/qwD5s9Oa74ZZ5DIkaf/P0QVG4unWl166Y8NfmBdww
         oZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784136404; x=1784741204;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PYuefCM79gXuAodISgJJBncvBoTe4PB5cbdqzkO39pc=;
        b=SPWVQVh0auzSwaHZ6s69JVV/wUPlF8TtdEgNY9nVlPGdQP4b8iA+EWdAjcyTqrb0Nc
         wl+upq9ta+fFcnQ/84K3A2oViaxeBVOeJ4/icQ9PoOZHc49SgSUGR/ZPIdtsT366gEse
         BRXCZ4Lw5EPoJcRY7/Ehqtb+U60lZuJMnIzpZEucvQ981oIZA3YB3u50DhiEhYwHZd50
         sAq19AIEUb8/HbHxAlkJes1hKzH0rPPyCdRnJpduFOk1mpsc7csRz6SKS3DmFVoR+P6P
         Ppw5YInhtqP4FvYB7WdECVYhfeybvEdG4avs3vyN3XKRXVYVywJmDM9tIqlktr+LaQQB
         76yg==
X-Forwarded-Encrypted: i=1; AHgh+RpcsJhYumT4+7V/GHX6KF76u/73tNEb3NTQxuVCGg2L7mbjaKMx8ofNDZlV2d90miiJmiFsPEM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDDgkll4SwrW6O/LWDKd2VlLoyStPVSM3zyHY/0WEIGOYEOXRN
	pm5krdszggdh1473qVRoB1Z0RFkvDmK5n/JKoMW57Pog3wk7fu8wp7++TjJ+NEYt1w==
X-Gm-Gg: AfdE7cnRu9qVcmlD64l42PW0yf/0mP455fJbkcka+dPRrx4fvZRaPXcf84lb4NwjlY3
	mmBMabr7c+sFck3ONC0ic4fS0KFRhmbOTD3YpaXonSRrDHFVDLcJHY0Dk5DQNWqkJK917GB7Wfd
	Hh1/9vOrDFZgdh5Y356Hx3IUHfZ83NHgANTKdAQ1yciS9H36ukSWVWtVKnMW0Frxbm/dKSLpDXB
	yUCfBHQYLfn/4Cq2gg5dfpZtUIX+Ymf2IasHz870UKIH5xt/bvqTuwTDhIaV+R2Zsl4eO3TOh/S
	AfNHJ6QMhhPtp9HMc2wBl44DhuQ4EjlFam7tnq2fC4lMDDBaHe/GgflDTVsVl6/msFqlmen8/sE
	6etGP1zDXYZUMWMICh1+6ea9iiCfhoWTNon3gS5dfshS7+/i8Rv+W8dNS/kwFDuDI/alp8M+Q2t
	Xpj0pbuw61w7aQCMA2FHECw6pU8QuZMH0EsSa6/K+Tclo6iMTJzBM=
X-Received: by 2002:a05:600c:8183:b0:495:4056:9473 with SMTP id 5b1f17b1804b1-49540569485mr13706785e9.28.1784136403312;
        Wed, 15 Jul 2026 10:26:43 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a322dc6sm171452445e9.10.2026.07.15.10.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 10:26:42 -0700 (PDT)
Date: Wed, 15 Jul 2026 18:26:39 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 02/24] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <alfCz_WQR_Al2lFw@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260715115906.2664882-3-smostafa@google.com>

On Wed, Jul 15, 2026 at 11:58:43AM +0000, Mostafa Saleh wrote:
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can protect and access the MMIO of IOMMUs.
> 
> As donating MMIO is very rare, and we don’t need to encode the full
> state, it’s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner ID
> to prevent the host from mapping the page on faults.
> 
> Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> stage-2 PTEs, as this can be triggered from recycle logic under memory
> pressure. There is no code relying on this, as all ownership changes is
> done via kvm_pgtable_stage2_set_owner()
> 
> For the error path in IOMMU drivers, add a function to donate MMIO
> back from hyp to host. However, that leaks the hypervisor virtual
> address range which should be acceptable as this is quite rare and
> it matches the behaviour of fix_map/block.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
>  3 files changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 29935c7da1de..51b0eb3844a9 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
>  int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> +/*
> + * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
> + * private range and unmapped from the host stage-2.
> + */
> +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr);
> +/* Remaps MMIO range in the host, typically used in error path. */
> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 4e329e39a695..d803b3dd4cb4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
>  	u64 addr = 0;
>  	int i, ret;
>  
> -	/* Unmap all non-memory regions to recycle the pages */
> +	/*
> +	 * Unmap all non-memory regions to recycle the pages.
> +	 * That relies on kvm_pgtable_stage2_unmap() not clearing
> +	 * counted PTEs which include hypervisor MMIO.
> +	 */
>  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
>  		reg = &hyp_memory[i];
>  		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> @@ -1119,6 +1123,91 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  	return ret;
>  }
>  
> +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size, unsigned long *haddr)
> +{
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret;
> +
> +	/* Only before de-privilege. */
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +		return -EPERM;
> +
> +	if (!PAGE_ALIGNED(addr | size) ||

You wouldn't need that with u64 pfn, u64 nr_pages :) 

> +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	ret = __pkvm_create_private_mapping(addr, size, PAGE_HYP_DEVICE, haddr);
> +	if (ret)
> +		return ret;
> +
> +	host_lock_component();
> +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> +		if (addr_is_memory(addr + offset)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> +		if (ret)
> +			goto unlock;

Is that called for big regions? because that looks quite inefficient even for
something that is init and IIRC we want to use this for GIC hardening too?

Perhaps it wouldn't be complicated to walk hyp_memory[] to make sure this
doesn't overlap any memory region. And then to reuse check_page_state_range() to
verify the host stage-2? 

> +		if (pte && !kvm_pte_valid(pte)) {
> +			ret = -EPERM;
> +			goto unlock;
> +		}
> +	}
> +	/*
> +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> +	 */

Not sure we want that level of detail, it will probably become stall very
quickly. Perhaps we can simply say "the annotation is refcounted and protects
this region until it is released with __pkvm_hyp_donate_host_mmio()" or
something like that?

Also that makes me think, do we want to add this to the ownership_selftest?

> +	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +			      addr, size, &host_s2_pool,
> +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> +unlock:
> +	host_unlock_component();
> +	return ret;
> +}
> +
> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> +{
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret = 0;
> +
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +		return -EPERM;
> +
> +	if (!PAGE_ALIGNED(addr | size) ||
> +	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	host_lock_component();
> +	for (offset = 0; offset < size; offset += PAGE_SIZE) {
> +		if (addr_is_memory(addr + offset)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> +		if (ret)
> +			goto unlock;
> +		if (!pte || kvm_pte_valid(pte)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
> +			ret = -EPERM;
> +			goto unlock;
> +		}
> +	}
> +	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
> +unlock:
> +	host_unlock_component();
> +	return ret;
> +}
> +
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 91a7dfad6686..3073184cf6ad 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1161,13 +1161,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	kvm_pte_t *childp = NULL;
>  	bool need_flush = false;
>  
> -	if (!kvm_pte_valid(ctx->old)) {
> -		if (stage2_pte_is_counted(ctx->old)) {
> -			kvm_clear_pte(ctx->ptep);
> -			mm_ops->put_page(ctx->ptep);
> -		}
> +	/*
> +	 * That also ignores stage2_pte_is_counted() instead of clearing
> +	 * the PTE as the MMIO can be owned by the hypervisor.

Not sure we should reference something pKVM specific in that code. Perhaps just
say we don't touch refcounted PTEs?


> +	 */
> +	if (!kvm_pte_valid(ctx->old))
>  		return 0;
> -	}
>  
>  	if (kvm_pte_table(ctx->old, ctx->level)) {
>  		childp = kvm_pte_follow(ctx->old, mm_ops);
> -- 
> 2.55.0.141.g00534a21ce-goog
> 
