Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667BA1EBFE8;
	Tue, 14 Jan 2025 19:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736883931; cv=none; b=kuzAJr5xhIXWJWY9ynbPAb8A5tw0MbM89g8HmcgeFVi9Ldh3sGE1ITgUC1dlbcoQl0IAeNC5ZE6ZA8OOfgyEL2muUNRK+bujrlucf/7U2ky39IL2nBigwrX76sZsgDqOQjWiWpqm2CLZcAdp+xMW4lDjMo62tb4mGTwAPIemPkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736883931; c=relaxed/simple;
	bh=2ml/TIaI6G15M5AEJ90KaNKUGMB1AieEtHjJb/6pMnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ci1GB4LPf0Q+M3QkZi4CEKisdF1C2uoqriQx3vY1UN7yR1OmXGzwOIMmjjfCRy4r48xR7ncRVZaeFJtUQz1WapZ2Y32k6d4JVhlQw1x6G1QeMuv2V6RzL5z2G8juLOP58sD/wHisZmZfTQWBvRH9qK84CI9G6Rl0pxqL8uKWtno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2SpaxeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2SpaxeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC25C4CEDD;
	Tue, 14 Jan 2025 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736883930;
	bh=2ml/TIaI6G15M5AEJ90KaNKUGMB1AieEtHjJb/6pMnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K2SpaxeRNWMFa+VKE8DpGNH7vsi78nICaF/074HAST+1I7jjpxZEoKQszs+TcqIff
	 m1358f50vtFtpLSMmiPZxb1R7u0YO+128bvzOdJEFRw9Ur7/3OWRYwO9FvUnXXNYkF
	 qJ551HEpnp2Z9nE0C3OAK4OC8NOa+D/OjfHwz6csjt0rvRF+CIXP+1kID/PlfRZtRF
	 ZEPa5GfPWGBlC/jaH3cP7Phl6ee2JcshkuBsF+lus/R3PumhHXCoz+MK5BJqs2BTeV
	 lHZFvXUb4T0nF2dUmnxS6ZHWPtlNsm//drzA0JKYDrUxDSONbD3acVhEbwTI1cN2vE
	 UgEn+W0GhItug==
Date: Tue, 14 Jan 2025 19:45:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, James Clark <james.clark@linaro.org>,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, coresight@lists.linaro.org,
	James Clark <james.clark@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
Message-ID: <883e4173-d11c-48ba-88fb-13302ccd6834@sirena.org.uk>
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org>
 <87frloqjso.wl-maz@kernel.org>
 <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org>
 <86jzaywtea.wl-maz@kernel.org>
 <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NBHLGodB6XJd8ngr"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
X-Cookie: Sauron is alive in Argentina!


--NBHLGodB6XJd8ngr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025 at 12:16:27PM -0600, Rob Herring wrote:
> On Mon, Jan 13, 2025 at 10:49=E2=80=AFAM Marc Zyngier <maz@kernel.org> wr=
ote:

> > The better option would be to add the comment *and* sort the file.
> > Leading by example has some value, it seems.

> IME, it's better if documentation just states what the tools enforce.

> Can't we add something like this to the header generation:

> $ grep '^Sysreg\s' arch/arm64/tools/sysreg | sort -n -k3 -k4 -k5 -k6 -k7 =
-c
> sort: -:22: disorder: Sysreg ID_MMFR4_EL1       3       0       0
>  2       6

Sounds good to me.

--NBHLGodB6XJd8ngr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeGvtMACgkQJNaLcl1U
h9DQDwf2J2bZkmKraJMzR/mJKrMXvtfn14Ugf+UdML9Wb+rdDmyG6OQrrgb1XkAO
hlP/cC1bA+npKb1pjREfCgRVAbHtX9sO0/mOFtL9dANnO1SzDyXZRtCJA58ZSmJX
bKuWj/bGWrI8aakHAVb+pE96b7vhrf8Cn2NkCfFw3FW6uxzt/lqBNF89vrQqyo1n
GaJr4vSxwqhSuouPIElFkVH0I2j2mDJcdgrCWDsxF7EyaB4xfVQvd/yqs7lUZltE
OOPftckHf/nl8gxKE1yTTM9caTxaH8SO58UUVhGfw2ARhNqlogNdiUWj97i9ly57
e0kGQuJNyy24hhbl39VtP8NtMsUs
=ARhY
-----END PGP SIGNATURE-----

--NBHLGodB6XJd8ngr--
