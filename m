Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47CDC47088
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 07:53:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B80961443
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 07:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B80961443
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B173449E5F;
	Wed, 26 May 2021 03:53:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3+4hv4zb7l3; Wed, 26 May 2021 03:52:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4FA640825;
	Wed, 26 May 2021 03:52:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4077B40825
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 03:52:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3-tklRFq0Dj8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 03:52:54 -0400 (EDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
 [209.85.222.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F17040799
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 03:52:54 -0400 (EDT)
Received: by mail-ua1-f53.google.com with SMTP id n61so285328uan.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 00:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=DF4Qym5vi5urmQVozT7x89feYVqRBLX860c1iUhsLiU=;
 b=Q1WwGUdprrISjJyI/0ZxolD8hFW0zZvf2x+pPl1RBVPibEdS3W1rKcQ2jxc8oLItrW
 vhzb7V7muFKROfaBbb5njFyHrZ29usblfo1SGM7fu313Kp6RaWZXBArlyQvg2BgHKKIp
 u4pwRLvJTyDlmC11a9qSx8m2hOeMyQZ2iT/KzNfOK/GMLE8Zv9cHQqfQumojg/E2cFEK
 g8j+wZPE5Md2xT/XxpOIBNZQah5t4sUOojIhPseE/UOC2x6Y9xnpzD6kFizP+NHui9bE
 fzrXS/9pTAMHWYLTV4O6kBJnUA0xU8ZWd0HQJapcXoLagBwvW7WyYhslp+nlO7vVOVEp
 6ozA==
X-Gm-Message-State: AOAM5302KCjo8dWZyHpa4CBDgl/Gr8nWXeWyBBs8nlkpYNa6e+EgMy4m
 FUv0LTifHpLmKL8RhLOlp5JJQcBN6rkC+F8vARY=
X-Google-Smtp-Source: ABdhPJxZSU7OcT6+Xw6agQLX8qT6DqdHwFEcdKKd93N3mCPT/ubOM0JdG4oGvbsyUb2+YK1Dc2xb1IMQ8nAWxqjy1SU=
X-Received: by 2002:a1f:9505:: with SMTP id x5mr26222492vkd.6.1622015574205;
 Wed, 26 May 2021 00:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
 <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
 <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
In-Reply-To: <6c522f8116f54fa6f23a2d217d966c5a@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 26 May 2021 09:52:42 +0200
Message-ID: <CAMuHMdWzBqLVOVn_z8S2H-x-kL+DfOsM5mDb_D8OKsyRJtKpdA@mail.gmail.com>
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

On Tue, May 11, 2021 at 11:13 AM Marc Zyngier <maz@kernel.org> wrote:
> On 2021-05-11 10:07, Geert Uytterhoeven wrote:
> > On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> >> From: Jianyong Wu <jianyong.wu@arm.com>
> >>
> >> Currently, there is no mechanism to keep time sync between guest and
> >> host
> >> in arm/arm64 virtualization environment. Time in guest will drift
> >> compared
> >> with host after boot up as they may both use third party time sources
> >> to correct their time respectively. The time deviation will be in
> >> order
> >> of milliseconds. But in some scenarios,like in cloud environment, we
> >> ask
> >> for higher time precision.
> >>
> >> kvm ptp clock, which chooses the host clock source as a reference
> >> clock to sync time between guest and host, has been adopted by x86
> >> which takes the time sync order from milliseconds to nanoseconds.
> >>
> >> This patch enables kvm ptp clock for arm/arm64 and improves clock sync
> >> precision
> >> significantly.
> >
> >> --- a/drivers/ptp/Kconfig
> >> +++ b/drivers/ptp/Kconfig
> >> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
> >>  config PTP_1588_CLOCK_KVM
> >>         tristate "KVM virtual PTP clock"
> >>         depends on PTP_1588_CLOCK
> >> -       depends on KVM_GUEST && X86
> >> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&
> >> ARM_ARCH_TIMER)
> >
> > Why does this not depend on KVM_GUEST on ARM?
> > I.e. shouldn't the dependency be:
> >
> >     KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))
> >
> > ?
>
> arm/arm64 do not select KVM_GUEST. Any kernel can be used for a guest,
> and KVM/arm64 doesn't know about this configuration symbol.

OK.

Does PTP_1588_CLOCK_KVM need to default to yes?
Perhaps only on X86, to maintain the status quo?

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
