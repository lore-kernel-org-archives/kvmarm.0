Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DA8C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 12:15:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F114C49E49;
	Tue, 25 Jan 2022 07:15:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7KZBi+jKcHUf; Tue, 25 Jan 2022 07:15:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB2C49B0A;
	Tue, 25 Jan 2022 07:15:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4F849AF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 07:15:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tsqg8wPEaKNc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 07:15:39 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C475411BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 07:15:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 633F9B817ED;
 Tue, 25 Jan 2022 12:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC0EC340E0;
 Tue, 25 Jan 2022 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643112936;
 bh=+BPgF8RegY0meHVcPfjKYDlnsQFJtpvb4tI1Bi3dYXE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MtM0nmjKZgFQbwMBnBGO/d5R3rHePax1BqLreg9msC+fpgKIGKk0ZGrk7Lk0bWo08
 jEaruAfvfaT3zWVSlNFBOE3WVaQ9xfJPC87FnkuwedSYGET09lWy1LCQeiBinB2rdb
 lwgoV5gjF8Go/Nj7Wl5q8tq8sn16X+fOInxNXBfHDuXccGOu652i/xwLYjX9+YmsA4
 AtnS6Pr1WTGHgZog1BdwBhDrBatOqqHwnXEs3cQqdMN0o1lf6v32CgLbJkRKEyhUkx
 9HxKqsipXfZG/GWBrdy12AHY+uHLxC6nxRDSSpqUg29V1zJ9u9g6xJqsviMtfNb3OI
 u+vA4aFtVw4Fw==
Date: Tue, 25 Jan 2022 12:15:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 05/38] arm64/sme: System register and exception
 syndrome definitions
Message-ID: <Ye/p4YpWWnZSPFaZ@sirena.org.uk>
References: <20220125001114.193425-1-broonie@kernel.org>
 <20220125001114.193425-6-broonie@kernel.org>
 <87zgnk6or8.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87zgnk6or8.wl-maz@kernel.org>
X-Cookie: The second best policy is dishonesty.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============9051762072174147319=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============9051762072174147319==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DA6PqB3G+/AhTsSL"
Content-Disposition: inline


--DA6PqB3G+/AhTsSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 25, 2022 at 11:25:31AM +0000, Marc Zyngier wrote:
> On Tue, 25 Jan 2022 00:10:41 +0000,
> Mark Brown <broonie@kernel.org> wrote:

> > +/* HFG[WR]TR_EL2 bit definitions */
> > +#define HFGxTR_EL2_nTPIDR_EL0_SHIFT	55
> > +#define HFGxTR_EL2_nTPIDR_EL0_MASK	(1 << HFGxTR_EL2_nTPIDR_EL0_SHIFT)

> This annoyingly clashes with bit 35 of the same registers, which maps
> to TPIDR_EL0. I have the feeling that this really should be TPIDR2_EL0.

Yes, it should be.

--DA6PqB3G+/AhTsSL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHv6eEACgkQJNaLcl1U
h9Bqogf/cPq0bM4yoDggdP1uvRbGK1VpH1TSSNyNLxG6PNgq8w3D5EY8BuCDrP40
Ss+eJ0UElwdsoXScwvFKoIeXt6pGtughyC2uEnxz+rif0YlGOQyoWg9SWbzq56+g
lSrYeMGyIPzHiJaXtjsFQEQBfiRoxEGilmte8Owq01WhyTea9cEZbYyu9Wk8pjJZ
GWPOOMBXqCRPL5zbFVJsGEV4meEMFew/pqNCZJw5jgkUEHGj8ln92kipxoE8YULJ
ibed2fmR2WpadC7SftEzh9S/Gd+I2XBxtw5bg7f8OSqn0NAit0umxnwXVmT1jGxu
+kQ/lXqNg/SndWNAKKGAWteJRQqTUA==
=nbA7
-----END PGP SIGNATURE-----

--DA6PqB3G+/AhTsSL--

--===============9051762072174147319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9051762072174147319==--
