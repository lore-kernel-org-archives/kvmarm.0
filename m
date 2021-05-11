Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5DEC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 09:08:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25B4F61932
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 09:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25B4F61932
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 828EC4B4BD;
	Tue, 11 May 2021 05:08:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XvlfvS7HWPNi; Tue, 11 May 2021 05:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B2B4B49F;
	Tue, 11 May 2021 05:08:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8502B4B487
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 05:08:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t9qa2TOwrYIy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 05:08:11 -0400 (EDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com
 [209.85.217.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 241664B41D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 05:08:11 -0400 (EDT)
Received: by mail-vs1-f50.google.com with SMTP id l4so2997070vsa.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 02:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VWZENhS44KnEbYhJ55uNu4C5dSY972Eyg88PLcY/zho=;
 b=jNsEvOaHhk8ePOJH2l7hwvRPokRCSmMyFJPmc7X6ncVtkXq6Oy/7T7+47jI3B2wSmQ
 OTPJHBOWwHmJGmcTT9ilQQPPkf/yR842vVjNOMASPT4L0TbLcyL3y+VCF0BQT0VfdUDS
 hPe+X7ey9aIYbm8AOQ/osAB1N2ZapnUJPCfpMlKX0PGF8/EfeNuBt1rYfBWyD2CVPSgH
 FXnOvoFhJirX6yWy2XwE/5v8oRYRDMJFuRMopEeY8Ovq4daxrUdGzu3y/gxLPhn0znN7
 utaZ2bY+Ki7R8RhdLEYWKucC3UHtQjGYP9ee31rVFZfDB8wFRK79srx/XVLX0ZzN8L06
 VeNg==
X-Gm-Message-State: AOAM530iB9jzQRVlCfF+5K3AsR/AeApcZP9otSLi1lrf4na7D2O7ufR4
 T/LCQcC7gBQB2RPGEjZ0ZtXtgZFm7PiepHKi7wI=
X-Google-Smtp-Source: ABdhPJweTlTBbaLMWAGki0KxVFdQqpl/ZcfogWI1Lhfowsw6ZamthDcv+jjw6/wD3nCQ2Fi0vyUoOcx9OTMR/abE99c=
X-Received: by 2002:a67:3113:: with SMTP id x19mr17992653vsx.40.1620724090696; 
 Tue, 11 May 2021 02:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-8-maz@kernel.org>
In-Reply-To: <20210330145430.996981-8-maz@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 11 May 2021 11:07:59 +0200
Message-ID: <CAMuHMdWd5261ti-zKsroFLvWs0abaWa7G4DKefgPwFb3rEjnNw@mail.gmail.com>
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
To: Marc Zyngier <maz@kernel.org>, jianyong.wu@arm.com
Cc: Android Kernel Team <kernel-team@android.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, justin.he@arm.com,
 KVM list <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
 Richard Cochran <richardcochran@gmail.com>, Yangbo Lu <yangbo.lu@nxp.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Steven Price <steven.price@arm.com>,
 Andre Przywara <Andre.Przywara@arm.com>, John Stultz <john.stultz@linaro.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, seanjc@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

Hi Marc, Jianyong,

On Tue, Mar 30, 2021 at 4:56 PM Marc Zyngier <maz@kernel.org> wrote:
> From: Jianyong Wu <jianyong.wu@arm.com>
>
> Currently, there is no mechanism to keep time sync between guest and host
> in arm/arm64 virtualization environment. Time in guest will drift compared
> with host after boot up as they may both use third party time sources
> to correct their time respectively. The time deviation will be in order
> of milliseconds. But in some scenarios,like in cloud environment, we ask
> for higher time precision.
>
> kvm ptp clock, which chooses the host clock source as a reference
> clock to sync time between guest and host, has been adopted by x86
> which takes the time sync order from milliseconds to nanoseconds.
>
> This patch enables kvm ptp clock for arm/arm64 and improves clock sync precision
> significantly.

> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH
>  config PTP_1588_CLOCK_KVM
>         tristate "KVM virtual PTP clock"
>         depends on PTP_1588_CLOCK
> -       depends on KVM_GUEST && X86
> +       depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER)

Why does this not depend on KVM_GUEST on ARM?
I.e. shouldn't the dependency be:

    KVM_GUEST && (X86 || (HAVE_ARM_SMCCC_DISCOVERY && ARM_ARCH_TIMER))

?

>         default y
>         help
>           This driver adds support for using kvm infrastructure as a PTP

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
