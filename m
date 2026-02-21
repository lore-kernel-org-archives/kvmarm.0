Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783C83A14
	for <kvmarm@lists.linux.dev>; Sat, 21 Feb 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771681374; cv=none; b=ULfBPA2eotc+dFuV2OgrHznMmaJhn7pWbkOz08Ynqde7FAleMzAyIvREvjQGhYzTStXEX0HihMXoL3MCgqZKVV6xJlzeYif8SevZuJvwamDUe1MkvlYVV4xyzo6y5HB4D4V6mWjpK2w1Zp9NbRld0vHsEgCo8KgACKz1JoVJbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771681374; c=relaxed/simple;
	bh=v6GR3oqYzvfOr2YecJKXRoYn33wFLOk55C03VlCt/gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0B6NHCN6sULO5Lsm/1abRv7kG8Fk3Ahl7BLaCYGYnMVhX1/5Kfs33K5NDE1HgYrCHMvCmZstDueGOmeblHWXJjZCOOL5VlXcXo7d5NIOjFkMCySL1WQjdTIJHjaMZbLvlPfQZ/qJi3CCJ1zFAWMqUe8eODKzw81CrDOuQlEPjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha3UyzOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha3UyzOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A69C4CEF7;
	Sat, 21 Feb 2026 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771681374;
	bh=v6GR3oqYzvfOr2YecJKXRoYn33wFLOk55C03VlCt/gM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ha3UyzOW5Yxid/1siPoBgGy2my03xA0rTjZ2rmRhwTFKFG0AYvLhSEBbwQuTep2ba
	 E7GZyamfO9Oy5f6DzY4PpFy1fIRZVADMEDPBbypSX2YHxpKOP5Ph7/28mhV73aTWCn
	 Dspufk4nRKdR/Te1Fl47QYR2OJgTiAdRYlozDyrmHhxpEr0oPyaEzE7UoxuoCcRHNL
	 GOoTz/5jsK80AAuEU6lfq2ljAypiv2na7TWaZRIFVA5Q7d4oA77TvSR5C/88KkLwEF
	 m6BrCqVjix5ve7jPOpvqI/tbtDIi4yJO0f1JxH0XWt/XLDjv78pq1V7uZhVqDUlL7P
	 FvdggvH8JtTzQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 105BC1AC5849; Sat, 21 Feb 2026 13:42:52 +0000 (GMT)
Date: Sat, 21 Feb 2026 13:42:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: pKVM breakage in mainline on n1sdp
Message-ID: <aZm2XCZLYxgxL99d@sirena.co.uk>
References: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk>
 <87bjhie67o.wl-maz@kernel.org>
 <87a4x2e60i.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hQsWoqqfBdjsjULQ"
Content-Disposition: inline
In-Reply-To: <87a4x2e60i.wl-maz@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--hQsWoqqfBdjsjULQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 21, 2026 at 10:38:05AM +0000, Marc Zyngier wrote:

> If that's vanilla 6.19, then there is post Feb 8th. Sorry for the
> unwarranted rant.

It won't be vanilla v6.19, that specific log will be tip of Linus' tree
=66rom yesterday morning UK time which should be 8bf22c33e7a1 ("Merge tag
'net-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net"),
there were a few results for commits over the day prior to that showing
the same behaviour.

> Can you share the configuration for this kernel?

It should be an arm64 defconfig (I'm having trouble connecting to the
relevant systems right now to double check).

--hQsWoqqfBdjsjULQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmZtlgACgkQJNaLcl1U
h9Chpwf+MGnnovVbLurNrKvyiMsVEn2Q2nWU7AGFk4i1H2xVJFxXRQbaIPACI2YR
+b6PG8V+N4gYKg6n4TXW6mv6IaoGzMlEiZfRc9M2TCf8/6GRfejivPaV6avZZ/PS
BxqFG2kVl55MBI112eCfiDEPYJbAyioLDWvOjvUXi81J+3HgAOTcPd9PxzIwj5Ye
IF3RV73EMQwfw8cpGViOSzEYmFIoNM+UPqXfxClgLDuw3fqSBIV1KLUSRuGw4Fvk
WmVm0bz9reUt91btv3NGtngrg2I+eMqej5ecL3b2fUu8BwAgX6cUn+6EUzIRHM5d
mjm1cr1GOMtYiaKny+rSJdWSo0993A==
=s/0e
-----END PGP SIGNATURE-----

--hQsWoqqfBdjsjULQ--
