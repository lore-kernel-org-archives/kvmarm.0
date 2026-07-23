Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C07B4570CE
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820586; cv=none; b=m0jplNVZr9Q2F/dWAVHGh7qiDddIHgwV/d5clnglkrTJKs+Tux64CR5rejpiYAQ+B7R2aHKt57cKwf+yUi/R/x5fmW/6zSdazxuIC5CpV0YSIvaBJMDs7SJw85wR6q9fN6iF8+y4ywT4GeE6g0fXBP41W5TDKD3zL8GOD8K4wFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820586; c=relaxed/simple;
	bh=b+Dy8uMnMtF4EY2uXcTzTNWGbKJO4obdHHaMV4tsUV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtGJpBvkBnrkvqCNvcQeEttvHOPVWg1IiLZb2TNJBlZPmg48mdjqEeBZpKOh99m7EGPRm/kh+eWRzufIqSXjZ+0J3DrvOvKun/RQrpiw5uQhzW+6e38tqvT7cyB7kVPrl8YKlMfVxvn4VrBFYr3w8H6dpbEcVL75UXv1rSAk378=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Edm/Lj6Z; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Edm/Lj6Z"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954d5d814fso75705e9.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784820582; x=1785425382; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=az69NFcHQRpQtQpk0RYT0bOWRtpe4QIe7DhS238fcTI=;
        b=Edm/Lj6ZhE7/HcmhmZgf3LupXBe2K836ItqMXdYK09JPpdyD1ni8O11d5QjpoNN760
         IxHA0MIMah8MyfXm1t78PngDMn9dWtpQGoLl9wCpM46pYo9K4DagCmeAVUFcctRKVQjp
         VS9n+zzhaFYwZu273PBWGmA6ENAYuntkEgR332JYIx4qSoHt4yd55GV22llqkVanN95x
         iWkAMbCCBA8jZUxdgxnMdFOeOyyPDt6ZtlfoBrHKlgOt+rO19i9JmXvxbzo5nrbjzgZp
         rcNFNsatyutS6Bm7MLRrLOSkY12cr34C1bFJBZr3h3eQ3TfxTzMnTS11RP3zCiO6fCAi
         Ax9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784820582; x=1785425382;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=az69NFcHQRpQtQpk0RYT0bOWRtpe4QIe7DhS238fcTI=;
        b=L7Q2QStvblER46UEiHxbQO+7RA4jNdu9f+mfv+eevZkX1lxE+WX4iQ/ecmADSa0/fn
         Rn3pjQzzls/9Ot5rhd94SgvbVvxxvFNASHuftXDJS7gIm6kebFF1FURN9Mh8s9Z1d/t1
         TPyOa1xl+4cLcBUsfoa9tD5iPBgdENmHAF8X+GVE3Vq8jT6Dxn5WrrUgOz2vJa5ZzV5t
         Oix1bpSrrCNxsS5DteayYIIg3GzJDqPfQwdwfd9wW0JozCRVqBSKUV8YJIEad8xINXPi
         Q8g7kmEqiiYNSg9I004F9EiUv855WnorZYc1DVS9RDie9pd5bqpMigdTB3CtzsH3YoG/
         TNLw==
X-Forwarded-Encrypted: i=1; AHgh+RqBTfQxbonpw9YNcVTQ79HpEa7Kjd+Spwsab7U0lfR6NR/4nnWrPFIhkQsmrJ+dMsuupy9aF/U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmF5mdz2m99DrPlptkWgD4ykQZwwVDjW5jJfTb8g8fy35Xegig
	49AE3FZxiF1/dj46kd934LbV6ugUvcj51kwp1I+3Uj2GcTV3F3zt+qG0b+w1d95BoA==
X-Gm-Gg: AR+sD13wxP4pwXUkKb/TMiLgi3KGZCAlLRjgxyu0djuagwQXz+PFupbBuVFRDrU5ugW
	bR32i6SzeMfkMcfX+hB0Y8InXSc4r0YD18nVCA4CVZlDgMm/Wd+tmDogvkUClFQKXC9yl9x0DTq
	J33WKZ3MTGJbGiCsLwNesEMZFddw2BmiZRNqQUMHMxU7vSH17H/SOHN6ys586Ams5+05/8YKjLQ
	H4NArOEIYEQgaxVoTJkzlfBtqnOedPjlGy+pbPKBpZK72Um211rylwBQWWlEW0dD+PII9NZr3dt
	uyevRwhs/qBAHbXk7a4trwmOqXrxjzK2netYW2Sf5NAyPVlH614YsO354ejgg80TLVNur9aLc4n
	dAuOCj+Q39uSg6afoD4dA4iBXlstreyBwoJKsLYfVYrmDyZ0SPgZDvEMNq6yT7QKFVTF8w3y4Ol
	yCpg2O+2Xc0HdXvcjotKq/GgWyWWY+URR52wtSwyH9Ltk=
