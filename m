Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBAD622
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 02:22:54 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so812359pji.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Nov 2022 19:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7hSoZw8Zf9r0JK1yTid31zGLxatTQtFs42RwqoR9MRo=;
        b=Ng8PDPyEJvjQ2XkFaT8iC0xWn/YVIPJElzDnHLSa154sCHubjiCFseuLTA29wtVn2R
         zait5QjnAJ7IvjC8W30t65jJV7whAbjXACGhtTzRPXwLi9fs3sLug/C0i5q2bBLEdHU7
         QCCXf1Vrag0ZU5y7uoj1xIONqFP8JUhvdbk4IWnOjpXmaRPf1mEZOMHjBGBLnCLx5msL
         QuzVoREpWdXwzrlPMjzQjmg9Sy8KtoWtFBEPDuBOY6vI9VmMKEa24XfIS/Zm6bxh/01i
         JRkg+az9LgxXdG0j84QZqfSgj5uEzZwv7njrg9bOyYQrJR5e3TJEGcUPHm4UiS1dtLik
         QqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hSoZw8Zf9r0JK1yTid31zGLxatTQtFs42RwqoR9MRo=;
        b=hfHEsmLBXMlgSyrtKoqgMomPtU33xJd2mJzPoir6/0hv5eiqeeZEsebDvzzUEFpCSK
         TDfjMmAVaO9KOKTo9BoGQhsmU+qFwif20UeCgBTBGdUqvORNOIeL9sfVbPFHhksVetXZ
         PszULmtMfAQV6b9GibxHu8i2JYytENK/TIta9gaH6BygKd3YY2tbyxxsH0dheGcFUZ6S
         nJrebDxiPYAChyCXjPvJQpxsqgYg9jOiR1uLK/nr2G3EDfHoAihCEEqCk1d9ta3AUFXv
         ogvBi2lYZZ23VkpspvZU4ZiJ/hWUphVISfzrQF4x1i/eKkG7TGkyw/08JaLzAmdh0/65
         mcXw==
X-Gm-Message-State: ACrzQf1hYACkH0Fzc1IrcDwMz2SwvUtVMcQTemVQGZ5Nc6GXzNBEamt+
	9KcqfwTaOgnAxQzCUKmSgOT7vQ==
X-Google-Smtp-Source: AMsMyM4uWuLDXQgmDx+QR9W8VuKqSULuJ9Jeb7bJvEMPgTDunHhgg4PsCO+bVvZF+LmVAno5DuHQKQ==
X-Received: by 2002:a17:902:d2c5:b0:186:afd7:56d3 with SMTP id n5-20020a170902d2c500b00186afd756d3mr22234372plc.142.1667355773730;
        Tue, 01 Nov 2022 19:22:53 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id p4-20020a622904000000b0056da2ad6503sm3485182pfp.39.2022.11.01.19.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 19:22:53 -0700 (PDT)
Date: Tue, 1 Nov 2022 19:22:49 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 12/15] KVM: arm64: Make block->table PTE changes
 parallel-aware
Message-ID: <Y2HUebPnIgzLim0w@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027222247.1685023-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027222247.1685023-1-oliver.upton@linux.dev>
Message-ID: <20221102022249.KyGUtyDrO-MEoCK5CLMNPl_Taw3e8ixq4EBnpOa28pE@z>

On Thu, Oct 27, 2022 at 10:22:47PM +0000, Oliver Upton wrote:
> In order to service stage-2 faults in parallel, stage-2 table walkers
> must take exclusive ownership of the PTE being worked on. An additional
> requirement of the architecture is that software must perform a
> 'break-before-make' operation when changing the block size used for
> mapping memory.
> 
> Roll these two concepts together into helpers for performing a
> 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> has been locked by a software walker. Additionally, use an atomic
> compare-exchange to 'break' the PTE when the stage-2 page tables are
> possibly shared with another software walker. Elide the DSB + TLBI if
> the evicted PTE was invalid (and thus not subject to break-before-make).
> 
> All of the atomics do nothing for now, as the stage-2 walker isn't fully
> ready to perform parallel walks.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 82 +++++++++++++++++++++++++++++++++---
>  1 file changed, 76 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4c579b3beabf..1df858c21b2e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID		1
>  
> +/*
> + * Used to indicate a pte for which a 'break-before-make' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable_walker	*walker;
>  
> @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>  	return !!pte;
>  }
>  
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
>  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
>  {
>  	if (!kvm_pgtable_walk_shared(ctx)) {
> @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>  	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
>  }
>  
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *			    'break-before-make' requirements of the
> + *			    architecture.
> + *
> + * @ctx: context of the visited pte.
> + * @data: stage-2 map data
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pte was valid, performs the necessary serialization and TLB
> + * invalidation for the old value. For counted ptes, drops the reference count
> + * on the containing table page.
> + */
> +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +				 struct stage2_map_data *data)

Would it be possible to pass "kvm_s2_mmu *mmu" directly (instead of
"stage2_map_data *data")? so this function can be reused by other
walkers.  Another option would be to stash "struct kvm_s2_mmu" in
"struct kvm_pgtable_visit_ctx".

> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +	if (stage2_pte_is_locked(ctx->old)) {
> +		/*
> +		 * Should never occur if this walker has exclusive access to the
> +		 * page tables.
> +		 */
> +		WARN_ON(!kvm_pgtable_walk_shared(ctx));
> +		return false;
> +	}
> +
> +	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> +		return false;
> +
> +	/*
> +	 * Perform the appropriate TLB invalidation based on the evicted pte
> +	 * value (if any).
> +	 */
> +	if (kvm_pte_table(ctx->old, ctx->level))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> +	else if (kvm_pte_valid(ctx->old))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, ctx->addr, ctx->level);
> +
> +	if (stage2_pte_is_counted(ctx->old))
> +		mm_ops->put_page(ctx->ptep);
> +
> +	return true;
> +}
> +
> +static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> +
> +	if (stage2_pte_is_counted(new))
> +		mm_ops->get_page(ctx->ptep);
> +
> +	smp_store_release(ctx->ptep, new);
> +}
> +
>  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>  			   struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -795,7 +864,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  				struct stage2_map_data *data)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -	kvm_pte_t *childp;
> +	kvm_pte_t *childp, new;
>  	int ret;
>  
>  	ret = stage2_map_walker_try_leaf(ctx, data);
> @@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!childp)
>  		return -ENOMEM;
>  
> +	if (!stage2_try_break_pte(ctx, data)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
>  	/*
>  	 * If we've run into an existing block mapping then replace it with
>  	 * a table. Accesses beyond 'end' that fall within the new table
>  	 * will be mapped lazily.
>  	 */
> -	if (stage2_pte_is_counted(ctx->old))
> -		stage2_put_pte(ctx, data->mmu, mm_ops);
> -
>  	new = kvm_init_table_pte(childp, mm_ops);
> -	mm_ops->get_page(ctx->ptep);
> -	smp_store_release(ctx->ptep, new);
> +	stage2_make_pte(ctx, new);
>  
>  	return 0;
>  }
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
