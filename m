Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D7DC34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:06:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86BC52176D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 13:06:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86BC52176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF6E4AF05;
	Tue, 18 Feb 2020 08:06:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hmx7CGAfB5uK; Tue, 18 Feb 2020 08:06:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9364ACD5;
	Tue, 18 Feb 2020 08:06:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9CA4A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:06:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7UmaD6wkg9m1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 08:06:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79C14A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 08:06:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42A471FB;
 Tue, 18 Feb 2020 05:06:21 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA29D3F703;
 Tue, 18 Feb 2020 05:06:20 -0800 (PST)
Date: Tue, 18 Feb 2020 13:06:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
Message-ID: <20200218130619.GE4232@sirena.org.uk>
References: <20200218124456.10615-1-broonie@kernel.org>
 <49f7de5f1d86e7edcc34edb55d5011be@kernel.org>
MIME-Version: 1.0
In-Reply-To: <49f7de5f1d86e7edcc34edb55d5011be@kernel.org>
X-Cookie: No alcohol, dogs or horses.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============5221229050155861885=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5221229050155861885==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uCPdOCrL+PnN2Vxy"
Content-Disposition: inline


--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2020 at 12:56:52PM +0000, Marc Zyngier wrote:

> I'd really appreciate it if you could send these as a series, instead of
> an isolated patch every other day.

OK, I can do that for the KVM stuff - I've been actively trying to keep
the patches separate where there's no dependencies between them as it
avoids things getting caught up in review for more complicated stuff or
cases where someone decides they want extra cleanup while we're at it
which is especially useful when only some of the series is needed for
building on top of as is the case here.

--uCPdOCrL+PnN2Vxy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5L4UoACgkQJNaLcl1U
h9Dy+Qf9GtBbjh9KlVQIqVkbd9XQ9t365dTvsoYYQBMzI3q3zvTgOVzlg+O0vUt+
3Xy+PBFLuw4/ynJeAWfB3GcG2OaAroDsGBEDzkXA5jJ0zOKbq9MuuNmLr07mRVgX
Jim7fz0J2QJ7VjRkb6SgRBd5zAQeMY/fWt53I0UqjA3eQbAEf7UScXoj5/6yFpfw
YlR+2i98aXNlb300X/SRGiAYAZLX/krKjUfgO/6jEvZJ3IQsviY7b0mUttRx4ovI
7m2j3E1eyVGBFlRBhD/0aWV5V/ps6YQjkHzOo3qe2d6UUB0f9zLSYSOQUy3o5ppQ
CBRwusKcBn6OS3v+4HedGMaGa5m0rg==
=O8oy
-----END PGP SIGNATURE-----

--uCPdOCrL+PnN2Vxy--

--===============5221229050155861885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5221229050155861885==--
