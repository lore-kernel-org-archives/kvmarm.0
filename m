Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16928C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 11:50:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9429D221F9
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 11:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9429D221F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1DAC4B193;
	Mon,  4 Jan 2021 06:50:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GaEguzlgo3Gy; Mon,  4 Jan 2021 06:50:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7664B192;
	Mon,  4 Jan 2021 06:50:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC8E4B192
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 06:50:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBBzUUK-c91y for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 06:50:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64AB64B191
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 06:50:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F08B11FB;
 Mon,  4 Jan 2021 03:50:44 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17E3F3F70D;
 Mon,  4 Jan 2021 03:50:42 -0800 (PST)
Date: Mon, 4 Jan 2021 11:49:54 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 4/5] arm64: Add support for SMCCC TRNG entropy source
Message-ID: <20210104114814.5e1fe218@slackpad.fritz.box>
In-Reply-To: <20201211162612.GF4929@sirena.org.uk>
References: <20201211160005.187336-1-andre.przywara@arm.com>
 <20201211160005.187336-5-andre.przywara@arm.com>
 <20201211162612.GF4929@sirena.org.uk>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, 11 Dec 2020 16:26:12 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Fri, Dec 11, 2020 at 04:00:04PM +0000, Andre Przywara wrote:
> 
> >  static inline bool __must_check arch_get_random_seed_long(unsigned
> > long *v) {
> > +	struct arm_smccc_res res;
> > +
> > +	/*
> > +	 * We prefer the SMCCC call, since its semantics (return
> > actual
> > +	 * hardware backed entropy) is closer to the idea behind
> > this
> > +	 * function here than what even the RNDRSS register
> > provides
> > +	 * (the output of a pseudo RNG freshly seeded by a TRNG).
> > +	 */  
> 
> This logic...
> 
> > @@ -77,10 +117,20 @@ arch_get_random_seed_long_early(unsigned long
> > *v) {
> >  	WARN_ON(system_state != SYSTEM_BOOTING);
> >  
> > -	if (!__early_cpu_has_rndr())
> > -		return false;
> > +	if (__early_cpu_has_rndr())
> > +		return __arm64_rndr(v);
> > +
> > +	if (smccc_trng_available) {
> > +		struct arm_smccc_res res;
> >  
> > -	return __arm64_rndr(v);
> > +		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64,
> > &res);
> > +		if ((int)res.a0 >= 0) {
> > +			*v = res.a3;
> > +			return true;
> > +		}
> > +	}
> > +
> > +	return false;  
> 
> ...seems to also apply here but we prefer the RNDR instead of the
> SMCC. We probably want to either do the same thing or add a comment
> saying what's going on.

Argh, you are right, I missed to change this part as well.

Will send a fixed and rebased v5 ASAP.

Cheers,
Andre


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
