Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD01C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 14:31:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C7A4D74D;
	Wed, 20 Jul 2022 10:31:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GRyHwU1Z3VI8; Wed, 20 Jul 2022 10:31:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 952E84D76D;
	Wed, 20 Jul 2022 10:31:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFCD4D762
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 10:31:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OfH4pxR0aKX4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 10:31:42 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 210404D74D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 10:31:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF3561AA9;
 Wed, 20 Jul 2022 14:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D7C3411E;
 Wed, 20 Jul 2022 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658327500;
 bh=nrYVzirEpVfGxb+nF66Y81Y0MU6byNLifPJ3se8xu3A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=D/CmSw13tcsB2Yb7V2VwFvFTCI1S9EBqmI0sWmZmzNBFChyZIZZkFseOz2pOiANNi
 MO8Fy3H2dExQTffEQa5FuCxD9BTQ8IRVpblYireLd6Ou9WW3yJzcSmfiETbjbcsbvb
 jN3hclkrTnzGLEjY0USHgpMBgaX3CN2eyO2fIft9tXqqP6Q5kI/IYGZujTS4ClLXTG
 /cvCsBmCwBWtNpLu3TANh31pCwO4TwK4MBIsogsdMBMtiQ5+sVvvst4ebFpCZ7xgrS
 MmV6GIOL5yvT/wtf7fW2dPWoQjEB+EZapF2JQcYj4nofgeaUb2h3bkzf5IBMGWQ6VB
 fbnu1V4pSv9kw==
Date: Wed, 20 Jul 2022 15:31:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state
 on syscall by default
Message-ID: <YtgRxh1L7VrHvjDl@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-8-broonie@kernel.org>
 <YtbraaDE0eJhRHkx@arm.com> <YtcHkkwiDZTEpWrZ@sirena.org.uk>
 <878rooyvvv.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <878rooyvvv.wl-maz@kernel.org>
X-Cookie: I exist, therefore I am paid.
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Andre Przywara <andre.przywara@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============7883935952070189724=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7883935952070189724==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ikjDWuqMc9YAfWJe"
Content-Disposition: inline


--ikjDWuqMc9YAfWJe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 20, 2022 at 10:29:56AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > it.  Marc Zyngier has previously noted publicly the current behaviour
> > being a consideration in the context of discusion of optimisation ideas
> > like this one, I was a bit surprised that he commented on an earlier
> > patch in the series but not this one.

> Just because I don't repeat myself doesn't mean I changed my mind. I
> still don't buy the ABI change, as there is already a large(-ish) body
> of SW that assumes the current semantics.

Your previous comments (or at least the ones that I saw) weren't *quite*
that definitive.

I'm unconvinced about us actually having a large body of software at
this point, it's only potentially things that directly do syscalls in
the middle of SVE using functions and never get run with qemu user mode
- that could definitely be a thing, but let's not overstate it.

--ikjDWuqMc9YAfWJe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLYEcUACgkQJNaLcl1U
h9D4Zwf+JpSiqbu9mtBaaQntIU18N3sjzZFXRyX0evSnef5lEF2bn2JzNXhgtruo
T2vMP3QYW36U9M2DQz//w/svEByebOHL1b8tGDu4I8jIcqqAkDZWZi44HDsYpZJT
HU8LPhymK9Y0w9wGNqn8iM2OuTMH8KxUaz4aT2cmKyb3z6MXv1nKTATIaTDLzrJT
0HkaBBnW4Fv6SHEU3g20bBOSsJoMzNZFtz2d3tYHgd/I5KoIiGdj1fTiBA9Htjpq
NZMOejz9ntCZs08KkN873gjisgAoSJXX+6jJmAw6UlimMnOW8OIQjcQCl8fOkw4d
e6+IXXzz3U8u9uzCd+kFZQ4i3R/A4A==
=a9MH
-----END PGP SIGNATURE-----

--ikjDWuqMc9YAfWJe--

--===============7883935952070189724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7883935952070189724==--
