Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC927C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 21:51:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4F34B1D2;
	Wed, 20 Apr 2022 17:51:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4GZL2P75KT5m; Wed, 20 Apr 2022 17:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059054B0FB;
	Wed, 20 Apr 2022 17:51:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F46C4A193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uPqGBmcE0voD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 17:51:25 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAED64A104
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:51:24 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id
 ay11-20020a05600c1e0b00b0038eb92fa965so4599940wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 14:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rP5OWtrk4WktWLxKaOlM9djXhcx1PFOBsoG0vk8ejJ4=;
 b=IsIFYApUU0Ui4KekTPmRGr3ZeeQ6LFZW58iPNtRFHIdkWqkpazH/3PBI2H9j4xODGo
 yeto18wxSYb5ugdm7IdeP8jGmcSvKcDVJOTBELz870GpPOJ666CGkJPy9sLxDaTuktFY
 xCOfOimswxqF5K+eZrWyGXah1s826WKqxyZYZz3OTINFe6EXkkOT4pI9iY5ibMzZwYpx
 E6ZrPEYCqUQ1KA6ovQQ3fY4PezQSEm+xmse+M+WWD8f2I3WluGBCMLVOjcQSvf1t+81y
 T3d+QGfCtHfgvB9+vgeUCtciDXP1XcuJFvSPL4ojn+03j9LWdglXlCOIoD8C1frT0KiH
 j5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rP5OWtrk4WktWLxKaOlM9djXhcx1PFOBsoG0vk8ejJ4=;
 b=MOwcw0ahLVq26HCmwEGa3HsGvdvbIaeOCuTirJRRzDJ1h3W+MzVUkWPuQAAB9LiK/h
 Xm+JD1PiyEEx1NlwvANjqKTwkz40wnXConli0tEx4WJVN2VqOZ58ShjA7aC6NdoqwFLW
 /vdZhYiDW2Jyuu2gBKonyxDDb3nLfInxEcZgbHHLCFTFFJD6oaFBerr25wuK/Y/yeV0L
 grXnMDJEVuNI8Vl1szQyRquQ0wjWIbfuKasmpHIokaMBzzWpoqizVuETJNT4dqjNq2ZQ
 tsMUrczQII0pOtNjtjRDbjuxOe0Y1+WzdKs8wq/ndsPrBHXWRcf/h9TazIyTVEwA0kVe
 An/A==
X-Gm-Message-State: AOAM533ks7D5YwfwoprWix34ISNfx4RwWfz7mOT6eEzfTXj6N6ijC06x
 1F9M2z7PF1hqmH0aBtvs3hbz0hFWfhYCNsOzVhVL+A==
X-Google-Smtp-Source: ABdhPJwPjeINIU8CHmBNAe17pDAu6Ngpj5ab0xFuVeaOMxuTV2W3WzInKm3hX/Q/Wnmh0WyECF668faVm90Xu6UAEfc=
X-Received: by 2002:a05:600c:4f87:b0:392:9236:3c73 with SMTP id
 n7-20020a05600c4f8700b0039292363c73mr5637940wmq.158.1650491483628; Wed, 20
 Apr 2022 14:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
 <20220408200349.1529080-6-kaleshsingh@google.com>
 <87v8v6aek0.wl-maz@kernel.org>
 <CAC_TJvd=ubTMM+BRdELFokbxiKqaePAprG-pq3fR1vjKV9L6aA@mail.gmail.com>
In-Reply-To: <CAC_TJvd=ubTMM+BRdELFokbxiKqaePAprG-pq3fR1vjKV9L6aA@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 20 Apr 2022 14:51:12 -0700
Message-ID: <CAC_TJvcWkieK9XQeKi4-nB1ijUZs0csd3wAaWpRE9a375Zx=qw@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] KVM: arm64: Detect and handle hypervisor stack
 overflows
To: Marc Zyngier <maz@kernel.org>
Cc: Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Masahiro Yamada <masahiroy@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Nathan Chancellor <nathan@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>
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

