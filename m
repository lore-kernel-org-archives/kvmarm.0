Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948553A961E
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 07:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784878205; cv=none; b=buXwnq886lgrk/R44uzZV5N2VK9QXwy5EiOWSOlmB8iLYgNkCCk7AqtYPVU63KlUzy3F9t5du+5KESmySfJ87p1wfpDVFUXSjGDub4QjWTywQDVrD/f2TdGR9kTbfKh6En6r/ynU5k5O1g6K28vLUrEvP+7iQMnD+r5zverxKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784878205; c=relaxed/simple;
	bh=yY+6nGGoC7SvCNPy9+SB9sPivvMfP9TGKwCk8wJLH3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auLQiMPUjSEhQB+wfVpE86R7JbpH0Xojy2FCvfnxkhmAe7OHUdan8fwSVbJa9yOX6OSfWkq3+XSyoXMNmTotkb4/0Bc524ciLSNOABGoViHoHkVm74+sV6YRJ5OfqySqT6rnRMoarsLNQBTZhfbK3AEon0EhOem1NGqu3qzS/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QEXs8C3k; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QEXs8C3k"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954bb689dfso14185e9.1
        for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 00:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784878201; x=1785483001; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FQTURpMAeObF7dJ+XksltfWeYZ6LOjkjOUPDqZ3O/F4=;
        b=QEXs8C3kP4F0IQ8dvH8QzalCiXp20fTTldVSXs1A5BpVpsrHBlbHviz5VjrjTRj/+d
         R/Pz79mEYTLf72vHvaP3F12b10kVLQKma9RL6NFthEzhjabylAcEVDoOmme9/jhTXD3k
         v3xM4GWqQKymkwQqaAfJtO1a2q16J9CiPnn9IBZ2D/XdPijS7c8F/mcthbCwFMQBOC8T
         RjqLWV/fAjHs5Fz/5iSMbfqYslIIJhqbFfRKz5bYdxfGxRWXrNm2mP0Vyfy90elzvC/X
         uIh13H19+OIZnOh8dhYQUpR9v56zsM2ZXb3n7+v0vB8HBIg+uwzkqKycwryhq4uSf1uZ
         3WVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784878201; x=1785483001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQTURpMAeObF7dJ+XksltfWeYZ6LOjkjOUPDqZ3O/F4=;
        b=aug1F9zfTrrKCkUxuTQfk1DN2WRh+ffL9vQWvT1VgWguMozYCYzDykS1BbJcn07vJr
         1LrtXFbnu3OxeIpn13phvp7yqexGGVLgbozY3D2XyPLrkDG9pQOqfJDuSLyS7L+2Zw6V
         VqMQIooW9XJf76+SZ2p+plIoOy8RI1Vml79byPdFKdromFXxOMMRDq8rkSDbadm+vZfi
         6AkZej1X8pgPs+VO8NQ0MgdYI0Z3LSldxiToaFMNAo9XB01Grb2z4FLEHMe1tHngDGQE
         YqMTvUUE8TsGLE2wiNvpJJSRy5HcGcX3l6LpSkaiaLpPwDzOpIQhy0R5VxM6v60CfASr
         /RmA==
X-Forwarded-Encrypted: i=1; AHgh+RoLaZarBtTOYIWVMSd/RHNPwhwRgUP0hhNRoJ4/10d5l+TJhO6oVNB9SaS51UwdMLnC+HuYylg=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywkt1KM+JbJl6eSqwAcocikG/ry/aseNSccwbrAeUlBjEYfhSgy
	XosA126Ev5PG4px9buc0VuPGOHm3ecML0dd8abYcFPO0iXT4ZHRZ947oPpjBlIicjg==
