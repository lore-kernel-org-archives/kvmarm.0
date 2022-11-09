Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C31C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA06F4BB68;
	Thu, 10 Nov 2022 09:52:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GSi2okwD8gUR; Thu, 10 Nov 2022 09:52:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3D44BADD;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7231B4B9FF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhQnHL6L+Mpj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:26:38 -0500 (EST)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34F9E4B9A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:38 -0500 (EST)
Received: by mail-qv1-f43.google.com with SMTP id n18so221011qvt.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=BFALFEh11gYbShb1RAGYtj5dFXgHaYyKewnp1K6Oabw=;
 b=nkpPoywYHDX5oTr3GbMz5tTHTbZRWuHW8NsemjQAHKz4xMNyjw9Kw3TWRe27yjr76z
 IBZ1A+/qXFEjCKl27M3fE9pkpDU9I3JTR4zbvOj+4jCI9hqLDgluIov21g9AdxlOvH6f
 6+jQxDfcpBkBuv8/es+JjRYaZuzv05sxFzhJp+iJ0ocYP1bVwD4kNHNJE54E0BHJKzvh
 xm7E8paRC3gDOrz6zKCidGlV55d7khDLjydj3bnP0caZAz7Jv9eySzK7b3Kyiev3SnDD
 pLccJJKiuNRt3H8cIeX8/LTgYv910T61kXFTc8Wa18t+rCI6AekXKlRECex2xYxVMoCn
 GETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=BFALFEh11gYbShb1RAGYtj5dFXgHaYyKewnp1K6Oabw=;
 b=LYyX8y0btdrvtH5jNiCgEfU9+dNwsWcOT9wFc22NRGY4GV9r0tgUtWrl1pv9qqq90O
 Pj5kj434FXSdUZyqhCrt1B142TqN6wkHL8Rud82Pr6CNR2m25tTW5cMVny0bGybjoO/m
 ClHvU7dmnUdjrbL8z/FMY4Exj1yqKypl9iuMHEfVVn28gh9Crzhq4QXBPA6xNSgM7FeI
 FWUGMDPsPPtBgrtThkc5TEvMQPcMoJcBvrIzOHso2PkGjh0ZoUzwbztrLTCMZejFDIiL
 bo1y1olwVSNQHMpbr8EZr9AyNNaLmzDaNzhhnmPAqF4z/h6daOFJx4xp+pLnQjO2Rj5g
 96xg==
X-Gm-Message-State: ACrzQf1UwAc2uUdbf9OHYdsGgxHBz6HHwi6Q51g1X/oRUD0DSPUtpCdq
 RJBe+2zfMKozrT5PGDXUJlaixh5BqmncRsWjvDh26w==
X-Google-Smtp-Source: AMsMyM67iMqLmmP+/O0bTNzsRNFWvVwvyyOSZ+AivFDFmfKATCCtpTElHUJLpL1k112VENpp1GALRfF2i5Y8/vcehHM=
X-Received: by 2002:a05:6214:4103:b0:4b6:818c:eb7b with SMTP id
 kc3-20020a056214410300b004b6818ceb7bmr57729500qvb.28.1668032797696; Wed, 09
 Nov 2022 14:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-11-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-11-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:26:26 -0800
Message-ID: <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
Subject: Re: [PATCH v5 10/14] KVM: arm64: Split init and set for table PTE
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

On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Create a helper to initialize a table and directly call
> smp_store_release() to install it (for now). Prepare for a subsequent
> change that generalizes PTE writes with a helper.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a34e2050f931..f4dd77c6c97d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
>         WRITE_ONCE(*ptep, 0);
>  }
>
> -static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> -                             struct kvm_pgtable_mm_ops *mm_ops)
> +static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> -       kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> +       kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
>
>         pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
>         pte |= KVM_PTE_VALID;
> -
> -       WARN_ON(kvm_pte_valid(old));

Is there any reason to drop this warning?


> -       smp_store_release(ptep, pte);
> +       return pte;
>  }
>
>  static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> @@ -413,7 +410,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                           enum kvm_pgtable_walk_flags visit)
>  {
> -       kvm_pte_t *childp;
> +       kvm_pte_t *childp, new;
>         struct hyp_map_data *data = ctx->arg;
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
> @@ -427,8 +424,10 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!childp)
>                 return -ENOMEM;
>
> -       kvm_set_table_pte(ctx->ptep, childp, mm_ops);
> +       new = kvm_init_table_pte(childp, mm_ops);
>         mm_ops->get_page(ctx->ptep);
> +       smp_store_release(ctx->ptep, new);
> +
>         return 0;
>  }
>
> @@ -796,7 +795,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                 struct stage2_map_data *data)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -       kvm_pte_t *childp;
> +       kvm_pte_t *childp, new;
>         int ret;
>
>         ret = stage2_map_walker_try_leaf(ctx, data);
> @@ -821,8 +820,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (stage2_pte_is_counted(ctx->old))
>                 stage2_put_pte(ctx, data->mmu, mm_ops);
>
> -       kvm_set_table_pte(ctx->ptep, childp, mm_ops);
> +       new = kvm_init_table_pte(childp, mm_ops);
>         mm_ops->get_page(ctx->ptep);
> +       smp_store_release(ctx->ptep, new);
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
