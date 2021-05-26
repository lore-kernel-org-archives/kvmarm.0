Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B2BC2B9F7
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 08:51:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08A17613C0
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 08:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A17613C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1E44A4A4;
	Wed, 26 May 2021 04:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 351aYq-uHgDK; Wed, 26 May 2021 04:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5606E49DE7;
	Wed, 26 May 2021 04:51:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C684A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 04:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AysRMAu0jPz8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 04:50:59 -0400 (EDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com
 [209.85.222.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EDB64064F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 04:50:59 -0400 (EDT)
Received: by mail-ua1-f51.google.com with SMTP id d14so353584ual.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ftj/o/FDlLZjvveU5gflHCydxVxy9/duOHSuWLsKuds=;
 b=UZmnsgl9i/IELoCP7CeDfQfPuZVdYOxGVjQ/LL0hCYD3xaTDXqEBJSgpIKKqqJNXLz
 2g44PsYjt+P6gIMUwcMg9VI252h6JDXR9V3W4R+/gQVsLO1KAi+m2cqc55ki7FWqkwKU
 dTxTToJ6hxKQriM4a3NInW4vJkNFNY7ohTEc6RuR/YrDs4X9mkufCtd5HzJEDZ6ItvIL
 d3uIQzC/2swwC39A98h1vuAYQH38PA7L80siSREtv+1VcZId2UhLwZiFk0V+meHYqtj8
 h95dUYLsbIdDvdYPYu2rAP2ET96g7aZ2DOL+xGULRYCi6H6vPevAg/fnZBwhB3gzVC77
 DrOw==
X-Gm-Message-State: AOAM5316Xn2aya9wXzUcY3ozE2fQJBfebk8K68KtnD4Zad/7FIdjPDdm
 EHDy3p8fQ6hT36H2bK3ckeLS7akgQPWaHXDVMck=
X-Google-Smtp-Source: ABdhPJywUZ6Xwv+zij4MSQ000T5eibp+TpLy3YyyGoFqj+kf4ejbTke4WZLjWrCgAdHGlnISxwMlbpFtCE1QmEgp5j8=
X-Received: by 2002:ab0:2a8b:: with SMTP id h11mr31904723uar.4.1622019058834; 
 Wed, 26 May 2021 01:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
 <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
 <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
 <8735u9x6sb.wl-maz@kernel.org>
 <CAMuHMdUBwcB-v0ugCPB3D6dbttiSbqQeHgNrr+r331ntRrfiAw@mail.gmail.com>
 <871r9tx5dq.wl-maz@kernel.org>
In-Reply-To: <871r9tx5dq.wl-maz@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 26 May 2021 10:50:47 +0200
Message-ID: <CAMuHMdVFE=RB5wPUi9PH5WeQPSYfcg+ugKigB4nAo9yotO+WYg@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To: Marc Zyngier <maz@kernel.org>
Cc: KVM list <kvm@vger.kernel.org>, seanjc@google.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, justin.he@arm.com,
 Steven Price <steven.price@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 Andre Przywara <Andre.Przywara@arm.com>,
 Richard Cochran <richardcochran@gmail.com>, Yangbo Lu <yangbo.lu@nxp.com>,
 John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
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

Hi Marc,

On Wed, May 26, 2021 at 10:32 AM Marc Zyngier <maz@kernel.org> wrote:
> On Wed, 26 May 2021 09:18:27 +0100,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, May 26, 2021 at 10:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > On Wed, 26 May 2021 08:52:42 +0100,
> > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > > > > > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > > >> From: Jianyong Wu <jianyong.wu@arm.com>
> > > > > >
> > > > > >> --- a/drivers/ptp/Kconfig
> > > > > >> +++ b/drivers/ptp/Kconfig
> > > > > >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> > > > > >>  config PTP_1588_CLOCK_KVM
> > > > > >>         tristate "KVM virtual PTP clock"
> > > > > >>         depends on PTP_1588_CLOCK
> > > > > >> -       depends on KVM_GUEST && X86
> > > > > >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> > > > > >> ARM_ARCH_TIMER)
> > > > > >
> > > > > > Why does this not depend on KVM_GUEST on ARM?
> > > > > > I.e. shouldn't the dependency be:
> > > > > >
> > > > > >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> > > > > >
> > > > > > ?
> > > > >
> > > > > arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> > > > > and KVM/arm64 doesn't know about this configuration symbol.
> > > >
> > > > OK.
> > > >
> > > > Does PTP_1588_CLOCK_KVM need to default to yes?
> > > > Perhaps only on X86, to maintain the status quo?
> > >
> > > I think I don't really understand the problem you are trying to
> > > solve. Is it that 'make oldconfig' now asks you about this new driver?
> > > Why is that an issue?
> >
> > My first "problem" was that it asked about this new driver on
> > arm/arm64, while I assumed there were some missing dependencies
> > (configuring a kernel should not ask useless questions).  That turned
> > out to be a wrong assumption, so there is no such problem here.
> >
> > The second problem is "default y": code that is not critical should
> > not be enabled by default.  Hence my last question.
>
> I think consistency between architectures is important. Certainly,
> distributions depend on that, and we otherwise end-up with distro
> kernels missing functionalities.
>
> The notion of "critical" is also pretty relative. defconfig contains a

I'm not talking about defconfig, but about "default y" in defconfig.

> gazillion of things that are not critical to most people, for example,
> and yet misses a bunch of things that are needed to boot on some of my
> systems.

Perhaps those should be added, so those systems can be tested using
defconfig?  At least for arm64, I think that's aligned with the
arm64 defconfig policy.

> That's just to say that I find it difficult to make that choice from
> the PoV of a kernel hacker. I'm personally more inclined to leave
> things enabled and let people *disable* things if they want to reduce
> the footprint of their kernel.

The standard question to respond to w.r.t. "default y" is: "Why is
your feature so special that it needs to be enabled by default?",
which implies "default y" is the exception, not the rule.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
