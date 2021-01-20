Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14ABC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:16:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DE4C2339E
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 13:16:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DE4C2339E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ECA14B168;
	Wed, 20 Jan 2021 08:16:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G8ScMPJrriQe; Wed, 20 Jan 2021 08:16:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83EF94B16C;
	Wed, 20 Jan 2021 08:16:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECD84B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:16:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sAq9Cv+yN9Vh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 08:16:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835D84B124
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 08:16:12 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581B8233A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611148571;
 bh=87O7GrSH7aFNMKentPe/tHn88Y8PdtjVrGHyPMN/1Ks=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=nx/USp8x+a4VErW3+FrTdkcMiu71DTeVUy0+HRIQr3KRZoZ56eS19LkKj+BRzQB9B
 mgkkI4AxBYx6QWaTf45JAgLtrFUast2bjTzRk65ih2vbik7/0FNEhJhtnYGjZt6HQT
 da/O5wPcLe9wTkXtuCSaz93E50Vj3eET5tEdytU1F1rvjroXl5UNyfD3d09f6Nj6Zw
 BryR9RL/SCwVum6VXmBSd+F+UVcVIH6sjDfsng73Ng8BVteGwUjY2wlM3UuFgRs9VT
 0+v5uQwK8tdFhNFIIOBubt/WtYtb2uAS6j+9mc5sv8HNb5GQJ4OyAlN8S+smC5mdD8
 q+Gft8kAVVRZw==
Received: by mail-oi1-f182.google.com with SMTP id 15so24957779oix.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 05:16:11 -0800 (PST)
X-Gm-Message-State: AOAM530s/I633sQtp/PZtDUuYq4OEoRYFbow/bLpRIqg9S9uvk0jPTpx
 wwrvtr5qtDV/cJEsmtMUUKOfwy9/PC6+lfqhVyw=
X-Google-Smtp-Source: ABdhPJw8vZjz+ynYzeabDu0W9Mkp4ZmuPTi9i1w7KwilsqfguTeO6X1CqhyKq14F6BMDgjhUR8h2OGXCiTzK2zKrLAg=
X-Received: by 2002:aca:210f:: with SMTP id 15mr2800820oiz.174.1611148570568; 
 Wed, 20 Jan 2021 05:16:10 -0800 (PST)
MIME-Version: 1.0
References: <20210106103453.152275-1-andre.przywara@arm.com>
 <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
In-Reply-To: <161114590396.218530.9227813162726341261.b4-ty@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 20 Jan 2021 14:15:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHW4gPdWXc93eAYpHNU3H+Whg-n2mcEKX=Zro0nANhgSg@mail.gmail.com>
Message-ID: <CAMj1kXHW4gPdWXc93eAYpHNU3H+Whg-n2mcEKX=Zro0nANhgSg@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] ARM: arm64: Add SMCCC TRNG entropy service
To: Will Deacon <will@kernel.org>
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

On Wed, 20 Jan 2021 at 14:01, Will Deacon <will@kernel.org> wrote:
>
> On Wed, 6 Jan 2021 10:34:48 +0000, Andre Przywara wrote:
> > a fix to v5, now *really* fixing the wrong priority of SMCCC vs. RNDR
> > in arch_get_random_seed_long_early(). Apologies for messing this up
> > in v5 and thanks to broonie for being on the watch!
> >
> > Will, Catalin: it would be much appreciated if you could consider taking
> > patch 1/5. This contains the common definitions, and is a prerequisite
> > for every other patch, although they are somewhat independent and likely
> > will need to go through different subsystems.
> >
> > [...]
>
> Applied the first patch only to arm64 (for-next/rng), thanks!
>
> [1/5] firmware: smccc: Add SMCCC TRNG function call IDs
>       https://git.kernel.org/arm64/c/67c6bb56b649
>
> What's the plan for the rest of the series, and I think the related
> change over at [1]?
>

Given that Ted seems to have lost interest in /dev/random patches, I
was hoping [1] could be taken via the arm64 tree instead. Without this
patch, I don't think we should expose the SMCCC RNG interface via
arch_get_random_seed(), given how insanely often it will be called in
that case.

Note that the KVM patch implements the opposite end of this interface,
and is not affected by [1] at all, so that can be taken at any time.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
