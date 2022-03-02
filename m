Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9A5C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  3 Mar 2022 11:20:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8D449EDF;
	Thu,  3 Mar 2022 06:20:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IivN2xKerNev; Thu,  3 Mar 2022 06:20:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3977249EF2;
	Thu,  3 Mar 2022 06:20:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C24C49B07
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:31:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VljmSrB50GKH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:31:16 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 093DC43C8C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:31:15 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id
 a5-20020a05600c224500b003832be89f25so1718768wmm.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 09:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=r8D9Glo/IqaUHdT1IqNZ/4L9jANqiQOBO7H8ZnJ11bo=;
 b=kprMM0PaxhQaUOtqFTUXwwSlh4FWOta0HNFj3k7wlkS3kkvEmZ+wqPXkOH8B7y9/oC
 bm2gpBOVubXzle2zPcw8J4V7zljJPHIGhK4LrcPmyX92uvl7bC9wBUgtv6SjxBBFh2dY
 hcYB13Xv3owOAW+CWyYokl0ROfZlLpNgD4VTywg6B1V5WHMB04iufGZ/UiYQmN4WA4Nr
 gaiSEvvwL/JrKDnH1wb7+LFr4UY8vX1Fl/UqusDD2AYSrYEW5Zk/uEXCJYGrCSk/ufW4
 Hn7qtBMFNHJAEYKi1pg6r+9QpgVjIiYbQPjAYT+hhjhFeyakxl5yLxHCKGsJOlUmknxn
 +W3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=r8D9Glo/IqaUHdT1IqNZ/4L9jANqiQOBO7H8ZnJ11bo=;
 b=e01ZswlEUJzkejyH1K+U4etLZ9/8wwKt9eXWyd9x4JyIpXErGbktp6PoQnpZnhewHE
 WFaXs8VlYL0VMwfU9D0Z2bthTYfRrbWZA+MMmP8OvSHhyvlXbSxw7roC3TAMdKLS7GCZ
 9w4PaIWH6HCFl1nN980Vp5e7rwjqcvcLEBFaMuoQBANFhuSQazBKfhUyuF2lxgfNnSoQ
 hsrs/armFIlfiIIrW05n4Y2E/S9BwzCOe07TMiESSsxdttlkpGM7YoBTGOZtcpPXe/5A
 MicuxPWUeMkml3JuylIeOnKyQov/aZgv5ViIbduv86TI50DpRmoDz5ACSsGy5hv+bn4m
 Cvjg==
X-Gm-Message-State: AOAM532aKsVxiJi2eE4wy0DbUzvkTj82Zc033uyQNQ77UBe4y6JVakBM
 QhanEoyaakh2jygutvE70R88jO2bWkj5L9wmSaB6FA==
X-Google-Smtp-Source: ABdhPJyq4u8HQIq9pMffamDskyFj4okMEA25x2hK2hxWrrZpj8MvyhBFFR4we+1tTnFgbJ0bfNScYb4wg6LgfMWVPhU=
X-Received: by 2002:a05:600c:2284:b0:386:90d8:73ca with SMTP id
 4-20020a05600c228400b0038690d873camr714048wmf.66.1646242274759; Wed, 02 Mar
 2022 09:31:14 -0800 (PST)
MIME-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
 <20220225033548.1912117-4-kaleshsingh@google.com>
 <87tucg6b97.wl-maz@kernel.org>
