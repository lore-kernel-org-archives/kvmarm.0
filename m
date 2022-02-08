Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698ADC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 16:19:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A354B133;
	Tue,  8 Feb 2022 11:19:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aJU4mrjcnHzd; Tue,  8 Feb 2022 11:19:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 432624B0FC;
	Tue,  8 Feb 2022 11:19:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D474A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:19:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O7DIIElYxKrv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 11:19:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E94B849F05
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:19:23 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CC50B61697;
 Tue,  8 Feb 2022 16:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE69C004E1;
 Tue,  8 Feb 2022 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644337162;
 bh=gzpbduvOrB92O7Klqq3r2KXyOxfguLFKQkuqKq2JWss=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HzhR6dZ+yd3whIuSFwnzBfQ5EaZbtdE1L3QtLZT4NnOUvHGJD19QBZxYK7JPS0Nlz
 lBGxQwPWaIKsA9dNoVJk+RhSdPYeKpGVc+NyzFkdYHJshMpllha57SSWlVHi2EMjLj
 36fkRVa2BuGf2H2LPrqLPm7Mfjek5+rLnjJSojw/tLgOkEqA54MEAotkVVT0aJCaP5
 J1+ilPbMROUzvVmk9JP69bl6rncQzPtUjqiIvGQxjVuw7CIPTbudASP9feKlHGFO28
 oGnE5buAUK9zzQqU7C0/tVwvGkzcYQYGDGONoUvy6FlLJwMMl3M6iTSE0cB9jUglK+
 776riKp9NqQ6w==
Date: Tue, 8 Feb 2022 16:19:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 32/40] kselftest/arm64: Add tests for TPIDR2
Message-ID: <YgKYA0H6C8U59UmI@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-33-broonie@kernel.org>
 <14e08c27-289d-8c39-15ef-220e0a7949f0@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <14e08c27-289d-8c39-15ef-220e0a7949f0@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============2606650762194635358=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2606650762194635358==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="caKUZSkjaiZxfANo"
Content-Disposition: inline


--caKUZSkjaiZxfANo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 07, 2022 at 05:23:15PM -0700, Shuah Khan wrote:
> On 2/7/22 8:21 AM, Mark Brown wrote:

> > +		set_tpidr2(getpid());
> > +		if (get_tpidr2() == getpid()) {
> > +			exit(1);
> > +		} else {
> > +			putstr("# Failed to set TPIDR2 in child\n");
> > +			exit(0);

> Is this test expected to fail? Is that why it exits with 0 status?

This is so that we can use the exit code as a boolean value in the
parent without having to invert it.  Given that this is just a fork() of
the program itself it didn't seem useful to invert the value purely to
pass it back to the parent, it seemed better to consistently use natural
true/false rather than 0 on success rather than mixing the two.

--caKUZSkjaiZxfANo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICmAMACgkQJNaLcl1U
h9DeCwf+M/YFs1syQhLXKoRRvMUlgHvbSyoJSU3IxNUIOcl12UfUn8ZnTOuP8FsQ
/7kKlUxz8oDnuqiRJ86gOXrPf9EG13fBlzQn2UxN6X45m6tJ6fU3xrWHi6D5Thkc
LZ9Q4pKDUA70X8vufRj5E1VW23M/nGDOW9xIXvAi02JT+/DnYTYURkCCCSGbWUEQ
H8GMD6/oKdaBYMCziYq2BimpzQ1UMRdi0dR4MFr3bVfREBJuTy/TGWpkLyGz6LsV
noHGtzoRd04yFDWQVpRueYQ8S6jp9JugXpmZNWPtIrt9OmdSL6IV69sOEfeS2DLP
j9mn9PTZszWXRHrplxa7fjJVKVPGlw==
=1Dto
-----END PGP SIGNATURE-----

--caKUZSkjaiZxfANo--

--===============2606650762194635358==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2606650762194635358==--
