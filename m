Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A7FC55179
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:45:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2508620936
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2508620936
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 556D34B609;
	Thu,  5 Nov 2020 09:45:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SSdPR7lgurUQ; Thu,  5 Nov 2020 09:45:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 224F04B503;
	Thu,  5 Nov 2020 09:45:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F0434B503
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:45:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R9w8TpJ0JlSK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 09:45:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA954B500
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:45:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7557D14BF;
 Thu,  5 Nov 2020 06:45:36 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.58.72])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A86743F718;
 Thu,  5 Nov 2020 06:45:33 -0800 (PST)
Date: Thu, 5 Nov 2020 14:45:30 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201105144530.GK82102@C02TD0UTHF1T.local>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
 <20201105134142.GA4856@sirena.org.uk>
 <20201105140322.GH82102@C02TD0UTHF1T.local>
 <CAMj1kXEsaZAGT0jnPNyj_K1Q4W7E1+WP=tQf3bTPQi=KOCUv4g@mail.gmail.com>
 <20201105143023.GI82102@C02TD0UTHF1T.local>
 <CAMj1kXEoot13bFKywPRVf4BFhA5tSp+Nate=+Z+JsQdLW1oRrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMj1kXEoot13bFKywPRVf4BFhA5tSp+Nate=+Z+JsQdLW1oRrg@mail.gmail.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Marc Zyngier <maz@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Sudeep Holla <sudeep.holla@arm.com>, Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, Mark Brown <broonie@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Nov 05, 2020 at 03:34:01PM +0100, Ard Biesheuvel wrote:
> On Thu, 5 Nov 2020 at 15:30, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Nov 05, 2020 at 03:04:57PM +0100, Ard Biesheuvel wrote:
> > > On Thu, 5 Nov 2020 at 15:03, Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > > > That said, I'm not sure it's great to plumb this under the
> > > > arch_get_random*() interfaces, e.g. given this measn that
> > > > add_interrupt_randomness() will end up trapping to the host all the time
> > > > when it calls arch_get_random_seed_long().
> > >
> > > As it turns out, add_interrupt_randomness() isn't actually used on ARM.
> >
> > It's certainly called on arm64, per a warning I just hacked in:

[...]

> > ... and I couldn't immediately spot why 32-bit arm  would be different.
> 
> Hmm, I actually meant both arm64 and ARM.
> 
> Marc looked into this at my request a while ago, and I had a look
> myself as well at the time, and IIRC, we both concluded that we don't
> hit that code path. Darn.
> 
> In any case, the way add_interrupt_randomness() calls
> arch_get_random_seed_long() is absolutely insane, so we should try to
> fix that in any case.

I have no strong opinion there, and I'm happy with that getting cleaned
up.

Regardless, I do think it's reasonable for the common code to expect
that arch_get_random_*() to be roughly as expensive as "most other
instructions" (since even RNDR* is expensive the CPU might be able to do
useful speculative work in the mean time), whereas a trap to the host is
always liable to be expensive as no useful work can be done while the
host is handling it, so I think it makes sense to distinguish the two.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
