Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8183C4BB288
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212542; cv=none; b=g3Vrrn9haXMZ7HlX+7P4bZb5OKVql8aWSX54TBQ0ONi42WRUM+AuIzDEjynLiXT4jT2M+tWMwyXuANx70h+2lbmGAse6YFsHTUPAJ2h+1Pm/jCVT9tqsz17y+VhI+1KjDdVR5avf4YhDUj12g5MfL3fciVk4TlrTyXGzHYj0GoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212542; c=relaxed/simple;
	bh=J3uLqr1bwxQ3KPBelR/UqUHMgCgoV6kG7kJMNY3ASQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dy8KvhSXmB6HiTRr0mwYwijdFftvXLLsN9nzfFaF+WHgUKSSLRzDpDb8jOcaOWzdCeVjHDyzAgU0IL3+1dImehr5EDVZb2fIdNvfxVgO6NzUXC/ff+ezQgJc3THvIyG47pPjtAM7bUv4nUK0p1D5iraMUyoiolixrNlZAYvxm3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kgifhqba; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kgifhqba"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d8239so16285175e9.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 08:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791212539; x=1791817339; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lQ07Wpw/41IyXuGwO1TNf2h3w/qx6ENdaCXlHUoPSxo=;
        b=kgifhqbaNwzRhZsX9BTmY4OtpJzv2k40We5pLBh8neHxO2/KEJfpzqdgZqk2VFb4/j
         7y/vHU70p5e0XGkyfbC06LXjzZtI8iLsXYXE7bPi/LK5Hzo54Ds5BdFsA1ylt/f6bMt4
         oFCSF5O0XWlzUjKBSuDi9RJjVfdV1TndXvME+ewFTI3DVNTRY504K1hzPEet05IfpPEf
         CKUakG0hcCilQmzL4lmSZg3niUth+0SrPvCMsF31mHVi67P8hyWTMBH/iuEzj7awhJl7
         +76F5dQ3APxu7YaKJK3F6Xxdf/MZ3FJHnYdrMVCpqlMT+VNqKp/WVt1fTMdBvqOzN3fm
         nAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212539; x=1791817339;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQ07Wpw/41IyXuGwO1TNf2h3w/qx6ENdaCXlHUoPSxo=;
        b=2ViPQJT95aVi6wsQHGHFzqe1RdLfqRwa6gR57OlXSNG7E2wyNazCriD4eeteHDD1P7
         hCy0cWUKbJCiX+I4mR8EyS4bkzYFcXg8ImFctF73e3kNY1lqdwVA79hUVaAdUoxuUdP/
         Jh6JQYPogfwopgMKSmEeI9pSCU6sIB+HUzLHetTq1EJQfFNs0KDQgN8CQGms3at5gwGz
         WvvuxeuTKQYLjgW+vY7ltl8ZU+l3o6ehB9ZP9UdxRycDBJ+hNl2MDtnYz+0iHlnaSmsN
         DAzmlNSbqRhdoyAZC4+VGHsrGhzKWmLIeRPLhivTFItB5EsvWvMs89ZN8gDhmPmnlxC2
         upUQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3oDgbHI5ZGgRambK5qv+FYB1VWu5LRmXgDapmnS+qrPks9IbPIspkpOeruS+seewVO//Vinw=@lists.linux.dev
X-Gm-Message-State: AFuF++kZ3clJiHPGG/YdQXeFkFgTdBz8or453xr3H3lxMUaiYr9fkFmI
	E1XwAb+aYyQIRDgPc3jsiRBqs1dvTJNLJLqXC/QAP5t6p431z8il8E9AWpS6kONbnw==
X-Gm-Gg: AYBFou1JEsdvh4vmfpBYMRbM8vopDOicinLPr4NlRlZ8l68N2R9HC6AYWlmxOABRPjI
	Zv/BuZCSeku5CO+/ebo5oO6ntWlASBeqrB+fF/SLSKYlIesxdHo7OrGuTBLNpVdbWappg+o9Mly
	yW6oqKsLBXnojSEI4OqTBtMrYVikwQ8eXBV5KDyo4zwnM07PwixvWjAEUYT6aukCNK4wPUzdMD3
	vditmRpUMvuR4d7SAx7eyLh+uB9Tu2bwSQyawOWnh+M4Bz6A5Tqp4IsHzrrbzo4kusu9U0XOkG8
	+G53UAXI+npLzuDuuLR8CKU6mdiAdAdVj/i9hfay/9TEyQlX1OsbrCubu5PGmAHCzThPrbL1YDf
	f3aZN3Iq+7qSXNL1FT5te+eQIMU0pbDya8RYroBzYLnHutiiqxUhcwgn5ToRDmCGrXf0Eo+Hbyt
	a0l4iAAna6LruAVUIpnBgYAUyrbE5t89k+J/u6LjfZzxbAX04KUIeGqsV4TVeyXlbyFcNQaOdfN
	MoSFg5vwnMCU3lQ3iTj9TWMsm+X/1H/fxtG/R5FQiE=
