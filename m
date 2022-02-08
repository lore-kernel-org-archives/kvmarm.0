Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519A3C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 15:46:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7CD94B1BF;
	Tue,  8 Feb 2022 10:46:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bb3+gHIOPJ4J; Tue,  8 Feb 2022 10:46:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20A284B0FB;
	Tue,  8 Feb 2022 10:46:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C25804B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:46:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BpD4mke33Se for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 10:46:30 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6FCC4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 10:46:30 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9908CB81BB6;
 Tue,  8 Feb 2022 15:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A88EC004E1;
 Tue,  8 Feb 2022 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644335187;
 bh=DRWJIJPMlskULku9yaK+tODGkj7DW8yQ/eJCnmvS9as=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=aGksKg4R10A5v7fwn05lVZu5Nx4atr7PUzK7fmO5XUalzYLwvx8BINcE82IWBQyma
 SlU+bC7fL5VaEwYi/PZxGvcuGCzuxZG6kAloNLVT+ChWVjARlTx9MCPVJp5wLbJdtF
 Xd0sp+/MBApRSNjeu9BBjROt0tCZ8cAN2M1P7gC2p2KkTLTZbBKOUUMmRH7OpzPm76
 TRnbNJJZTvynE3O13njW26RkfUibF39HEdNDQeoy2dIdIR110Tx7nS3HQ4df5hU752
 Pe6jAqrUdae9Axm1QW2+6d7/0rOKJc0j4DuK9f88dqG2+F2jTa3NLFsQdpzpWezHP9
 UVYHg0rLOz7Wg==
Date: Tue, 8 Feb 2022 15:46:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgKQTLwW+ha5XNx8@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============7337949320904711433=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7337949320904711433==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a0nOFmUi8k/21Hgr"
Content-Disposition: inline


--a0nOFmUi8k/21Hgr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 07, 2022 at 05:10:35PM -0700, Shuah Khan wrote:

> > +++ b/Documentation/arm64/sme.rst
> > @@ -0,0 +1,432 @@
>=20
> Missing SPDX here?

Only a couple of rst files have SPDX documentation here, I guess the
SPDX people aren't worrying about documentation?

--a0nOFmUi8k/21Hgr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICkEwACgkQJNaLcl1U
h9AJxQf/biL9lh017hFUh2yzO+cXO2WAlCO8hMp+diLpKGjXJsHjbB+/BeJu9X1I
CpAQL2bMPweDbErwHK4EgdIzguG983JnF83hfxwPfYlP9wIeTlYqOG5vQGYscXhI
wQmoy5NCgCly1vL6+1uSoMj5P4Iot8SnmQOG1ZraCT7l2NRmcF/UQf0Lu/tZgK4S
SIalo2MpLDxODhkaXYkaRorbu97DOV4DVroDon8kEqH5VEVykzK65nXDytvQWwNr
Q/c93T32M5r+SP4aX16vrLu1dmDJolARtDIFNRnAmQLxuIZsIx0VqH0VKTxALMlK
1RWedBYAFc5LnyG7I4DMTdtEHIfQZA==
=yh62
-----END PGP SIGNATURE-----

--a0nOFmUi8k/21Hgr--

--===============7337949320904711433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7337949320904711433==--
