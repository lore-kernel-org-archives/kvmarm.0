Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2526C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 17 Jul 2022 19:02:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CBE34CBAC;
	Sun, 17 Jul 2022 15:02:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oPot7hvd9U4D; Sun, 17 Jul 2022 15:02:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B3F4CC66;
	Sun, 17 Jul 2022 15:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 569A44CC4F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jul 2022 15:02:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OWhKBzduDrB5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Jul 2022 15:02:12 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 427164CC40
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jul 2022 15:02:12 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id
 i205-20020a1c3bd6000000b003a2fa488efdso155538wma.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jul 2022 12:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Lk12/tpXTVU6up0Wt2/X99tShnjn+1oi0pbFBCCHdiY=;
 b=k8dg2dnozSZK58gGe/uYCFWyHCllyYsYNtTj3/11ajimjpONsm4zkGbvrfalM1N2Xd
 XAJEGHQOOW3s4iTeVPmiAjaauCx+bZIZgyrEn4MTcttTNr4WaGgh1+YTb4/S/d86/oX5
 vvt6eQDKQQdgin/SnREFbe4yxGZh/FqwaCFJPiyJTJtVDCHvxD7KkNdkdCAUxN0DXdgp
 NuFnc+a6h8yImF6GsoVa620DgsaA2rNGi3X9ibQTl6zd5TOWG+t4uEcSCmpxDThwp92J
 6B+weZuVGIcFloTQoamwsXUcezI917Z+Jx2/L+gTlwhC82fsj6cv1CeN0ISYNLVx3Uk4
 b6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Lk12/tpXTVU6up0Wt2/X99tShnjn+1oi0pbFBCCHdiY=;
 b=2d3t5kc6Mo8tJtrMrM8KCeHbeIgzTiq8VylnoNVI102z6PiLofU9WeGAXqkoKvaWwG
 SPj+AWuW/27NvZVRtVd4AKNGr+obKtaRCvkx1K9BhShIJSYQ8JR78RzT21omrKB08QjC
 Gg842DKz4uNG2qgiV/T7Z2ATndZFPM5A+lQitjEcLzfW01g2qSvFReKBwJbsoaFJIeWH
 8AglXeALo2SoC1CtBMivQfs/p34BBF2Sxajb0EAGjhYD5akSM+7ZTkTrK9/w5DxZWITP
 sw68mP34xz/V0fdJTdIUgT++ve6+zinnsQZoGIShVqYkO23lP9FYk9InIneQUUo+xOWZ
 ZxZA==
X-Gm-Message-State: AJIora+9DN5WO13XZe768kcWELoJOEA2JMoKSoFvAmUbqKpicOr3mOxV
 vkmeWF7kl+we/ON/Nr8hWnHpGhErQ04bWyp4pFC3UQ==
X-Google-Smtp-Source: AGRyM1txM6jdFQSAihKOCcCQ02JZOMHBF4S9utIUHEL5wAa8Yd7D1Z3rq2vr36XdQB1ibThKxK+VFG5OnZx+sJbPO7A=
X-Received: by 2002:a05:600c:4eca:b0:3a1:9c39:ac20 with SMTP id
 g10-20020a05600c4eca00b003a19c39ac20mr29653002wmq.61.1658084531022; Sun, 17
 Jul 2022 12:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220715235824.2549012-1-kaleshsingh@google.com>
 <87zgh8yq7q.wl-maz@kernel.org>
In-Reply-To: <87zgh8yq7q.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Sun, 17 Jul 2022 12:02:00 -0700
Message-ID: <CAC_TJveFHh1ykT0ctZC7zK_6rwNSgMe+242h_aVZ_48GD3Xtaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix hypervisor address symbolization
To: Marc Zyngier <maz@kernel.org>
Cc: android-mm@google.com, "Cc: Android Kernel" <kernel-team@android.com>,
 LKML <linux-kernel@vger.kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
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

On Sun, Jul 17, 2022 at 3:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 16 Jul 2022 00:58:24 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve correctly
>
> I guess you mean *incorrectly* here, right?

Yes, sorry. "INcorrectly" I meant to say.

>
> > from kallsyms. Fix this by adding the KASLR offset before printing the
> > symbols.
> >
> > Based on arm64 for-next/stacktrace.
>
> In general, place these remarks after the '---' line, as they don't
> really make sense in the commit itself (which is likely to be merged
> on a different base anyway).
>
> >
> > Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
> > Reported-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kvm/handle_exit.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index f66c0142b335..e43926ef2bc2 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -347,10 +347,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> >                       kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
> >               else
> >                       kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
> > -                                     (void *)panic_addr);
> > +                                     (void *)(panic_addr + kaslr_offset()));
> >       } else {
> >               kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
> > -                             (void *)panic_addr);
> > +                             (void *)(panic_addr + kaslr_offset()));
> >       }
> >
> >       /*
> >
>
> I'll fix the above as I apply the patch, no need to respin.

Thanks Marc.

-- Kalesh

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
