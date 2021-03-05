Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD17C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47EE964F4C
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47EE964F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D70B64B27D;
	Fri,  5 Mar 2021 13:58:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gci09nxMexdT; Fri,  5 Mar 2021 13:58:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984654B43F;
	Fri,  5 Mar 2021 13:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C24454B21E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 11:55:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0M293qn3vG1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 11:55:54 -0500 (EST)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com
 [209.85.217.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C5E24B204
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 11:55:54 -0500 (EST)
Received: by mail-vs1-f46.google.com with SMTP id b189so1319208vsd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 08:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NKf5oBBu2KISuo5V0ahvjDLUwLWiqpHm4voeGNA9XVQ=;
 b=MFc/EgDeUn5T82qMVlgRjQ8BfFaLSo8y39d7Tq6SwZJoyUiEUORWtASykVvNbxEIyF
 FP1J8f+/4QHcuUIRn7KvRoG1BoNPrbI5TsXRA8ViSu6CusWjgPcQfCW+Xzu8vHu6LOYr
 jOi/jbaJQlMBxQ8PPc1CaXyub0rqamP3K9ttcvy0W+UfRQ9XKeeqbvYX72/5dzAtnpr6
 /7pMt32h3e5jH2DgdcjfdxCLx5DInK3o3UhTtsenKKiGCKFKfyzYTI8e/2jFriUSO6yL
 40xvLUDycCVb4xx0SgkLpiYwK14bnT68fRLDitnsudT4vHsxFbW/obrkBY5ISbUWs5AE
 2Arw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NKf5oBBu2KISuo5V0ahvjDLUwLWiqpHm4voeGNA9XVQ=;
 b=OOXg+yKP0gGIhLUszHHnwyl39sI5D9JlJf6h2i1O5IpsoCoK0lgOMo3JaK0hkB7FN5
 5E8YQHXrzD8I5i33ajdqgBKZkyZhF98K+Y+vithKqNJaSWK5tqmhBi8nBU5BqUE1TwCs
 7G7uGORb0rMtuHyyZkcXNPPAp3+5sz3E0P2R7KSR6HO2q9y+K/Fmy1PQWQ43Ap8yqxeX
 EY11zDZu+QtCZP1wAhW+RWFhr11Hqhpj9gJS1V2XUNYq9x1vsb5Xc6ki9rvCtoJjAmGP
 1hGHYl5cGQGAS7NZ12frW5P4UaQmpZW+aI8YeVYepOPP59NBzKPiw9objDkFaBpBBC39
 lmbQ==
X-Gm-Message-State: AOAM530+nFMozdiJozgOSeTD9YztTB5lSqOraznQ/VFMOxf/kndc+8Pt
 MbVYSTbm0AnsKG4WM+c3LduTZXqg2MoQwDoxcLrgog==
X-Google-Smtp-Source: ABdhPJzpfWrcs5DxykHEI6KERA5BOBknmIj6EemM4VWPPImoQO4fG5rdh8rsez5jUuFficqkpwK3BC3QFLegheMWHTs=
X-Received: by 2002:a67:ed4a:: with SMTP id m10mr7437760vsp.14.1614963353636; 
 Fri, 05 Mar 2021 08:55:53 -0800 (PST)
MIME-Version: 1.0
References: <20210304184544.2014171-1-samitolvanen@google.com>
 <87k0qmzq5u.wl-maz@kernel.org>
 <CABCJKufmjMT8+hGEnL3aJM7-OSwhYSHiJA=i8e7dHSGDWXYtsg@mail.gmail.com>
 <878s72sgwt.wl-maz@kernel.org>
 <CABCJKud1EmXmmQj-YOUNCFhE3P1W6Uhqpwe1G0zcR5zw71ksJA@mail.gmail.com>
 <CABCJKudvzBggE7AZQERto5Wo_LoL0G2sNee7_1R7h2TnGhjq8A@mail.gmail.com>
 <87im65zvb9.wl-maz@kernel.org>
 <CAMj1kXEg2cwyJ4BnPq9nWKkG0rcBJhUZasTLThba4Fnt+3e9Vw@mail.gmail.com>
In-Reply-To: <CAMj1kXEg2cwyJ4BnPq9nWKkG0rcBJhUZasTLThba4Fnt+3e9Vw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 5 Mar 2021 08:55:42 -0800
Message-ID: <CABCJKud2eSr8ZfPxwa3XVTaJvAfYgydsWUu-AKo2gtNStQshFQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Disable LTO in hyp
To: Ard Biesheuvel <ardb@kernel.org>
X-Mailman-Approved-At: Fri, 05 Mar 2021 13:58:33 -0500
Cc: Kees Cook <keescook@chromium.org>, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Fri, Mar 5, 2021 at 6:22 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 5 Mar 2021 at 12:38, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 05 Mar 2021 02:38:17 +0000,
> > Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > On Thu, Mar 4, 2021 at 2:34 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > > >
> > > > On Thu, Mar 4, 2021 at 2:17 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > On Thu, 04 Mar 2021 21:25:41 +0000,
> > > > > Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > [...]
> >
> > > > > > I assume hyp_panic() ends up being placed too far from __guest_enter()
> > > > > > when the kernel is large enough. Possibly something to do with LLVM
> > > > > > always splitting functions into separate sections with LTO. I'm not
> > > > > > sure why the linker cannot shuffle things around to make everyone
> > > > > > happy in this case, but I confirmed that this patch also fixes the
> > > > > > build issue for me:
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > > index af8e940d0f03..128197b7c794 100644
> > > > > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > > @@ -214,7 +214,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> > > > > >  }
> > > > > >  NOKPROBE_SYMBOL(__hyp_call_panic);
> > > > > >
> > > > > > -void __noreturn hyp_panic(void)
> > > > > > +void __noreturn hyp_panic(void) __section(".text")
> > > > > >  {
> > > > > >         u64 spsr = read_sysreg_el2(SYS_SPSR);
> > > > > >         u64 elr = read_sysreg_el2(SYS_ELR);
> > > > > >
> > > > >
> > > > > We're getting into black-magic territory here. Why wouldn't hyp_panic
> > > > > be in the .text section already?
> > > >
> > > > It's not quite black magic. LLVM essentially flips on
> > > > -ffunction-sections with LTO and therefore, hyp_panic() will be in
> > > > .text.hyp_panic in vmlinux.o, while __guest_enter() will be in .text.
> > > > Everything ends up in .text when we link vmlinux, of course.
> > > >
> > > > $ readelf --sections vmlinux.o | grep hyp_panic
> > > >   [3936] .text.hyp_panic   PROGBITS         0000000000000000  004b56e4
> > >
> > > Note that disabling LTO here has essentially the same effect as using
> > > __section(".text"). It stops the compiler from splitting these
> > > functions into .text.* sections and makes it less likely that
> > > hyp_panic() ends up too far away from __guest_enter().
> > >
> > > If neither of these workarounds sound appealing, I suppose we could
> > > alternatively change hyp/entry.S to use adr_l for hyp_panic. Thoughts?
> >
> > That would be an actual fix instead of a workaround, as it would
> > remove existing assumptions about the relative locations of the two
> > objects. I guess you need to fix both instances with something such
> > as:
> >
> > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> > index b0afad7a99c6..a43e1f7ee354 100644
> > --- a/arch/arm64/kvm/hyp/entry.S
> > +++ b/arch/arm64/kvm/hyp/entry.S
> > @@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
> >
> >         // If the hyp context is loaded, go straight to hyp_panic
> >         get_loaded_vcpu x0, x1
> > -       cbz     x0, hyp_panic
> > -
> > +       cbnz    x0, 1f
> > +       adr_l   x0, hyp_panic
> > +       br      x0
> > +1:
>
> Agree with replacing the conditional branches that refer to external
> symbols: the compiler never emits those, for the reason we are seeing
> here, i.e., the range is simply insufficient.
>
> But let's just use 'b hyp_panic' instead, no?

Alright, this seems to work for me:

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..c62265951467 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)

        // If the hyp context is loaded, go straight to hyp_panic
        get_loaded_vcpu x0, x1
