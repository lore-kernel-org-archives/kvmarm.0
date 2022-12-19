Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E402C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 15:01:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDA74B8C7;
	Mon, 19 Dec 2022 10:01:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1-pMUxGeiijx; Mon, 19 Dec 2022 10:01:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063594B8B4;
	Mon, 19 Dec 2022 10:01:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEBE24B8AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:01:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TBbwvY17ry7b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 10:01:37 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B797C4B889
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:01:37 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8B18460F18;
 Mon, 19 Dec 2022 15:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F88C433D2;
 Mon, 19 Dec 2022 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671462096;
 bh=fQl1soAH+o/N3eRgAlLaFBBRGKmW0pCblygzAUxFLhU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RuF7hpTGX6ovJF1sDqwgwDqlX+NbPx03E0AlfdEpQnD1CC6DONwyiX0yVBHHfX1A+
 Ybc/kDFaL7J9Sn/F1a5Ygr7pxVzGibqWKwTT163pbYSwhr0gCFvAbZC1BV2ZfMetgS
 hHa1D6lR79/h6do8DW49tp3oNUChL1oj9Io9VURkXhcX1f+SuJh/vKXORVNv7S27L2
 Bf3m9YPAn+zixdMXR4HUk7L9vnTXp7uh6nFZnlva1iZJ/vl2axero30DaCCWOWtpu6
 JFnk1+juW9TTx4TZaYGAKxhpLqysiE1QxDd4gq9fdLsL17C8ioLaBjWd3HLY2sBG3X
 hkgqyzaRCCuIg==
Date: Mon, 19 Dec 2022 15:01:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v3 2/7] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6B8yQxR3wP6VUbW@sirena.org.uk>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-3-akihiko.odaki@daynix.com>
MIME-Version: 1.0
In-Reply-To: <20221218051412.384657-3-akihiko.odaki@daynix.com>
X-Cookie: I brake for chezlogs!
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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
Content-Type: multipart/mixed; boundary="===============1794768015849106740=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1794768015849106740==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bs4hCqutwxbx+i3f"
Content-Disposition: inline


--bs4hCqutwxbx+i3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 18, 2022 at 02:14:07PM +0900, Akihiko Odaki wrote:
> CCSIDR2_EL1 was added with FEAT_CCIDX.
>=20
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Reviewed-by: Mark Brown <broonie@kernel.org>

This matches DDI0487I.a.

--bs4hCqutwxbx+i3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgfMgACgkQJNaLcl1U
h9BkKAf+NPos2o6mLgjoG89mZgkmPOF4TShAObGH5JrXHGyhZnj53UB6vh9JI5tX
6uz/oVmHC1btr/6CqnoISLk/Rt7cd4gjgZ8DScJ9ZZV3tIzgbPxIvE4ONDMT9h9O
Diy71bwou0xCYa1fURWOyeIt3T6yn5AiZsnqvf0v9nDZlcTG2h7lJBnnxTB4z+L0
yGXYWtl968mWkyTDQ4sgYbaumdP6x/iDwNLAGEo7f/g0Pzpxd+ODSaykBrFBhTV5
2zHafaqPrR0Ty9eke3BLDlWYLcIPK5WfNq/+WoG2vxWuzhVy6yEEDZL/AGGyI1DL
Rrt+To8Eqxx7xA9zDDg48XIODFIzdg==
=iHBD
-----END PGP SIGNATURE-----

--bs4hCqutwxbx+i3f--

--===============1794768015849106740==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1794768015849106740==--
