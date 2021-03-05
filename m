Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974ADC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 14:22:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 057D96509D
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 14:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 057D96509D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE044B148;
	Fri,  5 Mar 2021 09:22:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9FGmqLVq22zy; Fri,  5 Mar 2021 09:22:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B234B660;
	Fri,  5 Mar 2021 09:22:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F027F4B449
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 09:22:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b-1EWdwJdLG7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 09:22:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9DAC4B448
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 09:22:41 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C901B650A1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614954158;
 bh=TF6kkVYhiMKo/VRx3K5CMKWJtwR127Kj6DaWkXM7xpE=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=QYvp/tYwgK6SFE3F0D46qQTC+0Scc2rKODmAzdtJSp/NMImt7wZ7q4SehKlqYJyL1
 +0vWOExN5hRIOoaZsy3auR8SsNa6KHQiUczo/UcqVKlE4SxPPQv2eAHKBQMzdPdz4u
 eTmCs31dc1tkRzGaMqXBhCFCcUNrwOR4Fi9V2F68EjZ7sWF8AEmiLx9F2Qamt1DrC8
 47fr4IyAOk9dL8OqE8GcPs05JwGkTG45+lDdIHdCnpYjZPZUnmyjW+eVxSTctMDydI
 BijhO+edkLCQdS4mnXPPQet3XDwEOjwa9tejfNmtSLE9Zc0g9LGpVsFye6mwKd4a3j
 OG8r0aVPH9byg==
Received: by mail-ot1-f51.google.com with SMTP id w3so1914338oti.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 06:22:38 -0800 (PST)
X-Gm-Message-State: AOAM530SJjzpNpBccAiWsMSKJXuY+Bbqk0+0tctzDZeqfIZHvHcXR0QO
 TsemMhxaSEnuxRECidmq0SVTE8DkYYcsflQ0X+s=
X-Google-Smtp-Source: ABdhPJyrLkuAbmq8cSLTxcWDjM/KdwrZ83+kVR0FSwcH1L5bylc1eHPXfyo5umymmymnntnqFd81lgDobSGEl6F7+VU=
X-Received: by 2002:a9d:7512:: with SMTP id r18mr8348674otk.90.1614954158033; 
 Fri, 05 Mar 2021 06:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20210304184544.2014171-1-samitolvanen@google.com>
 <87k0qmzq5u.wl-maz@kernel.org>
 <CABCJKufmjMT8+hGEnL3aJM7-OSwhYSHiJA=i8e7dHSGDWXYtsg@mail.gmail.com>
 <878s72sgwt.wl-maz@kernel.org>
 <CABCJKud1EmXmmQj-YOUNCFhE3P1W6Uhqpwe1G0zcR5zw71ksJA@mail.gmail.com>
 <CABCJKudvzBggE7AZQERto5Wo_LoL0G2sNee7_1R7h2TnGhjq8A@mail.gmail.com>
 <87im65zvb9.wl-maz@kernel.org>
In-Reply-To: <87im65zvb9.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 5 Mar 2021 15:22:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEg2cwyJ4BnPq9nWKkG0rcBJhUZasTLThba4Fnt+3e9Vw@mail.gmail.com>
Message-ID: <CAMj1kXEg2cwyJ4BnPq9nWKkG0rcBJhUZasTLThba4Fnt+3e9Vw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Disable LTO in hyp
To: Marc Zyngier <maz@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Fangrui Song <maskray@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
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

