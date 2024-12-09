Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2751B4239
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733755811; cv=none; b=Ix9gyWfnZ/ExhAWant5bP7NkqqdOtVxIUS/LjhOmSTfrQo477RwhtYjTDBD6cdzEA6aoCrf8xVI+kFcmwSKib2FjobC4GHstXKRJTwpeV0Y0dSbTX35nB3YyVJIspGOBtvUCTKvLncCpFmQHMNj3CU/vN66NeT/rtP63p2nl99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733755811; c=relaxed/simple;
	bh=QNICOKCDqQx8wLcl9YtGpAxA37hpdnJ/XSY727ONqJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWiRs92sOQAaLA+Wa0LUIERk8zXWvG/cCmatzxmTVXavtpNZ2b1E+9VD3TNy4uSi7edXm5qjb5zW+Um3b11fmBq1lasrlAEFt3i+5tdyPgxKRQl0e/NAUeROPwNSfCalaU9AivxSqLPzOqH4Q+kcheif/rwP50Swbvc/noiSqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4MoffX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4MoffX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C55C4CEDE;
	Mon,  9 Dec 2024 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733755810;
	bh=QNICOKCDqQx8wLcl9YtGpAxA37hpdnJ/XSY727ONqJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j4MoffX6wSrVo6cfkuKH+CMYY8YOjbfmeAhyNrfHawm0f8B3TeFhbvBgNvbSG7Tgk
	 ayxVG/rEKf9EqQ8TPvm2z7n5poFbiBj1abqJYaJsvI8V2YXy27FvSJgGOeDVcYNuEK
	 LCeETF7M7T6rqUJN7JwKff5pBEaUQbKBt0g7InetSDfMc+76x0FbdOkr3S3UWliAZ0
	 /o6k1jYXtbqXo2N6r3kDRYs+T6zrQHGhecsb7RCO3TM1jkCNfCsZ8AEjrC3pwUeA2r
	 5Wr7uAoPNX7sLDslaQxTqbF81NXVpOLSg1UArZSpWwaQRQx8FKJ94gGgD3HGszgkUc
	 EQEU7x4NRLslQ==
Date: Mon, 9 Dec 2024 14:50:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 4/4] arm64/sysreg: Get rid of CPACR_ELx SysregFields
Message-ID: <aa8a6c68-13d6-4311-8903-577cec91f8fa@sirena.org.uk>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="skbI6LnrmfTymsLf"
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-5-maz@kernel.org>
X-Cookie: Lensmen eat Jedi for breakfast.


--skbI6LnrmfTymsLf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2024 at 07:07:40PM +0000, Marc Zyngier wrote:
> There is no such thing as CPACR_ELx in the architecture.
> What we have is CPACR_EL1, for which CPTR_EL12 is an accessor.
>=20
> Rename CPACR_ELx_* to CPACR_EL1_*, and fix the bit of code using
> these names.

Reviewed-by: Mark Brown <broonie@kernel.org>

--skbI6LnrmfTymsLf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdXA50ACgkQJNaLcl1U
h9BRJAf/S0ycslVskgXpXkjdvI/5+VVEFQFc/0Bq4LuCxfAySEoj5lYXZBfkCbyU
fUepdbv4utG+qLWjLDeezQFKDMSLU1jCaOjly/wS5lDoyo3/Q2eUZ47d1YbaFxad
A8d8UEQCnmqDrUGhBf+PGERd4nhI25x9PIZNDDlQBHkQ7T5DN9cUZYvi54cLADxM
XWFgKnnYYSg6iQR69KkjYx5cult0bxD6Icx7PhqyZbNo/lD+S79mlTeajEtNk9CP
G1qYyebgGVHIRXOVajFW3w3/wWAigddiBAnhIWatFTwWhv2yHC8Ti3Y9QZ5EX6wm
N8mhwTBF+RWlkQrCZZTXZWvs+rFNRg==
=/h92
-----END PGP SIGNATURE-----

--skbI6LnrmfTymsLf--
