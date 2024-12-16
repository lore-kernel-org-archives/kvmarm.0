Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4AE1D514E;
	Mon, 16 Dec 2024 20:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734382332; cv=none; b=bCkNiphZrjV1jnO2kiZ5oy/hhfrDd/cNKGOYZ/+lqukl5b5th/jqsYxQ5QZ3yBiHq9v+0KjI3H+yCNwE8j7TucpGg6AKZpPfzqqrDXxzoJ66zqxbryqamjYq2QH8TtAF0D3udKsLTHFkBpRFEFe0y3Qs/x+VS/bSK4HvLUcsi00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734382332; c=relaxed/simple;
	bh=P4N4npRw9l2lYAIYPKpSwxZEHeTuyIbIDB3Me3pUDDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2pG/8MIWA++fc1JamAc7+V3RWI06N2Ch+cvdetHKBZuz6C6NMe60Z7/mB1HSuR+8CXcvzVCzHdzoQUEISZnFF8VDGG7HK3x/gFMc9RkVVD43Jy95zFztPG3n3KTs6tZtxUkr4IYdi4nlhnfSEa3scSjA5nuKvNlQ5VxWyNvy2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFTWMAz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFTWMAz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6B6C4CED0;
	Mon, 16 Dec 2024 20:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734382331;
	bh=P4N4npRw9l2lYAIYPKpSwxZEHeTuyIbIDB3Me3pUDDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MFTWMAz5yd1SZCjlq7bX24x3pqbze2bCFMcTpKm1UX9IY2TNPqrHq8swBaG4tLgm8
	 7s+XugKt1YR/GT6YbYq5Tq7ikXwD5CcQnz5CoagtKrKw1JBRhJj/QW/ln7DqUFzfQ/
	 di1owgcNZrJvdChtaVIK7s5R5+htBDCIg30rkctsbJi8sEL6xrzRGafKQrxoU+zZbM
	 INSchVZJ+0xw6wGl8SN4sUA2l6x+V+t7ccKe6RzCGfByFZbZc8i27vDhbu4rbEjQcV
	 UnKesr9HTjRSuVReMnkXsC2A42t6Hqsce1W5dXR75wc9/QsB+4v+LdUBh8ZB2qp3pY
	 8Hh1h++DkLqdA==
Date: Mon, 16 Dec 2024 20:52:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 09/46] arm64/sysreg: Add register fields for
 HFGWTR2_EL2
Message-ID: <1c1ac530-35cd-4fe4-93f1-1a6876c796c7@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-10-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gQgirNPpUJRoLazz"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-10-anshuman.khandual@arm.com>
X-Cookie: Be different: conform.


--gQgirNPpUJRoLazz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:34AM +0530, Anshuman Khandual wrote:
> This adds register fields for HFGWTR2_EL2 as per the definitions based
> on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--gQgirNPpUJRoLazz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdgkvUACgkQJNaLcl1U
h9BxRAf/UGDgCBdJrU3TS+Kx10KsHXS5MIs8ainlwpwbKqo+Hddp7hl5ChN12hfI
PUJ7bT89YTFmjheYBgShw88T5p+HqaK4189NAkrgLj5KzkgmhM5296OyNtLmVDKr
0zfPSIYCIsmu5UTWI+tzH7pg+aqY76VhrLn3sd8AVnu6UYAYENaEXwsTyyExknF/
RwLCMSwxWmibB5S7g/96QtCrGbeUvGB4XvpVMUijNuctxmAdYzCknDaiXWjKnsEv
Q4DwAsSzJXIDPdmaAz6vZTbgjd2dFuIDFFOXqSKRmPzLgFSEyVTp38Ycr9YHYTko
teeYnuvVoWxVt6mriGL/LR7vjicAgw==
=zIEV
-----END PGP SIGNATURE-----

--gQgirNPpUJRoLazz--