X-Received: by 2002:a05:600c:4e4e:b0:4a0:62d:4424 with SMTP id 5b1f17b1804b1-4a027566f93mr192858015e9.8.1791212537927;
        Mon, 05 Oct 2026 08:02:17 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1785398b5sm156955e9.2.2026.10.05.08.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:02:12 -0700 (PDT)
Date: Mon, 5 Oct 2026 16:02:06 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com,
	sebastianene@google.com, keirf@google.com, qperret@google.com,
	linu.cherian@arm.com
Subject: Re: [PATCH v3 2/2] KVM: arm64: Support BBM level 3
Message-ID: <asO77kvqqwCsJt8I@google.com>
References: <20260904132855.638117-1-smostafa@google.com>
 <20260904132855.638117-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904132855.638117-3-smostafa@google.com>

On Fri, Sep 04, 2026 at 01:28:55PM +0000, Mostafa Saleh wrote:
> If the system supports hardware Break-Before-Make (BBM) level 3, use it
> to replace stage-2 PTEs directly. Otherwise, fall back to the software
> BBM sequence.
> 
> For BBML3 the sequence is:
> 1) Get a reference count on the containing table for the new PTE.
> 2) Atomically update the PTE with the new valid descriptor.
> 3) Invalidate the TLB for the old PTE.
> 4) Drop the reference count holding the old PTE.
> 
> Add 2 helpers:
> 1) kvm_pgtable_use_bbml3(): Checks for the architecture requirement
>    for BBML3.
> 
> 2) stage2_use_bbml3(): Extra checks added by SW design (FWB and DIC)
>    - As BBML3 will update the PTE atomically, it can only know it
>      raced with another core at the point of the cmpxchg failing,
>      unlike the SW implementation which locks the PTE first.
>      And as we must issue CMOs to the new mapped page before the
>      update, that means with BBML3 racing cores will issue redundant
>      CMOs.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 111 ++++++++++++++++++++++++++++-------
>  1 file changed, 90 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d670da8882a5..a9ba761e9a01 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -82,6 +82,27 @@ static bool kvm_pte_table(kvm_pte_t pte, s8 level)
>  	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
>  }
>  
> +/*
> + * Check if BBML3 can be used for this PTE update.
> + * Fallback to software break-before-make for leaf-to-leaf changes.
> + */
> +static bool kvm_pgtable_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
> +				  kvm_pte_t new)
> +{
> +	if (!system_supports_bbml3())
> +		return false;
> +
> +	if (!kvm_pte_valid(ctx->old) || !kvm_pte_valid(new))
> +		return false;
> +
> +	/* Block <-> Table is ok. */
> +	if (kvm_pte_table(new, ctx->level) ||
> +	    kvm_pte_table(ctx->old, ctx->level))
> +		return true;
> +
> +	return false;
> +}
> +
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
>  {
>  	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> @@ -835,25 +856,46 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  		mm_ops->put_page(ctx->ptep);
>  }
>  
> +/*
> + * Don't use bbml3 for stage-2 if FWB or DIC are not supported
> + * as that means racing cores will issue duplicate CMOs.
> + */
> +static bool stage2_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
> +			     kvm_pte_t new)
> +{
> +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> +	    !cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> +		return false;
> +
> +	return kvm_pgtable_use_bbml3(ctx, new);
> +}
> +
>  /**
>   * stage2_try_break_pte() - Invalidates a pte according to the
>   *			    'break-before-make' requirements of the
> - *			    architecture.
> + *			    architecture, if BBML3 is supported it
> + *			    will be used and this function won't
> + *			    break the PTE.
>   *
>   * @ctx: context of the visited pte.
>   * @mmu: stage-2 mmu
> + * @new: New pte installed in make.
>   *
> - * Returns: true if the pte was successfully broken.
> + * Returns: true if the pte was successfully broken or BBML3 is used.
>   *
>   * If the removed pte was valid, performs the necessary serialization and TLB
>   * invalidation for the old value. For counted ptes, drops the reference count
>   * on the containing table page.
>   */
>  static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> -				 struct kvm_s2_mmu *mmu)
> +				 struct kvm_s2_mmu *mmu, kvm_pte_t new)
>  {
>  	kvm_pte_t locked_pte;
>  
> +	/* All handled in stage2_make_pte() */
> +	if (stage2_use_bbml3(ctx, new))
> +		return true;
> +

Wouldn't it be easier to keep try_break_pte/make_pte to the !bbml3 case and to
just create a make_pte_bbml3() variant to be called when stage2_use_bbml3()?

  if (!stage2_use_bbml3()) {
      if (stage2_try_break_pte())
          return -EAGAIN;
      stage2_make_pte();
  } else {
      if (stage2_make_pte_bbml3())
          return -EAGAIN;
  }

I believe also, the error path would look less weird as we catch an error in
make_pte() but without reverting the break_pte() (even if it is correct right
now).

And perhaps you could introduce a function that does both break/make
(stage2_update_pte()?) called by both stage2_split_walker() and
stage2_map_walk_leaf(). This would avoid repeating the error path.

Otherwise, everything looks functional to me.

-- 
Vincent


>  	if (stage2_pte_is_locked(ctx->old)) {
>  		/*
>  		 * Should never occur if this walker has exclusive access to the
> @@ -873,16 +915,37 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  	return true;
>  }
>  
> -static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> +static bool stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> +			    kvm_pte_t new)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  
> -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> -
>  	if (stage2_pte_is_counted(new))
>  		mm_ops->get_page(ctx->ptep);
>  
> +	if (stage2_use_bbml3(ctx, new)) {
> +		if (!kvm_pgtable_walk_shared(ctx)) {
> +			/*
> +			 * stage2_try_set_pte() uses WRITE_ONCE for non-shared walks,
> +			 * lacking release semantics used in the software BBM case.
> +			 */
> +			smp_wmb();
> +		}
> +
> +		if (!stage2_try_set_pte(ctx, new)) {
> +			/* Raced with another core. */
> +			if (stage2_pte_is_counted(new))
> +				mm_ops->put_page(ctx->ptep);
> +			return false;
> +		}
> +
> +		stage2_clean_old_pte(ctx, mmu);
> +		return true;
> +	}
> +
> +	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
>  	smp_store_release(ctx->ptep, new);
> +	return true;
>  }
>  
>  static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> @@ -1001,7 +1064,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  		return 0;
>  	}
>  
> -	if (!stage2_try_break_pte(ctx, data->mmu))
> +	if (!stage2_try_break_pte(ctx, data->mmu, new))
>  		return -EAGAIN;
>  
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
> @@ -1014,7 +1077,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	    stage2_pte_executable(new))
>  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>  
> -	stage2_make_pte(ctx, new);
> +	if (!stage2_make_pte(ctx, data->mmu, new))
> +		return -EAGAIN;
>  
>  	return 0;
>  }
> @@ -1057,19 +1121,21 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	childp = mm_ops->zalloc_page(data->memcache);
>  	if (!childp)
>  		return -ENOMEM;
> -
> -	if (!stage2_try_break_pte(ctx, data->mmu)) {
> -		mm_ops->put_page(childp);
> -		return -EAGAIN;
> -	}
> -
>  	/*
>  	 * If we've run into an existing block mapping then replace it with
>  	 * a table. Accesses beyond 'end' that fall within the new table
>  	 * will be mapped lazily.
>  	 */
>  	new = kvm_init_table_pte(childp, mm_ops);
> -	stage2_make_pte(ctx, new);
> +	if (!stage2_try_break_pte(ctx, data->mmu, new)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
> +	if (!stage2_make_pte(ctx, data->mmu, new)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
>  
>  	return 0;
>  }
> @@ -1549,18 +1615,21 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (IS_ERR(childp))
>  		return PTR_ERR(childp);
>  
> -	if (!stage2_try_break_pte(ctx, mmu)) {
> -		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> -		return -EAGAIN;
> -	}
> -
>  	/*
>  	 * Note, the contents of the page table are guaranteed to be made
>  	 * visible before the new PTE is assigned because stage2_make_pte()
>  	 * writes the PTE using smp_store_release().
>  	 */
>  	new = kvm_init_table_pte(childp, mm_ops);
> -	stage2_make_pte(ctx, new);
> +	if (!stage2_try_break_pte(ctx, mmu, new)) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> +		return -EAGAIN;
> +	}
> +
> +	if (!stage2_make_pte(ctx, mmu, new)) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> +		return -EAGAIN;
> +	}
>  	return 0;
>  }
>  
> -- 
> 2.55.0.979.g7e5102b832-goog
> 
