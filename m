Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41E9C4741F
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:05:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D553220782
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 14:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0Avospv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D553220782
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6634B722;
	Thu,  5 Nov 2020 09:05:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qXKVJTcBH3Hc; Thu,  5 Nov 2020 09:05:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D814B72E;
	Thu,  5 Nov 2020 09:05:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7424B722
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:05:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ORlce-0L5gTT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 09:05:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC3CA4B719
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 09:05:11 -0500 (EST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8CE9721734
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604585110;
 bh=esBcP/AJui6XiODiwrRpOoJCZgU1uTPnZxKtrRhiwcQ=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=p0Avospvm9Lp2t90GSwX+PDScEW9y9WjpQyOZ/4BKa83ieD2OGsfWV5jRNyiM/aDm
 9nk0uok6m3Xa66LyTG14bQXYC2S0pWeB6ElqYQiozYM7JWBGNa75/RFcx7pq3GF23w
 AL7Xu7QQPpAL/z9XBzQePs8klKyRBXZtzWv5J0Kk=
Received: by mail-oi1-f180.google.com with SMTP id m143so1756184oig.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 06:05:10 -0800 (PST)
X-Gm-Message-State: AOAM532yoDLmbt+V7YW3NaBdx0dkLfzmmXUpI1ngxR/KP6ds3oCpw4JS
 XdS1JaqOrDWeeoCsQwHFFnraXbkhcMcSslkZ1zI=
X-Google-Smtp-Source: ABdhPJzvhwiuKTQ1g53DmeNxesk2+lZ+jwmMOBSwIT6oWGiGdQqKP2WkQiSoendqj34YoBYf+kut4OMFtsrmDTp2C7Q=
X-Received: by 2002:aca:2310:: with SMTP id e16mr1519564oie.47.1604585109752; 
 Thu, 05 Nov 2020 06:05:09 -0800 (PST)
MIME-Version: 1.0
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-5-andre.przywara@arm.com>
 <20201105134142.GA4856@sirena.org.uk>
 <20201105140322.GH82102@C02TD0UTHF1T.local>
In-Reply-To: <20201105140322.GH82102@C02TD0UTHF1T.local>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 5 Nov 2020 15:04:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEsaZAGT0jnPNyj_K1Q4W7E1+WP=tQf3bTPQi=KOCUv4g@mail.gmail.com>
Message-ID: <CAMj1kXEsaZAGT0jnPNyj_K1Q4W7E1+WP=tQf3bTPQi=KOCUv4g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
To: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
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

On Thu, 5 Nov 2020 at 15:03, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Thu, Nov 05, 2020 at 01:41:42PM +0000, Mark Brown wrote:
> > On Thu, Nov 05, 2020 at 12:56:55PM +0000, Andre Przywara wrote:
> >
> > >  static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
> > >  {
> > > +   struct arm_smccc_res res;
> > >     unsigned long val;
> > > -   bool ok = arch_get_random_seed_long(&val);
> > >
> > > -   *v = val;
> > > -   return ok;
> > > +   if (cpus_have_const_cap(ARM64_HAS_RNG)) {
> > > +           if (arch_get_random_seed_long(&val)) {
> > > +                   *v = val;
> > > +                   return true;
> > > +           }
> > > +           return false;
> > > +   }
> >
> > It isn't obvious to me why we don't fall through to trying the SMCCC
> > TRNG here if for some reason the v8.5-RNG didn't give us something.
> > Definitely an obscure possibility but still...
>
> I think it's better to assume that if we have a HW RNG and it's not
> giving us entropy, it's not worthwhile trapping to the host, which might
> encounter the exact same issue.
>
> I'd rather we have one RNG source that we trust works, and use that
> exclusively.
>
> That said, I'm not sure it's great to plumb this under the
> arch_get_random*() interfaces, e.g. given this measn that
> add_interrupt_randomness() will end up trapping to the host all the time
> when it calls arch_get_random_seed_long().
>

As it turns out, add_interrupt_randomness() isn't actually used on ARM.

> Is there an existing interface for "slow" runtime entropy that we can
> plumb this into instead?
>
> Thanks,
> Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
