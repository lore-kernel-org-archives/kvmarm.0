Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84831F9A4
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 12:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886488; cv=none; b=XwT1grq7kWIGKK3Sm36GJZUy8P1E9UB5Yko83IEfr7cPlGG/RiOGds77p4fItuYX1f48cGbuzGMo09D6dgMTLZMKelw3F+4Io+uXSk5gMO7vKwHbIJfVd3TBHzI8mLa4i6TTqkkIF8ehhIiWF4yMKiBBUCO/VDjXE0tcAVj4Im8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886488; c=relaxed/simple;
	bh=qOnAiGZWNRKnxsZPXVHyIgdDDKWj8GiapQ+ICGIW6jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMO7RTGE1vmKQKg8BjuCWq7yrWXbmFYxTIrQ9rC5EC7NDyueYfE/iNZx25Sycm1+qkBopTvbyjqMpiRmtMZgmdl+k1u323Oj2FvQJdvbCqdwKcw/S9ve9K1y+vssFaSwL0QYK5Sf9di29nZBGopkoyCxygJrapplHadTTESQ5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFJV5b+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFJV5b+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14A81F000E9;
	Wed, 27 May 2026 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779886486;
	bh=YuKRZliHAqjx6BUMVNCWGaJCofdb60yHGpb2RM+7j7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fFJV5b+TWrN3RNrwSxDnyQY7OaE4GfOtu1Ds9oCqBzzwHSjJJI9BS0rSNJjGL9+Qu
	 Us7Q4ZBMO6WijdXPhWzIPOqK+Fh5T+S16kP1tSUf8W1uPIjgKOW0iujsDc5pqv044t
	 jSiIqaGxdVioVQ42tuOBxM0sAgAqetFQZEhJj/Mh8D4hABUHhEvQ78qekdYv0J/7mq
	 CO/+frZTI3aUulhQv4tvE/sHRfQvxnxi0QIc8jAVzdVgjlJ/u8msDb0lhWVO1s75nr
	 cz6VLy455LOhQVJ8kk4fs9PJ+X/6ABDK6YoD4YMZSwMcid1bSdgsY3aldXP2/LC0mE
	 sd/Y3WnAq+mBg==
Date: Wed, 27 May 2026 13:54:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 16/18] arm64: fpsimd: Move sve_flush_live() inline
Message-ID: <0f34443d-222e-42d3-b6c2-d15bb656e1d2@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-17-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4+ysNe/tZm5mxePQ"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-17-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--4+ysNe/tZm5mxePQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:54PM +0100, Mark Rutland wrote:
> Currently sve_flush_live() is written in out-of-line assembly. It would
> be nice if we could move it inline such that control flow can be written
> more clearly in C, and to permit the removal of otherwise unused
> assembly macros.

> +static inline void sve_flush_live(void)
> +{
> +	unsigned long vl = sve_get_vl();
> +
> +	if (vl > sizeof(__uint128_t)) {

It feels odd to use sizeof(__unit128_t) here rather than u128.  Whatever
colour the bikeshed is:

Reviewed-by: Mark Brown <broonie@kernel.org>

--4+ysNe/tZm5mxePQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoW6ZEACgkQJNaLcl1U
h9B/tAf/Sz+I/JD1zptA+eebS3b+2KUNdmhU9v1tYQv1ybjUgTZDI1e28ZOlBN5i
m2uZ+JWuQf5tjj65PsrZilL31VwJZ8otZHMsW1SuaJM/9Ldmf4gBaWIXbWvBmma5
Stb+tqx1f9A14uFnFE4l7DzGo45lncF3vmNmY/P18834G2jyxSikQWZ8S4L8Y2YY
W3se6X++e6LuLiQVvqN/3rZ7kM2ULC7R/D7kESnTBdVDsDtTV/KRm+CazdmkA7tB
Fe9cjRYZJP4PFJxf5zmk4VgZTl+o/Egx7R2Sh2DeQgkKpybSimlXuRTMAIk79M+Q
JE9Ar7145yRHZXXikh6svKALtk5Wxw==
=vuzK
-----END PGP SIGNATURE-----

--4+ysNe/tZm5mxePQ--
