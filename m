Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E681C6FA86
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 09:53:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BE749F2C;
	Thu, 22 Sep 2022 05:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nXBWNk78f-ru; Thu, 22 Sep 2022 05:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4F64120D;
	Thu, 22 Sep 2022 05:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FFE14B7C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 02:03:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lz+hCp5Ifjxr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 02:03:03 -0400 (EDT)
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com
 [209.85.166.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37F294B7C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 02:03:03 -0400 (EDT)
Received: by mail-il1-f178.google.com with SMTP id v1so506966ilq.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=sOA+/TKyOIxErphM8ulICJKXcjYIe3Hnn+mK8Vn1QTM=;
 b=oLVCAIE0kI6LAeFqewe/GIlHsASV142Awdg1+e71ZG84q8Ma76uAIJvH/MEwFLRfFa
 iGSksuK0U3DQU0eb6JX0VwDQlgwebwCoPTu9HzT/rewK7/EK2csGVlB6MGoKakc3mpV1
 dPFjIWM89c9ry42h771FIhOkGDovVrNKmsIK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=sOA+/TKyOIxErphM8ulICJKXcjYIe3Hnn+mK8Vn1QTM=;
 b=fyrfXrS+HGymKC2F3Olthd3R2Q0h1P/ILrIrT4xT99VmggFSVjAU7JrgsMcj7zrFeS
 Koz/p60Xu0uFfmt6RpBHLglZGRlp/zrHO6Jcp8DPJD7f5+l/ztDR33bvYpz1aDUc2M9y
 3bPpE8oZEObcKbW9JDRtiQk9lBwdbwtPAV4sLpxO1qoKTKOWaoXuoJPZRIVhg0HngZzg
 xlzv65IJl1lY+ksu2rNLGQ8ByoKeBIUK7Bvysx9a1RX2hA4YGJotV7yP5EGKQgc+t5uM
 dSud1k+/uxDyol8xeO0RTwufS6GeuoGeDJXOWqPz5lMJq8G2QnmO7WlU6VmjQ4clgIoy
 W9kA==
X-Gm-Message-State: ACrzQf3RuB2bguS0szSvXhbZsRLIR5bmTXwangOYvObUuRjSN8RpgFvz
 qpo22ZrmRevxpmHFjBK2/V3KtOgJCDRkMj6iDXQ/Vw==
X-Google-Smtp-Source: AMsMyM72Uvd/+DyXlH3OoMGGh3CieEQrwrdTmZ9CZcO59IYmsDVk3q5CWFMYa/8qCcALFckXM8rJ41Y2C/851tvaA7g=
X-Received: by 2002:a05:6e02:1a48:b0:2f3:2e91:b78 with SMTP id
 u8-20020a056e021a4800b002f32e910b78mr11808724ilv.96.1663740182612; Tue, 20
 Sep 2022 23:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220920082005.2459826-1-denik@chromium.org>
 <877d1yl797.wl-maz@kernel.org>
 <CAOYpmdHMbDdssEJJwXktEj1SDLncHTeL7x7aKxVe6j1vzSMgtw@mail.gmail.com>
In-Reply-To: <CAOYpmdHMbDdssEJJwXktEj1SDLncHTeL7x7aKxVe6j1vzSMgtw@mail.gmail.com>
From: Denis Nikitin <denik@chromium.org>
Date: Tue, 20 Sep 2022 23:02:50 -0700
Message-ID: <CADDJ8CW5MV3vUPdm4iwjwS4VyeV9rCAMZZpJbNFtNLFD-wThVA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nvhe: Disable profile optimization
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Thu, 22 Sep 2022 05:53:07 -0400
Cc: Denis Nikitin <denik@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Manoj Gupta <manojgupta@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Adding a few more comments...

On Tue, Sep 20, 2022 at 5:08 PM Denis Nikitin <denik@google.com> wrote:
>
> Hi Mark,
>
> Thank you for a quick response.
>
> On Tue, Sep 20, 2022 at 2:34 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > Hi Denis,
> >
> > On Tue, 20 Sep 2022 09:20:05 +0100,
> > Denis Nikitin <denik@chromium.org> wrote:
> > >
> > > Kernel build with -fprofile-sample-use raises the following failure:
> > >
> > > error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
> > > section ".rel.llvm.call-graph-profile"
> >
> > How is this flag provided? I don't see any occurrence of it in the
> > kernel so far.
>
> On ChromeOS we build the kernel with sample profiles by adding
> -fprofile-sample-use=/path/to/gcov.profile to KCFLAGS.
>
> >
> > >
> > > SHT_REL is generated by the latest lld, see
> > > https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
> >
> > Is this part of a released toolchain? If so, can you spell out the
> > first version where this occurs?
>
> Yes, it was added in llvm-13. I will update the patch.
>
> >
> > > Disable profile optimization in kvm/nvhe to fix the build with
> > > AutoFDO.
> >
> > It'd be good to at least mention how AutoFDO and -fprofile-sample-use
> > relate to each other.
>
> Good point. AutoFDO is an example of sample profiles.
> It's not actually relevant for the bug. I will better remove it.
>
> >
> > >
> > > Signed-off-by: Denis Nikitin <denik@chromium.org>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/Makefile | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > > index b5c5119c7396..6a6188374a52 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > > @@ -89,6 +89,9 @@ quiet_cmd_hypcopy = HYPCOPY $@
> > >  # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
> > >  # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
> > >  KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
> > > +# Profile optimization creates SHT_REL section '.llvm.call-graph-profile' for
> > > +# the hot code. SHT_REL is currently not supported by the KVM tools.
> >
> > 'KVM tools' seems vague. Maybe call out the actual helper that
> > processes the relocations?
>
> Agreed.
>
> >
> > > +KBUILD_CFLAGS += $(call cc-option,-fno-profile-sample-use,-fno-profile-use)
> >
> > Why adding these options instead of filtering out the offending option
> > as it is done just above?
>
> That was actually the alternative solution and it worked as well.
> Let me double check if profile optimization doesn't mess up with other
> sections and if it doesn't I will remove the '.llvm.call-graph-profile'
> section instead.

When I remove the '.llvm.call-graph-profile' section the layout of other
sections slightly changes (offsets and sizes) compared to
`-fno-profile-sample-use`. But the list of sections remains the same.

>
> >
> > Also, is this the only place the kernel fails to compile? The EFI stub
> > does similar things AFAIR, and could potentially fail the same way.
>
> This was the only place in 5.15 where we tested it.
> Let me see if EFI has this section.

EFI code is not marked as hot in the profile.

Regarding "could potentially fail", I don't see any explicit manipulations
with code sections in EFI.
The hardcoded EFI stub entries should not be affected.

>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
>
> Thanks,
> Denis

- Denis
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