X-Gm-Gg: AR+sD11csFkNQtVib0t4Wx+XFPWyG82ZGYLF12hF0wGf0iNREoiwE4nl3gvM7udP4Hl
	iMKUeXrorBwh4h+P1LAezDUB63fxHfkCn1MD/tXOpCAgqW5s9dgmvI6opzuWSYYySZ3wc3C9PYZ
	akK8fEKVP4nidsFSsnKSMA2q1UYkYdYYlargHUNJnYIERqWLcmBZDme2kCf7uMTE9EFdt5Eces+
	eqz/y2AuR1nAwlkdMuXXuuSpoMUZ65ZHujcrgkgAjeQACWiTmzGrqxTOalnGV2BZ5tGx9/KWlYv
	/3OVBEzL0GK9CTrFZO9PF6tsswhlWKcg0a7QzE7DIVcERv3YLjwjnztE39m3cmrKa8M5uCaY/J4
	/aHTLuWAfR0c9W7ez0idPscoE6q3IstjDIDQQMWPaW44DECLRJqHer2B84dmOK0EwQf3y+bvULi
	lOPtU4M1yvwYigZAXySAufZlA4isrCuT+NJysTCpdrQCVm0IFO
X-Received: by 2002:a05:600c:5354:b0:493:b169:784d with SMTP id 5b1f17b1804b1-4957bce335cmr934215e9.8.1784878200153;
        Fri, 24 Jul 2026 00:30:00 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531basm21931338f8f.19.2026.07.24.00.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 00:29:59 -0700 (PDT)
Date: Fri, 24 Jul 2026 07:29:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, keirf@google.com
Subject: Re: [PATCH v7 07/24] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <amMUc79daKqAGNFM@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-8-smostafa@google.com>
 <amIzYUiVWGoepmkG@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIzYUiVWGoepmkG@google.com>

Hi Seb,