In-Reply-To: <87tucg6b97.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 2 Mar 2022 09:31:03 -0800
Message-ID: <CAC_TJvcjq5R_+UzhhqjZnusa5g+RT0HbLHBob-pTqofKgMSp9g@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] KVM: arm64: Add guard pages for KVM nVHE
 hypervisor stack
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Thu, 03 Mar 2022 06:20:26 -0500
Cc: Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 LKML <linux-kernel@vger.kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Suren Baghdasaryan <surenb@google.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Tue, Mar 1, 2022 at 11:53 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 25 Feb 2022 03:34:48 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Maps the stack pages in the flexible private VA range and allocates
> > guard pages below the stack as unbacked VA space. The stack is aligned
> > to twice its size to aid overflow detection (implemented in a subsequent
> > patch in the series).
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v4:
> >   - Replace IS_ERR_OR_NULL check with IS_ERR check now that
> >     hyp_alloc_private_va_range() returns an error for null
> >     pointer, per Fuad
> >   - Format comments to < 80 cols, per Fuad
> >
> > Changes in v3:
> >   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
> >
> >  arch/arm64/include/asm/kvm_asm.h |  1 +
> >  arch/arm64/kvm/arm.c             | 32 +++++++++++++++++++++++++++++---
> >  2 files changed, 30 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index d5b0386ef765..2e277f2ed671 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -169,6 +169,7 @@ struct kvm_nvhe_init_params {
> >       unsigned long tcr_el2;
> >       unsigned long tpidr_el2;
> >       unsigned long stack_hyp_va;
> > +     unsigned long stack_pa;
> >       phys_addr_t pgd_pa;
> >       unsigned long hcr_el2;
> >       unsigned long vttbr;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index ecc5958e27fe..0a83c0e7f838 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1541,7 +1541,6 @@ static void cpu_prepare_hyp_mode(int cpu)
> >       tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
> >       params->tcr_el2 = tcr;
> >
> > -     params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
> >       params->pgd_pa = kvm_mmu_get_httbr();
> >       if (is_protected_kvm_enabled())
> >               params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
> > @@ -1990,14 +1989,41 @@ static int init_hyp_mode(void)
> >        * Map the Hyp stack pages
> >        */
> >       for_each_possible_cpu(cpu) {
> > +             struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
> >               char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
> > -             err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
> > -                                       PAGE_HYP);
> > +             unsigned long stack_hyp_va, guard_hyp_va;
> >
> > +             /*
> > +              * Private mappings are allocated downwards from io_map_base
> > +              * so allocate the stack first then the guard page.
> > +              *
> > +              * The stack is aligned to twice its size to facilitate overflow
> > +              * detection.
> > +              */
> > +             err = __create_hyp_private_mapping(__pa(stack_page), PAGE_SIZE,
> > +                                             PAGE_SIZE * 2, &stack_hyp_va, PAGE_HYP);
>
> Right, I guess that's where my earlier ask breaks, as you want an
> alignment that is *larger* than the allocation.
>
> >               if (err) {
> >                       kvm_err("Cannot map hyp stack\n");
> >                       goto out_err;
> >               }
> > +
> > +             /* Allocate unbacked private VA range for stack guard page */
> > +             guard_hyp_va = hyp_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
>
> Huh. You are implicitly relying on the VA allocator handing you an
> address contiguous with the previous mapping. That's... brave. I'd
> rather you allocate the VA space upfront with the correct alignment
> and then map the single page where it should be in the VA region.
>
> That'd be a lot less fragile.

Agreed. I'll fix it in the next version.

Thanks,
Kalesh
>
> > +             if (IS_ERR((void *)guard_hyp_va)) {
> > +                     err = PTR_ERR((void *)guard_hyp_va);
> > +                     kvm_err("Cannot allocate hyp stack guard page\n");
> > +                     goto out_err;
> > +             }
> > +
> > +             /*
> > +              * Save the stack PA in nvhe_init_params. This will be needed
> > +              * to recreate the stack mapping in protected nVHE mode.
> > +              * __hyp_pa() won't do the right thing there, since the stack
> > +              * has been mapped in the flexible private VA space.
> > +              */
> > +             params->stack_pa = __pa(stack_page) + PAGE_SIZE;
> > +
> > +             params->stack_hyp_va = stack_hyp_va + PAGE_SIZE;
> >       }
> >
> >       for_each_possible_cpu(cpu) {
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
