Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA7931F993
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779891189; cv=none; b=CYmlWuiYfyl8NdpHh1smaflRoOMOGLQHVZ6mcRv1W5JQzguqqXdKoY2HJKU8ivHYcJpNlbU1wMr51ixP092C0KDbhN3t99caRizH7DzHFvMo5eG8M83Iw56rtuLVNtDSpFz+JVJsWENNoflsyszW2yiX9at+toItCBs1+X822Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779891189; c=relaxed/simple;
	bh=8P58/1fx7l2cbwGSthKwlZlBDS+GHviw5jPTYaNJKAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOZWcCJPTo+1PO24RtfR0CxfqdesW+wvyq0kxyVnTZfgtliLBJ1sg3es9TxIkUee2Psvh2PLqG7nZz7hYMtee4aHDbquuNvGb/PWdF1bJ/y8tzgp4s3Q55j/Jk8OzzMFSI48c3mI0hZbT2sEHcbscs49SIdfzw2wrhKoNXkjrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aY21OfGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aY21OfGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B91F00A3D;
	Wed, 27 May 2026 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779891188;
	bh=cJPJU4tbAYEX1ukh2P+hlLCnXB/TI8A9zswFtwRlV/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aY21OfGrasXmEYj9vQYyvhDko6du7jdhVAjAr8Qo420sBhRgRDmU+HusuvFqczNMq
	 xPGCr/TrC5G9KgZPdj9xgDtThoWBg6RFMJDERsJLgf+kO7ehYxtGtsJxM2ZWzMiVeq
	 ebistdsym/hPqAerfJoZssQXZHSNOzvoqvTShYYNWz//p/4hjeQCb4N9RFAwKW5Fe1
	 ZmFXUa9r78Y5g9vMy8T5bESjhm9uQlqow9jdJiLj+AEXylSF++SSD2QPjQI2Z52vA4
	 yf1hhnNS/NkUYsCbnJrhchbEXBCSUTBATxfac+RHbhvEJ0dWtjaEcL0z/Wl8avz5xl
	 lBu1CtRHhmBRw==
Date: Wed, 27 May 2026 15:13:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 11/18] arm64: fpsimd: Split FPSR/FPCR from SVE
 save/restore
Message-ID: <4bcf4ec4-6c82-4dc2-b96a-a3a76340ecfe@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-12-mark.rutland@arm.com>
 <0b72df66-2914-4537-811e-2080e0a7ce6c@sirena.org.uk>
 <ahb20fXkdWI7SljE@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8ouGmEJHyeUZhv0D"
Content-Disposition: inline
In-Reply-To: <ahb20fXkdWI7SljE@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: You are fairminded, just and loving.


--8ouGmEJHyeUZhv0D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 27, 2026 at 02:51:13PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 05:28:21PM +0100, Mark Brown wrote:
> > On Thu, May 21, 2026 at 02:25:49PM +0100, Mark Rutland wrote:

> > > ... so I've assumed that this doesn't actually matter in practice, and
> > > implemented the C version matching the existing SVE assembly.

> > There is a possibility that it only matters for older, FPSIMD only CPUs
> > or just that nobody got round to benchmarking this on physical CPUs with
> > SVE and in fact a similar optimisation is also useful there.

> All of that might be true, but that doesn't change my assessment that
> this doesn't seem to matter in practice, and given that the overall goal
> of this series is to *simplify* things, I'd much rather err towards that
> than hypothetical performance concerns.

This could do with more clarification in the commit log, right now it
just points to us not having done this for SVE but that's running on a
rather shiner set of CPUs (and likely written without any physical
implementation available) so that's a rather large jump.

> > I'm a bit wary of dropping the optimisation without any verification
> > of the performance impact, but equally I'm not aware of a specific
> > benchmark that showed the impact or even if there was one in the first
> > place.  The changelog sounds like the optimisation might've been
> > written based on inspection alone, I don't know if anyone will
> > remember more than a decade later.

> From what I remember, the changes in commit 5959e25729a5 were made based
> on intuition, inspired by a contemporary retrospective change to the
> architecture that made FPCR self-synchronizing. Previously the
> architecture required a context synchronization event for the write to
> take effect, but implementations happened to be stronger.

> The conditional write isn't necessarily a win, because the cost of
> recovering from a branch mispredict can be much larger than the cost of
> micro-architectural mechanisms to ensure that FPCR is
> self-synchronizing.

That seems likely from my read of the commit log there, it smells like
something done from inspection rather than because there's an observed
performance change.  It'd be good to put something like the above in the
commit log since it's a much more relevant analysis than the comparison
with the SVE path.

--8ouGmEJHyeUZhv0D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoW++8ACgkQJNaLcl1U
h9DgHwf/URmveagI56O1UH0OmT2rDV24+jtw1D49QQ/kZxghFUzyrJw9gM8j0zfo
zj/LlzpJF8Xnuuyp7bh0BC3IieJn7L5etrlhVVsJfI52cYVF0YbU26EfUFEGmJzt
kVogO+l3ZUPJrxr9KnY3PpGwmLl7+4ldzOZMTuuyqFicp39hw+57L/rrJl850XwE
2C9lIafie6XpxoxwCFtDSrOIu7CVW6y8mWo4fPYMv77O1l5e+t5+PmBWBOzrPxnm
95WnMKl5XrYXxdu5bBiv2dnJibYoumtOpnKVBRldTbVa3aAEAaf4Pugd+v6949F1
ZGmuTVn7m0mnDdH87bdm9T6PdiBgLA==
=2zVn
-----END PGP SIGNATURE-----

--8ouGmEJHyeUZhv0D--
