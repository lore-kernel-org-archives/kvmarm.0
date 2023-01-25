Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989354C83
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 22:20:46 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id bm8so2352077oib.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mMN1uGFzD4Ah/Bo6fKk+5YN8Lg3dxQzr3D55yY1NtKs=;
        b=C6ntfnEtMJt2j5DrQJKnyiMj3+hJCGBbmj044R0ouYXJEbL8Ta92YhrxtTj57+8+wf
         08fhYYRiLZ0Um3ZO23n06U3hXSNRA66yuiIH6zbzkRXvTOwdvc/eaMBzECvNvqaY1pQb
         cTo0MyBt6aBOHCq1nAqrRH9YzAFAo8sbjf3F3RxOoUlAZVN5V2AQ2r37nz86+Vg2sUPJ
         S/ZnROZwb1hgdbEpCeHIkF3FDt+cBEm3plulkAFTV9Kor5+aPql7yJAYJaIsWpEMU2Ff
         VkJ4q4tYoXp5ebWb+DHI3W7OXggpvKyteowPUtbg7eN/q0tmFpgtca7rZHuR3SxEZQd8
         fUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMN1uGFzD4Ah/Bo6fKk+5YN8Lg3dxQzr3D55yY1NtKs=;
        b=lNYW5rBeDmW29UuL7MFQotvaYWT7VlpkMSzt0Td3qS0sQq3ASo2j1/fkFgkL2nsKZQ
         3/BQOJ/cIbfuwXg4L7BuLnQJU7KA8rU+ud3h5eXgCJQNkvLMIeYPNgScgMcCDmOAaz/p
         130Idxe7Ho5EaLfNhwrJkiba6TNYYZXDNVW1mpFZw99Uo2Yclb62gyuLua9HqUSxffa2
         ODZGOTl5tEyi6RJFbz5hyjPmjJcXKJgQjxNGzpKfPDUJ1wNOzDgGKlO7EJ35+UNzB0XB
         YBo1SBkEBJBbOoijchFMz8MP0iZvDgtIlvR9ELO+s1vLoRB/Bt1bxgw561H4qnp+0jHV
         vpCg==
X-Gm-Message-State: AFqh2krgf42Wvu0bWSk9FwUDFhYC610N2zEqQb6iuKgdBDTFXAq5lHs2
	oGXQtbY1irO7ntalhWEJkDp4X3TXWwycZMWuUTA7Ew==
X-Google-Smtp-Source: AMrXdXsklhSg5PxOuRHLC0Plnu+fQ9QwTycKq0GnTOUykYVeNYyl8bkoAqJqEj6u9gl5XSf/U/WTMThActLOCAgjQNQ=
X-Received: by 2002:a05:6808:3b1:b0:364:ebf2:735c with SMTP id
 n17-20020a05680803b100b00364ebf2735cmr2296416oie.179.1674685245369; Wed, 25
 Jan 2023 14:20:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com> <20230109215347.3119271-6-rananta@google.com>
 <Y9Bo9qwJhs3KK6jR@thinky-boi>
In-Reply-To: <Y9Bo9qwJhs3KK6jR@thinky-boi>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 25 Jan 2023 14:20:34 -0800
Message-ID: <CAJHc60yzrt5Y-aVyL3s-Ai=dbtNc_GqENzzbvbmokXgEoLiGLw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] KVM: arm64: Optimize the stage2 map path with
 TLBI range instructions
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, Jan 24, 2023 at 3:25 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Raghavendra,
>
> My comment from the previous change also applies here:
>
>   KVM: arm64: Use range-based TLBIs when collapsing hugepages
>
> On Mon, Jan 09, 2023 at 09:53:46PM +0000, Raghavendra Rao Ananta wrote:
> > Currently, when the map path of stage2 page-table coalesces a
> > bunch of pages into a hugepage, KVM invalidates the entire
> > VM's TLB entries. This would cause a perforamance penality for
> > the guest whose pages have already been coalesced earlier as they
> > would have to refill their TLB entries unnecessarily again.
>
> It is also problematic that we do this on every single fault where we
> collapse a hugepage.
>
Yes! I'll also include this description in v2.

