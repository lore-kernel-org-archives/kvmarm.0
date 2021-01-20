Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0767C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:26:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A98D23359
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A98D23359
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABC34B13C;
	Wed, 20 Jan 2021 08:26:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RJpxt84YveHb; Wed, 20 Jan 2021 08:26:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 461AD4B168;
	Wed, 20 Jan 2021 08:26:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F313B4B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:26:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5RZii49CT2r5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 08:26:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F29724B13C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:26:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B2A68233A1;
 Wed, 20 Jan 2021 13:26:28 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l2DVC-008x9e-IT; Wed, 20 Jan 2021 13:26:26 +0000
MIME-Version: 1.0
Date: Wed, 20 Jan 2021 13:26:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v6 0/5] ARM: arm64: Add SMCCC TRNG entropy service
In-Reply-To: <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
References: <20210106103453.152275-1-andre.przywara@arm.com>
 <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <d2423ab6e44855846a8f61f327932784@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, andre.przywara@arm.com,
 linux@armlinux.org.uk, catalin.marinas@arm.com, ardb@kernel.org,
 kernel-team@android.com, tytso@mit.edu, broonie@kernel.org,
 sudeep.holla@arm.com, linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
 kvmarm@lists.cs.columbia.edu, lorenzo.pieralisi@arm.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Sudeep Holla <sudeep.holla@arm.com>,
 kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-20 13:01, Will Deacon wrote:
> On Wed, 6 Jan 2021 10:34:48 +0000, Andre Przywara wrote:
>> a fix to v5, now *really* fixing the wrong priority of SMCCC vs. RNDR
>> in arch_get_random_seed_long_early(). Apologies for messing this up
>> in v5 and thanks to broonie for being on the watch!
>> 
>> Will, Catalin: it would be much appreciated if you could consider 
>> taking
>> patch 1/5. This contains the common definitions, and is a prerequisite
>> for every other patch, although they are somewhat independent and 
>> likely
>> will need to go through different subsystems.
>> 
>> [...]
> 
> Applied the first patch only to arm64 (for-next/rng), thanks!
> 
> [1/5] firmware: smccc: Add SMCCC TRNG function call IDs
>       https://git.kernel.org/arm64/c/67c6bb56b649

I can't see how the rest of the patches can go via any other tree
if all the definitions are in the first one.

Andre, can you explain what your plan is?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
