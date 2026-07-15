Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340334A2E2E
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138202; cv=none; b=fP7MI2SBusML7jlURY7dj7aqE12Zbmxojr8xe44MJWFz1w5NPZqNAz2ufn8TNZpNlXoHCA7GNo9BKo0XWMCi3gm+3BsqJJPhdlKy26vCkTOOeRWtc1nk18uE+hKir9FAEfS2KEe3AWa2pFXKx4i+ghvgfUEtb4B+Vbr5ZcRTCR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138202; c=relaxed/simple;
	bh=xuSvc9yhBFGzX8mnmE6RyQN6QrXCLz6PDQHp+6SjUaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2Une2oDnUUibrz3ToKwPW4oFwbJUzk3qT2vOu8tJ5LZe/OlAoNTcXtYeHbiTBk+MZXyBuiLXlKxukJ64qQrlXPspuXNGfA0wZGR5OquM/hDyTtry9/jXT2m7IKo5gDCOELcYlQDARMycGA6rLopczos0fBQ+MvXpQdNLSwE3iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdPfcC2u; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdPfcC2u"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493c733f15aso51685785e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784138198; x=1784742998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0V1FTARVtoHKDhD2y26WaLiZ0OdS9Qk3q3wsxYlCeSQ=;
        b=QdPfcC2uy44DYLHkFIBNA5mrwqBvZ3NWP0GisFgbdSoZF7m35fMwQIt4AJQp+O+qeM
         7BRRDNqmBaDnsFnSTYUWZWtyW0s25RK74DQgk49UyJlxwcUl3oC1fXLk9A1qhff/I4nc
         uwRNVG/EEuiBSW2a11+YpUDtN1epp4EqANhYoDeL6ZrxmztxYL7clPJICWYRouvDD2fy
         U2EKGHyMcm0B/z+O+TOUTlCP9UpPKZqSfXAxT17VNq9+WnjI5k3TE+qaotKZIch+DMt9
         tqItnuSm2z3DWAP6tHfEeLNnxk1X6jnBYCTcJwmzT85RJ5sbBbWi4c7cAdNTDq0EWjDG
         FrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784138198; x=1784742998;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0V1FTARVtoHKDhD2y26WaLiZ0OdS9Qk3q3wsxYlCeSQ=;
        b=i26Q9RofDLJAqVl7/a1MkzqLRQY+ez+iSv7VWE81ruX7loqWsH0qu9pt4KJObPWvMB
         ADXt843ZQDuEmRWhq92rClCO1cciieA33MW5T1KtBLRs+BafXrRaL5Xl92nTXcBnfrLa
         ymqgUVw6vUu5mDVgX9kRUd4G0viPBZOt8Z4/3Fo55bGA0hvyHLK6Tlk4GVZLJ/WTlY+O
         th6glh4DukZsmYOqZtZjdYMPV+JeYFnE3iI5YWt7YCxGQWlzuIcgenEbjf70FagVG3j7
         i+8hvjzzn2ljVt29fui9+4FOhioBdt70+7Ffp46bcdNvfF2yneqEXo87SRXIHzbRn1fE
         Ls8w==
X-Forwarded-Encrypted: i=1; AHgh+RoM1G/M70UB9YjTuCaVnQGEtRS99c2gblhqosmeFpOe5KKVTxblfyu7XVfFkjd/IS7mdkmldME=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHTS2USwTiHrr3JVW2ePIkWAL5D6+7Fm4H5IOAJN5XvS2GNoAk
	kI7g+c+sa5M/Yj6P/KJBK/55UJq1cRJaCFOL8Hhzzc6x2j722yuxvYPdybQwdG28aQ==
X-Gm-Gg: AfdE7cmxhNk2/lw76TQxCV6COI6BW8GAUm4HPEWCsHEJVAq9x0q2alFQSEMqmWKVBJT
	f5DSpsFFtMfF601s0oSQf1IuQ66aT3hrWksBq1IjHRgiWHVjCOyP5Px1CdF5/Ie4UFrHl8YsUTt
	DVdwFJbf2AUA+W2wMCgpgIjtcW5fDulplx1BKOB/MruIQLCEioW9VTgSydKGBLeD5a1/4Pcx/qC
	nDWVEBjhtslAxFCKWNax0Y8NaXMH/rcc+SdKT8SLxpALoxdOHBuQSrhMZVhPTbLBgrYdaaLOMrh
	xhg2065Jb4IDjeBlb54Ym3qSXbLjSn+x9OK7NNAb0lvch6KtxUkCAYIy71kvZCNQ2OPt0YSzwRy
	toTZLr5h9t60e+ImSpz1q32VfN8kKt64WRqxXZP4sCyiJmaSYTUQdryl6GRV5gTmNPc4Uxb4Kjk
	wktTxKDzbI/m2VntLjPeNDPK2eoJqfEvETpSH6mmQFJxYdlJaa2cc=
X-Received: by 2002:a05:600c:a00b:b0:493:f261:d295 with SMTP id 5b1f17b1804b1-4953f1552bfmr26635515e9.4.1784138197915;
        Wed, 15 Jul 2026 10:56:37 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49508728019sm163467455e9.5.2026.07.15.10.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 10:56:36 -0700 (PDT)
Date: Wed, 15 Jul 2026 18:56:33 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 07/24] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alfJ0cLRSw-qmCrP@google.com>
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

nit: I believe that for more complex init like that we should just put it after
the declarations.

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

nit: You could have a helper? So is_memory isn't passed as a reference.

__snapshot_host_stage2(u64 start, u64 end, bool is_memory)

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
> +
> +	ret = pkvm_iommu_ops->init();
> +	if (ret)
> +		return ret;
> +
> +	return pkvm_iommu_snapshot_host_stage2();
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

Out of curiosity, why is it "host_stage2_idmap" and not just "idmap" ?

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

On error here the host stage-2 annotation needs to be reverted. Or just
WARN_ON() here. It also probably better to do it before the page-state has
changed, even if we hold the host stage-2 lock.

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

Ha ok I understand your remark yesterday. I thought you'd put
pkvm_iommu_host_stage2_idmap() into host_stage2_idmap_locked()... but then it
means it tries to map on very host abort. 

(same though as host_stage2_set_owner_metadata_locked(), I would first update
the iommu and then update the page-state)

>  unlock:
>  	guest_unlock_component(vm);
>  	host_unlock_component();
> -- 
> 2.55.0.141.g00534a21ce-goog
> 
