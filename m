Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C68C43217
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B224BB42;
	Thu, 10 Nov 2022 09:52:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uTXvBXXBDC5w; Thu, 10 Nov 2022 09:52:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 141FB4BB48;
	Thu, 10 Nov 2022 09:51:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E774BA14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M9vBLBc1ZzQE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:26:55 -0500 (EST)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19A044B9FF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:26:55 -0500 (EST)
Received: by mail-qv1-f48.google.com with SMTP id u7so214093qvn.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=mIH/gnU14scU0A1hyWtmYd9lzDy4ZgiwB42b18TqphI=;
 b=HFR4OdnxHrsQVbCXJcHORcKq3LD310hCms8AAWUb9x0WfZhWqQ6vfgIdCi9y6aMJqn
 ntUPcIVnrCEAomqTv2G9Op/3FygLTY8aQ7k5Q14ornuw1MbBp3zItwYfOhDBr4hO9zYR
 dmqKIWyBZP6xhWegZrdSKiyCzjlEXbKqWVZBKi/iv9zcWqpz6Uwg0C8hAIs+dvXcT/vS
 qv0A+h+egVI/qNJXzGyz/FXaq0evLNo44P9eBJ8RQdkcUbwVRfgHQkZT7ltKYHgnceUO
 KfNxgVRovf/22rKLGQkhf7NNqjEpo5AwVF46ehyydkzYwjQojxIopV/Pxc55C3hjJ41v
 x+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=mIH/gnU14scU0A1hyWtmYd9lzDy4ZgiwB42b18TqphI=;
 b=7cSQXC5v1MozfLUqp6E+DfmEfzFUm7f87nbGqrKdv0I/c6hTtxpKhBkdkG7D4OerYd
 +KS3pTFJNX/qN3GM0NlzI3DBTQxYonxh4iGzaYvF9UElD0eHz+4ZItrng57HdMU9qDmT
 JVrAoaZRHNHqqvu+gfmeWLp26l/WK4Pq0KrNLKFoojWxqcj/P6unVUhXUSUuFTeJenIp
 eeaMzvgGiqMV2ZXhFDpC+W5aKF0l6Vt65msRHjTOamKIUwGLldStYC4X7RD+8y7YJu+y
 PObd0qJa7S/yGKht1ML1jfGGCN46fmdWx/Pj8x70mQu4oPPqW8a+1qcsn/8N89XwGV/T
 TOOQ==
X-Gm-Message-State: ACrzQf3ztY0j5ZT+CsZ0gtK2eUKRlcGP64241T8oEHPVrnAgUJ6b7WT0
 NT2mWe85iZ+05nx4B/hflqsQF7O+gpySVA6fxdhhlg==
X-Google-Smtp-Source: AMsMyM5J4JGxdLxEvM+TDclGKxrd4EGyAN5hOkeEDZV0xVYhb9vkBF6uFdXqxyk3atCKOBNJ2lAaV7B4qRWzA01q8BA=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56203622qvc.28.1668032814598; Wed, 09
 Nov 2022 14:26:54 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215934.1895478-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215934.1895478-1-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:26:43 -0800
Message-ID: <CANgfPd8b+JZq5AAvasY=GaRjLPyEN87irg2HkcYvaBxdRhZgdA@mail.gmail.com>
Subject: Re: [PATCH v5 12/14] KVM: arm64: Make leaf->leaf PTE changes
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
> Convert stage2_map_walker_try_leaf() to use the new break-before-make
> helpers, thereby making the handler parallel-aware. As before, avoid the
> break-before-make if recreating the existing mapping. Additionally,
> retry execution if another vCPU thread is modifying the same PTE.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b9f0d792b8d9..238f29389617 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -804,18 +804,17 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         else
>                 new = kvm_init_invalid_leaf_owner(data->owner_id);
>
> -       if (stage2_pte_is_counted(ctx->old)) {
> -               /*
> -                * Skip updating the PTE if we are trying to recreate the exact
> -                * same mapping or only change the access permissions. Instead,
> -                * the vCPU will exit one more time from guest if still needed
> -                * and then go through the path of relaxing permissions.
> -                */
> -               if (!stage2_pte_needs_update(ctx->old, new))
> -                       return -EAGAIN;
> +       /*
> +        * Skip updating the PTE if we are trying to recreate the exact
> +        * same mapping or only change the access permissions. Instead,
> +        * the vCPU will exit one more time from guest if still needed
> +        * and then go through the path of relaxing permissions.
> +        */
> +       if (!stage2_pte_needs_update(ctx->old, new))
> +               return -EAGAIN;
>
> -               stage2_put_pte(ctx, data->mmu, mm_ops);
> -       }
> +       if (!stage2_try_break_pte(ctx, data->mmu))
> +               return -EAGAIN;
>
>         /* Perform CMOs before installation of the guest stage-2 PTE */
>         if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> @@ -825,9 +824,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
>                 mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>
> -       smp_store_release(ctx->ptep, new);
> -       if (stage2_pte_is_counted(new))
> -               mm_ops->get_page(ctx->ptep);
> +       stage2_make_pte(ctx, new);
> +
>         if (kvm_phys_is_valid(phys))
>                 data->phys += granule;
>         return 0;
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
