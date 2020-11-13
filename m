Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A485C55ABD
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 23:05:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0D902225B
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 23:05:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7cXewQj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0D902225B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5DA54B3D3;
	Fri, 13 Nov 2020 18:05:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ydLI5P9rieDu; Fri, 13 Nov 2020 18:05:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE7244B426;
	Fri, 13 Nov 2020 18:05:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D484B3D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 18:05:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8N3esIRGtNV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 18:05:49 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E74A4B3CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 18:05:49 -0500 (EST)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 07C6A22261
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 23:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605308748;
 bh=rxXZRbWdF7kFIEpjIlgp4JhisxbNWUCpDybad8Epf78=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=p7cXewQjdUFsjCaMvIsNjMrhUltximm9Trhf+GbCZqgoDpmrqyXLMwpSdPWWkE7VF
 A082URcztNoLO9CPID8NL+L8198O3y9bBPxWfbL7yOlqHdJUb0IBTTppdcKSnHfnam
 J/aT3V06wWmp0GnFM0KNobLQa1gmEofnkmP/77Qc=
Received: by mail-oi1-f181.google.com with SMTP id k19so3570976oic.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 15:05:47 -0800 (PST)
X-Gm-Message-State: AOAM532FRvbDt0LbbIJoyNeyAq0PsDTiZ5iso741V6DDojCYSmWJJaVy
 b/q1f2krG1NFqH2Kraux/SapuGh7S+2wrVmrI9o=
X-Google-Smtp-Source: ABdhPJx9ux+FpFaYeBgYw09pe+K5GKEwpjUQpJEX1l9QRE0KF2MevwplpUs4/CB6CUT5iCNJT/lyzjNvsYQzLdaA7lQ=
X-Received: by 2002:aca:5c82:: with SMTP id q124mr3157521oib.33.1605308747182; 
 Fri, 13 Nov 2020 15:05:47 -0800 (PST)
MIME-Version: 1.0
References: <20201113182435.64015-1-andre.przywara@arm.com>
In-Reply-To: <20201113182435.64015-1-andre.przywara@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 14 Nov 2020 00:05:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG__RAneq6NwquLiM1ja8O3cepUB6Ovp9aSgy3D_6hN1A@mail.gmail.com>
Message-ID: <CAMj1kXG__RAneq6NwquLiM1ja8O3cepUB6Ovp9aSgy3D_6hN1A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ARM: arm64: Add SMCCC TRNG entropy service
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Theodore Ts'o <tytso@mit.edu>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
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

On Fri, 13 Nov 2020 at 19:24, Andre Przywara <andre.przywara@arm.com> wrote:
>
> Hi,
>
> an update to v2 with some fixes and a few tweaks. Ard's patch [1] should
> significantly reduce the frequency of arch_get_random_seed_long() calls,
> not sure if that is enough the appease the concerns about the
> potentially long latency of SMC calls. I also dropped the direct
> arch_get_random() call in KVM for the same reason. An alternative could
> be to just use the SMC in the _early() versions, but then we would lose
> the SMCCC entropy source for the periodic reseeds. This could be mitigated
> by using a hwrng driver [2] and rngd.
> The only other non-minor change to v2 is the addition of using the SMCCC
> call in the _early() variant. For a changelog see below.
>
> Sudeep: patch 1/5 is a prerequisite for all other patches, which
> themselves could be considered separate and need to go via different trees.
> If we could agree on that one now and get that merged, it would help the
> handling of the other patches going forward.
>
> Cheers,
> Andre
> ==============================
>
> The ARM architected TRNG firmware interface, described in ARM spec
> DEN0098[3], defines an ARM SMCCC based interface to a true random number
> generator, provided by firmware.
>
> This series collects all the patches implementing this in various
> places: as a user feeding into the ARCH_RANDOM pool, both for ARM and
> arm64, and as a service provider for KVM guests.
>
> Patch 1 introduces the interface definition used by all three entities.
> Patch 2 prepares the Arm SMCCC firmware driver to probe for the
> interface. This patch is needed to avoid a later dependency on *two*
> patches (there might be a better solution to this problem).
>
> Patch 3 implements the ARM part, patch 4 is the arm64 version.
> The final patch 5 adds support to provide random numbers to KVM guests.
>
> This was tested on:
> - QEMU -kernel (no SMCCC, regression test)
> - Juno w/ prototype of the h/w Trusted RNG support
> - mainline KVM (SMCCC, but no TRNG: regression test)
> - ARM and arm64 KVM guests, using the KVM service in patch 5/5
>
> Based on v5.10-rc3, please let me know if I should rebased on something
> else. A git repo is accessible at:
> https://gitlab.arm.com/linux-arm/linux-ap/-/commits/smccc-trng/v3/
>
> Cheers,
> Andre
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2020-November/615446.html
> [2] https://gitlab.arm.com/linux-arm/linux-ap/-/commit/87e3722f437
> [3] https://developer.arm.com/documentation/den0098/latest/
>
> Changelog v2 ... v3:
> - ARM: fix compilation with randconfig
> - arm64: use SMCCC call also in arch_get_random_seed_long_early()
> - KVM: comment on return value usage
> - KVM: use more interesting UUID (enjoy, Marc!)

UUIDs are constructed using certain rules, so probably better to
refrain from playing games with them here.

If Marc wants an easter egg, he will have to wait until Easter.

> - KVM: use bitmaps instead of open coded long arrays
> - KVM: drop direct usage of arch_get_random() interface
>
> Changelog "v1" ... v2:
> - trigger ARCH_RANDOM initialisation from the SMCCC firmware driver
> - use a single bool in smccc.c to hold the initialisation state for arm64
> - handle endianess correctly in the KVM provider
>
> Andre Przywara (2):
>   firmware: smccc: Introduce SMCCC TRNG framework
>   arm64: Add support for SMCCC TRNG entropy source
>
> Ard Biesheuvel (3):
>   firmware: smccc: Add SMCCC TRNG function call IDs
>   ARM: implement support for SMCCC TRNG entropy source
>   KVM: arm64: implement the TRNG hypervisor call
>
>  arch/arm/Kconfig                    |  4 ++
>  arch/arm/include/asm/archrandom.h   | 74 +++++++++++++++++++++++++
>  arch/arm64/include/asm/archrandom.h | 79 +++++++++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h   |  2 +
>  arch/arm64/kvm/Makefile             |  2 +-
>  arch/arm64/kvm/hypercalls.c         |  6 ++
>  arch/arm64/kvm/trng.c               | 85 +++++++++++++++++++++++++++++
>  drivers/firmware/smccc/smccc.c      |  5 ++
>  include/linux/arm-smccc.h           | 31 +++++++++++
>  9 files changed, 277 insertions(+), 11 deletions(-)
>  create mode 100644 arch/arm/include/asm/archrandom.h
>  create mode 100644 arch/arm64/kvm/trng.c
>
> --
> 2.17.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
