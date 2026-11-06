Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794000373;
	b=BM3rZuxvUcKv9/VnSr7qe0XxOLOuKSnfTal14aFVwCdhViwwcS63QGLDCTM8IZvAWfeE
	 KfSJvtYpUcZ2oD53/fdolztMRj4EBjmtuF7YXBL++Dx1FXsaFs8owpipyzQYxT4gfxclT
	 vl9g2pt2q81lfjC3lg83Zno1cmFj4LFFt2GRyqlE3Cicn36SickKRluEvRCqvl0sj6d7N
	 0/N6D8mTwFWwvID6p/8bRLGbnazrhLi+hLWbgrnw9Ts6HlHe/GnnRfoc6PepboWnCo5hJ
	 6YxPf9c1sxHDBS+chxcafqAFI7KX6FSdILF/LdEnKDolLONr5rVkakDjGTwiSw6HUEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794000373;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vIkavoY4n/2ifojsD/pwpTnMH3j6uXS6/wlgJxw81VE=;
	b=b9+x4hsFGnhRbTOWKYoxcn/cbt8uy7ajLkjTXIiuMEtcSw6tg+iKNA3591iCI7uZ4eKs
	 05su/EfSRN4PguaTfrfVCzvHOlnXYHJkx/gjlYOFw1vve5ERz44oe/ycVnGaGBqPGTkqL
	 F2BTdMaQXWqtgalS7wNCgiar+G4N+UmgWm0PmT+I84N3neglqo/L47aPnHmCQ2qe3JCVX
	 y9t7UM3pjm1GuqxUsywbn6+pDM4kyq3l2XzkOsQi5sdV62cfnyA/v8iWvsajpQ+ohZeqH
	 b06lG5Qzm9cNPIJRhV0neM8YyBUZ0iMF/V7bXby7RkSUSOUii3HKI4uH0LuyQU5gjng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLSXzEqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F37606A32D;
	Fri,  6 Nov 2026 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLSXzEqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4014A1F0089F;
	Fri,  6 Nov 2026 21:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794000372;
	bh=vIkavoY4n/2ifojsD/pwpTnMH3j6uXS6/wlgJxw81VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mLSXzEqytKd5xOzhWK/7DPCd+wkjNKWraYbdGNRjsbxHiBOB7iaCjWYF19lLfDACb
	 Qh7BNN/QRCXTlmlPBfD/4li4uunFL30UF1mB2d4Z/d8h8RlZx08UKHYQcFvw2MW07a
	 RZNC90e6px/yu5qR5ZZdBh3XroPMSrfbsEhLE+O6HDB/hRxBychLISO2GVyon3ym8X
	 h6FCfb+PcdEyZ69+8iR5bqThT9CuzGf4vhL9Gt9uC1BffCM3FTXs9qlvwvcYcqpBmI
	 XzdcjXKXmKae/T/QkyP2XF5ITYsq8ASOfr+VVgg+r5RnRA7qAxJ4N22a1jmyf9ztD9
	 59taTtPSojrpw==
Date: Fri, 6 Nov 2026 13:26:10 -0800
From: Oliver Upton <oupton@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com, xuheng@cs.columbia.edu,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v3] KVM: arm64: Use consistent type for pool size
Message-ID: <au5F8u4onNe-KtyM@kernel.org>
References: <20261106172750.2678873-1-smostafa@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106172750.2678873-1-smostafa@google.com>

On Fri, Nov 06, 2026 at 05:27:49PM +0000, Mostafa Saleh wrote:
> All the pool sizes in the hypervisor are "unsigned long" but when
> they get passed to hyp_early_alloc_contig() or hyp_pool_init() they get
> truncated to 32-bits.
> 
> That is not a big problem at the moment as to overflow this we need
> 4G bytes of carveout (2 TB of host or guest system memory).
> 
> However when new users are added (as IOMMU) it is hard to reason
> about the carveout size anymore.
> 
> Fixes: e75960408723 ("KVM: arm64: Introduce an early Hyp page allocator")
> Fixes: 8e17c66249e9 ("KVM: arm64: Introduce a Hyp buddy page allocator")
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 2 +-
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 6 +++---
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
> index dc61aaa56f31..462883c4e325 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
> @@ -7,7 +7,7 @@
>  void hyp_early_alloc_init(void *virt, unsigned long size);
>  unsigned long hyp_early_alloc_nr_used_pages(void);
>  void *hyp_early_alloc_page(void *arg);
> -void *hyp_early_alloc_contig(unsigned int nr_pages);
> +void *hyp_early_alloc_contig(unsigned long nr_pages);
>  
>  extern struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
>  
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> index 3766333bace9..3a428dc40b14 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -29,6 +29,6 @@ void hyp_get_page(struct hyp_pool *pool, void *addr);
>  void hyp_put_page(struct hyp_pool *pool, void *addr);
>  
>  /* Used pages cannot be freed */
> -int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> -		  unsigned int reserved_pages);
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
> +		  unsigned long reserved_pages);
>  #endif /* __KVM_HYP_GFP_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> index 00de04153cc6..9fef0c7d2185 100644
> --- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> @@ -21,7 +21,7 @@ unsigned long hyp_early_alloc_nr_used_pages(void)
>  	return (cur - base) >> PAGE_SHIFT;
>  }
>  
> -void *hyp_early_alloc_contig(unsigned int nr_pages)
> +void *hyp_early_alloc_contig(unsigned long nr_pages)
>  {
>  	unsigned long size = (nr_pages << PAGE_SHIFT);
>  	void *ret = (void *)cur;
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index 57f86aa0f82f..51460d420c94 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -229,12 +229,12 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
>  	return hyp_page_to_virt(p);
>  }
>  
> -int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> -		  unsigned int reserved_pages)
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
> +		  unsigned long reserved_pages)
>  {
>  	phys_addr_t phys = hyp_pfn_to_phys(pfn);
>  	struct hyp_page *p;
> -	int i;
> +	unsigned long i;
>  
>  	hyp_spin_lock_init(&pool->lock);
>  	pool->max_order = min(MAX_PAGE_ORDER,
> -- 
> 2.56.0.455.g6c5a503b38-goog
> 
