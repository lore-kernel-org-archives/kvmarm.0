Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C1537649B
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785078741; cv=none; b=sShhAmwKHj4tYMlJbssROvzoPkVg0gaE1A1b2RTLLDDIIbel24tcCvp2mPD/9fYsbburGk+hy5rEIhImFdf+Sqmy24u6KaQ+aTJbHHsNrUJ0eoRZjtja0E24wnBWX0OXGeK5Xqf02pvHTOppFLsB81QrtFlNjfarT/WtpuO415Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785078741; c=relaxed/simple;
	bh=/3IqU8U7xo/f3YRNu9UJOEHpiOSv7EJ3A0fLAu88gsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pk9xiTMGb6WSIWfTzVGUnpbocyiVhlO4c5dDh2O8cZvQLkfV82KUs2sgrZ0bDkoBj/VALq4Vzm7lBNRcnNWIu0jMAPywRlUmHWA9v3wTwUede5S4Y+Ae6LAMzqIlhIJ8+p4VGqLktOkaQsvC8vo3yV7/dxxUzReI6t02t6EgHi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ed5an+kq; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ed5an+kq"
X-Forwarded-Encrypted: i=1; AHgh+Rq04SYzY14Ak7bt+ewiCo3U7yZbp1EjwWu+osV0+hvBRQ6lupkQunumGE6AEX5g7sPEJTbJ6Io=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785078736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zizj9Zfv80ZephJVTwvLABE7brgFhnhJjP5l+ivAlo4=;
	b=Ed5an+kqGfwD8pBRDUXWeBKBsbqyVmLvrFKqhTAJfynLyPvexo+F73bMmj8QwUoj4Ili72
	0+G8FYIDZkiA/0vIZjvl+q/vB+QChys3ijEtkpflDTeoODXywoDrWxCRJZWqgBiHGZIr5c
	fXlaimpL8T99gyKRVyZB/fK54xMIISA=
X-Gm-Message-State: AOJu0YykWMIL8kaNFBrGHIumxRZ45W9yGqB0lyNS1E/n6Mx+7fI0TrcY
	Bjw4ydTWDW3efYlkW5g9FFct/EZuBJsPXWaqRX1dtsYDK/KoMNsuYiK2csUTjkMc9w5W1KyEhg5
	GNf0eOAgH2AhVJ4KyTqlKRrSWJ7fAKwD+k0CXfmKE
X-Received: by 2002:a05:622a:e198:20b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-529a5c1acfamr21067511cf.0.1785078726501; Sun, 26 Jul 2026
 08:12:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715150125.2798116-1-smostafa@google.com>
In-Reply-To: <20260715150125.2798116-1-smostafa@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 26 Jul 2026 16:11:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyhFhooFDUsjEu_9TDkiPeOrFZLE4PEL7gFvf6Lk9ShOA@mail.gmail.com>
X-Gm-Features: AUfX_mwy3jWyH-Tvwq789eUPJlNX89fkyt2UCwKxTp-OL1P5nSI-YyRYDYs6HZQ
Message-ID: <CA+EHjTyhFhooFDUsjEu_9TDkiPeOrFZLE4PEL7gFvf6Lk9ShOA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use consistent type for pool size
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Wed, 15 Jul 2026 at 16:01, Mostafa Saleh <smostafa@google.com> wrote:
>
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
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
> For example in the SMMUv3 to avoid this overflow, I add a cap
> for the pools size to UINT_MAX to work around this:
> https://lore.kernel.org/linux-iommu/20260715115906.2664882-9-smostafa@google.com/
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
> -                 unsigned int reserved_pages);
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
> +                 unsigned long reserved_pages);
>  #endif /* __KVM_HYP_GFP_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> index 00de04153cc6..9fef0c7d2185 100644
> --- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> @@ -21,7 +21,7 @@ unsigned long hyp_early_alloc_nr_used_pages(void)
>         return (cur - base) >> PAGE_SHIFT;
>  }
>
> -void *hyp_early_alloc_contig(unsigned int nr_pages)
> +void *hyp_early_alloc_contig(unsigned long nr_pages)
>  {
>         unsigned long size = (nr_pages << PAGE_SHIFT);
>         void *ret = (void *)cur;
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index 57f86aa0f82f..51460d420c94 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -229,12 +229,12 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
>         return hyp_page_to_virt(p);
>  }
>
> -int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> -                 unsigned int reserved_pages)
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
> +                 unsigned long reserved_pages)
>  {
>         phys_addr_t phys = hyp_pfn_to_phys(pfn);
>         struct hyp_page *p;
> -       int i;
> +       unsigned long i;
>
>         hyp_spin_lock_init(&pool->lock);
>         pool->max_order = min(MAX_PAGE_ORDER,
> --
> 2.55.0.141.g00534a21ce-goog
>
