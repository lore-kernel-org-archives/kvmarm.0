Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C637E302
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805111; cv=none; b=NlKmiP99cl+r2QBvGcfVhRhWed4d4EC4PdBjoE6MpiyyQiYtStSbM+SobUzIbZa3Fm6EqOkLXM7V4MZbtxCdvC1qzbpAeb1hYLyrSG6uQUt3MtIWYUiwLf2WHbwMcwIBYtGRUTypFxEjV4QiE3DA+pXMitQ414z+r7bTDcSde8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805111; c=relaxed/simple;
	bh=/H/hJa1FEjQPpe/KYbX90f7yxfTWFQPS0ifgrelJ5fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boS6aTo4v7XlsCPhjMl6qvKdvxwfq142GsHrK2RGUFEwHkhmS92xTJPHjI00qPdaIsZsHhGP6K9hqIocXSevj+7gk4PFswrLMf/OpV3AnkAC3jU5l/SzIahHCLsYY3Oeqq3joNGfpL/BxYqFApQabv6w3eTwoDfvkh9GF1ryeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+J2Nksk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+J2Nksk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79E31F000E9;
	Tue, 26 May 2026 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779805110;
	bh=/H/hJa1FEjQPpe/KYbX90f7yxfTWFQPS0ifgrelJ5fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q+J2Nkskz8fJbNcXHe8+HfSCiBX5wlDKZ3VHBcGJch0eEWdqVZQKbSomDNCFR1/L9
	 6+vc/55b6RRtqqLtzfBX2vwtbL90jyptSiUOFpAiTdpLjM09adfNbwNC9HKp2ZsJpZ
	 vKUUeTKTbLa4e/Vaz5aQhBcaDYzsH8/+z72mH9mofBkhVpNhihMNJl/5o3UGIl/y5V
	 rUWD9O0Z4BXvXFypcxg6dESELUWGtizrBqaZ91G7e20VfPdXyeFRQfSk3JZ2awsOZQ
	 BJ/5T29v8bzjPzu/XVcHf2ZLcIAYwDr8SXE7nuOLekRM7ocw1eFlot9hP1sOqZ5/ck
	 iF8895v+j4EGQ==
Date: Tue, 26 May 2026 15:18:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 01/18] KVM: arm64: Don't include <asm/fpsimdmacros.h>
Message-ID: <a9bc03f5-e7f1-4927-9156-8dc17ffdb5f9@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-2-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PoA56a1ZTiAd6PNU"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-2-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--PoA56a1ZTiAd6PNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 02:25:39PM +0100, Mark Rutland wrote:
> There's no need for hyp/entry.S to include <asm/fpsimdmacros.h>.
>=20
> The fpsimd macros have never been used by code in hyp/entry.S, and were
> instead used by code in hyp/fpsimd.S.
>=20
> Remove the unnecessary include.

Reviewed-by: Mark Brown <broonie@kernel.org>

--PoA56a1ZTiAd6PNU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVq7EACgkQJNaLcl1U
h9A8Gwf8CEp6Hc6OgwT3SM+2uiPQUQevRblOiY6/WkUv407QoqYP4JDWJlHYqnDj
r/REeCBEJ7vcqX6hhZdkUz7p/MekCKN/0+pzOPUjZWHA1dTU082CFDAyFmxaq66c
VG31Dk0d4cbGrlMwhb3QflhiIp5bhAHLz2Kj5vrHuKZzESywAfZXDXtpXKFm4EQ1
1Hi0k/lnZEg+udle9++dDyzwC7GuHOAyhqUHnvXfssAmBdd8BVl/1A1YYjaPyimR
h0lYsHvEfYL2IfPI2pOZCIwGWIuVlvVHYkFmeBloCd6La/WXEsyy5I9r9JmGymTq
bucSQ4qKF+CHB42caIp8KgHDaDuaqw==
=LUWf
-----END PGP SIGNATURE-----

--PoA56a1ZTiAd6PNU--
