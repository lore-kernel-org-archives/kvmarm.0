Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF14C4741F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 15:35:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 470E522202
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 15:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/vLytVC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 470E522202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 936EC4B869;
	Fri,  6 Nov 2020 10:35:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFuFG+2FurxX; Fri,  6 Nov 2020 10:35:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D7F4B7DF;
	Fri,  6 Nov 2020 10:35:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 056224B7D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 10:35:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EfLclfVYhUhe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 10:35:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D9CA4B6CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 10:35:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C7CB2208C7;
 Fri,  6 Nov 2020 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604676914;
 bh=paZN7AmMflubbnBs/ZRVSzsc+RrX8RA/W7ofJ5ThUB4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=C/vLytVCM05e1EYByu8kmhzsDIqP+J60oRAVf5w8r/c+cO4NuYXpPOrI9VBJuwAPv
 NxpwfRGFFH9zfC7W+h6pzbrx6TGo2RMsVwoPPFO51fmX1iygQvk7L/B5nZtEsepCaI
 qxWEvsSRPSSfVAsVGIsKsB+FAQ/gkVJsHZbLtTBs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb3lg-008Ej3-NW; Fri, 06 Nov 2020 15:35:12 +0000
MIME-Version: 1.0
Date: Fri, 06 Nov 2020 15:35:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 3/5] ARM: implement support for SMCCC TRNG entropy
 source
In-Reply-To: <CAMj1kXHfRpA906eDq6-yo-FbhvNbXYa5vs1xhAr7zG43VTP_QQ@mail.gmail.com>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-4-andre.przywara@arm.com>
 <7b36daa49c78d60dc788bbb3c9c1bdaa@misterjones.org>
 <CAMj1kXHfRpA906eDq6-yo-FbhvNbXYa5vs1xhAr7zG43VTP_QQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <a9ba945763b6dc2b21d48561192f6e3f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, andre.przywara@arm.com, will@kernel.org,
 catalin.marinas@arm.com, linux@armlinux.org.uk, lorenzo.pieralisi@arm.com,
 linus.walleij@linaro.org, linux-kernel@vger.kernel.org, broonie@kernel.org,
 sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-06 15:30, Ard Biesheuvel wrote:
> On Fri, 6 Nov 2020 at 16:30, Marc Zyngier <maz@misterjones.org> wrote:

[...]

>> I don't think this cast is safe. At least not on 64bit.
> 
> True, but this is arch/arm

I think the glasses theme becomes recurrent. Apologies for the noise.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
