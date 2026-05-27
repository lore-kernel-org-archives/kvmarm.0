Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE9625B30D
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779884966; cv=none; b=avzKcNnV2ittdsbRSm5WnPibl+yOgNzXBPU8uD02jdntMDU6V7RTLVYQ60/1vPug5g1UFUks3miISF4ui1iYZEUtfqQ3sR/9Sow/a86ce95xAsAstHVbhcQ7FO1Gh9QfIR6dQEm8TxlYLgwCt/Vu/bzZyY3lJdw48z1Vwigeofc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779884966; c=relaxed/simple;
	bh=P6Giflfvchb6NZjulgUz4DhbUjIv9lOhcRLxlAXMESs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0HUgKvDquy1pLXNWae2AybJksf30KP+jfADQ6Wf6sw+OPWSEIDDTSEOafbvqWlWxuJMpkWYpNt7dylQqiJlLGDuzHG6O30NRRADHtGHIqLnaGNTGga+A3XPQ0Atb2ghIkC4lJYA0K4o9jO7U2xlent5NmOfnKZPhKJqgJ9e9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otkztzJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otkztzJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EBE1F000E9;
	Wed, 27 May 2026 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779884965;
	bh=P6Giflfvchb6NZjulgUz4DhbUjIv9lOhcRLxlAXMESs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=otkztzJEHgXu9dGNuOG43MBJN2ozTwV96u/a9ImZ+tzsmlLNahdOG5xIzU0Blr+ua
	 RS6n1DMooVRU67ILnIelJdUdWXy6VYKMZVF/FA1bRACsoHPR7+sx+4OXY77+d/7RPU
	 fenMFusxgicdrHfg4YfQ37PptQbL91ptZGyvvfPR35wKM4tNB8C6reAejmI8uWB0jI
	 Vs1pRhIAUEj/+3gpd/ewyi8yPyGAz+zhvDsGEj3PbkbsSSnRJ6zcN2rsCcAb3RQO9v
	 NepcK4n34ty4f4day/BL0I4FVub2Ep+ClZMArb+cfY3YB8/mEqMqXQvwmj/dtelbBf
	 JeOZuvM/S2cYg==
Date: Wed, 27 May 2026 13:29:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 15/18] arm64: fpsimd: Move SVE save/restore inline
Message-ID: <bf4fda69-c387-496a-aa7b-60ddb48e74aa@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-16-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ya5TE6wnOBYzJmoP"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-16-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--ya5TE6wnOBYzJmoP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:53PM +0100, Mark Rutland wrote:

> To handle the above, move the SVE register save/restore sequences
> to inline assembly.

That's a lot nicer than the macros:

Reviewed-by: Mark Brown <broonie@kernel.org>

--ya5TE6wnOBYzJmoP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoW46AACgkQJNaLcl1U
h9DSlAf+Pd+HyrNo7yd3QuYwJqQIVpP1gqWq92C8uv2n+lYBNthOz8jPZ5Kzqr8T
k3p51EhEuC942QtVHS6ZCgsyL5MI0x26lLRgzRQbh2zljubYTVvBLovXbiUnRyTy
JDBoIu/Ra/DmxqSDsPYouV5UFduCEiOopr7BI5A4vlSHbIYkED85eWU/jSmJHBTL
8mhyMwAFT79rTMkdgxr68snAQh0LICAlufv66tFTyd5x0Marl4G0WHEOetb8+QqX
8JM1xVIvFSUs6x5PIhVKivQ16Qq+hxtgnLv9KYEXWKVaXNR7NWUVGFDlbscKUkSn
svCUnf89m3L9pIY6acmXYDk3yzfmvw==
=lDv6
-----END PGP SIGNATURE-----

--ya5TE6wnOBYzJmoP--
