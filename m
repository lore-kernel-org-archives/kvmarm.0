Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1EA1D1F6B;
	Mon, 16 Dec 2024 22:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734387088; cv=none; b=eYlpL4lezDjhxGTnkkTBOfC+RVYhrjJDyJ4sGrL25Z84PC0Vh8k+ANEDb/hI0PKRDHYncbhXEpppBLrvMbu6OYCejWihtR20p5f6os07zGJ9D1KPrjYFvlmZ+AT98pg3f79ZcjO/P788ydiuQE54vVUilTPjrdVNboSxPb2lfy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734387088; c=relaxed/simple;
	bh=aV1J6MifAqAJ1Jq0WWRrntWcl/8qrLrWiHHgvEodlsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzeGQ2rHbCT74YGuYhXqErOEn9nCGrc+i15udPV4HXtMwmNUYY4A4NUMkjfAW9oNifKeh2cU+uiXsopy0S7e5edq9bARUHhywj7Oyq1P5yEDG1aVt2gSji9Yz1l3ROAdtRdnCVCxUy/fZGeKHg43v67A+EFLY7VH3AyPtZoXmC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAuDIdXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAuDIdXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7589FC4CED0;
	Mon, 16 Dec 2024 22:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734387087;
	bh=aV1J6MifAqAJ1Jq0WWRrntWcl/8qrLrWiHHgvEodlsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAuDIdXRxiy7LoqcKDg1yIU7cZNBbFDNz3F2w/LHl5+U5qirzcXDa34q4UXCS/xhE
	 KqcQwIuU+oalAdVZX0SyacRyvHw02C3cbodn21yVcr6O5TtLTL9Tcf440XUSbcS2Y5
	 HUQ/tLEbkGaisiKIRb/0DyKLYnzP9rEA8Pz/mulFHoYVUjgvbXEHlioKjASJW/0zcL
	 eq0oW41Z1rPxbFIGjSaEvvi0h1myyyhwo/km4hf7YW21rODc39/gDtVagtMcahl+UR
	 nTgAf1TlRKGh6UX/lt6QwsQM+wXKxGylh+SEa5xTM/C1NS29u6rlAB7eFPuslPn4CL
	 fxAlPpAdRjJ+Q==
Date: Mon, 16 Dec 2024 22:11:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 12/46] arm64/sysreg: Add register fields for
 TRBMPAM_EL1
Message-ID: <01ca449e-b34d-4833-941a-4aaeb197b28c@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-13-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Z7aSgB+b+DyrUt5q"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-13-anshuman.khandual@arm.com>
X-Cookie: Be different: conform.


--Z7aSgB+b+DyrUt5q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:37AM +0530, Anshuman Khandual wrote:
> This adds register fields for TRBMPAM_EL1 as per the definitions based
> on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Z7aSgB+b+DyrUt5q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdgpYoACgkQJNaLcl1U
h9DhWAf8DObkHaJw3p45M7h0LKyURhsSBHONCy1NsNNHrMKVgjxmWILSQusHgA5Y
JlqE4pb1xspixa/eB+wbdC8QOb0tdJ0e/9aWxlJe2C96HTawajMmsC6Ne/++IC7S
d/0ShOIWFn/QPcSChyIdf/5Su8SG2qSYdmRMpvKfYCwrEXz0WQzlojwNk2nebOzM
CtOWpyJ+EgihefQbW4l/rjUo5MwXFchsxylpkKQ4xX6gdIpJm+iSDe2OG4T2N+ut
NKiXPTZAt5bu6JR6dpl8Ua3W7JjAzQzl/PvdBUt/m0/1Lohkm5JuCv59n5UEfefF
VSEc/dpRvMZMus5QDA8q5PQUkj60gw==
=32OO
-----END PGP SIGNATURE-----

--Z7aSgB+b+DyrUt5q--
