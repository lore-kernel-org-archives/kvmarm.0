Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F261C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 18:43:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C928A6526C
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 18:43:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C928A6526C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493E54B478;
	Mon,  8 Mar 2021 13:43:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WUtz5SSAo16k; Mon,  8 Mar 2021 13:43:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E684B419;
	Mon,  8 Mar 2021 13:43:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF684B3D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 13:43:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id No5NmwW-RBO6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 13:43:53 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D20164B108
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 13:43:52 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id u4so22697429lfs.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Mar 2021 10:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oWJi9TTK3RpTTf/7yDpb3oKd8vTmZ+hAd/ZIvo399K0=;
 b=VDtPSQXlEcN+q/UYFT4QEKwBkymIGMbNymOpTZqlJp1yVZszjOrHhcSGx9SoKLjNHv
 vjU+4cVg3NgBi4iN4aWrHKfSupE3huSJ5oxnbVMdLKVlNtdW7gH3r0pnlQxXtvwBLzma
 0l0hIsr07cNuqnswsLmBM3Gauey8bhBHBunRF28DNV48YBMtjmJxqtS5uhAB61E7/H3P
 HqbTxcX1jXT/pG138l1FiXJJZbp3yf8SWcFeMsF401pmqJ+ZFiCgtQLaG3y/ZT6FQa76
 yKWLOvST0TKWWT0+pS58+dcMSWRgqN60nODXwRKRF6U6gKoC4p/ywvSRi21HfY0+TwMJ
 qXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oWJi9TTK3RpTTf/7yDpb3oKd8vTmZ+hAd/ZIvo399K0=;
 b=fxN0r+YVTlyJAEv2HvKl1KrhBZq40wF//htIj+D+OGXBlu1QGxpYkA1UW1v+EfXy0g
 3g9SpbgnIJC5Z2ty+ilmCtB/KWDHwsEyy4WezdsmGQMRiSICmOQ8zTdps3MDx7S8PPcx
 2xGraMiO5SMW9dr5I99osxef/FD/zVE5QHYdw6C1DCFhmTAtE9P6weJDozL6KtqKTUuk
 Ku6LIkQ4oCgG/H/BXgXksx4409sEFe+EkZBKEP+By3nhdVPsW7wtS1Q2AToXiERDePLU
 Gv3huN5naij3XTYBv14xtXPDeO12wtXIdpkhvL8h2RdbHgKFL++sOCVDJYnavUTT9wPl
 1vfw==
X-Gm-Message-State: AOAM532XdJyph/lOE6AaV/O35YEZJOR7/RX4Dd5yOwJMerzNeWokMe7o
 sunK6hWHwzCi2PbHjz0cemvUf+XrM8ZP1qO8GrtucQ==
X-Google-Smtp-Source: ABdhPJxNiNBgvk6wXCSYzNgULfRUBJt1pMh/Hd/bhT6XXmFMIkmzLRDwOxVJYiu9798wXBq4uKOEtpr5D7uRIIY6MY4=
X-Received: by 2002:ac2:5ca7:: with SMTP id e7mr15135284lfq.646.1615229030939; 
 Mon, 08 Mar 2021 10:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20210205044403.1559010-1-jingzhangos@google.com>
 <20210308164902.GA26772@willie-the-truck>
In-Reply-To: <20210308164902.GA26772@willie-the-truck>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 8 Mar 2021 12:43:40 -0600
Message-ID: <CAAdAUtjhye2f5uHQjmYdfU8HD+c0WvxvbaLg3AKzu28tEDkDhQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Remove redundant check for S2FWB
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

Hi Will,

On Mon, Mar 8, 2021 at 10:49 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Feb 05, 2021 at 04:44:03AM +0000, Jing Zhang wrote:
> > Remove redundant check for CPU feature S2FWB in dcache flush code
> > to save some CPU cycles for every memslot flush and unmapping.
> > And move the S2FWB check to outer functions to avoid future
> > redundancy and keep consistent with other usage like in
> > access_dcsw and kvm_arch_prepare_memory_region.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 9 ++-------
> >  arch/arm64/kvm/mmu.c         | 3 ++-
> >  2 files changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index bdf8e55ed308..afd57564b1cb 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -642,9 +642,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >
> >  static void stage2_flush_dcache(void *addr, u64 size)
> >  {
> > -     if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> > -             return;
> > -
> >       __flush_dcache_area(addr, size);
> >  }
> >
> > @@ -670,7 +667,8 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >
> >               if (page_count(virt_to_page(childp)) != 1)
> >                       return 0;
> > -     } else if (stage2_pte_cacheable(pte)) {
> > +     } else if (stage2_pte_cacheable(pte) &&
> > +                     !cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> >               need_flush = true;
> >       }
> >
> > @@ -846,9 +844,6 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >               .flags  = KVM_PGTABLE_WALK_LEAF,
> >       };
> >
> > -     if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> > -             return 0;
> > -
> >       return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
>
> I think we should leave pgtable.c as it is: there's no benefit from this
> change on the unmap path, and the other path involves the case where the
> caller has asked for a flush and we can elide it.
Agreed.
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7d2257cc5438..53130ed23304 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1458,7 +1458,8 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
> >        * If switching it off, need to clean the caches.
> >        * Clean + invalidate does the trick always.
> >        */
> > -     if (now_enabled != was_enabled)
> > +     if (now_enabled != was_enabled &&
> > +                     !cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> >               stage2_flush_vm(vcpu->kvm);
>
> This change looks fine, but I don't grok the justification in your follow-up
> email. You say:
>
>   | The saving is from the code path of memslot flush. The S2FWB check was
>   | in stage2_flush_dcache, in which case, for a memslot flush, the check
>   | was done for every page.
>
> but I don't see where this is called for every page. It looks to me like it's
> called for every pgd in the range, which is a very different kettle of frogs.
>
> What am I missing?
You are right. It is called for every pgd in the range instead of for
every page.
>
> Will

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