> > Hence, if the system supports it, use __kvm_tlb_flush_range_vmid_ipa()
> > to flush only the range of pages that have been combined into
> > a hugepage, while leaving other TLB entries alone.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 29 +++++++++++++++++++++++++----
> >  1 file changed, 25 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b11cf2c618a6c..099032bb01bce 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -686,6 +686,22 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >       return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
> >  }
> >
> > +static void kvm_table_pte_flush(struct kvm_s2_mmu *mmu, u64 addr, u32 level, u32 tlb_level)
>
> Could you call this something like kvm_pgtable_flush_range() and take an
> address range as an argument? TLBIRANGE can be used outside the context
> of a table (i.e. a subset of PTEs).
>
Good idea. In that case, the function becomes very close to arm64's
implementation of kvm_flush_remote_tlbs_range() on top of David's
series [1].
Too bad, we may not be able to invoke that. I'll rename the function.

> > +{
> > +     if (system_supports_tlb_range()) {
> > +             u64 end = addr + kvm_granule_size(level);
> > +
> > +             kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, addr, end, tlb_level);
> > +     } else {
> > +             /*
> > +              * Invalidate the whole stage-2, as we may have numerous leaf
> > +              * entries below us which would otherwise need invalidating
> > +              * individually.
> > +              */
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +     }
> > +}
> > +
> >  /**
> >   * stage2_try_break_pte() - Invalidates a pte according to the
> >   *                       'break-before-make' requirements of the
> > @@ -693,6 +709,7 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >   *
> >   * @ctx: context of the visited pte.
> >   * @mmu: stage-2 mmu
> > + * @tlb_level: The level at which the leaf pages are expected (for FEAT_TTL hint)
>
> Do we need the caller to provide the TTL hint? We already have
> ctx->level, and stage2_try_break_pte() also knows what the removed PTE
> contained (i.e. a table or a block/page).
>
ctx->level may not always translate to TTL level hint. For example,
the patch 6/6 of this series also calls stage2_try_break_pte(), but
from the very top level (level-1). In that case, the level can be
extracted from ctx, but we won't have any idea what the TTL hint is
since we won't be traversing all of the page-table. As a result, we
pass 0. However, if we are remapping a table to a bunch of pages, TTL
level hint could be just one level down.

> >   * Returns: true if the pte was successfully broken.
> >   *
> > @@ -701,7 +718,7 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >   * on the containing table page.
> >   */
> >  static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > -                              struct kvm_s2_mmu *mmu)
> > +                              struct kvm_s2_mmu *mmu, u32 tlb_level)
> >  {
> >       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> >
> > @@ -722,7 +739,7 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >        * value (if any).
> >        */
> >       if (kvm_pte_table(ctx->old, ctx->level))
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +             kvm_table_pte_flush(mmu, ctx->addr, ctx->level, tlb_level);
>
> I don't think we should provide a TTL hint for a removed table. It is
> entirely possible for the unlinked table to contain a mix of blocks and
> pages, meaning there isn't a uniform table level for the whole range.
>
True, but it's particularly useful for the case where we know that a
table is going to be replaced by a block. In that case, can't we be
sure of the TTL level? Perhaps for other cases, we can supply 0. WDYT?

> >       else if (kvm_pte_valid(ctx->old))
> >               kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> >
> > @@ -804,7 +821,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >       if (!stage2_pte_needs_update(ctx->old, new))
> >               return -EAGAIN;
> >
> > -     if (!stage2_try_break_pte(ctx, data->mmu))
> > +     if (!stage2_try_break_pte(ctx, data->mmu, ctx->level))
> >               return -EAGAIN;
> >
> >       /* Perform CMOs before installation of the guest stage-2 PTE */
> > @@ -861,7 +878,11 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >       if (!childp)
> >               return -ENOMEM;
> >
> > -     if (!stage2_try_break_pte(ctx, data->mmu)) {
> > +     /*
> > +      * As the table will be replaced with a block, one level down would
> > +      * be the current page entries held by the table.
> > +      */
>
> This isn't necessarily true. Ignoring mixed block/pages for a moment,
> Collapsing a PUD entry into a block after dirty logging (where we mapped
> at PTE level) would imply a TTL of ctx->level + 2.
>
> But again, I think it is best to provide no hint in this case.
>
Ah, right. We could also collapse into a 1G block. No hint would be
better in that case.

Thanks,
Raghavendra

[1]: https://lore.kernel.org/linux-arm-kernel/20230119173559.2517103-1-dmatlack@google.com/T/#meca775fa8accc996900d5e9caeb004f7b9774627

> --
> Thanks,
> Oliver
