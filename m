Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A968C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5484650A3
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5484650A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 199824B28F;
	Fri,  5 Mar 2021 13:58:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gnt2S1Jn2PEd; Fri,  5 Mar 2021 13:58:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CC114B1F6;
	Fri,  5 Mar 2021 13:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 401724B3D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 17:34:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gJEEEH5cfFQV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 17:34:30 -0500 (EST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com
 [209.85.221.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AFC34B3D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 17:34:30 -0500 (EST)
Received: by mail-vk1-f176.google.com with SMTP id j188so64453vke.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 14:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Rajd7yQJWJDe7aYct9nFV0g6FXEt/vXGJuGQS9x6yXw=;
 b=oUka736fvVmqzp5RZlMPVQlOWSDNz4htaYj7uuL247K09QoorKATvBeitoXWE8gl+X
 r94pJWxWaxqv79liStuj+r+wOq9fKTa2NVLKprtxD75cZnVmt9BEMnKCn4Xd9zs4UWJ6
 CQ6jtxH67C/5rnyDzukP5k1FYOYfssSHIFSyNA7WdjiO/frwnnkVeZoO7o+Gc9I57FTo
 u/S0ZsgZwgdx5YNwzOLc4j3eZMAZpI2wZLGK5WsqjQgS6eiEvoJewqz2ADLgJI4oWCKz
 gj3GrX4nrKqtReA0fKuEEoPzn+FxbRqEKhIr5E0rCzeUqMUCAyfLv51punQn6wxGiPA0
 JyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Rajd7yQJWJDe7aYct9nFV0g6FXEt/vXGJuGQS9x6yXw=;
 b=eOCD7fS5BntJixUsFeyna5f/ZDHddvMM86NRo5wpvC0OW/a15gJsf6CXaVUcYDTJaf
 hctuYJT+E3g/gLL8heV8T9o2V6/dKsJc74xoGwMSHTLvtw82ZOD185MYiu7oUZ49G3DH
 II8aAwSxkqBc1B+tAsjffo/8GyMpRvPqYeUbsrUavqaYJBQF45/FMVBQrmtA7sE/nqUX
 g9dpyjwMru2kBjgKavAf5VbVhgVem++WRbX1qdq1WTpIKSlGysXsgruBOoNs8AtMZszu
 IFkT4OqZbGXGpwKx3jPs3e4/BU1yZ31malwrKcBsjkfdECGZEjFt2ygGORHXKsNnzAmO
 yusA==
X-Gm-Message-State: AOAM532//n4QGFpIr1tw5dQZUK3jx6n6j0pqrITNawR3+9ThA3wdIPjH
 L982jbdG5cy4vS0f9FtQbSnhDjon/IFiUmhM2EXEuA==
X-Google-Smtp-Source: ABdhPJw9hVzk/M0ZP7TpOX5Yz4NgqYdBHM97WKO8NA9JuMXAIsUjqPbiWDl2C+auPNVj7KxAWJlH8sBOEJlhhiJycZs=
X-Received: by 2002:a1f:99c2:: with SMTP id b185mr4516009vke.3.1614897269361; 
 Thu, 04 Mar 2021 14:34:29 -0800 (PST)
MIME-Version: 1.0
References: <20210304184544.2014171-1-samitolvanen@google.com>
 <87k0qmzq5u.wl-maz@kernel.org>
 <CABCJKufmjMT8+hGEnL3aJM7-OSwhYSHiJA=i8e7dHSGDWXYtsg@mail.gmail.com>
 <878s72sgwt.wl-maz@kernel.org>
In-Reply-To: <878s72sgwt.wl-maz@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 4 Mar 2021 14:34:18 -0800
Message-ID: <CABCJKud1EmXmmQj-YOUNCFhE3P1W6Uhqpwe1G0zcR5zw71ksJA@mail.gmail.com>
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

On Thu, Mar 4, 2021 at 2:17 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 04 Mar 2021 21:25:41 +0000,
> Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Thu, Mar 4, 2021 at 11:15 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 04 Mar 2021 18:45:44 +0000,
> > > Sami Tolvanen <samitolvanen@google.com> wrote:
> > > >
> > > > allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
> > > > linker errors:
> > > >
> > > >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
> > >
> > > I assume this message is only an oddity, right? Because
> > > __guest_enter() is as far as you can imagine from irqbypass.c...
> >
> > I'm not sure what's up with the filename in the error message. Fangrui
> > or Nick probably have a better idea.
> >
> > > >   relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
> > > >   [-1048576, 1048575]; references hyp_panic
> > > >   >>> defined in vmlinux.o
> > > >
> > > >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
> > > >   relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
> > > >   [-1048576, 1048575]; references hyp_panic
> > > >   >>> defined in vmlinux.o
> > > >
> > > > As LTO is not really necessary for the hypervisor code, disable it for
> > > > the hyp directory to fix the build.
> > >
> > > Can you shed some light on what the problem is exactly?
> >
> > I assume hyp_panic() ends up being placed too far from __guest_enter()
> > when the kernel is large enough. Possibly something to do with LLVM
> > always splitting functions into separate sections with LTO. I'm not
> > sure why the linker cannot shuffle things around to make everyone
> > happy in this case, but I confirmed that this patch also fixes the
> > build issue for me:
> >
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > index af8e940d0f03..128197b7c794 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -214,7 +214,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> >  }
> >  NOKPROBE_SYMBOL(__hyp_call_panic);
> >
> > -void __noreturn hyp_panic(void)
> > +void __noreturn hyp_panic(void) __section(".text")
> >  {
> >         u64 spsr = read_sysreg_el2(SYS_SPSR);
> >         u64 elr = read_sysreg_el2(SYS_ELR);
> >
>
> We're getting into black-magic territory here. Why wouldn't hyp_panic
> be in the .text section already?

It's not quite black magic. LLVM essentially flips on
-ffunction-sections with LTO and therefore, hyp_panic() will be in
.text.hyp_panic in vmlinux.o, while __guest_enter() will be in .text.
Everything ends up in .text when we link vmlinux, of course.

$ readelf --sections vmlinux.o | grep hyp_panic
  [3936] .text.hyp_panic   PROGBITS         0000000000000000  004b56e4

Sami
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
