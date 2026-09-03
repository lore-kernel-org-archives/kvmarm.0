Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241864E8DFB;
	Thu,  3 Sep 2026 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463809; cv=none; b=bDB5L2L/+UOCQcnFDdqQEG6J8LASb/kSIP2XyMMPyxot/RJdoj6JVYnWLsYPbPnjU7MuOOJALXZIKze+ETxI4oLmjHJ5Ie6JVuCdHGyrLLaHbg739tQx2Dv6YD1RVA+ETWR+WDYM3ggm6L4ayXssBPXwDOgfawi2fxA/cj80KE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463809; c=relaxed/simple;
	bh=xbEVnZ/OJwY8tb6jYB+RURgmp+0pEujD1txhVy9SOxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4tUQVOKhy+juiA6D0tUOctjEWb/UKB7cjgZkhbD9yJwOYjWFHZn9oYQQTnTAsxxWl0CgtItMnn6EfupFWFSaLuYmDBVH3uZo4UtbVt+zI47wrBrKUjbmMRHgxvhyQa3Ok+BxWb/iilvA+/t9w6EWqzmZfoBtewc95GTjZWw1t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAFDPd5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAFDPd5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8F11F000E9;
	Thu,  3 Sep 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788463797;
	bh=hqz8/SjMZZzy7B2gdCWcCdfuHRhXx1ToG0cZIkRfkss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VAFDPd5eM1O+RCQ7MZv/mJBq+17lAqBhBzMKain6EgUe5MW/vScuu+pCld47Xtfuz
	 mnVsCDoCVylCTjgwx0fmqmIDRlI08uQjxEXe31/r8M0GrISP29WJR/mQXs0nsGvZdV
	 AQ6fHa4LiBf2Dh2s3PjKPfwlfGXivpiG4HthJgkkwRjlsEXdEEeYHcHWmmZAchKKSt
	 5SL0hBpQsPGBix/lCV0/s6TazK2T82al9g4fE8aQYDBH26+39Gl790B1MEupc+JF8i
	 GKBEjGKwYc3Hk1jtirc4uulukf/1HMBC841Dsn1LYbza3RSlgrDE1uYRNyPY/Ic7UZ
	 e6nKPMqGZKeSg==
Date: Thu, 3 Sep 2026 20:29:51 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Message-ID: <6e5e3995-b67d-4962-aa05-49a727780bf4@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org>
 <apmcDT8YTjS6eXE0@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GuKfjbABZoEkZnsG"
Content-Disposition: inline
In-Reply-To: <apmcDT8YTjS6eXE0@gremlin>
X-Cookie: One picture is worth 128K words.


--GuKfjbABZoEkZnsG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 03, 2026 at 05:23:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 10:47:00PM +0100, Mark Brown wrote:

> > -	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
> > +	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),

> Yikes, yeah I see from the doc I referenced in 1/14 that that's the wrong
> instruction ([0]).

> I guess this wasn't visible before in any case because 9/14 is required to
> actually enable this in practice?

Yes, it should be academic without guest GCS support.

--GuKfjbABZoEkZnsG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqZyq4ACgkQJNaLcl1U
h9CMbwf/bDjK65GOecop0V/w4MHNGpqHlxYTlwIZNgHvx4flf7+6kidJrMKC1ylk
TSF9ZQ2L13zwoQhjTdGpHqVVRAkkbmwcq90/gNRctaw4ZPOt30xqQFtShSilRCxL
Mr2IIiDDnyDm/49zvAU9utR35OxFNdcZiGcmIrGuvZ0kp0XTyunnFS9uav0W1Yzq
2kx9DKutX18CB87B27+Q97ysuuWrZqKPQDXaYHwwJEiOZwoDHomkjaEAVhQF3Rii
bAT5gofK71RJJPsheQ5b39GIdW5WauzKiz622pvwg3kYccda8Axazb3FH6CzpQgS
pA7n6DAXLLnkqH0Yj6NStIwJrUL3Nw==
=dXbQ
-----END PGP SIGNATURE-----

--GuKfjbABZoEkZnsG--
