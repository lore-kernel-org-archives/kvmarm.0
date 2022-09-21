Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41010C6FA82
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 09:53:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A55410DA;
	Thu, 22 Sep 2022 05:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id it+Tl0w2BA3Z; Thu, 22 Sep 2022 05:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A21D410DE;
	Thu, 22 Sep 2022 05:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF1A4B703
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:08:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LM1HwtcPGXN4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 20:08:26 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985854B621
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:08:26 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 i15-20020a17090a4b8f00b0020073b4ac27so4045484pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=P+2TPNWdXXOCWAvqTb/n3Y3lh5Lh38PVwp86QKZPW/U=;
 b=l79CvKW56MUCcXospEUz9HzLbq84Cfb4nvfiZqwlGWLuDvqwo4gFUQugO1KgXZ9Feg
 F5QakQ/sjeAhCMC9RQW4hR6FDddJHvpXKeOgn212CjqVjQ8lXWaQka6F+KDFmCtzUUFp
 886SmNU7eIDMwzOpAT29RFKvf+9dHNdY++bxzgSoE325sin8U4JmiBfqbOLUOgsuN+IB
 r5UKnDBMDxzngTWqQF8pu8lKhOXBWgwmc0yJdTx9JnyvITwzRwBJ0eYao/RNdCt6Xi5y
 jiathpY5irAfSmUkcV7YbeQT23gXpZ35jag3sLF87/vV36PSAfyOFfr0EVFCrePSB/vu
 7WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=P+2TPNWdXXOCWAvqTb/n3Y3lh5Lh38PVwp86QKZPW/U=;
 b=wgoEzaZG9DhlMpeKjA9FoqlSiK6wAOawMvbMDa2dtZ7OxY72ySC2vmfux3DPdszuBh
 AnyP9VHyxt0TFoRr3uKMazmdpJjmPhbiIo5/soNavs6sKaHxOZ9bJJik8pRnDunMd+nB
 ltUtDCraBhP9CfPOu9XQiizxl6cXhGh4V8mEbHxrCZHTnsf8Lvwrclswus/QGjgO2ZxN
 C/WpFjXjMscRCdtF1+ppJmLWhmJo8w25cZhbvZJmGWuCHpC3ZtWxAXyfZ5E00f/dtw3g
 Bczu1hFXotNJs82JLcXh/3N1ae5EDJMxzUUJ46IE8LeBDzwt06+BJmmHD8SV4obcuP+u
 N3CQ==
X-Gm-Message-State: ACrzQf2n/1ARqMKevDaZX8w5QhmhAUS/fAhU0OjBx8uGEpL8AiOE36Ib
 tWMM0vvYhP2aYN50C3TctVyLg51p2C5uKbxVG5bNUQ==
X-Google-Smtp-Source: AMsMyM7Hq+eK82DO64bRlQggpPM3rRQhxkz+7K4Da9DMNHl9amBFdTiPYROgJVmKyMQhJXyZ+2seMh8dbNV5Qz4qacQ=
X-Received: by 2002:a17:902:d2c4:b0:178:32c4:6648 with SMTP id
 n4-20020a170902d2c400b0017832c46648mr2115146plc.88.1663718905205; Tue, 20 Sep
 2022 17:08:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220920082005.2459826-1-denik@chromium.org>
 <877d1yl797.wl-maz@kernel.org>
In-Reply-To: <877d1yl797.wl-maz@kernel.org>
From: Denis Nikitin <denik@google.com>
Date: Tue, 20 Sep 2022 17:08:09 -0700
Message-ID: <CAOYpmdHMbDdssEJJwXktEj1SDLncHTeL7x7aKxVe6j1vzSMgtw@mail.gmail.com>
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

Hi Mark,

Thank you for a quick response.

On Tue, Sep 20, 2022 at 2:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Denis,
>
> On Tue, 20 Sep 2022 09:20:05 +0100,
> Denis Nikitin <denik@chromium.org> wrote:
> >
> > Kernel build with -fprofile-sample-use raises the following failure:
> >
> > error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
> > section ".rel.llvm.call-graph-profile"
>
> How is this flag provided? I don't see any occurrence of it in the
> kernel so far.

On ChromeOS we build the kernel with sample profiles by adding
-fprofile-sample-use=/path/to/gcov.profile to KCFLAGS.

>
> >
> > SHT_REL is generated by the latest lld, see
> > https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
>
> Is this part of a released toolchain? If so, can you spell out the
> first version where this occurs?

Yes, it was added in llvm-13. I will update the patch.

>
> > Disable profile optimization in kvm/nvhe to fix the build with
> > AutoFDO.
>
> It'd be good to at least mention how AutoFDO and -fprofile-sample-use
> relate to each other.

Good point. AutoFDO is an example of sample profiles.
It's not actually relevant for the bug. I will better remove it.

>
> >
> > Signed-off-by: Denis Nikitin <denik@chromium.org>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/Makefile | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index b5c5119c7396..6a6188374a52 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -89,6 +89,9 @@ quiet_cmd_hypcopy = HYPCOPY $@
> >  # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
> >  # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
> >  KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
> > +# Profile optimization creates SHT_REL section '.llvm.call-graph-profile' for
> > +# the hot code. SHT_REL is currently not supported by the KVM tools.
>
> 'KVM tools' seems vague. Maybe call out the actual helper that
> processes the relocations?

Agreed.

>
> > +KBUILD_CFLAGS += $(call cc-option,-fno-profile-sample-use,-fno-profile-use)
>
> Why adding these options instead of filtering out the offending option
> as it is done just above?

That was actually the alternative solution and it worked as well.
Let me double check if profile optimization doesn't mess up with other
sections and if it doesn't I will remove the '.llvm.call-graph-profile'
section instead.

>
> Also, is this the only place the kernel fails to compile? The EFI stub
> does similar things AFAIR, and could potentially fail the same way.

This was the only place in 5.15 where we tested it.
Let me see if EFI has this section.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Denis
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
