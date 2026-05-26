Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7DE38BF61
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810437; cv=none; b=Lk1f5RmCoIprVuW4LQOvpI2vM1RCirbM4ufr98MhNWgHgI9cwGYswbpj74mOBkd2xyY42ibLQkQZXlZH7wdE8u+ZZL4A5NdovB8PsiG9B1lhZXPJp+9PzOvPp/NpjU5cwXcmzFQnQRjtJ7yxhlBzhQ++XcV5H4IiN0vGHD5r3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810437; c=relaxed/simple;
	bh=LlI5xgira7s+5pqZZoZR/MaF0ZvnyAOrd36rKkkL928=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VO7keO1gdvTmqQmNfVcqkmbVn9bz2J7zN1c0V3pxWUbKrshml703Lp+LNHBq6v/7pBQb7DrwIs/8hBWy0Mi2ClNqja+6jCNmCjllk13kSdsHNmtbvzG58XjSJ0RGilYMxLzkLyOIRALv081g+XJiBfFKHAOwiB2bXAd1YKZHcV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNrWfGUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNrWfGUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1FA1F000E9;
	Tue, 26 May 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810436;
	bh=LlI5xgira7s+5pqZZoZR/MaF0ZvnyAOrd36rKkkL928=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XNrWfGUXbmyn6gOwODChUHBLFtkcy2s2zHOfg9KhQkth36UU/7neANIf+cQnnnG5p
	 gu3m2k/LSc5hC/VauiOg0uPflCERQX8PORWZzJlO3xY2PaZqLvyRxvSreRvTbBix5S
	 kqTjBsZ5LMMlSx6C6u8aqKB8b6is6Txeo1ErISS1QbLjJKZtY7JL774ZhMOEBDKejc
	 dOvr8KU/e3jTiNr/V00QZ2OU637q9PbcjKLC0oo7miWbYoVgmmeji6SyqfzTsTf31w
	 pd3RDRgoApFctCsDf1B1mWBMb0YlfmC8tzQP1WT+2NVqBqdn7UNJod5T0MKAkljbb1
	 H5rC6Z7SYqKUQ==
Date: Tue, 26 May 2026 16:47:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 09/18] arm64: fpsimd: Move sve_get_vl() and sme_get_vl()
 inline
Message-ID: <3bdac1e2-efcd-44ce-a15b-3f20bbcab80c@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-10-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BbKZvTDc7vrTGQ/b"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-10-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--BbKZvTDc7vrTGQ/b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:47PM +0100, Mark Rutland wrote:
> The sve_get_vl() and sme_get_vl() functions are wrappers for the RDVL
> and RDSVL instructions respectively. There's no need for those to be
> out-of-line.

Reviewed-by: Mark Brown <broonie@kernel.org>

--BbKZvTDc7vrTGQ/b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVwH4ACgkQJNaLcl1U
h9AVWwgAg/lBHjYGjFtpVuM2U1cdCV1P9rissPlv6kb++fNc57R+CKIo70W9q+hS
xQJBmkvSsrVmwvKD6VDWAzWKsggvTO0j38wd19IvXQ3qTC58P0mUQ/8Gi4cZaGJO
8Mrxlc7Te4c5U789cic8G+ngsmlSzOGBc7R5KGMY5uwxv+G5lkg/EuDeft1t4jXU
j1jD3UxAs9NOZI4FlgpVlObjR/VT/nuJrhiFTD08XLOi4Slj1vaXPGNxPsIHmud4
Oh6G/HdIr8KvgWHyK3LQ937/ecaifDqF4ZHkYHh0X78qHvHRgNhSvD0W+iaetlz9
IXE/6tvQDpMlMd4XZMeyoINUt+KcYA==
=iTOo
-----END PGP SIGNATURE-----

--BbKZvTDc7vrTGQ/b--