On Mon, Apr 18, 2022 at 7:41 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> On Mon, Apr 18, 2022 at 3:09 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 08 Apr 2022 21:03:28 +0100,
> > Kalesh Singh <kaleshsingh@google.com> wrote:
> > >
> > > The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
> > > are aligned such  that any valid stack address has PAGE_SHIFT bit as 1.
> > > This allows us to conveniently check for overflow in the exception entry
> > > without corrupting any GPRs. We won't recover from a stack overflow so
> > > panic the hypervisor.
> > >
> > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > > Tested-by: Fuad Tabba <tabba@google.com>
> > > Reviewed-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >
> > > Changes in v7:
> > >   - Add Fuad's Reviewed-by and Tested-by tags.
> > >
> > > Changes in v5:
> > >   - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0
> > >
> > > Changes in v3:
> > >   - Remove test_sp_overflow macro, per Mark
> > >   - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard
> > >
> > >
> > >  arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
> > >  2 files changed, 30 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > > index 3d613e721a75..be6d844279b1 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > > @@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
> > >
> > >  .macro invalid_host_el2_vect
> > >       .align 7
> > > +
> > > +     /*
> > > +      * Test whether the SP has overflowed, without corrupting a GPR.
> > > +      * nVHE hypervisor stacks are aligned so that the PAGE_SHIFT bit
> > > +      * of SP should always be 1.
> > > +      */
> > > +     add     sp, sp, x0                      // sp' = sp + x0
> > > +     sub     x0, sp, x0                      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> > > +     tbz     x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
> > > +     sub     x0, sp, x0                      // x0'' = sp' - x0' = (sp + x0) - sp = x0
> > > +     sub     sp, sp, x0                      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> > > +
> > >       /* If a guest is loaded, panic out of it. */
> > >       stp     x0, x1, [sp, #-16]!
> > >       get_loaded_vcpu x0, x1
> > > @@ -165,6 +177,18 @@ SYM_FUNC_END(__host_hvc)
> > >        * been partially clobbered by __host_enter.
> > >        */
> > >       b       hyp_panic
> > > +
> > > +.L__hyp_sp_overflow\@:
> > > +     /*
> > > +      * Reset SP to the top of the stack, to allow handling the hyp_panic.
> > > +      * This corrupts the stack but is ok, since we won't be attempting
> > > +      * any unwinding here.
> > > +      */
> > > +     ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> > > +     mov     sp, x0
> > > +
> > > +     bl      hyp_panic_bad_stack
> >
> > Why bl? You clearly don't expect to return here, given that you have
> > an ASM_BUG() right below, and that you are calling a __no_return
> > function. I think we should be consistent with the rest of the code
> > and just do a simple branch.
>
> The idea was to use bl  to give the hyp_panic_bad_stack() frame in the
> stack trace, which makes it easy to identify overflows. I can add a
> comment and drop the redundant ASM_BUG()

Sorry, my mistake here: bl will give us the current frame in the stack
trace (hyp_host_vector) so it doesn't affect hyp_panic_bad_stack (next
frame) being in the strace trace. Addressed in v8:
https://lore.kernel.org/r/20220420214317.3303360-6-kaleshsingh@google.com/

Thanks,
Kalesh

>
> Thanks,
> Kalesh
>
> >
> > It also gives us a chance to preserve an extra register from the
> > context.
> >
> > > +     ASM_BUG()
> > >  .endm
> > >
> > >  .macro invalid_host_el1_vect
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > > index 6410d21d8695..703a5d3f611b 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > > @@ -347,7 +347,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > >       return exit_code;
> > >  }
> > >
> > > -void __noreturn hyp_panic(void)
> > > +asmlinkage void __noreturn hyp_panic(void)
> > >  {
> > >       u64 spsr = read_sysreg_el2(SYS_SPSR);
> > >       u64 elr = read_sysreg_el2(SYS_ELR);
> > > @@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
> > >       unreachable();
> > >  }
> > >
> > > +asmlinkage void __noreturn hyp_panic_bad_stack(void)
> > > +{
> > > +     hyp_panic();
> > > +}
> > > +
> > >  asmlinkage void kvm_unexpected_el2_exception(void)
> > >  {
> > >       return __kvm_unexpected_el2_exception();
> > > --
> > > 2.35.1.1178.g4f1659d476-goog
> > >
> > >
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