X-Received: by 2002:a05:600c:25a:b0:495:4593:616c with SMTP id 5b1f17b1804b1-49573dbe5f0mr1298465e9.1.1784820581451;
        Thu, 23 Jul 2026 08:29:41 -0700 (PDT)
Received: from google.com (145.16.38.34.bc.googleusercontent.com. [34.38.16.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531afsm15860709f8f.24.2026.07.23.08.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:29:40 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:29:37 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, keirf@google.com
Subject: Re: [PATCH v7 07/24] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <amIzYUiVWGoepmkG@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-8-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715115906.2664882-8-smostafa@google.com>

On Wed, Jul 15, 2026 at 11:58:48AM +0000, Mostafa Saleh wrote:
> Create a page-table for the IOMMU that shadows the host CPU stage-2
> to establish DMA isolation.
> 
> An initial snapshot is created after the driver init, then
> on every permission change a callback would be called for
> the IOMMU driver to update the page table.
> 
> There are 3 different ways to add the callback:
> 1) In the high level memory transitions: (__pkvm_host_donate_hyp(),
>   __pkvm_host_donate_guest()...
> 
> 2) In Lower level functions covering all transitions
>   - host_stage2_set_owner_metadata_locked() which covers:
>    - __pkvm_host_donate_hyp()
>    - __pkvm_host_donate_guest()
>    - __pkvm_host_donate_hyp()
>    - __pkvm_guest_unshare_host()
>   - host_stage2_set_owner_locked() only for ID_HOST which covers:
>    - __pkvm_hyp_donate_host()
>    - __pkvm_host_force_reclaim_page_guest()
>    - __pkvm_host_reclaim_page_guest()
>   - __pkvm_guest_share_host()
> 
> 3) In the lowest level function __host_update_page_state(), which
>    requires only one callback. However, in that case the page state
>    is not enough as we might need to know the old state also.
> 
> Option #2 was implemented here.
> 
> For some cases, an SMMUv3 may be able to share the same page-table
> used with the host CPU stage-2 directly.
> 
> However, this is too strict and requires changes to the core hypervisor
> page-table code, plus it would require the hypervisor to handle IOMMU
> page-faults. This can be added later as an optimization for SMMUV3.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   4 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
>  arch/arm64/kvm/hyp/nvhe/iommu.c               | 129 +++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  27 ++--
>  4 files changed, 145 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> index df3d0cc5d4db..857d7dd2ebc3 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> @@ -3,11 +3,15 @@
>  #define __ARM64_KVM_NVHE_IOMMU_H__
>  
>  #include <asm/kvm_host.h>
> +#include <asm/kvm_pgtable.h>
>  
>  struct pkvm_iommu_ops {
>  	int (*init)(void);
> +	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);

Hi Mostafa,

Maybe host_stage2_idmap_locked, since it is invoked while the host
stage-2 lock is acquired ?

