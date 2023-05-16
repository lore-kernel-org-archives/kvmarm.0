Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086534CD4
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 17:32:36 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1aaf702c3ccso7405ad.1
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 10:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684258356; x=1686850356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rwakRNEZg00nJzKAJVvqSW5mx9DF58xDsBOKOjXcGQA=;
        b=48zw4tbCUK3vGZufLMLLEwQ+sgsBMegKdmj0vJqljYT3moOcm3JXbsptCXCTkJkGuw
         F4Le0TQpKcQI7LVTK/toaaDPgbalw7SjJIGn2JHUg4K3ylsY6S+11ElYio9txLwt5SZU
         QIZQNV6gWxlBAtqqgy5wQViycV5Qd92NnCemXf33+lgCplDy+s+jOdgn735Jkotk2R63
         NgLE32DdSzY3Z8U09U1UngZ0PSSvVLOeYy9Ehx2QMPaaXhcWc4Xq5KQVZP2AsEUPf+1z
         sG2X+iCKKFlNr1J2KvX7XQs44of0426qvz238/vBQARnCyTTplIbzOaaLlfIXMVMOyVK
         ljoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684258356; x=1686850356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwakRNEZg00nJzKAJVvqSW5mx9DF58xDsBOKOjXcGQA=;
        b=K7NkwnHDuN29qhpwZQ8jV+c00w5Vi/QFhfvl+3r/OPIJT8VMnfzOdDcadANlGYOqGR
         eZqTUav/ELrBPjUAKLU7XZgBsDJkdbYLTMdA9oo1CC9LVQ3nH7kVxa9dBPuF7eMCGz2P
         JjNzG1H2F+wkZuaXlebl996v57sSzwLXdqSgMIvSmmf2wtJMvuAw4KTTbN5+SPZH139/
         HNrNju8/CRAlfk/SsYkSgnGsrUtzxJHdIqCP824hC2Sjlc5cppPsNv+kQbE+S/6KnC7G
         FXFgIyaB7nIf45iGlzOLaL/HwsuQUHfez2ojbrDojut8pmKEsPl4xuMXCF/eOEiaALUz
         Kq2w==
X-Gm-Message-State: AC+VfDxuLFV3m440dEbAvcC3tAIulpQutJq9+mxhp8AtBc0OgOOuNVhQ
	mDtOSp3oKk3bPYaIDvoQgAglW/JFj/z59n+19EyM4g==
X-Google-Smtp-Source: ACHHUZ6wWlpTv3IpwTR512FEiD5s98A5U3Lt0r6lTl9BzMmumqhm2ei8LXBGXvZYcIrzuW22YQrsdzk3pHp0zdiWakE=
X-Received: by 2002:a17:903:187:b0:1a6:6a2d:18f0 with SMTP id
 z7-20020a170903018700b001a66a2d18f0mr213668plg.9.1684258352254; Tue, 16 May
 2023 10:32:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-7-rananta@google.com>
 <ZF51f5tYPjK1aCpd@linux.dev>
In-Reply-To: <ZF51f5tYPjK1aCpd@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 16 May 2023 10:32:20 -0700
Message-ID: <CAJHc60wJob+VpRN-Z3VDTH1sVHSYUxPSCpyKCrC4rFBRuCcsQA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: Add 'skip_flush' arg to stage2_put_pte()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Ricardo Koller <ricarkol@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, May 12, 2023 at 10:21=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghavendra,
>
> On Fri, Apr 14, 2023 at 05:29:21PM +0000, Raghavendra Rao Ananta wrote:
> > Add a 'skip_flush' argument in stage2_put_pte() to
> > control the TLB invalidations. This will be leveraged
> > by the upcoming patch to defer the individual PTE
> > invalidations until the entire walk is finished.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index b8f0dbd12f773..3f136e35feb5e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -772,7 +772,7 @@ static void stage2_make_pte(const struct kvm_pgtabl=
e_visit_ctx *ctx, kvm_pte_t n
> >  }
> >
> >  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, st=
ruct kvm_s2_mmu *mmu,
> > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > +                        struct kvm_pgtable_mm_ops *mm_ops, bool skip_f=
lush)
>
> Assuming you are going to pull the cpufeature checks into this helper,
> it might me helpful to narrow the scope of it. 'stage2_put_pte()' sounds
> very generic, but it is about to have a very precise meaning in relation
> to kvm_pgtable_stage2_unmap().
>
> So maybe stage2_unmap_put_pte()? While at it, you'd want to have a
> shared helper for the deferral check:
>
Yeah, stage2_unmap_put_pte() sounds better. I'll change that.

> static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> {
>         /* your blurb for why FWB is required too */
>         return system_supports_tlb_range() && stage2_has_fwb(pgt);
> }
>
Good idea; I can introduce the helper, now that we'll get rid of
stage2_unmap_data.skip_pte_tlbis (patch 7/7) as per your comments.
Also, since we are now making stage2_put_pte() specific to unmap, I
can also get rid of the 'skip_flush' arg and call
stage2_unmap_defer_tlb_flush() directly, or do you have a preference
for the additional arg?

Thank you.
Raghavendra
> The 'flush' part is annoying, because the exact term is an invalidation,
> but we already have that pattern in all of our TLB invalidation helpers.
>
> >  {
> >       /*
> >        * Clear the existing PTE, and perform break-before-make with
> > @@ -780,7 +780,10 @@ static void stage2_put_pte(const struct kvm_pgtabl=
e_visit_ctx *ctx, struct kvm_s
> >        */
> >       if (kvm_pte_valid(ctx->old)) {
> >               kvm_clear_pte(ctx->ptep);
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ct=
x->level);
> > +
> > +             if (!skip_flush)
> > +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > +                                     ctx->addr, ctx->level);
> >       }
> >
> >       mm_ops->put_page(ctx->ptep);
> > @@ -1015,7 +1018,7 @@ static int stage2_unmap_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >        * block entry and rely on the remaining portions being faulted
> >        * back lazily.
> >        */
> > -     stage2_put_pte(ctx, mmu, mm_ops);
> > +     stage2_put_pte(ctx, mmu, mm_ops, false);
> >
> >       if (need_flush && mm_ops->dcache_clean_inval_poc)
> >               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, m=
m_ops),
> > --
> > 2.40.0.634.g4ca3ef3211-goog
> >
>
> --
> Thanks,
> Oliver
