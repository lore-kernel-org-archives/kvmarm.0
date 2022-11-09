Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7132C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A43E04BB1F;
	Thu, 10 Nov 2022 09:52:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l92pv6HFq4+4; Thu, 10 Nov 2022 09:52:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 246304BB4B;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 596F64BA1D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:23:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PQzhS0HvgXDV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:23:44 -0500 (EST)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 396D64BA20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:23:44 -0500 (EST)
Received: by mail-qv1-f47.google.com with SMTP id e15so242032qvo.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=T4nhT+5+y72roggfQdrm+izhSoBAQsPwGSdMCJ4k+/s=;
 b=ZRk7+7DpcBDPfssndDH0jCsamFZ4YFaIenBG2tIgkAkWQDqVwmqi3fxsDov3PqIR/i
 skbO0PMGHk6vhDr0gZPT0+F6QhsLM/3CNLNtPocc682fg9VP0+lrtztvKipjBgkAa5Qz
 6yvEY7mPt7wfiEUpxrngFbezvdkNerpDIKyKImWGy0INUfvIyf/zX8UcE62Eexfq+Tms
 dTZb0Ent0XVyDBRC219MOJtGajH9xJJ9n548ytZM26stde3QdXEaWepM/7/cIjGzL8d5
 GhoYEcAjU2lmbn2F6w2G44+XHfcx9H+sem+ZVz8T0qp1xSt7GF3Hf2b3gYHqRUwXFgwc
 8PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=T4nhT+5+y72roggfQdrm+izhSoBAQsPwGSdMCJ4k+/s=;
 b=ZWXc4eXzX2EA7u8AnFTTULVDnpS7cUVqd9HdfZzcxD7F7prFzihHxD6TwkkLu4x5n/
 sT1m4dn1Wxl7Q6PKdyKSTa9M8Ay6Rl8v7YZ+DaWOAUMDBnbAISWYuIM3Rdt2kV3NboMt
 VeLuJCdPCth58GlzKUhrlDT4ZDUihmrOi/kKdyS3a78OxLebSKPYt1tDo+MF3iJWd3nl
 i+48MtBkmdrdM/W5lq7qTTjcHWVQGhO1/HiSwAPF2uW+Tmpz0uZ0D771XwMgkye/lpdO
 KpZzmiArnZtkTm5FiKxEqweyVz0aXiuq/xMcHFShZypk45qfPb2fuGOETGlOYsMmyYb+
 HQQg==
X-Gm-Message-State: ACrzQf2IqgH1b7MiHdUZzwbLPXbtxfumguPTazYJ4/ivNEpCt2QF5Vsu
 31N7ELvW8wH6G2XUbHcn/t7rZCvEMbBEYFckwHQHUw==
X-Google-Smtp-Source: AMsMyM5TapTqPRC0kKImkN6kMspQ3TuK1Gmv3b9wyzlFRHK+SpRPTCXYNOg2RgAbIk324w0L82kK6VOq6bWdOqkcmso=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56191873qvc.28.1668032623716; Wed, 09
 Nov 2022 14:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-6-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-6-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:33 -0800
Message-ID: <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> A subsequent change to KVM will move the tear down of an unlinked
> stage-2 subtree out of the critical path of the break-before-make
> sequence.
>
> Introduce a new helper for tearing down unlinked stage-2 subtrees.
> Leverage the existing stage-2 free walkers to do so, with a deep call
> into __kvm_pgtable_walk() as the subtree is no longer reachable from the
> root.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index a752793482cb..93b1feeaebab 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   */
>  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>
> +/**
> + * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> + * @mm_ops:    Memory management callbacks.
> + * @pgtable:   Unlinked stage-2 paging structure to be freed.
> + * @level:     Level of the stage-2 paging structure to be freed.
> + *
> + * The page-table is assumed to be unreachable by any hardware walkers prior to
> + * freeing and therefore no TLB invalidation is performed.
> + */
> +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> +
>  /**
>   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 93989b750a26..363a5cce7e1a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>         pgt->pgd = NULL;
>  }
> +
> +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> +{
> +       kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> +       struct kvm_pgtable_walker walker = {
> +               .cb     = stage2_free_walker,
> +               .flags  = KVM_PGTABLE_WALK_LEAF |
> +                         KVM_PGTABLE_WALK_TABLE_POST,
> +       };
> +       struct kvm_pgtable_walk_data data = {
> +               .walker = &walker,
> +
> +               /*
> +                * At this point the IPA really doesn't matter, as the page
> +                * table being traversed has already been removed from the stage
> +                * 2. Set an appropriate range to cover the entire page table.
> +                */
> +               .addr   = 0,
> +               .end    = kvm_granule_size(level),
> +       };
> +
> +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> +}

Will this callback be able to yield? In my experience, if processing a
large teardown (i.e. level >=3 / maps 512G region) it's possible to
hit scheduler tick warnings.


> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
