Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC7A21105
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/3oqz6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C7CC43397;
	Thu,  5 Oct 2023 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696515297;
	bh=nZ2pQOUK1xxCQH8F9rUTMa70XO6gjHFBAjV0L7xLvLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/3oqz6L0PP/o7CzLKBlV9IstV7GdqYsIOhHkOf7881CYhujPH4Xo9jAQV9vlXdbf
	 atjwhOs0mbg0dI/BknjgmeVxqCsvQFYT92lhaCTz3TizCZxFLiJAgPtpZbCw2YHUbP
	 tKAhEmwYlC7JgANOh7aodswZAsQHnfJAFZmq6sxlNFYjJd7XsECJ0/Ru7szVzCz1WU
	 ZHW4XKMSsaOGXWDxzV2eLNPhvORwm0Gzn2z7Z41KbEk2x3OiBXZx00tC2aRQuJ6fsR
	 a7IBL6wekJ+8cSyjJqXr2x1ux2g6gzgoZ4YAivHYhalfYwOrUPSGscyo32Ufn8UdVF
	 6nU44bEEg2FyA==
Date: Thu, 5 Oct 2023 15:14:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/20] arm64: context switch POR_EL0 register
Message-ID: <b1e43c42-111f-43e3-9e24-89ddef76fedc@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-6-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4H61ssqIvNduKjuy"
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-6-joey.gouly@arm.com>
X-Cookie: Avoid contact with eyes.


--4H61ssqIvNduKjuy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2023 at 03:01:08PM +0100, Joey Gouly wrote:

> +/* Initial value for Permission Overlay Extension for EL0 */
> +#define POR_EL0_INIT	UL(0x7)

Might be useful to explain why this is the default (and possibly also
define in terms of the constants for POR values)?

> +static void permission_overlay_switch(struct task_struct *next)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_HAS_S1POE)) {

Why the _unlikely here?

--4H61ssqIvNduKjuy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUexNoACgkQJNaLcl1U
h9CQ+wf/eLvm0CgQ5tFcdi0/EMV/QJXOwQ3Pb8kGAib65/Ata6WMaKI1N2beahsU
VTMz/iPUnZXCok+njXMxfoF4O1FjDeho8dLcBSWfh5S9DRAvhvmIBbRkmJODaTFN
j2uSWM4RlVZ5LNxnvynwMXSdVILPAsaDIVEMQLqNGE3J74VUv/TRO6wZtmMk63WJ
Y9y1PsJ6Sr9IVrZ2cavoG5eVqs3EsnlrZSPjJ1ka27So6JTH11ehf3o2kZOUeStI
VrPGQbIvi84UKyag5Za1tuUPkf6oqJhTYT32Z2PCvl0DKiwhfI83M6WbphaNExdG
YhLY8PLIbi/ZatgqpS2eg+SlLPdA2w==
=kkEH
-----END PGP SIGNATURE-----

--4H61ssqIvNduKjuy--
