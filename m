Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55392C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 09:01:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B9C40C02;
	Tue, 15 Feb 2022 04:01:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Xv4xvHFu1+j; Tue, 15 Feb 2022 04:01:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E47E640CF5;
	Tue, 15 Feb 2022 04:01:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C33A149DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 17:03:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id POv8-7CZEPFk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 17:03:51 -0500 (EST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B73A49B26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 17:03:51 -0500 (EST)
Received: by mail-wm1-f50.google.com with SMTP id n8so5518007wms.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 14:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=38jyLv0u0qIybtfltYvr9HnUqxoAfv/j6qkWJXrbAAo=;
 b=Bbc1wXI0wF4/tZHAV6O92OtxEnnXMyCGRgfqz5u8k0HZT2ULi2fbifTaHrNxSmtJ+D
 /pB4mpDnuSXZnBFMUsmFm4Pvr+kbqQhRpv1knlo6l/11eVtn6Vc/fFlNmmKmA3RbbSTb
 eW1UHQ+bkXRbVHL3pEd1Av2GFhuri7dyi7vq5QH08mWS8pKEgcR9GeKfRlZzDdqsFVvO
 cEJoH+Uw1klNK6ivy+ROT1OedTUHu+cO/vuBJ8Wyvvwuvj6qLPOGuvG18v21Xpxl4yUI
 rAC9VeUwTqi0p/izmYFOFhR7dhFMjP4bf/eIoYUvx1WWN4McP/eIu6q4bT+HZGV5il/U
 bkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=38jyLv0u0qIybtfltYvr9HnUqxoAfv/j6qkWJXrbAAo=;
 b=N3LpQH3++HthhUuvzeG3tXVP22nZeFzbUf8wKdcGLCzVhplfMuLRj1vN5QjMhNxump
 0/xP+LHT3pkRaqPklu9xCb0jWTaoY0JdE7QZ6mBAHAX/1M+lge23WUXtvNDA+8f277Fd
 2KG1ii87qvJlADcytzdNfWrmmHPFvoJ603fS2O51fdrz3jxdU9CyCExKAl0TsZT48eez
 jZsU7oLbLyB1aau6oLM7wCx9M+r87SycaQdIXyDFIsOzGWg+vCw7DV3O9Z8FuPu50gpT
 mosVA+6tP6VaELk6AIscvZW8k5kVl3i++W4e3mZyzwYJAWhZkNiBSIyP58eqUGa1DPHB
 Uk7w==
X-Gm-Message-State: AOAM5302mt4ZgGZNetoBhzVelu1pSmlN2NpFpv+haNPsXcJ+1TeM+Q0c
 VinxchRbABuogb4lq3rEipb54oVmOTflqYYGqZM00w==
X-Google-Smtp-Source: ABdhPJyuOiZOcvtPPW6+z6Ib5nhEDOP4uK+8XwPv1UzoZ8fYA3rhV/irfeMg2SHAqjLLlCju5rICe7VFiX47yacb0YE=
X-Received: by 2002:a05:600c:3b21:: with SMTP id
 m33mr633946wms.7.1644876230035; 
 Mon, 14 Feb 2022 14:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
 <20220210224220.4076151-5-kaleshsingh@google.com>
 <87leyd4k5q.wl-maz@kernel.org>
In-Reply-To: <87leyd4k5q.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 14 Feb 2022 14:03:38 -0800
Message-ID: <CAC_TJvep6n74PJARzR9J9_pHZEGUnehb0W50f64m-16UGJE_Cg@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: Allocate guard pages near hyp stacks
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Tue, 15 Feb 2022 04:01:17 -0500
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 LKML <linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Mon, Feb 14, 2022 at 6:06 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 22:41:45 +0000,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > From: Quentin Perret <qperret@google.com>
> >
> > Allocate unbacked VA space underneath each stack page to ensure stack
> > overflows get trapped and don't corrupt memory silently.
> >
> > The stack is aligned to twice its size (PAGE_SIZE), meaning that any
> > valid stack address has PAGE_SHIFT bit as 0. This allows us to easily
> > check for overflow in the exception entry without corrupting any GPRs.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > [ Kalesh - Update commit text and comments,
> >            refactor, add overflow handling ]
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/host.S   | 16 ++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c  | 19 ++++++++++++++++++-
> >  arch/arm64/kvm/hyp/nvhe/switch.c |  5 +++++
> >  3 files changed, 39 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 3d613e721a75..78e4b612ac06 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -153,6 +153,10 @@ SYM_FUNC_END(__host_hvc)
> >
> >  .macro invalid_host_el2_vect
> >       .align 7
> > +
> > +     /* Test stack overflow without corrupting GPRs */
> > +     test_sp_overflow PAGE_SHIFT, .L__hyp_sp_overflow\@
> > +
>
> I am definitely concerned with this in a system not using pKVM (which
> is on average 100% of the upstream users so far! ;-). This is more or
> less guaranteed to do the wrong thing 50% of the times, depending on
> the alignment of the stack.

Thanks for pointing this out Marc. I'll rework this to work for both
protected and non-protected modes.

>
> >       /* If a guest is loaded, panic out of it. */
> >       stp     x0, x1, [sp, #-16]!
> >       get_loaded_vcpu x0, x1
> > @@ -165,6 +169,18 @@ SYM_FUNC_END(__host_hvc)
> >        * been partially clobbered by __host_enter.
> >        */
> >       b       hyp_panic
> > +
> > +.L__hyp_sp_overflow\@:
> > +     /*
> > +      * Reset SP to the top of the stack, to allow handling the hyp_panic.
> > +      * This corrupts the stack but is ok, since we won't be attempting
> > +      * any unwinding here.
> > +      */
> > +     ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> > +     mov     sp, x0
> > +
> > +     bl      hyp_panic_bad_stack
> > +     ASM_BUG()
> >  .endm
> >
> >  .macro invalid_host_el1_vect
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 99e178cf4249..114053dff228 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -105,7 +105,24 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >               if (ret)
> >                       return ret;
> >
> > -             /* Map stack pages in the 'private' VA range */
> > +             /*
> > +              * Allocate 'private' VA range for stack guard pages.
> > +              *
> > +              * The 'private' VA range grows upward and stacks downwards, so
> > +              * allocate the guard page first. But make sure to align the
> > +              * stack itself with PAGE_SIZE * 2 granularity to ease overflow
> > +              * detection in the entry assembly code.
> > +              */
> > +             do {
> > +                     start = (void *)hyp_alloc_private_va_range(PAGE_SIZE);
> > +                     if (IS_ERR(start))
> > +                             return PTR_ERR(start);
> > +             } while (IS_ALIGNED((u64) start, PAGE_SIZE * 2));
>
> This seems cumbersome. Can't we tweak hyp_alloc_private_va_range() to
> perform the required alignment? It could easily be convinced to return
> an address that is aligned on the size of the region, which would
> avoid this sort of loop.

Ack. I'll update it for v2.

- Kalesh

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
