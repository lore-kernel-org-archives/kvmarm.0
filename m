Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9ABC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35E0223357
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35E0223357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A05674B1A7;
	Wed, 20 Jan 2021 08:49:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xv-GzIYU+1Q5; Wed, 20 Jan 2021 08:49:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8304B191;
	Wed, 20 Jan 2021 08:49:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D014B162
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:49:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fnJ2sIiCn3r9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 08:49:11 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60D8F4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:49:11 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39DB23340;
 Wed, 20 Jan 2021 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611150550;
 bh=OQBSvzfYcwZS8/3ldKkX9veJ3pP4BOkdeXMVtbXLWHE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TXEB0doB0IG+whfzmKW+EqOYgTcjTpnzkM01FZLhyTA+fT2l/nEFEnI+2RCKZhCOq
 SNGCYfJt8iiec8OKZFmXshdk4ePw4zjx/L6ODtNYykOvULwgQTUyejhsnsofWDcE45
 dzErkqrPL9QmGSPhg/ysbAaOzNBQBcQrDsMftrKb+QZOVUQHEk9okilPFmVsDvAX8s
 cueYkL/tI1ZL4Di+y+JMl4IxxjgrjbMuM8xbOW1O3jynCRbmJM0jGxSB+PQ385EIzW
 oyUG/qBpV3UxONqwbYeE3a39365R1gAWZ1jyaszsuYeJE7JCQkJvCHkCzGq8yP0mxc
 wEGvXTQx/lBFg==
Date: Wed, 20 Jan 2021 13:49:04 +0000
From: Will Deacon <will@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v6 0/5] ARM: arm64: Add SMCCC TRNG entropy service
Message-ID: <20210120134904.GA20315@willie-the-truck>
References: <20210106103453.152275-1-andre.przywara@arm.com>
 <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
 <d2423ab6e44855846a8f61f327932784@kernel.org>
 <20210120134524.0c47139a@slackpad.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210120134524.0c47139a@slackpad.fritz.box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Marc Zyngier <maz@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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

On Wed, Jan 20, 2021 at 01:45:24PM +0000, Andre Przywara wrote:
> On Wed, 20 Jan 2021 13:26:26 +0000
> Marc Zyngier <maz@kernel.org> wrote:
> 
> Hi,
> 
> > On 2021-01-20 13:01, Will Deacon wrote:
> > > On Wed, 6 Jan 2021 10:34:48 +0000, Andre Przywara wrote:  
> > >> a fix to v5, now *really* fixing the wrong priority of SMCCC vs.
> > >> RNDR in arch_get_random_seed_long_early(). Apologies for messing
> > >> this up in v5 and thanks to broonie for being on the watch!
> > >> 
> > >> Will, Catalin: it would be much appreciated if you could consider 
> > >> taking
> > >> patch 1/5. This contains the common definitions, and is a
> > >> prerequisite for every other patch, although they are somewhat
> > >> independent and likely
> > >> will need to go through different subsystems.
> > >> 
> > >> [...]  
> > > 
> > > Applied the first patch only to arm64 (for-next/rng), thanks!
> > > 
> > > [1/5] firmware: smccc: Add SMCCC TRNG function call IDs
> > >       https://git.kernel.org/arm64/c/67c6bb56b649  
> > 
> > I can't see how the rest of the patches can go via any other tree
> > if all the definitions are in the first one.
> > 
> > Andre, can you explain what your plan is?
> 
> Well, I don't really have a great solution for that, other than hoping
> that 1/5 makes it into Linus' master at some point.
> 
> I see that it's a stretch, but pulling 1/5 into 5.11 now would
> prepare the stage for the others to go via any tree, into 5.12-rc1?
> 
> Or you could maybe take both 1/5 and 5/5 into your kvm-arm tree, and
> would hope that a git rebase later would sort this out for you?
> 
> But I think you are much more experienced in those kind of issues, so
> happy to hear about any other solutions.

for-next/rng is a stable branch, so anybody who wants the first patch can
just pull it (without anything I queue on top).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
