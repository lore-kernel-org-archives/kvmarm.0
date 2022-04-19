Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAA8C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 02:41:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD7E4B134;
	Mon, 18 Apr 2022 22:41:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYzZw6jxeUj4; Mon, 18 Apr 2022 22:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E0D4B091;
	Mon, 18 Apr 2022 22:41:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9693349EE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7WNv7Zpx3aEv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 22:41:12 -0400 (EDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6730140BA9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:41:12 -0400 (EDT)
Received: by mail-wm1-f54.google.com with SMTP id p189so9760906wmp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=R5qlpkxDkxkpAXcTdddiMdjLGBJEO/iRcDx+bQyggJo=;
 b=cwhlxpNpfyge5Tw3YhltCaJxvbzPH1qOqSuU1HdM28IFDklyXhoCyTgmNTvtsUwBTc
 MhEqSUzCPgZ17ydLw1yh2DLaycVeFyterA9iWEJvEFBp1Zfn2kpKRNOiDd0OjShHWmZ7
 GrNYrbmMIVdkv/X50S6qQIhJfio/TUA8O5TS0Qbk+6x+UF5GDahmhnv60F+tSSKeH8di
 xSBcbyKYuMji6h4/F4aZwnCImZnwejPfQhqfCiOIZlEy/ZaVGcF3aIUIByMPW2rV8Ijt
 88bEdCmrKVv3hiBlQmDvp0k8MquAJ93qj9cTAlTt3Nr10QHjjAUlSAwx3iAFHHmVMEO4
 hjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=R5qlpkxDkxkpAXcTdddiMdjLGBJEO/iRcDx+bQyggJo=;
 b=h25xnzp7mNbe6rFU4AJ5BMXkpN+FJvaYovqZdqn0QH7ZQxRZ9VSi1cQiZw9yGKAc3t
 BKgq94yacddwbwzVz5exYd49lLLgvG2ACBZxA++WCBHVfH3arEbLJeqYkoEfupVZ2rgd
 TRuoxkkai7usFVijKgiWhpnZkGD7JcAaBpn2iHcIHsDkUgogr9kWsgtb++2bpDmCkekr
 0oCHhUqJWKgr5tff9B7GJz0vHTRb1TybnKqaLdVU9X9VaVIus+0tt3/FRR9N/pLAvy/P
 v/Ef8M8+MzylwFPgI2kM2ST75vxMeXKvF8fCpjwmhp0mNi2+71BUvb3k6XWgDnrcB5MB
 IUpQ==
X-Gm-Message-State: AOAM531HJNZzPSVg+TZ7188mOq+BPG/kuDGs0XATJNgrDoHlYfXCiGCA
 z5Sgmg6Riwf8js4oU8oEj6FtN9X+rTKz03Q9lRIHKg==
X-Google-Smtp-Source: ABdhPJx9nM4O6ke6iJlgie/f9XIfjCIkbp1CTn5gtentYY+mSfxNNqEVrNPON9mnvgc4j9VZHLB3AKkkPxGxoaXUYng=
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id
 u23-20020a7bc057000000b0037bebadc9c8mr17443313wmc.61.1650336071166; Mon, 18
 Apr 2022 19:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
 <20220408200349.1529080-6-kaleshsingh@google.com>
 <87v8v6aek0.wl-maz@kernel.org>
In-Reply-To: <87v8v6aek0.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Apr 2022 19:41:00 -0700
Message-ID: <CAC_TJvd=ubTMM+BRdELFokbxiKqaePAprG-pq3fR1vjKV9L6aA@mail.gmail.com>
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

On Mon, Apr 18, 2022 at 3:09 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 08 Apr 2022 21:03:28 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
> > are aligned such  that any valid stack address has PAGE_SHIFT bit as 1.
> > This allows us to conveniently check for overflow in the exception entry
> > without corrupting any GPRs. We won't recover from a stack overflow so
> > panic the hypervisor.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > Tested-by: Fuad Tabba <tabba@google.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > ---
> >
> > Changes in v7:
> >   - Add Fuad's Reviewed-by and Tested-by tags.
> >
> > Changes in v5:
> >   - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0
> >
> > Changes in v3:
> >   - Remove test_sp_overflow macro, per Mark
> >   - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard
> >
> >
> >  arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
> >  2 files changed, 30 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 3d613e721a75..be6d844279b1 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
> >
> >  .macro invalid_host_el2_vect
> >       .align 7
> > +
> > +     /*
> > +      * Test whether the SP has overflowed, without corrupting a GPR.
> > +      * nVHE hypervisor stacks are aligned so that the PAGE_SHIFT bit
> > +      * of SP should always be 1.
> > +      */
> > +     add     sp, sp, x0                      // sp' = sp + x0
> > +     sub     x0, sp, x0                      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> > +     tbz     x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
> > +     sub     x0, sp, x0                      // x0'' = sp' - x0' = (sp + x0) - sp = x0
> > +     sub     sp, sp, x0                      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> > +
> >       /* If a guest is loaded, panic out of it. */
> >       stp     x0, x1, [sp, #-16]!
> >       get_loaded_vcpu x0, x1
> > @@ -165,6 +177,18 @@ SYM_FUNC_END(__host_hvc)
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
>
> Why bl? You clearly don't expect to return here, given that you have
> an ASM_BUG() right below, and that you are calling a __no_return
> function. I think we should be consistent with the rest of the code
> and just do a simple branch.

The idea was to use bl  to give the hyp_panic_bad_stack() frame in the
stack trace, which makes it easy to identify overflows. I can add a
comment and drop the redundant ASM_BUG()

Thanks,
Kalesh

>
> It also gives us a chance to preserve an extra register from the
> context.
>
> > +     ASM_BUG()
> >  .endm
> >
> >  .macro invalid_host_el1_vect
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 6410d21d8695..703a5d3f611b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -347,7 +347,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >       return exit_code;
> >  }
> >
> > -void __noreturn hyp_panic(void)
> > +asmlinkage void __noreturn hyp_panic(void)
> >  {
> >       u64 spsr = read_sysreg_el2(SYS_SPSR);
> >       u64 elr = read_sysreg_el2(SYS_ELR);
> > @@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
> >       unreachable();
> >  }
> >
> > +asmlinkage void __noreturn hyp_panic_bad_stack(void)
> > +{
> > +     hyp_panic();
> > +}
> > +
> >  asmlinkage void kvm_unexpected_el2_exception(void)
> >  {
> >       return __kvm_unexpected_el2_exception();
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
> >
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
