Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FA33FDC04
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814587; cv=none; b=ePHNGHoMoyOkCtW3Vjzw55qUOUAUGn2hdzV4Lvd8bhsyaRAT+0KRmMOEXtC4oRay8NifVF8Q1Vob0gmOgLRxafe+f0odFmt4Wa1ptO36VH1gi21g3HnygpN59p9H4OzTh+pfohC//0ars/UJIBYsAKzUGlgf99KCOD70W91AvKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814587; c=relaxed/simple;
	bh=aE+R/u09j8qM6TPFTCpY//gr4sjjgMS3TYVXl/OxTJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edkFWKzwR0p0mB46vLetkUnriGQLBJcDl1HJjavel7DkwYtPPZWEl9WpwuvScs6MPZXdIJr84KOJZZ3WBoUqwEd+xFK+d9/I6jBB0NgUgNNWb3YGAk79U+wYOozbzPQPcG8Qj3nafzqn4ju6EZHJOcWeObu4LOqlQ2ydYodORlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRCwgva0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRCwgva0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815B91F00A3C;
	Tue, 26 May 2026 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779814586;
	bh=aE+R/u09j8qM6TPFTCpY//gr4sjjgMS3TYVXl/OxTJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kRCwgva0cKHWRcWeDrk3mAlIH8Wcj/VmkNwQHUqODoirO01qihrywcJl1QmThtuW3
	 agMpjHifJfRBYr0MeDE6bVrrXzZApgD9GLcaZ7Lgu0K5GOtbwnJA7EnuiF7KL3LswE
	 KyVRGzagtdp55YXgeVhAwIEuBMgtZh7yKGxnJ61e5Ll1o2UcTggRAI+ig9g0yolYvX
	 giPv44vfde7r7yshYJuW7th2tCgIu/bC+FUsj2umteS67UJAbulXe6c9m4WDuf5Nol
	 suzAaTBG1h1Vhsbv+U6v4rs2H15HO42G8LZYEh6cw+iGbahEOy6qfKwpiXy47Jl6zJ
	 WFP1DB06c7DCg==
Date: Tue, 26 May 2026 17:56:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 14/18] arm64: fpsimd: Use opaque type for SME state
Message-ID: <5374217b-c66f-413c-94a3-a17daf64297d@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-15-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k7dlkVAhEl2qN3Op"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-15-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--k7dlkVAhEl2qN3Op
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 02:25:52PM +0100, Mark Rutland wrote:
> As the SME state size can vary at runtime, we don't have a concrete type
> for the in-memory SME state, and pass this around using a pointer to
> void.
>=20
> Using pointer to void means that it's very easy to introduce errors that
> cannot be caught by the compiler (e.g. as 'void **' can be assigned to
> 'void *').
>=20
> Improve this by adding an opaque 'struct sve_state', and consistently
> passing a pointer to this.

Reviewed-by: Mark Brown <broonie@kernel.org>

--k7dlkVAhEl2qN3Op
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoV0LUACgkQJNaLcl1U
h9DQDAf+JGb0gcT8On/y7MnY+7JzDNUH1pP7oAg36SBjfXyTtn67iSOgfyO+BBJV
8bpvKMwIgCrCsfpi+Xphp2Bu7WpJtqgheZG4bm3DrpMuvyf4aaSDb/sTLtsAka/l
CALNrdL7aHk0BSCY7GC6mpw3sMJUZqidhY153exnOytVdqVK4C5mOCvIDN+E6xqa
ITVY8g/Za8gDYAyyyWdLnUAFXBMBfJ6BB1orBdcx/gC+liPEwcj+HG1K36alIuvm
PgZ/DTpNu0/UyS+fT18zKOgd2WFUkmzxRDWC/Ie6oA0O58pF9KnNlLO/WUTOwhA8
O6b1LKf+Uht1imtKIGUJbWjQBesH9g==
=cZ12
-----END PGP SIGNATURE-----

--k7dlkVAhEl2qN3Op--
