Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CBE3FBB72
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779988279; cv=none; b=kXSuN2GYf0MyUI8Byqrdw2OJxLpqi3VOqF4t8lGoT5zmYwy4AFOsEvFgs0vIWswRJH19ejZzD7+HXkXzvZczDAwF4VaGYqB1bztPXaNHz8HGp0omEVTWoxqlYauAbrgodwrllcFkRBRruGsmgbkkr/pdhjrSgnMnR0cu0Uef3Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779988279; c=relaxed/simple;
	bh=op5TUIxpKpfxVyq7A3UM11jCmaSh2miUdAwtva/16po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNLAnPS5VUO5YJfF9ZBQfRmY4yMdfhR6cIV1o5v+t8UYZwuoqYfz07eSg9OswF8VbZFQMEkprBX/zRxkLnczNQySp8YOH5Y2h5a4k0iWKRMLmTpuKs/+Lc/lM0c2qRja/hBq77iGrdiQ62OxBG3OrigSuW6HiguJCr9Wu7qK32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/FC5Nrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/FC5Nrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0871F00A3A;
	Thu, 28 May 2026 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779988277;
	bh=ne5NblxnXMQF8yPQxOSuFHig/XO1ZCxwk3uYECriioU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b/FC5NrdWC9MLl/ASS2+MzfpKvX1AqwxI3c5dpfglMleMzAv/TXM1dAj75EWMdR5R
	 Qvp+Um/0Jew3XNaVRU1dUHtm8ZuRqNXN0BY7McgL3Ib83/HoOwR8Ti9QFJ6gy0r4Ki
	 iI9gGaOOPISdMTgXipgfWWuzrqxhpkA1slv7uWiR37kVgq8xc1pTacgm7Lw/oScKmE
	 2HLxgt3MHOxYALOk87hn6wSGExp18CSf4J2A38/sZP8Au46Nkw3saE/0puK/1z6ArA
	 HwCqp01dDW2gJw/oVe8Aq2RzCxu2RMnbLOULCfIYyzEO8elkUA5xxi8deVYguGRM58
	 uoYqGFNQ+OLGg==
Date: Thu, 28 May 2026 18:11:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, vladimir.murzin@arm.com,
	will@kernel.org
Subject: Re: [PATCH v2 10/18] arm64: sysreg: Add FPCR and FPSR
Message-ID: <aada8195-de39-485a-94bc-648afbfb4931@sirena.org.uk>
References: <20260528165446.701944-1-mark.rutland@arm.com>
 <20260528165446.701944-11-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yRfI9XPzratqbfwV"
Content-Disposition: inline
In-Reply-To: <20260528165446.701944-11-mark.rutland@arm.com>
X-Cookie: Someone is speaking well of you.


--yRfI9XPzratqbfwV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 05:54:38PM +0100, Mark Rutland wrote:
> Add sysreg definitions for FPCR and FPSR.
>=20
> Some versions of LLVM will refuse to assemble accesses to FPCR and FPSR
> unless the "fp" arch extension is enabled, which we don't currently do
> for read_sysreg() and write_sysreg(). In general, handling feature
> dependencies would complicate read_sysreg() and write_sysreg(), and it's
> simpler to use read_sysreg_s() and write_sysreg_s() instead, requiring
> sysreg definitions.

> The values used can be found in ARM ARM issue M.b:

>   https://developer.arm.com/documentation/ddi0487/mb/

> ... in sections:

> * C5.2.8 ("FPCR, Floating-point Control Register")
> * C5.2.10 ("FPSR, Floating-point Status Register")

Reviewed-by: Mark Brown <broonie@kernel.org>

Cross checked against DDI0601 2026-03.

--yRfI9XPzratqbfwV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoYdzAACgkQJNaLcl1U
h9COEQf/eRwk0q4UjwVJrb1mp6Y3QxTFbvULmcWoihp8EiU7fDNRCgGYHyUEVnYg
lrBErvxKaWGQwTAYuG/BDno22J3KN3dI4UKxa/j6A1zfWNl22oFzI9vwFQN4h6J6
472Bh8hanustZc2osrYnFRW15IGKWjoWbjfmPp5vnm688hI4XHxssT0sSC7W1SIw
TaL0CQziQ9xMyYH2CoGIbMfVvY15srg8qaLLxGi87Qc3sztbZnV44/FCn2P+cjTe
w9rVY09/7nJumbTWAVzgfTzSeeOmwrn7LFYya3GZ0TpWvfoxZ3zQCD8gwLHJyM8p
lnEQdiTJknn3wKzoSLU9iG7kKUW/cQ==
=Pbbn
-----END PGP SIGNATURE-----

--yRfI9XPzratqbfwV--
