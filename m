Return-Path: <SRS0=IlRN=GY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E438C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 17:54:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB96E207C5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 17:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB96E207C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F402F4B156;
	Thu, 21 Jan 2021 12:54:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXn1Fr5z4iOG; Thu, 21 Jan 2021 12:54:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02AA4B159;
	Thu, 21 Jan 2021 12:54:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE854B156
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jan 2021 12:54:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ex+eyCKSK23Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jan 2021 12:54:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCBA4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jan 2021 12:54:26 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414C621973;
 Thu, 21 Jan 2021 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611251665;
 bh=UoorRMvSGUceggy9m7jQ580i3cz0aYpDS1TAbvR/rEk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=A08rRJRbcUEexudiHrvqmX6AgJwLL+HJOEIqjMdYrhGPSBMaRSmAp77HRfl/uEhJr
 GDgqkSHYixgVJ6aZ3/d1//Rqo7o8dspi6AgBkV92oCVtU8OZWeDquOIjJBQlyHr9Jv
 enuXyQFtAe1WvTAfA036bxCKVyOZtMOix7roLxWNR7rWsvWNXsmSt56F0bXEfuzusc
 QjCarXuyOSzhmmsrD1QJxh3oASray65OGKXi5FJGAHdHBjt5uDnPGZOED7AjUNYlps
 u58NTQShoDQr6IoCETUMwnJNU8EemE1sc/ErtHbnwHv4ZF969qqtAg1Ib3doLCmeSp
 wp85wTVhx/DZg==
Date: Thu, 21 Jan 2021 17:54:20 +0000
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 0/5] ARM: arm64: Add SMCCC TRNG entropy service
Message-ID: <20210121175419.GA22963@willie-the-truck>
References: <20210106103453.152275-1-andre.przywara@arm.com>
 <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
 <CAMj1kXHW4gPdWXc93eAYpHNU3H+Whg-n2mcEKX=Zro0nANhgSg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMj1kXHW4gPdWXc93eAYpHNU3H+Whg-n2mcEKX=Zro0nANhgSg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Marc Zyngier <maz@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
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

On Wed, Jan 20, 2021 at 02:15:59PM +0100, Ard Biesheuvel wrote:
> On Wed, 20 Jan 2021 at 14:01, Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, 6 Jan 2021 10:34:48 +0000, Andre Przywara wrote:
> > > a fix to v5, now *really* fixing the wrong priority of SMCCC vs. RNDR
> > > in arch_get_random_seed_long_early(). Apologies for messing this up
> > > in v5 and thanks to broonie for being on the watch!
> > >
> > > Will, Catalin: it would be much appreciated if you could consider taking
> > > patch 1/5. This contains the common definitions, and is a prerequisite
> > > for every other patch, although they are somewhat independent and likely
> > > will need to go through different subsystems.
> > >
> > > [...]
> >
> > Applied the first patch only to arm64 (for-next/rng), thanks!
> >
> > [1/5] firmware: smccc: Add SMCCC TRNG function call IDs
> >       https://git.kernel.org/arm64/c/67c6bb56b649
> >
> > What's the plan for the rest of the series, and I think the related
> > change over at [1]?
> >
> 
> Given that Ted seems to have lost interest in /dev/random patches, I
> was hoping [1] could be taken via the arm64 tree instead. Without this
> patch, I don't think we should expose the SMCCC RNG interface via
> arch_get_random_seed(), given how insanely often it will be called in
> that case.

Ok, let's give that a shot -- I'll additionally pick patches 2 and 4 out
of this series, and merge in the /dev/random change on its own branch in
case there are any late objections.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
