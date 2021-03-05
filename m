Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FD4C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA0C1650A3
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA0C1650A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9A84B382;
	Fri,  5 Mar 2021 13:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id obLxYSCtGvPV; Fri,  5 Mar 2021 13:58:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B10D4B3D9;
	Fri,  5 Mar 2021 13:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 638B64B198
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 21:38:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LbuCl-m9RSFB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 21:38:30 -0500 (EST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com
 [209.85.222.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 580934B16B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 21:38:30 -0500 (EST)
Received: by mail-ua1-f46.google.com with SMTP id 62so259013uar.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 18:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QS2dc4BRJJgr8umUp9EpdfHdtGHxUWTC0395zWXgRQ0=;
 b=LSH6iwuk+SlxyAgzUKOCThatNBJjTF63wj9pl7/rv3WvWASJdjJ5g08bUmf4+LU4nr
 hUsYKepzYVnbq2ahvA2yinYFF1yOI+u7nlH+XozKJBVt/hGCDT0EI6B51/JnJ4hrDbXI
 lcFb/vEF3ijhC35zMtJnWQNY1R0xMoIaRGfErQzQSiAN3iNmMjUjLN14hzICPK81xQCI
 Pb9/lKaEvaWgRm3xCbQqMpivxmjtVOCDebEA+INWDAkDqUPrMMxty/lQQDEK2+Db3xdC
 CwiHANsN8spPAlFQkX7yqbhlTWfSY1RcjoyC/niyBpki7rRNL3tK4aZU20flB8KcWp5R
 C83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QS2dc4BRJJgr8umUp9EpdfHdtGHxUWTC0395zWXgRQ0=;
 b=ldCxRAJr7amZoILal9jg/C21EiYFUbC5oh2Snqsi/IbT7L3kRDBjGoYQWkBiV4sTsG
 gFHV22I7rOTnjldI9uuKTfplGmUET91n4r2GGrigmGdarxDB6eEgBaM3ZojFTnbm2yC0
 ovnauc43NyWdsmEAqzz+OaBzST+/U6VOyLUI70Fjw6NgtbKa7Hpm9jdf+hieRorSA/nz
 km8R5AL73MVjxoFj2IQotIdISDTXUXrSDaa41apM1hr/02x6YOILHpOfmRMae1voVMZe
 JL9BIKaXgqPFOBrZMHqRGzO4JMgSSa/o+yF+F+skL24njRqdtSBWT2Cqrg7Z7rw6Q4TA
 qTIw==
X-Gm-Message-State: AOAM531VD453QjEbJxWoyxgCBwcki83UoLTPupvNFgWpo7pOYXDBX/eq
 mUNWXxdX20XLgfcdXb5zmSF04c9gluie44tr7mOJZw==
X-Google-Smtp-Source: ABdhPJxMZd/afyVrbW4edXEQyCei1a86gfA8o3+MYDlHubXJYjQzSdCnAYOppQlxL7/Vjn59qH+xxqJciQKFnen8Po0=
X-Received: by 2002:a9f:374d:: with SMTP id a13mr4660885uae.122.1614911909135; 
 Thu, 04 Mar 2021 18:38:29 -0800 (PST)
MIME-Version: 1.0
References: <20210304184544.2014171-1-samitolvanen@google.com>
 <87k0qmzq5u.wl-maz@kernel.org>
 <CABCJKufmjMT8+hGEnL3aJM7-OSwhYSHiJA=i8e7dHSGDWXYtsg@mail.gmail.com>
 <878s72sgwt.wl-maz@kernel.org>
 <CABCJKud1EmXmmQj-YOUNCFhE3P1W6Uhqpwe1G0zcR5zw71ksJA@mail.gmail.com>
In-Reply-To: <CABCJKud1EmXmmQj-YOUNCFhE3P1W6Uhqpwe1G0zcR5zw71ksJA@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 4 Mar 2021 18:38:17 -0800
Message-ID: <CABCJKudvzBggE7AZQERto5Wo_LoL0G2sNee7_1R7h2TnGhjq8A@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Disable LTO in hyp
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Fri, 05 Mar 2021 13:58:33 -0500
Cc: Kees Cook <keescook@chromium.org>, Fangrui Song <maskray@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>,
 LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 4, 2021 at 2:34 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Thu, Mar 4, 2021 at 2:17 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 04 Mar 2021 21:25:41 +0000,
> > Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > On Thu, Mar 4, 2021 at 11:15 AM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On Thu, 04 Mar 2021 18:45:44 +0000,
> > > > Sami Tolvanen <samitolvanen@google.com> wrote:
> > > > >
> > > > > allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
> > > > > linker errors:
> > > > >
> > > > >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
> > > >
> > > > I assume this message is only an oddity, right? Because
> > > > __guest_enter() is as far as you can imagine from irqbypass.c...
> > >
> > > I'm not sure what's up with the filename in the error message. Fangrui
> > > or Nick probably have a better idea.
> > >
> > > > >   relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
> > > > >   [-1048576, 1048575]; references hyp_panic
> > > > >   >>> defined in vmlinux.o
> > > > >
> > > > >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
> > > > >   relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
> > > > >   [-1048576, 1048575]; references hyp_panic
> > > > >   >>> defined in vmlinux.o
> > > > >
> > > > > As LTO is not really necessary for the hypervisor code, disable it for
> > > > > the hyp directory to fix the build.
> > > >
> > > > Can you shed some light on what the problem is exactly?
> > >
> > > I assume hyp_panic() ends up being placed too far from __guest_enter()
> > > when the kernel is large enough. Possibly something to do with LLVM
> > > always splitting functions into separate sections with LTO. I'm not
> > > sure why the linker cannot shuffle things around to make everyone
> > > happy in this case, but I confirmed that this patch also fixes the
> > > build issue for me:
> > >
> > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > index af8e940d0f03..128197b7c794 100644
> > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > @@ -214,7 +214,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> > >  }
> > >  NOKPROBE_SYMBOL(__hyp_call_panic);
> > >
> > > -void __noreturn hyp_panic(void)
> > > +void __noreturn hyp_panic(void) __section(".text")
> > >  {
> > >         u64 spsr = read_sysreg_el2(SYS_SPSR);
> > >         u64 elr = read_sysreg_el2(SYS_ELR);
> > >
> >
> > We're getting into black-magic territory here. Why wouldn't hyp_panic
> > be in the .text section already?
>
> It's not quite black magic. LLVM essentially flips on
> -ffunction-sections with LTO and therefore, hyp_panic() will be in
> .text.hyp_panic in vmlinux.o, while __guest_enter() will be in .text.
> Everything ends up in .text when we link vmlinux, of course.
>
> $ readelf --sections vmlinux.o | grep hyp_panic
>   [3936] .text.hyp_panic   PROGBITS         0000000000000000  004b56e4

Note that disabling LTO here has essentially the same effect as using
__section(".text"). It stops the compiler from splitting these
functions into .text.* sections and makes it less likely that
hyp_panic() ends up too far away from __guest_enter().

If neither of these workarounds sound appealing, I suppose we could
alternatively change hyp/entry.S to use adr_l for hyp_panic. Thoughts?

Sami
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
