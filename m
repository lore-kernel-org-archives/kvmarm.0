Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4C1C43217
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2AB94BAEB;
	Thu, 10 Nov 2022 09:52:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cGD1ojnB8JGl; Thu, 10 Nov 2022 09:52:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E56614BB77;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1134B9FF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DFP6z71fCnyw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:26:47 -0500 (EST)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com
 [209.85.160.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBD274B9A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:47 -0500 (EST)
Received: by mail-qt1-f172.google.com with SMTP id hh9so25829qtb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=ys/jQ8RbuqT3YumCTMbd+2452VktWwQQOObS7LSk5p4=;
 b=mk9lRpuokDL/uAOGOKs/+T+PEfPR48B5jrdBCU4h3IJuESuNqf45ir8gw9bRIeOeS2
 5boDsxOTz8DpWvHPjQhCVVSwOM6ovQKP64R6KI0RCxiP7tMx1y1DV02kaqZQLWfTIIIK
 TbjJqgkN+FpzGJDz9nIIK8l9JHwSamFn0UQVHIRm3S8ypg8qo2oRFMAbGNEOyPMoHgVs
 guGP5sgv0zVSjtqTSdAgYZhxbtjyozc30kfsiDsPFZZvSEgusnttdCQYnX0wMsBIhRsK
 PS2Rwu4d/kFG+09LQxPgUcg1wT8Uk5LZsZZvFYYJUXzlidk4zjrNqzmeBbQj7G25Mb/i
 N6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ys/jQ8RbuqT3YumCTMbd+2452VktWwQQOObS7LSk5p4=;
 b=6+hXTZugIgVQ+J2GZYoZfZulZShn0OKkie5RVkxFzhbyUbEErVIx069Y+1siB3SCJd
 ySCUWq03pYR8/s/GUR/U5joGIFGWeQz9NaTZRS22ewAnyGCZO0AC7ez8HpcPKpszKHnF
 lRp+7PCHveShRaDiIK1lEY9pHnuWVLrwKodhpZnOoGpKXR0GIOAPVdPs/5SUKGvAwEpw
 oS48RV/QWpAqSew4Joz0i2i14Q3gm5ToamrD32QoZCQaE2ol8kHLZTzQ5krEHfCIhE6w
 PI5pA9rpuifhccLAZpwBDJPPA6mom3MMhKAfagp6+QXFqF7GYhARoBhHXOEigDX0JvZs
 uVgw==
X-Gm-Message-State: ANoB5plCCamHLAtAez+0NOZ6bqjgUEeyquiCOAbyWMaa4CqUAtoOTktj
 ERX1GvP5C2rc+XqBsoaDYFFyzEBF1jISaI7fq0ysDA==
X-Google-Smtp-Source: AA0mqf78NDQ8xLt/Zae6fTGp38dnPf5BMr45qBFnT7kZ5Z23obSQYwTbVOjufSO4/KwQlp/1DoVnG+QFF53vnN4/bwY=
X-Received: by 2002:ac8:5ac2:0:b0:3a5:afca:2322 with SMTP id
 d2-20020ac85ac2000000b003a5afca2322mr4284025qtd.500.1668032807310; Wed, 09
 Nov 2022 14:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215855.1895367-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215855.1895367-1-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:26:36 -0800
Message-ID: <CANgfPd9OSUfDGCQG8tHXTCYtrrCDnkgPZM6qPDaQF90bZsVCkA@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] KVM: arm64: Make block->table PTE changes
 parallel-aware
To: Oliver Upton <oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
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

On Mon, Nov 7, 2022 at 1:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
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
>  arch/arm64/kvm/hyp/pgtable.c | 80 +++++++++++++++++++++++++++++++++---
>  1 file changed, 75 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f4dd77c6c97d..b9f0d792b8d9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK     GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID               1
>
> +/*
> + * Used to indicate a pte for which a 'break-before-make' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED         BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>         struct kvm_pgtable_walker       *walker;
>
> @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>         return !!pte;
>  }
>
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +       return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
>  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
>  {
>         if (!kvm_pgtable_walk_shared(ctx)) {
> @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>         return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
>  }
>
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *                         'break-before-make' requirements of the
> + *                         architecture.
> + *
> + * @ctx: context of the visited pte.
> + * @mmu: stage-2 mmu
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pte was valid, performs the necessary serialization and TLB
> + * invalidation for the old value. For counted ptes, drops the reference count
> + * on the containing table page.
> + */
> +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +                                struct kvm_s2_mmu *mmu)
> +{
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +       if (stage2_pte_is_locked(ctx->old)) {
> +               /*
> +                * Should never occur if this walker has exclusive access to the
> +                * page tables.
> +                */
> +               WARN_ON(!kvm_pgtable_walk_shared(ctx));
> +               return false;
> +       }
> +
> +       if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> +               return false;
> +
> +       /*
> +        * Perform the appropriate TLB invalidation based on the evicted pte
> +        * value (if any).
> +        */
> +       if (kvm_pte_table(ctx->old, ctx->level))
> +               kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +       else if (kvm_pte_valid(ctx->old))
> +               kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +       if (stage2_pte_is_counted(ctx->old))
> +               mm_ops->put_page(ctx->ptep);
> +
> +       return true;
> +}
> +
> +static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> +{
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +       WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> +
> +       if (stage2_pte_is_counted(new))
> +               mm_ops->get_page(ctx->ptep);
> +
> +       smp_store_release(ctx->ptep, new);
> +}
> +
>  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>                            struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!childp)
>                 return -ENOMEM;
>
> +       if (!stage2_try_break_pte(ctx, data->mmu)) {
> +               mm_ops->put_page(childp);
> +               return -EAGAIN;
> +       }
> +
>         /*
>          * If we've run into an existing block mapping then replace it with
>          * a table. Accesses beyond 'end' that fall within the new table
>          * will be mapped lazily.
>          */
> -       if (stage2_pte_is_counted(ctx->old))
> -               stage2_put_pte(ctx, data->mmu, mm_ops);
> -
>         new = kvm_init_table_pte(childp, mm_ops);

Does it make any sense to move this before the "break" to minimize the
critical section in which the PTE is locked?


> -       mm_ops->get_page(ctx->ptep);
> -       smp_store_release(ctx->ptep, new);
> +       stage2_make_pte(ctx, new);
>
>         return 0;
>  }
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
