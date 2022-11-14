Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9310EC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 20:55:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06EB24B733;
	Mon, 14 Nov 2022 15:55:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6V3xiBeKWG39; Mon, 14 Nov 2022 15:55:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4A14B8E2;
	Mon, 14 Nov 2022 15:55:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BFEB4B811
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:55:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9aBblEr68WdB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 15:54:58 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA2D04B733
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:54:58 -0500 (EST)
Date: Mon, 14 Nov 2022 20:54:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668459297;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=A678RV37X2a5WAdwm/7rFErOS5ZproL4wmh+eRAOrpo=;
 b=B+rTg85BNob60Y8KzATpVLW3TAzfrCuopXNCGmZ/lR0PoxYCXGLcjQls41txe211SpDK7T
 ck32Iiv8/6yqgWwbkunnWdVMUwao0/YgT7W/3yGETav5Gd240aA9yEebm60YWmftjtErZ+
 kU1REr35oS30HK8FaC8oEq0uIst1ANI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3KrHG4WMXMUquUy@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: ricarkol@gmail.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev, bgardon@google.com,
 maz@kernel.org, dmatlack@google.com, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:

[...]

> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:	Intermediate physical address from which to split.
> + * @size:	Size of the range.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> + *		page-table pages.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an exampe using 1GB
> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by the size of the memcache. It
> + * will fail it wasn't able to break any block.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d1f309128118..9c42eff6d42e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
>  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
>  }
>  
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	struct kvm_pgtable_mm_ops	*mm_ops;

You can also get at mm_ops through kvm_pgtable_visit_ctx

> +};
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct stage2_split_data *data = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t pte = ctx->old, attr, new;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	u64 phys;
> +
> +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> +		return -EINVAL;
> +
> +	/* Nothing to split at the last level */
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return 0;
> +
> +	/* We only split valid block mappings */
> +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> +		return 0;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> +
> +	/*
> +	 * Eager page splitting is best-effort, so we can ignore the error.
> +	 * The returned PTE (new) will be valid even if this call returns
> +	 * error: new will be a single (big) block PTE.  The only issue is
> +	 * that it will affect dirty logging performance, as the huge-pages
> +	 * will have to be split on fault, and so we WARN.
> +	 */
> +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));

I don't believe we should warn in this case, at least not
unconditionally. ENOMEM is an expected outcome, for example.

Additionally, I believe you'll want to bail out at this point to avoid
installing a potentially garbage PTE as well.

> +	stage2_put_pte(ctx, data->mmu, mm_ops);

Ah, I see why you've relaxed the WARN in patch 1 now.

I would recommend you follow the break-before-make pattern and use the
helpers here as well. stage2_try_break_pte() will demote the store to
WRITE_ONCE() if called from a non-shared context.

Then the WARN will behave as expected in stage2_make_pte().

> +	/*
> +	 * Note, the contents of the page table are guaranteed to be made
> +	 * visible before the new PTE is assigned because
> +	 * stage2_make__pte() writes the PTE using smp_store_release().

typo: stage2_make_pte()

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
