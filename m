Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00A81DD873;
	Wed, 11 Dec 2024 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733932096; cv=none; b=ZskZfxv+y5Swyp8685KaW0dDQ3D9IwDaF+QTFDgdcSqjiFYPxRxNFiYkoDex6xoCsMUY6cNwlZnv/FkJWF8QqPgcC7QytG3AlLQVaVevsvOnyBQchuXuqWT4zzRXu4BH1PUyXkLPTF46PpFjpTWVTqUIHQ4rjdHQgoqPsm0e9wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733932096; c=relaxed/simple;
	bh=YLacmmQOff+oT4ZIe+wvYVJYKWjSDhRMK864cvAg1II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpu3/FoHD3FI1IzNc06nPn8qQ8VOEJdcLDgSqZ37CVj+B/DgG4ikgpAGfRQS8BHcCdtrS34h184UCJ2ijhej6BGF8JXLj4W109URAoGmPwHRdj6TMe4lb71uSWhfbUD+AY8OsNfifikToNSUhlZLW/WbFYSutCF6vSCB1Apxw0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfOojM+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfOojM+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC480C4AF09;
	Wed, 11 Dec 2024 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733932096;
	bh=YLacmmQOff+oT4ZIe+wvYVJYKWjSDhRMK864cvAg1II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfOojM+cAe7XzR10RosCRkC50GMmSbyW0dbLpej6mH2vmg4uwZVX9ZDpNGnPsOL+o
	 XdeuXZ9KznvEy4yZxxn0/wnA6Up6vIxsSiYm7ri9S8RJlYvKP5wQfAAicfBiV7+wHx
	 zXDm6p8yGY3807+VpDrcLF3vN6wsvoS1IO2K75wkIRaknG3jFOQabXBMo3oeJpN5iz
	 flgkpkAfVyLDtvI0UTf9k64Fi9vV0fWBIciyDkZMmR0Z8hfMEW0MK1o1MPP5nGYz4P
	 +MUa56R9TjQrDPb7xU3fsCxT9n4cUt4sB1UoIW15IpH8dqNR14YPuz9IMDrTqS6d4g
	 UdUjjqSZWvoxA==
Date: Wed, 11 Dec 2024 15:48:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 01/46] arm64/sysreg: Update register fields for
 ID_AA64MMFR0_EL1
Message-ID: <409a5ef5-5237-41d9-9cf6-274c010ab2d8@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-2-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2I+DX9YYFLWygnpT"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-2-anshuman.khandual@arm.com>
X-Cookie: Every path has its puddle.


--2I+DX9YYFLWygnpT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:26AM +0530, Anshuman Khandual wrote:
> This updates ID_AA64MMFR0_EL1.FGT and ID_AA64MMFR0_EL1.PARANGE register
> fields as per the definitions based on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--2I+DX9YYFLWygnpT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdZtDkACgkQJNaLcl1U
h9B72Af/d+gjIUWdLm18k49dviMnY4a321sGjl9OHJTUhuUbdXMekpz9ytDLvG1u
Nc510KWK2itLqRJxSA/At6y9HgJ7UHCbzx6pdiB6I9EPrw1yR/LKSLPz7ErzR6hY
4meDA9QAX/63Qj0HEOyD8iBXmQq3gIjpIRvQyOmTcm934hit2phWeFRLZ4/u9wWr
2wR4BVWVxM+JpV61uV0h7IkU62WPdzhuI7UcCcdnQhvmZxUhzaJ7a8QtQhHiBZ1t
cAzSst4Ngq1wIbkr3cYdlfXtRsNTdb5G2afCOoJUWeK/jhZ9i52ayCtrtgRWuTus
3JX3K7bRXz9ek3InC7zvffHfagA0uQ==
=p2f7
-----END PGP SIGNATURE-----

--2I+DX9YYFLWygnpT--
