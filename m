Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4732C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 13:42:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2AD49ECC;
	Tue, 22 Feb 2022 08:42:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qnm34ksE1HwB; Tue, 22 Feb 2022 08:42:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3E74B0BD;
	Tue, 22 Feb 2022 08:42:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A6A4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:42:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mxY-hpH-J8b4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 08:42:34 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E1E049ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:42:34 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BF6856126A;
 Tue, 22 Feb 2022 13:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10505C340E8;
 Tue, 22 Feb 2022 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645537353;
 bh=Dgt4Njyb87/1m9sSS9cByUyH93W7hgmQZXT2bQcvLbM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FS2HTkxtW64sxuVW8n0wSjhFlnRTJuMQnIZ8Xql1lrAR2ox/DacMZ9PAdsJk6UWK/
 mu+lY9POXbUOs0c2AHa+OGNgqOtv+kg9mpdjVN3o56QsCE8yey3T6RwZOLC+uJnAYn
 E5l5gg+GY4HB9yJg74dQ1KkkL00YZaQid3Lj1x7SSfNKlW5Oq30olisneiH6HghyJl
 tgkN+zOyCjmG8tw7x6KTV7YQSGw6NLul3xsoE+xyTYTzQnpAE0Sl59MMFaYKX1VDT0
 K3MLAy35yo2hAhq3M0LaJkWHiJ9nfqMM7pGsbSBMCeiQphDm/8HWb0tstH8e8u5vTp
 5JdcGAvVtr6ag==
Date: Tue, 22 Feb 2022 13:42:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 16/40] arm64/sme: Implement streaming SVE context
 switching
Message-ID: <YhToQuAqnbg3FXDI@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-17-broonie@kernel.org>
 <YhTct2Cy1fMOsjuZ@arm.com>
MIME-Version: 1.0
In-Reply-To: <YhTct2Cy1fMOsjuZ@arm.com>
X-Cookie: I smell a wumpus.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============8753709865525216870=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8753709865525216870==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HCJoz7wijUUjw35T"
Content-Disposition: inline


--HCJoz7wijUUjw35T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 22, 2022 at 12:53:11PM +0000, Catalin Marinas wrote:

> I think I get this but a state diagram somewhere would help ;).

> IIUC you don't disable SM on a context switch, you just leave it in
> place until a task_fpsimd_load(). It shouldn't be a problem as
> kernel_neon_begin() disables it anyway.

Yes, streaming mode is part of the floating point state and this is how
we handle floating point in general - it's part of what's tracked with
TIF_FOREIGN_FPSTATE.  Unless we want to do something with floating point
we don't touch it.

--HCJoz7wijUUjw35T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIU6EIACgkQJNaLcl1U
h9AQKwf+NQfS1WFJTmF/zyR2Ew84K70XTrrLzPlgOF24CCCSuihIA3ZF22mUWYB4
W3snzj3yvOJioOrceWBR/rcSXdLqQy/KDO9CUbWAkShtfo4uukYgS9pivUZAEm8m
f+tJg3ktwvR7iO/wrYW65kfYAlwxSdzjXbUBFb8BkcwVjiezVOWVR1cZp8WV47DC
pIztOPzukFtV1lwiwZw6/p9M0qhsrXooLGBXcDw99t5WWWyfSF0sXREO8V1C0Tx5
zWULO6hCfSr9uK9T19lMG/FXDSnrV+3A0QuWZY2qMJiub1mgKJH/ofRKCNHnnJSR
70fYhIlRd5nXUGingt6IIJaIp/tQbw==
=JTyO
-----END PGP SIGNATURE-----

--HCJoz7wijUUjw35T--

--===============8753709865525216870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8753709865525216870==--