-       cbz     x0, hyp_panic
+       cbnz    x0, 1f
+       b       hyp_panic

+1:
        // The hyp context is saved so make sure it is restored to allow
        // hyp_panic to run at hyp and, subsequently, panic to run in the host.
        // This makes use of __guest_exit to avoid duplication but sets the
@@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
        // current state is saved to the guest context but it will only be
        // accurate if the guest had been completely restored.
        adr_this_cpu x0, kvm_hyp_ctxt, x1
-       adr     x1, hyp_panic
+       adr_l   x1, hyp_panic
        str     x1, [x0, #CPU_XREG_OFFSET(30)]

        get_vcpu_ptr    x1, x0

But when I say work, I mean this fixes the allmodconfig build with
LTO, and my kernel boots at EL2. I don't actually have a way to
properly test KVM on arm64. If nobody sees obvious issues here, I can
send a proper patch a bit later.

> >         // The hyp context is saved so make sure it is restored to allow
> >         // hyp_panic to run at hyp and, subsequently, panic to run in the host.
> >         // This makes use of __guest_exit to avoid duplication but sets the
> > @@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
> >         // current state is saved to the guest context but it will only be
> >         // accurate if the guest had been completely restored.
> >         adr_this_cpu x0, kvm_hyp_ctxt, x1
> > -       adr     x1, hyp_panic
> > +       adr_l   x1, hyp_panic
> >         str     x1, [x0, #CPU_XREG_OFFSET(30)]
> >
> >         get_vcpu_ptr    x1, x0
> >
> > which is completely untested. I wouldn't be surprised if there were
> > more of these somewhere.
> >
>
> A quick grep gives me
>
> $ objdump -r vmlinux.o |grep BR19
> 000000000005b6e0 R_AARCH64_CONDBR19  hyp_panic
> 0000000000418e08 R_AARCH64_CONDBR19  __memcpy
> 0000000000418e14 R_AARCH64_CONDBR19  __memcpy

These two are in __memmove. This shouldn't be an issue, at least with LTO.

> 0000000000003818 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003898 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003918 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003998 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003a18 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003a98 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003b18 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003b98 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
> 0000000000003c10 R_AARCH64_CONDBR19  __kvm_nvhe___host_exit
> 0000000000003c1c R_AARCH64_CONDBR19  __kvm_nvhe___host_exit
> 00000000000064f0 R_AARCH64_CONDBR19  __kvm_nvhe_hyp_panic
> 000000000000078c R_AARCH64_CONDBR19  __kvm_nvhe___kvm_handle_stub_hvc

It looks like all the nvhe code is linked together into kvm_nvhe.o, so
I don't think these will cause problems either.

Sami
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
