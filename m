Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE214BD04
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 18:42:01 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id ch10so3166989qtb.11
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 10:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BY6amq4t0C7j5VRpuTf5I55eTbai3EImvFhkGy1eZRM=;
        b=CZpaT1GzJwoYtyr7yZdaWezrxb8OUxzbV3FeGqMrQp3ML1jEggP7cFXSKBx0tNetpl
         GQO52WEVTRpOzI9Mlty8XezCOobO5UKZaaedifjgdvNkXnaCPLbdyZpjGWmsDMZmu1Fr
         NJWbl6/2elyK7ja11h4GRiufLtac6aRhg9y7YDvTf/uJo668ImyIKpHfv67LQiqkPWql
         rqsj+XPiNIG/u0QBxFdWRjsyv4WTyGRmiL57Jbb2zOuUcdXxC46nZrkr5KhV1/flvtup
         PCE65MotrB2bKvcjD2YF/AjDrTTnvvgpLrbd0UDEy3rw5Ct6X/SewnVO6KY1Dqcqtjlc
         ksxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BY6amq4t0C7j5VRpuTf5I55eTbai3EImvFhkGy1eZRM=;
        b=HR1uacO6JL6Hjxf+cInB5/+S7mtWZXsOAN1C6N3RzUdTvIEFI7Kx8Mg/NrsSzTDaxC
         m4eTcnAN1I2sIP+BxhtuFsF8AshqAMojxfAm2Zlo36JZkAsKZ1xxpgFlVKNMx5MkSf6R
         V9NMYNYw5xgG6Bb4un+Z87Uh8OaLqBTQpBZ0S1r4+Ta6l2tFq2gAAMlcWzfdZpB3lues
         /wDhtSiWcsLVCUWfLu3ZnYYs4cHh5ETLctouV18w0D/v0jhig+HMrpVOd+WMCXMEt49j
         Q6c6JDIc3G6EwWS1YHq6gssikz+EadHmgk9cllYQgMwRdvu0f5U3cyO4s/TfNoCwb4un
         BvNg==
X-Gm-Message-State: AO0yUKXpg77ES1jjPIdeHzhMae9u99fjUG0m6NfNXgKUmWn38o0tPLYA
	Xx2zdkG/ASsu4QhmwADyQVaELTV0JbrF36hmk2GAhg==
X-Google-Smtp-Source: AK7set+TV0gPnuynCexufh6sWlVI4yeUKTeGKQ/mF/3TW3KdGHv4dWQA+Z8Pt8zuRLDSJ9EyK1jXwX2ehfuYhVA9Gps=
X-Received: by 2002:ac8:73cf:0:b0:3b8:6a5d:cd86 with SMTP id
 v15-20020ac873cf000000b003b86a5dcd86mr358259qtp.6.1676572920687; Thu, 16 Feb
 2023 10:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com> <20230215174046.2201432-2-ricarkol@google.com>
 <29b8ac39-555d-ae3d-c583-ba186b473481@redhat.com>
In-Reply-To: <29b8ac39-555d-ae3d-c583-ba186b473481@redhat.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Thu, 16 Feb 2023 10:41:49 -0800
Message-ID: <CAOHnOrz8jTLrAr5HFVds_Nge9==h2Vb9paz4Lrecj=nf7q1Mzg@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
To: Shaoqin Huang <shahuang@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 15, 2023 at 6:56 PM Shaoqin Huang <shahuang@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/16/23 01:40, Ricardo Koller wrote:
> > Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
> > KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
> > perform break-before-make (BBM) nor cache maintenance operations
> > (CMO). This will by a future commit to create unlinked tables not
> > accessible to the HW page-table walker.  This is safe as these removed
> > tables are not visible to the HW page-table walker.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
> >   2 files changed, 34 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 63f81b27a4e3..3339192a97a9 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -188,12 +188,20 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> >    *                                  children.
> >    * @KVM_PGTABLE_WALK_SHARED:                Indicates the page-tables may be shared
> >    *                                  with other software walkers.
> > + * @KVM_PGTABLE_WALK_SKIP_BBM:               Visit and update table entries
> > + *                                   without Break-before-make
> > + *                                   requirements.
> > + * @KVM_PGTABLE_WALK_SKIP_CMO:               Visit and update table entries
> > + *                                   without Cache maintenance
> > + *                                   operations required.
> >    */
> >   enum kvm_pgtable_walk_flags {
> >       KVM_PGTABLE_WALK_LEAF                   = BIT(0),
> >       KVM_PGTABLE_WALK_TABLE_PRE              = BIT(1),
> >       KVM_PGTABLE_WALK_TABLE_POST             = BIT(2),
> >       KVM_PGTABLE_WALK_SHARED                 = BIT(3),
> > +     KVM_PGTABLE_WALK_SKIP_BBM               = BIT(4),
> > +     KVM_PGTABLE_WALK_SKIP_CMO               = BIT(4),
>
> The KVM_PGTABLE_WALK_SKIP_BBM and KVM_PGTABLE_WALK_SKIP_CMO use the same
> BIT(4), if I understand correctly, the two flags are used in different
> operation and will never be used at the same time.
>

That was supposed to be a BIT(5):
KVM_PGTABLE_WALK_SKIP_BBM               = BIT(4),
KVM_PGTABLE_WALK_SKIP_CMO               = BIT(5),

>
> Maybe add some comments to illustrate why the two use the same bit can
> be better.
>
>
> >   };
> >
> >   struct kvm_pgtable_visit_ctx {
> > @@ -215,6 +223,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
> >       return ctx->flags & KVM_PGTABLE_WALK_SHARED;
> >   }
> >
> > +static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
> > +{
> > +     return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
> > +}
> > +
> > +static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
> > +{
> > +     return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
> > +}
> > +
> >   /**
> >    * struct kvm_pgtable_walker - Hook into a page-table walk.
> >    * @cb:             Callback function to invoke during the walk.
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b11cf2c618a6..e093e222daf3 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -717,14 +717,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >       if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> >               return false;
> >
> > -     /*
> > -      * Perform the appropriate TLB invalidation based on the evicted pte
> > -      * value (if any).
> > -      */
> > -     if (kvm_pte_table(ctx->old, ctx->level))
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > -     else if (kvm_pte_valid(ctx->old))
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> > +     if (!kvm_pgtable_walk_skip_bbm(ctx)) {
> > +             /*
> > +              * Perform the appropriate TLB invalidation based on the
> > +              * evicted pte value (if any).
> > +              */
> > +             if (kvm_pte_table(ctx->old, ctx->level))
> > +                     kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +             else if (kvm_pte_valid(ctx->old))
> > +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > +                                  ctx->addr, ctx->level);
> > +     }
> >
> >       if (stage2_pte_is_counted(ctx->old))
> >               mm_ops->put_page(ctx->ptep);
> > @@ -808,11 +811,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >               return -EAGAIN;
> >
> >       /* Perform CMOs before installation of the guest stage-2 PTE */
> > -     if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> > +     if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
> > +         stage2_pte_cacheable(pgt, new))
> >               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> > -                                             granule);
> > +                                            granule);
> >
> > -     if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> > +     if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
> > +         stage2_pte_executable(new))
> >               mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> >
> >       stage2_make_pte(ctx, new);
>
> --
> Regards,
> Shaoqin
>