>  };
>  
>  int pkvm_iommu_init(void);
>  
> +int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
> +				 enum kvm_pgtable_prot prot);
>  #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 51b0eb3844a9..99b821b3cf65 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -59,6 +59,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct
>  int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
>  
>  bool addr_is_memory(phys_addr_t phys);
> +
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
> index ef456eff42d2..08009609ec59 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
> @@ -4,16 +4,137 @@
>   *
>   * Copyright (C) 2022 Linaro Ltd.
>   */
> +#include <linux/iommu.h>
> +#include <asm/kvm_pkvm.h>
> +
>  #include <nvhe/iommu.h>
> +#include <nvhe/mem_protect.h>
> +#include <nvhe/spinlock.h>
>  
>  /* Only one set of ops supported */
>  struct pkvm_iommu_ops *pkvm_iommu_ops;
>  
> -int pkvm_iommu_init(void)
> +/* Protected by host_mmu.lock */
> +static bool pkvm_idmap_initialized;
> +
> +static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
>  {
> -	/* Keep DMA isolation optional. */
> -	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
> +	int iommu_prot = 0;
> +
> +	if (prot & KVM_PGTABLE_PROT_R)
> +		iommu_prot |= IOMMU_READ;
> +	if (prot & KVM_PGTABLE_PROT_W)
> +		iommu_prot |= IOMMU_WRITE;
> +
> +	/* We don't understand that, might be dangerous. */
> +	WARN_ON(prot & ~PKVM_HOST_MEM_PROT);
> +	return iommu_prot;
> +}
> +
> +/*
> + * IOMMU page tables are shadowed and not shared, that is mainly because:
> + * - Possible inconsistency between IOMMU and CPU features or format.
> + * - KVM relies on handling in page faults (BBM, lazy mapping).
> + */
> +static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
> +				  enum kvm_pgtable_walk_flags visit)
> +{
> +	u64 start = ctx->addr;
> +	u64 block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
> +			kvm_granule_size(ctx->level);
> +	u64 end = min(ctx->end, block_end);
> +	kvm_pte_t pte = *ctx->ptep;
> +	bool is_memory = *(bool *)ctx->arg;
> +	int prot;
> +
> +	/*
> +	 * Keep annotated PTEs unmapped, and map everything else even lazily
> +	 * mapped PTEs(0), as the IOMMU can't handle page faults.
> +	 * That maps the whole address space which can be large, but that doesn't
> +	 * use a lot of memory as it will be mostly large block (1 GB with 4kb pages)
> +	 */
> +	if (pte && !kvm_pte_valid(pte))
>  		return 0;

>  
> -	return pkvm_iommu_ops->init();
> +	if (kvm_pte_valid(pte))
> +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> +	else
> +		prot = IOMMU_READ | IOMMU_WRITE;

If it's invalid in the host stage-2 why do you make it read/write in the IOMMU
? Shouldn't it be an invalid descriptor in the IOMMU pagetables as well
?

> +
> +	if (!is_memory)
> +		prot |= IOMMU_MMIO;
> +
> +	return pkvm_iommu_ops->host_stage2_idmap(start, end, prot);
> +}
> +
> +static int pkvm_iommu_snapshot_host_stage2(void)
> +{
> +	struct kvm_pgtable *pgt = &host_mmu.pgt;
> +	bool is_memory;
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= __snapshot_host_stage2,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= &is_memory,
> +	};
> +	int ret = 0, i;
> +	u64 start = 0;
> +
> +	hyp_spin_lock(&host_mmu.lock);
> +	for (i = 0; i < hyp_memblock_nr; i++) {
> +		struct memblock_region *reg = &hyp_memory[i];
> +
> +		if (start < reg->base) {
> +			is_memory = false;
> +			ret = kvm_pgtable_walk(pgt, start, reg->base - start, &walker);
> +			if (ret)
> +				goto out_unlock;
> +		}
> +
> +		is_memory = true;
> +		ret = kvm_pgtable_walk(pgt, reg->base, reg->size, &walker);
> +		if (ret)
> +			goto out_unlock;
> +
> +		start = reg->base + reg->size;
> +	}
> +
> +	if (start < BIT(pgt->ia_bits)) {
> +		is_memory = false;
> +		ret = kvm_pgtable_walk(pgt, start, BIT(pgt->ia_bits) - start, &walker);
> +		if (ret)
> +			goto out_unlock;
> +	}
> +
> +	pkvm_idmap_initialized = true;
> +
> +out_unlock:
> +	hyp_spin_unlock(&host_mmu.lock);
> +	return ret;
> +}
> +
> +int pkvm_iommu_init(void)
> +{
> +	int ret;
> +
> +	/* Keep DMA isolation optional. */
> +	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
> +	    !pkvm_iommu_ops->host_stage2_idmap)
> +		return 0;

Shouldn't this scream or return not supported ? 

> +
> +	ret = pkvm_iommu_ops->init();
> +	if (ret)
> +		return ret;
> +
> +	return pkvm_iommu_snapshot_host_stage2();

If pkvm_iommu_snapshot_host_stage2() fails would you have to provide a
->deinit() corresponding callback ?

> +}
> +
> +int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
> +				enum kvm_pgtable_prot prot)
> +{
> +	hyp_assert_lock_held(&host_mmu.lock);
> +
> +	if (!pkvm_idmap_initialized)
> +		return 0;
> +
> +	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d803b3dd4cb4..ce610274bda0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -17,6 +17,7 @@
>  
>  #include <nvhe/arm-smccc.h>
>  #include <nvhe/gfp.h>
> +#include <nvhe/iommu.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> @@ -596,16 +597,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
>  	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
>  			      addr, size, &host_s2_pool,
>  			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> -	if (!ret) {
> -		/*
> -		 * After stage2 maintenance has happened, but before the page
> -		 * owner has changed.
> -		 */
> -		pkvm_sme_dvmsync_fw_call();
> -		__host_update_page_state(addr, size, PKVM_NOPAGE);
> -	}
> -
> -	return ret;
> +	if (ret)
> +		return ret;
> +	/*
> +	 * After stage2 maintenance has happened, but before the page
> +	 * owner has changed.
> +	 */
> +	pkvm_sme_dvmsync_fw_call();
> +	__host_update_page_state(addr, size, PKVM_NOPAGE);
> +	return pkvm_iommu_host_stage2_idmap(addr, addr + size, 0);
>  }
>  
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> @@ -618,8 +618,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>  			return -EPERM;
>  
>  		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
> -		if (!ret)
> -			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> +		if (ret)
> +			break;
> +		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> +		ret = pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_HOST_MEM_PROT);
>  		break;
>  	case PKVM_ID_HYP:
>  		ret = host_stage2_set_owner_metadata_locked(addr, size,
> @@ -1022,6 +1024,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>  				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
>  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
>  	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
> +	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
>  unlock:
>  	guest_unlock_component(vm);
>  	host_unlock_component();
> -- 
> 2.55.0.141.g00534a21ce-goog
> 
