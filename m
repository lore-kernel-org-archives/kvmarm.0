Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C969CC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 17:14:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716A54B156;
	Wed, 27 Apr 2022 13:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 554ksIDeSpEr; Wed, 27 Apr 2022 13:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4D240BDF;
	Wed, 27 Apr 2022 13:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A9140BBF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 13:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yp5qNQ2Y9i6G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 13:14:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 338124083E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 13:14:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8502861E1D;
 Wed, 27 Apr 2022 17:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E129AC385A9;
 Wed, 27 Apr 2022 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651079677;
 bh=1Wyh8HAQGleHtCXp63QH7fWGdVyOUhsSM+yv05Z8elw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=VJjI+yPUj/93d5Yww+huZrME56O8muQF4VW5ow0L+Uu29fJA6xhv6GlKKQbzgj17j
 jC187r2Foq4IBQ3URPZbgESLFL/xLgqqAEUJqh06sUc2BbRX3RnobTWb5+OSjAQgye
 +N3oQHj5OHBqf3vpLbLeDlVgFiE/HD1j2EbgNUABCb8qS2xYxOrq033ydwJX3vZEgI
 ApSQ4pdqE2SMfIoyRdf5wmsgxmcedu1UxWfZpSbr0yDfcDSnhM7o01IVJNqaqa/d7V
 Wt6bpcnNaNvoQpg6U0n6KU8gnQMuWTYNW8dmaZPWU6DY8hRRkoO/xVk+X8S/+lrmkD
 CDv5L3Y3FE9RQ==
Date: Wed, 27 Apr 2022 18:14:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
Message-ID: <Yml599vM948wXt6g@sirena.org.uk>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220427170858.GA2009@qian>
MIME-Version: 1.0
In-Reply-To: <20220427170858.GA2009@qian>
X-Cookie: Buckle up!
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Luca Salabrino <luca.scalabrino@arm.com>
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
Content-Type: multipart/mixed; boundary="===============4769536904539388517=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4769536904539388517==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SPfSU1Fp6tBwB5Ei"
Content-Disposition: inline


--SPfSU1Fp6tBwB5Ei
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2022 at 01:08:58PM -0400, Qian Cai wrote:
> On Tue, Apr 19, 2022 at 12:22:08PM +0100, Mark Brown wrote:

> > but not SVE, SME is an ARMv9 feature and SVE is mandatory for ARMv9.
> > The code attempts to handle any such systems that are encountered but
> > this hasn't been tested extensively.
>=20
> Running CPU offline/online on a Neoverse-N1 server will trigger a crash.

Can you try with=20

   https://lore.kernel.org/r/20220427130828.162615-1-broonie@kernel.org

please?

--SPfSU1Fp6tBwB5Ei
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJpefYACgkQJNaLcl1U
h9D1cAf+Onw5Pv5V2hKpJvcA5UX72wxZZ5Ln0Tt1QZLj8ao+nwGOLjwfk9EsK1Vd
h5lSxFF5OlEPCcmcKAbeoxzBv+j5YdlW5ifiHToAt7faO67xrTBI8EZBWXTqp6Ht
qANgoQvint2TO0GNxmkjSnI4itbJ2552NLuGSA7sdEevyat94D6gWeJqqiLShsDa
c7DbFEdzWX+AQrGzJ24vzGHCSG5AmA5VFnl9kqxA7aBouymENDc0EzDMPv6h72tH
blNLM01jSkNMvMiT6Z2okfgeXdHZ1u9ZgVof8w9skZeyt4ZtoPgGKSytliSZTu6i
ug033/8MxGzNUKABtp7oxitOR8+O8Q==
=bIU0
-----END PGP SIGNATURE-----

--SPfSU1Fp6tBwB5Ei--

--===============4769536904539388517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4769536904539388517==--
