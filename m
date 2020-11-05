Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21F8C4742C
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:39:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E80920936
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:39:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E80920936
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 704024B810;
	Thu,  5 Nov 2020 09:39:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hWumgTr47CND; Thu,  5 Nov 2020 09:39:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 497BA4B609;
	Thu,  5 Nov 2020 09:39:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 955E04B609
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:38:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sLuMFWQ24xm1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 09:38:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A70B4B570
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:38:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB61414BF;
 Thu,  5 Nov 2020 06:38:57 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.58.72])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B68D3F719;
 Thu,  5 Nov 2020 06:38:55 -0800 (PST)
Date: Thu, 5 Nov 2020 14:38:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201105143852.GJ82102@C02TD0UTHF1T.local>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
 <20201105134142.GA4856@sirena.org.uk>
 <20201105140322.GH82102@C02TD0UTHF1T.local>
 <20201105142949.GB4856@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201105142949.GB4856@sirena.org.uk>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-kernel@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Nov 05, 2020 at 02:29:49PM +0000, Mark Brown wrote:
> On Thu, Nov 05, 2020 at 02:03:22PM +0000, Mark Rutland wrote:
> > On Thu, Nov 05, 2020 at 01:41:42PM +0000, Mark Brown wrote:
> 
> > > It isn't obvious to me why we don't fall through to trying the SMCCC
> > > TRNG here if for some reason the v8.5-RNG didn't give us something.
> > > Definitely an obscure possibility but still...
> 
> > I think it's better to assume that if we have a HW RNG and it's not
> > giving us entropy, it's not worthwhile trapping to the host, which might
> > encounter the exact same issue.
> 
> There's definitely a good argument for that, but OTOH it's possible the
> SMCCC implementation is doing something else (it'd be an interesting
> implementation decision but...).  That said I don't really mind, I think
> my comment was more that if we're doing this the code should be explicit
> about what the intent is since right now it isn't obvious.  Either a
> comment or having an explicit "what method are we choosing" thing.
> 
> > That said, I'm not sure it's great to plumb this under the
> > arch_get_random*() interfaces, e.g. given this measn that
> > add_interrupt_randomness() will end up trapping to the host all the time
> > when it calls arch_get_random_seed_long().
> 
> > Is there an existing interface for "slow" runtime entropy that we can
> > plumb this into instead?
> 
> Yeah, I was wondering about this myself - it seems like a better fit for
> hwrng rather than the arch interfaces but that's not used until
> userspace comes up, the arch stuff is all expected to be quick.  I
> suppose we could implement the SMCCC stuff for the early variants of the
> API you added so it gets used for bootstrapping purposes and then we
> rely on userspace keeping things topped up by fetching entropy through
> hwrng or otherwise but that feels confused so I have a hard time getting
> enthusiastic about it.

I'm perfectly happy for the early functions to call this, or for us to
add something new firmwware_get_random_*() functions that we can call
early (and potentially at runtime, but less often than
arch_get_random_*()).

I suspect the easy thing to do for now is plumb this into the existing
early arch functions and hwrng.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