On Thu, Jul 23, 2026 at 03:29:37PM +0000, Sebastian Ene wrote:
> On Wed, Jul 15, 2026 at 11:58:48AM +0000, Mostafa Saleh wrote:
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > index df3d0cc5d4db..857d7dd2ebc3 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
> > @@ -3,11 +3,15 @@
> >  #define __ARM64_KVM_NVHE_IOMMU_H__
> >  
> >  #include <asm/kvm_host.h>
> > +#include <asm/kvm_pgtable.h>
> >  
> >  struct pkvm_iommu_ops {
> >  	int (*init)(void);
> > +	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
> 
> Hi Mostafa,
> 
> Maybe host_stage2_idmap_locked, since it is invoked while the host
> stage-2 lock is acquired ?

Vincent mentioned in earlier version that it can be called idmap()
also, I believe as this is not a function but a pointer, we do not
have over descirbe the name, but no strong opionion.

> 
> >  };
> >  
> >  int pkvm_iommu_init(void);
> >  
> > +int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
> > +				 enum kvm_pgtable_prot prot);
> >  #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 51b0eb3844a9..99b821b3cf65 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -59,6 +59,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct
> >  int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
> >  
> >  bool addr_is_memory(phys_addr_t phys);
> > +
> >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> >  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
> >  int kvm_host_prepare_stage2(void *pgt_pool_base);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
> > index ef456eff42d2..08009609ec59 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
> > @@ -4,16 +4,137 @@
> >   *
> >   * Copyright (C) 2022 Linaro Ltd.
> >   */
> > +#include <linux/iommu.h>
> > +#include <asm/kvm_pkvm.h>
> > +
> >  #include <nvhe/iommu.h>
> > +#include <nvhe/mem_protect.h>
> > +#include <nvhe/spinlock.h>
> >  
> >  /* Only one set of ops supported */
> >  struct pkvm_iommu_ops *pkvm_iommu_ops;
> >  
> > -int pkvm_iommu_init(void)
> > +/* Protected by host_mmu.lock */
> > +static bool pkvm_idmap_initialized;
> > +
> > +static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
> >  {
> > -	/* Keep DMA isolation optional. */
> > -	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
> > +	int iommu_prot = 0;
> > +
> > +	if (prot & KVM_PGTABLE_PROT_R)
> > +		iommu_prot |= IOMMU_READ;
> > +	if (prot & KVM_PGTABLE_PROT_W)
> > +		iommu_prot |= IOMMU_WRITE;
> > +
> > +	/* We don't understand that, might be dangerous. */
> > +	WARN_ON(prot & ~PKVM_HOST_MEM_PROT);
> > +	return iommu_prot;
> > +}
> > +
> > +/*
> > + * IOMMU page tables are shadowed and not shared, that is mainly because:
> > + * - Possible inconsistency between IOMMU and CPU features or format.
> > + * - KVM relies on handling in page faults (BBM, lazy mapping).
> > + */
> > +static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
> > +				  enum kvm_pgtable_walk_flags visit)
> > +{
> > +	u64 start = ctx->addr;
> > +	u64 block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
> > +			kvm_granule_size(ctx->level);
> > +	u64 end = min(ctx->end, block_end);
> > +	kvm_pte_t pte = *ctx->ptep;
> > +	bool is_memory = *(bool *)ctx->arg;
> > +	int prot;
> > +
> > +	/*
> > +	 * Keep annotated PTEs unmapped, and map everything else even lazily
> > +	 * mapped PTEs(0), as the IOMMU can't handle page faults.
> > +	 * That maps the whole address space which can be large, but that doesn't
> > +	 * use a lot of memory as it will be mostly large block (1 GB with 4kb pages)
> > +	 */
> > +	if (pte && !kvm_pte_valid(pte))
> >  		return 0;
> 
> >  
> > -	return pkvm_iommu_ops->init();
> > +	if (kvm_pte_valid(pte))
> > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > +	else
> > +		prot = IOMMU_READ | IOMMU_WRITE;
> 
> If it's invalid in the host stage-2 why do you make it read/write in the IOMMU
> ? Shouldn't it be an invalid descriptor in the IOMMU pagetables as well
> ?
> 

These are invalid and empty PTEs as a few lines up we return early for
invalid non-empty ones. For the empty PTEs, they are owned by the host
but lazily mapped. The IOMMU page table need to eagrly map those as it
can not handle page faults like the CPU.

> > +
> > +	if (!is_memory)
> > +		prot |= IOMMU_MMIO;
> > +
> > +	return pkvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > +}
> > +
> > +static int pkvm_iommu_snapshot_host_stage2(void)
> > +{
> > +	struct kvm_pgtable *pgt = &host_mmu.pgt;
> > +	bool is_memory;
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb	= __snapshot_host_stage2,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +		.arg	= &is_memory,
> > +	};
> > +	int ret = 0, i;
> > +	u64 start = 0;
> > +
> > +	hyp_spin_lock(&host_mmu.lock);
> > +	for (i = 0; i < hyp_memblock_nr; i++) {
> > +		struct memblock_region *reg = &hyp_memory[i];
> > +
> > +		if (start < reg->base) {
> > +			is_memory = false;
> > +			ret = kvm_pgtable_walk(pgt, start, reg->base - start, &walker);
> > +			if (ret)
> > +				goto out_unlock;
> > +		}
> > +
> > +		is_memory = true;
> > +		ret = kvm_pgtable_walk(pgt, reg->base, reg->size, &walker);
> > +		if (ret)
> > +			goto out_unlock;
> > +
> > +		start = reg->base + reg->size;
> > +	}
> > +
> > +	if (start < BIT(pgt->ia_bits)) {
> > +		is_memory = false;
> > +		ret = kvm_pgtable_walk(pgt, start, BIT(pgt->ia_bits) - start, &walker);
> > +		if (ret)
> > +			goto out_unlock;
> > +	}
> > +
> > +	pkvm_idmap_initialized = true;
> > +
> > +out_unlock:
> > +	hyp_spin_unlock(&host_mmu.lock);
> > +	return ret;
> > +}
> > +
> > +int pkvm_iommu_init(void)
> > +{
> > +	int ret;
> > +
> > +	/* Keep DMA isolation optional. */
> > +	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
> > +	    !pkvm_iommu_ops->host_stage2_idmap)
> > +		return 0;
> 
> Shouldn't this scream or return not supported ? 
> 

This was the case in the earlier versions, but I figured it would
regress so many setups, so I made DMA isolation optinal for now, I
think long term this can be a cmdline option. But t's up to the
maintainers how do they want to support this. I am happy to bring
the error return back.

> > +
> > +	ret = pkvm_iommu_ops->init();
> > +	if (ret)
> > +		return ret;
> > +
> > +	return pkvm_iommu_snapshot_host_stage2();
> 
> If pkvm_iommu_snapshot_host_stage2() fails would you have to provide a
> ->deinit() corresponding callback ?
> 

Good point, I tried to avoid having a deinit by making the IOMMU the
last thing done during setup as I did not want to make the patches
bigger.

Maybe WARN_ON() is enough for now? I need to think more about it.

Thanks,
Mostafa
