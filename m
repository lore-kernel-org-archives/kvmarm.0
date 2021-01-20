Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4626EC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:01:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A37B23357
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A37B23357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD674B194;
	Wed, 20 Jan 2021 08:01:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ITqM+nl4ehui; Wed, 20 Jan 2021 08:01:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7F134B139;
	Wed, 20 Jan 2021 08:01:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C12F4B132
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:01:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mffvB76opY3l for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 08:01:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 988E94B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:01:18 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B534423359;
 Wed, 20 Jan 2021 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611147677;
 bh=fv6o22qVsOE0z15uZ3xH1mPJXj9J7IiDzaa60rlTTfI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YduoI6OqvxriKJsI6iQsSU1sNIWsz3fWcf4p7CgaeOKUjohpRnHheqTU3PO765iNp
 vGY2VXlOFDKPz6nClnbKlg+pWEIsLmdtS9hqA5Gkv+9JpZnB5K4vto/h7uQ1YUBa72
 BOfmeo4m4MPjpBLWr/ztZ2HMgoz1rmHWPn1jXFdbutdoDIqMniwDofk06oaq5C8k04
 /HY/qNDhuAliRs1+FyC2RtEFieEswHxxyUXs3Ph8QfvgUweibnJoFBjwlqQwr19dRn
 netuWz7cQi/Mi5uH8RUsOWkh68DFHIsxGLT6U7born+S/ewfCh+miaybHXTIc7qhAX
 RES9H8/CZub+Q==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v6 0/5] ARM: arm64: Add SMCCC TRNG entropy service
Date: Wed, 20 Jan 2021 13:01:02 +0000
Message-Id: <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106103453.152275-1-andre.przywara@arm.com>
References: <20210106103453.152275-1-andre.przywara@arm.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, kernel-team@android.com,
 Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, 6 Jan 2021 10:34:48 +0000, Andre Przywara wrote:
> a fix to v5, now *really* fixing the wrong priority of SMCCC vs. RNDR
> in arch_get_random_seed_long_early(). Apologies for messing this up
> in v5 and thanks to broonie for being on the watch!
> 
> Will, Catalin: it would be much appreciated if you could consider taking
> patch 1/5. This contains the common definitions, and is a prerequisite
> for every other patch, although they are somewhat independent and likely
> will need to go through different subsystems.
> 
> [...]

Applied the first patch only to arm64 (for-next/rng), thanks!

[1/5] firmware: smccc: Add SMCCC TRNG function call IDs
      https://git.kernel.org/arm64/c/67c6bb56b649

What's the plan for the rest of the series, and I think the related
change over at [1]?

Cheers,
-- 
Will

[1] https://lore.kernel.org/linux-arm-kernel/20201105152944.16953-1-ardb@kernel.org/

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
