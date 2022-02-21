Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77037C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 23:39:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4414A19A;
	Mon, 21 Feb 2022 18:39:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fVENVAga03UJ; Mon, 21 Feb 2022 18:39:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9078349F28;
	Mon, 21 Feb 2022 18:39:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE03149F1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 18:39:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JVQfkHKb3+Rk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 18:39:18 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69BCA49F0C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 18:39:18 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D7B6FB8125F;
 Mon, 21 Feb 2022 23:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C38C340E9;
 Mon, 21 Feb 2022 23:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645486755;
 bh=q1IlG4736I9Ca4Bq23/owtBp8HKg6Hi5NPLrAAnQ0Eo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=W6npgAsfP5Wc5GBQf0mEfmGaX4vrAjF3DBucFy0sna5O0oCTNc9+B/wsiusUUcHyC
 U9aGGlFl/ONhM711uVuVCzg6FhNN5TnADzNcac2glj6xIXpCJcV/hLR/pUvyTZsHOw
 v7GYPTA0OYJL0E7s08NiFscoYjP3MvvpE82VLkfX2fTM9aGkAHrbK0gkmgeq9L2ODP
 6xFhV+Zk+dXYbxEX55hHEBOINLmRLS4fo5fCXoG5UEaEIXdJqL0Cmc2kg1Jb7CRf+m
 0VrXa1Zc6QBMPlA7sSGuj2dbK8nu99fuEvExEMm4aLTBm11FqKEDuckmpJk7xQ6R5d
 zwOiWhbD6gx+g==
Date: Mon, 21 Feb 2022 23:39:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 11/40] arm64/sme: Identify supported SME vector
 lengths at boot
Message-ID: <YhQim+ezIauVvE5v@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-12-broonie@kernel.org>
 <YhO2YJ1mliDYjy67@arm.com>
MIME-Version: 1.0
In-Reply-To: <YhO2YJ1mliDYjy67@arm.com>
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
Content-Type: multipart/mixed; boundary="===============8831020607431822935=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8831020607431822935==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cfWJdZnctFslGcVc"
Content-Disposition: inline


--cfWJdZnctFslGcVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 21, 2022 at 03:57:20PM +0000, Catalin Marinas wrote:
> On Mon, Feb 07, 2022 at 03:20:40PM +0000, Mark Brown wrote:

> > +		if (IS_ENABLED(CONFIG_ARM64_SME)) {
> > +			sme_kernel_enable(NULL);
> > +			vec_init_vq_map(ARM64_VEC_SME);

> Why do we need to call sme_kernel_enable() here? It's called again later
> via the cpufeature framework. I guess you need the CPACR_EL1 setup but
> we don't seem to do this for SVE.

It's not needed any more, it's bit rot.

--cfWJdZnctFslGcVc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIUIpoACgkQJNaLcl1U
h9AelAf+JxDGkO9etXGN9Qaw8x9BIScL19CYJdSOuNS8CUsg/wCZeHMIqhuTowDB
G3BSLkhbE1Tx5HnfECHCPq8eGyrEj0VV8mMW7z7dLX6ra1fvMVDXZC1Qc94gD/Q4
qgrJf6JnDPsMheUjFXJwWet6v6v245tO07vmgUSCbw7fy9Qe30pJEMqo7dz2yElQ
uDaeEJWEvqXlfpZPzsBFpNZStG28smGCnmHGk6ONEyWaZaqO0KrPNy/ibf0R4WkH
1V6Fe5opF5a92UubRQckrXhcKWoDP8zCJYIzrSgtPGKCLSEcB4qCRpl0itdSI173
DgMEKQh1xF/TqEJThDO/pgo7Zl3zEA==
=4fVM
-----END PGP SIGNATURE-----

--cfWJdZnctFslGcVc--

--===============8831020607431822935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8831020607431822935==--
