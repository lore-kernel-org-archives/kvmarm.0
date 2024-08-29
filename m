Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001215E5C0
	for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937135; cv=none; b=PxCzb7puUUi/LWI7XGhXWTF/YZWkQUhI1D3Iesmc2bQlRseuQx0tCSdeZKvS99HuOhZeTMl1Yzd+rBoyuvidREJHCgbemkH8fqb/PKWPMKDCncd8JUBFAxIatU7im/ta4cBdhbBPa5mOi+9TN5SW105g7KINkdgdLx3cQH0ZSe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937135; c=relaxed/simple;
	bh=eDfHnljHMyWWiAr0OxKGuH3KQf7wO8xa1W55Z+kmSB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1L0OmA9+pSaM5iJJrkRB38uZtM4Van684c4ZJy9UfSGNF3mhtKWksR7j8QY93J/EQECJD0pIVb28WcS87JsE543errdQxS1J2JnMIE2aTEgcMhg1TIcjhP0ZBzopaLoaK/od8UQ18NA1BhDVzhSGrc54XKZCoZVm9cXcfJtucU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZ1ef8CP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZ1ef8CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59DCC4CEC1;
	Thu, 29 Aug 2024 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724937135;
	bh=eDfHnljHMyWWiAr0OxKGuH3KQf7wO8xa1W55Z+kmSB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oZ1ef8CP/wDuTcX2ba0DEfoM8aHj9iFB/nIDcGRaMIsWRJYxxniq/HlQlUaRfepF4
	 nfHCd+3WzH/pCw4pJIFNAH7rEQtOWXlx8pbLSh84fBImZ+C6vNX723zP7wdf1JmK+D
	 zovt12o+cQxzRA3RbeMBlsnwAhY+wn6YoJAMXB1UokhKFEsOLZl2pvr1sxNpkt1hG8
	 4W5NJu1XIZ8AVFqIYOkBGUG+eXivFmcU7QGWKUckck64M6ZcDwtwhmFtVJ+tXuoVkO
	 rntQ8wWCdKdQEppYzcIblZ8I0Pbukfad+8PaVyrrXcPZ56JRlf1GqfmtVcMjC/CPQ4
	 c6qPEx09VTplA==
Date: Thu, 29 Aug 2024 14:12:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Cope with lack of GICv3 in
 set_id_regs
Message-ID: <f399b6b3-8ce4-49b0-85c8-ba9bfb7117ee@sirena.org.uk>
References: <20240829004622.3058639-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s5+YznQdYQFeNVPu"
Content-Disposition: inline
In-Reply-To: <20240829004622.3058639-1-oliver.upton@linux.dev>
X-Cookie: Go 'way!  You're bothering me!


--s5+YznQdYQFeNVPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2024 at 12:46:22AM +0000, Oliver Upton wrote:
> Broonie reports that the set_id_regs test is failing as of commit
> 5cb57a1aff75 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is
> presented to the guest"). The test does not anticipate the 'late' ID
> register fixup where KVM clobbers the GIC field in absence of GICv3.

A bit late but JFTR:

Tested-by: Mark Brown <broonie@kernel.org>

--s5+YznQdYQFeNVPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbQc6gACgkQJNaLcl1U
h9AmMQf9G8DS+m6feBAtQeP/V+0m0IdLDDAzRi289Hjtns/v/YRhzzstyKfD7SW9
MbPrAy0V9SJrbCuzlDGdyCUcqEo9/J2FF7dlNaEgKgR6CXnnd7tMMnkN1MUwiJwc
B2nq89e/CCf7jOxpRLleO+jBD+aVIdMiPtKKOj0EyEHuNAvFiJsWoN/9lAftJhfD
f9whOT0T5PBA5EkFWVci6s3CePTlCoSvYr5jMpaJi2idmA2qAqZGTXKTo0f4cA9C
pJY/WEFCXfthOQS1qxwwiGqixln2O6fzQ08+LiKURNgjQ8Xlmwj9MXy30mRYemd0
VId9vr43FQePI1yzrgTLgHxHEevkOQ==
=8WrB
-----END PGP SIGNATURE-----

--s5+YznQdYQFeNVPu--
