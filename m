Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D004BEBF6
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 22:23:44 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id w10so246392qvr.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=LE4t+xtxOOlWDWAJVVpK9S4cFpClSS/+Tzx6CPgkeKMPH5PCitg9Za7GEIFzsgwq+g
         CwCxylIHaaWBBnwa8ihM39R3yEnmr9xzRCweF2yXwtIXQh+HZbd3XV3OhV1g1D2uqIJb
         7Yy8UM7TbV8yH615NhPUxslGuW+h6IR8X3LIGKswymU4SUxvw1AVXnHEHajcluyPrQRA
         C7sH+o0qj6g4Fdjkf1F9DtWlNprhvAbq9KrNooFXKGQHOnVLo+dKSm/Rnkrbk/OlQgYj
         jFmMWW7p2OVXwK2Vwu52pkWJOdjkj5jSl7tcOakRtVOsohMHg/jetBcvjf9N9ZywvkN5
         apng==
X-Gm-Message-State: ACrzQf0cYtPB6cfSPtpHJNhnFvpL3lWm/voecA15UaLy1JOsrJV053fd
	ntrhL1w+YYy5uzBc5nDfkrh593k0Qk1tuv1Nxg6IvQ==
X-Google-Smtp-Source: AMsMyM5TapTqPRC0kKImkN6kMspQ3TuK1Gmv3b9wyzlFRHK+SpRPTCXYNOg2RgAbIk324w0L82kK6VOq6bWdOqkcmso=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56191873qvc.28.1668032623716; Wed, 09
 Nov 2022 14:23:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-6-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-6-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:33 -0800
Message-ID: <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	David Matlack <dmatlack@google.com>, Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221109222333.4xqVflA-N4w9HclnBsYqnqs33kTL7ecyYWcV5Cnyjos@z>

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
