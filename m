Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4E2C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 22:02:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20C6664FE3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 22:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20C6664FE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54A04B60A;
	Thu,  4 Mar 2021 17:02:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0TaH0FIMxiGe; Thu,  4 Mar 2021 17:02:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984DC4B629;
	Thu,  4 Mar 2021 17:02:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C56334B132
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 16:25:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8gilKDkyc+5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 16:25:53 -0500 (EST)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
 [209.85.222.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 932E34B12A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 16:25:53 -0500 (EST)
Received: by mail-ua1-f53.google.com with SMTP id u13so8056uap.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 13:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pCwoe+nr6h8/KUCkhmMjNpvzna+/assXUeU6NY8XPQw=;
 b=qNfhikGP/Y+wem+C6aP2zxL/0tWtf9IiSe6JA9ksOlB1STeGcs3MOep8E8xqEXHUUV
 08n7jU8Ti46BVhcBp5UcIw1VhqPrNv+3tFzjpM0dcg2rtOrTDbvjkRhq+atik1A0mWBa
 w9Vl0ueK6N/SLNESzCtvoaVKG8DSYp94p5JXIHT+uUvbqxpFeEBR6dbugzDA2WyYEHpx
 NEf1lXg3klrbeaHNWugn/3ftddgDTXgGBPxAAIusRbhizy+RPdxBP6JziO28z8fP6HBZ
 l88Zi3sMqiDBdiaxwWiLlDzhK4zNFu8tuKOF3ZbE6D0PSfR8mVWzp6QTuujWkyTQld/h
 P9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pCwoe+nr6h8/KUCkhmMjNpvzna+/assXUeU6NY8XPQw=;
 b=s2stD1eNMvpPMaBrDdrWgbDUbHrnVxFWnm0xou19CJK7MbDkvN67G9U6V2bL1OH0Gh
 zefZ632ff2oS1Dul7LI09q4VhxlXnluAbyUDPdgq/tNLSPKfS+/tnPj3u8rX9qO2UbTX
 jtOqmRcUcSGJrO4bEIZfA2AUJwAvo7Zj2KlZPvC1ayB617j7VeX3dw1RVIVNoITaEDRy
 FEM0RFy2PLNlatZK33qNGNZsEI89j6oLJC3vZrook0K4OQJ/QgAxNHbcdnA/xGzcEixH
 SZq2ohHB8MMoRboDie+Hb3zSZ39gx5yZxBnBTg83ScMgeemyPsN4vt3f40FnmE0YNoJa
 KBPA==
X-Gm-Message-State: AOAM531mpMfIIG/wzhSZwFJdgbZTszEJXL3VP7eqUPvFaqrSmf4o/1XQ
 Akf1PocnqN3QucBmmB8DPpm77wHhQmaXIsbOiq6fKA==
X-Google-Smtp-Source: ABdhPJy/oonaLJwQYkh03ssEj0zP6DykmvSGVfCb4vLaenGZYrlXd7G63N7OJvZ/l0mjcOAbE1mlQEK9CcmrkmWhq5E=
X-Received: by 2002:ab0:5ead:: with SMTP id y45mr3705042uag.33.1614893152797; 
 Thu, 04 Mar 2021 13:25:52 -0800 (PST)
MIME-Version: 1.0
References: <20210304184544.2014171-1-samitolvanen@google.com>
 <87k0qmzq5u.wl-maz@kernel.org>
In-Reply-To: <87k0qmzq5u.wl-maz@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 4 Mar 2021 13:25:41 -0800
Message-ID: <CABCJKufmjMT8+hGEnL3aJM7-OSwhYSHiJA=i8e7dHSGDWXYtsg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Disable LTO in hyp
To: Marc Zyngier <maz@kernel.org>, Fangrui Song <maskray@google.com>, 
 Nick Desaulniers <ndesaulniers@google.com>
X-Mailman-Approved-At: Thu, 04 Mar 2021 17:02:13 -0500
Cc: Kees Cook <keescook@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, LKML <linux-kernel@vger.kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
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

On Thu, Mar 4, 2021 at 11:15 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 04 Mar 2021 18:45:44 +0000,
> Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
> > linker errors:
> >
> >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
>
> I assume this message is only an oddity, right? Because
> __guest_enter() is as far as you can imagine from irqbypass.c...

I'm not sure what's up with the filename in the error message. Fangrui
or Nick probably have a better idea.

> >   relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
> >   [-1048576, 1048575]; references hyp_panic
> >   >>> defined in vmlinux.o
> >
> >   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
> >   relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
> >   [-1048576, 1048575]; references hyp_panic
> >   >>> defined in vmlinux.o
> >
> > As LTO is not really necessary for the hypervisor code, disable it for
> > the hyp directory to fix the build.
>
> Can you shed some light on what the problem is exactly?

I assume hyp_panic() ends up being placed too far from __guest_enter()
when the kernel is large enough. Possibly something to do with LLVM
always splitting functions into separate sections with LTO. I'm not
sure why the linker cannot shuffle things around to make everyone
happy in this case, but I confirmed that this patch also fixes the
build issue for me:

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index af8e940d0f03..128197b7c794 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -214,7 +214,7 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);

-void __noreturn hyp_panic(void)
+void __noreturn hyp_panic(void) __section(".text")
 {
        u64 spsr = read_sysreg_el2(SYS_SPSR);
        u64 elr = read_sysreg_el2(SYS_ELR);

> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1317
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  arch/arm64/kvm/hyp/Makefile | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> > index 687598e41b21..e8116016e6a8 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -11,3 +11,6 @@ subdir-ccflags-y := -I$(incdir)                             \
> >                   $(DISABLE_STACKLEAK_PLUGIN)
> >
> >  obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
> > +
> > +# Disable LTO for the files in this directory
> > +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> >
> > base-commit: f69d02e37a85645aa90d18cacfff36dba370f797
>
> Can this be reduced to the nvhe part of the tree? The rest of the
> hypervisor should support being built with LTO, I'd expect. Or am I
> missing something more significant?

No, this error appears to be about hyp_panic() in the vhe code. While
I'm not sure how beneficial LTO is in hypervisor code, there shouldn't
be any other reason we can't use it there.

Sami
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
