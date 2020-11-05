Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC24C5517A
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:03:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9AC1E20759
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AC1E20759
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFED4B779;
	Thu,  5 Nov 2020 09:03:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a2XmPSchxGnD; Thu,  5 Nov 2020 09:03:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE544B6D3;
	Thu,  5 Nov 2020 09:03:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E9904B6D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:03:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q3wjY2ryQHj8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 09:03:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 680CF4B693
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:03:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED82614BF;
 Thu,  5 Nov 2020 06:03:27 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.58.72])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78F9C3F719;
 Thu,  5 Nov 2020 06:03:25 -0800 (PST)
Date: Thu, 5 Nov 2020 14:03:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20201105140322.GH82102@C02TD0UTHF1T.local>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
 <20201105134142.GA4856@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201105134142.GA4856@sirena.org.uk>
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

On Thu, Nov 05, 2020 at 01:41:42PM +0000, Mark Brown wrote:
> On Thu, Nov 05, 2020 at 12:56:55PM +0000, Andre Przywara wrote:
> 
> >  static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
> >  {
> > +	struct arm_smccc_res res;
> >  	unsigned long val;
> > -	bool ok = arch_get_random_seed_long(&val);
> >  
> > -	*v = val;
> > -	return ok;
> > +	if (cpus_have_const_cap(ARM64_HAS_RNG)) {
> > +		if (arch_get_random_seed_long(&val)) {
> > +			*v = val;
> > +			return true;
> > +		}
> > +		return false;
> > +	}
> 
> It isn't obvious to me why we don't fall through to trying the SMCCC
> TRNG here if for some reason the v8.5-RNG didn't give us something.
> Definitely an obscure possibility but still...

I think it's better to assume that if we have a HW RNG and it's not
giving us entropy, it's not worthwhile trapping to the host, which might
encounter the exact same issue.

I'd rather we have one RNG source that we trust works, and use that
exclusively.

That said, I'm not sure it's great to plumb this under the
arch_get_random*() interfaces, e.g. given this measn that
add_interrupt_randomness() will end up trapping to the host all the time
when it calls arch_get_random_seed_long().

Is there an existing interface for "slow" runtime entropy that we can
plumb this into instead?

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
