Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A68C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 18:38:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DF64B190;
	Tue,  8 Feb 2022 13:38:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id STdO35+wcZRc; Tue,  8 Feb 2022 13:38:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 003424B19F;
	Tue,  8 Feb 2022 13:38:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F1FB4B190
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:38:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q8c2F-CuAnic for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 13:38:22 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67D744B0CB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 13:38:22 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 111F5CE1BC8;
 Tue,  8 Feb 2022 18:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BA0C004E1;
 Tue,  8 Feb 2022 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644345495;
 bh=8wrf14wnnwhTD0V2fyJYfFIjDT1NePF3BbrQJCxM4Qk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Vy2jnHNouE74L++j3JKHDG6ILgdmE6Eso28ntVdJOGUJj6DN1LSuAPlCB/FNzyoZX
 wS6OWAE9QQ3BVB+Z1G+NxR3eHdQ0vap0xwds3nij7LtxqUMkozZ2Q+NlDqCURQwCut
 RvBUknGgUnd5VkuH/bZ3v94PsFCYRCXVa5LGcmNvbQOBrePCDTV6HSZXFtt8kGz5pO
 fhnXjaPWmkWv9iwnA0l8/8u1FJhVp3kFh6AHwQBCQWqKCbfyUhrm3+Xgatzy8u2gtX
 2N+eslw0n4cMiY5mKeMO2uimuB1C2tUdAE21KGc6PNuddnMVZjjnrkhzJRqR0Zkwo3
 Eoigg7sI9DB8Q==
Date: Tue, 8 Feb 2022 18:38:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgK4kKrSs6e9seG8@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk>
MIME-Version: 1.0
In-Reply-To: <YgKQTLwW+ha5XNx8@sirena.org.uk>
X-Cookie: This is your fortune.
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============3393005105330270686=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3393005105330270686==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9EzABKYwuXw7aJpF"
Content-Disposition: inline


--9EzABKYwuXw7aJpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 08, 2022 at 03:46:27PM +0000, Mark Brown wrote:
> On Mon, Feb 07, 2022 at 05:10:35PM -0700, Shuah Khan wrote:
>=20
> > > +++ b/Documentation/arm64/sme.rst
> > > @@ -0,0 +1,432 @@
> >=20
> > Missing SPDX here?

> Only a couple of rst files have SPDX documentation here, I guess the
> SPDX people aren't worrying about documentation?

I can't find any free format plain text files with SPDX in them, even
really prominent stuff like README.  The process documentation is silent
on what's supposed to be done here too, it says you should use the
comment style for whatever format you're writing in but that's not a
thing for free format text.  Dealing with this feels out of scope for
this series, probably something for whenever someone gets round to doing
a conversion to .rst or some other format.

--9EzABKYwuXw7aJpF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICuJAACgkQJNaLcl1U
h9BKKAf/eUkYZVVQvMCsseGHtizTn6cn3eKYSzI8N+tQsJd4H43DHGBxjOcxe1V0
HyzbzUP1LuhnEXcADTd7dn08m5Hfq2PXSpEhzBCAW7mPIr88/XqLgDmXWqj3Y74w
BGrZ7GqJslA/jasJv4OS342/zqvFLgBu1zigLQjPE8xkOOxn/SgCuNk46rx/Hvs9
0EoWC26i2h+XPDVRWkZNGrVm23OSoeTzcSiYjbswj/E28o7Wnjs5Lzfheu3iN41P
yJcy8KnTMiBr16UFuRdWN2/NYLr7AoHQY18S5WPhjj4DZfDNvjcIVT2Qtp0xPt3P
JiJi4yQwNUP/ormKMXAvW7dekiZRNQ==
=Lo6A
-----END PGP SIGNATURE-----

--9EzABKYwuXw7aJpF--

--===============3393005105330270686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3393005105330270686==--
