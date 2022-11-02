Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FE0C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 02:22:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37B1F4BA86;
	Tue,  1 Nov 2022 22:22:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DRDMB+jILNC4; Tue,  1 Nov 2022 22:22:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23214BA99;
	Tue,  1 Nov 2022 22:22:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1FF4BA87
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 22:22:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cG+HD3sFjq9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 22:22:54 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D26474BA86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 22:22:54 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 p15-20020a17090a348f00b002141615576dso779993pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2022 19:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=oHPJoyiBZgc+dQX1BWUm6Pn/r0rudQ2oKsMse8qJvtOEd+TpYSe1FUoGbVEQqhz2Bx
 z5E4Wkb2ZZxGY70PMVYFpRTF+KyVl7MTT83TCvAaoLR54c1lg3+WYttiskOxFWf/2Hil
 dhs/wLB4oljiR6Qygf3CAQ6MW85iv3T9gYrjNSxezepwtO/i5fCa9j40W5L8/UWPxf8D
 TlX26191i52LKtIFAGtns+jSegp/qudOTyf73KR83LpryPCIX5KKG4OAiWERimBnQfip
 adzkI70CKSHtWfMRNpM+McipDXImOG5h/KnfFDmWDAUmvi6aD7yZebExa8MP5EAi070l
 cIfQ==
X-Gm-Message-State: ACrzQf3PYkjtU+p122R1f/N40XwNMfc57BB5L4sbK8BpM7+3s63xVS1T
 GSUUQ1yUEPpSFsiN8C729MM7vA==
X-Google-Smtp-Source: AMsMyM4uWuLDXQgmDx+QR9W8VuKqSULuJ9Jeb7bJvEMPgTDunHhgg4PsCO+bVvZF+LmVAno5DuHQKQ==
X-Received: by 2002:a17:902:d2c5:b0:186:afd7:56d3 with SMTP id
 n5-20020a170902d2c500b00186afd756d3mr22234372plc.142.1667355773730; 
 Tue, 01 Nov 2022 19:22:53 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 p4-20020a622904000000b0056da2ad6503sm3485182pfp.39.2022.11.01.19.22.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Nov 2022 19:22:53 -0700 (PDT)
Date: Tue, 1 Nov 2022 19:22:49 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 12/15] KVM: arm64: Make block->table PTE changes
 parallel-aware
Message-ID: <Y2HUebPnIgzLim0w@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027222247.1685023-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221027222247.1685023-1-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