On Fri, 5 Mar 2021 at 12:38, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 05 Mar 2021 02:38:17 +0000,
> Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Thu, Mar 4, 2021 at 2:34 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > On Thu, Mar 4, 2021 at 2:17 PM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On Thu, 04 Mar 2021 21:25:41 +0000,
> > > > Sami Tolvanen <samitolvanen@google.com> wrote:
>
> [...]
>
> > > > > I assume hyp_panic() ends up being placed too far from __guest_enter()
> > > > > when the kernel is large enough. Possibly something to do with LLVM
> > > > > always splitting functions into separate sections with LTO. I'm not
> > > > > sure why the linker cannot shuffle things around to make everyone
> > > > > happy in this case, but I confirmed that this patch also fixes the
> > > > > build issue for me:
> > > > >
> > > > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > index af8e940d0f03..128197b7c794 100644
> > > > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > @@ -214,7 +214,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> > > > >  }
> > > > >  NOKPROBE_SYMBOL(__hyp_call_panic);
> > > > >
> > > > > -void __noreturn hyp_panic(void)
> > > > > +void __noreturn hyp_panic(void) __section(".text")
> > > > >  {
> > > > >         u64 spsr = read_sysreg_el2(SYS_SPSR);
> > > > >         u64 elr = read_sysreg_el2(SYS_ELR);
> > > > >
> > > >
> > > > We're getting into black-magic territory here. Why wouldn't hyp_panic
> > > > be in the .text section already?
> > >
> > > It's not quite black magic. LLVM essentially flips on
> > > -ffunction-sections with LTO and therefore, hyp_panic() will be in
> > > .text.hyp_panic in vmlinux.o, while __guest_enter() will be in .text.
> > > Everything ends up in .text when we link vmlinux, of course.
> > >
> > > $ readelf --sections vmlinux.o | grep hyp_panic
> > >   [3936] .text.hyp_panic   PROGBITS         0000000000000000  004b56e4
> >
> > Note that disabling LTO here has essentially the same effect as using
> > __section(".text"). It stops the compiler from splitting these
> > functions into .text.* sections and makes it less likely that
> > hyp_panic() ends up too far away from __guest_enter().
> >
> > If neither of these workarounds sound appealing, I suppose we could
> > alternatively change hyp/entry.S to use adr_l for hyp_panic. Thoughts?
>
> That would be an actual fix instead of a workaround, as it would
> remove existing assumptions about the relative locations of the two
> objects. I guess you need to fix both instances with something such
> as:
>
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index b0afad7a99c6..a43e1f7ee354 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
>
>         // If the hyp context is loaded, go straight to hyp_panic
>         get_loaded_vcpu x0, x1
> -       cbz     x0, hyp_panic
> -
> +       cbnz    x0, 1f
> +       adr_l   x0, hyp_panic
> +       br      x0
> +1:

Agree with replacing the conditional branches that refer to external
symbols: the compiler never emits those, for the reason we are seeing
here, i.e., the range is simply insufficient.

But let's just use 'b hyp_panic' instead, no?



>         // The hyp context is saved so make sure it is restored to allow
>         // hyp_panic to run at hyp and, subsequently, panic to run in the host.
>         // This makes use of __guest_exit to avoid duplication but sets the
> @@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
>         // current state is saved to the guest context but it will only be
>         // accurate if the guest had been completely restored.
>         adr_this_cpu x0, kvm_hyp_ctxt, x1
> -       adr     x1, hyp_panic
> +       adr_l   x1, hyp_panic
>         str     x1, [x0, #CPU_XREG_OFFSET(30)]
>
>         get_vcpu_ptr    x1, x0
>
> which is completely untested. I wouldn't be surprised if there were
> more of these somewhere.
>

A quick grep gives me

$ objdump -r vmlinux.o |grep BR19
000000000005b6e0 R_AARCH64_CONDBR19  hyp_panic
0000000000418e08 R_AARCH64_CONDBR19  __memcpy
0000000000418e14 R_AARCH64_CONDBR19  __memcpy
0000000000003818 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003898 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003918 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003998 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003a18 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003a98 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003b18 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003b98 R_AARCH64_CONDBR19  __kvm_nvhe___guest_exit_panic
0000000000003c10 R_AARCH64_CONDBR19  __kvm_nvhe___host_exit
0000000000003c1c R_AARCH64_CONDBR19  __kvm_nvhe___host_exit
00000000000064f0 R_AARCH64_CONDBR19  __kvm_nvhe_hyp_panic
000000000000078c R_AARCH64_CONDBR19  __kvm_nvhe___kvm_handle_stub_hvc

So there are definitely a few other cases that require another look.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
