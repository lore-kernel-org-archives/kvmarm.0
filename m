Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6313398E
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227597; cv=none; b=TYnO2fC//tV0gE/eAU6qhz7z9n/W0n+dPjjkxd+u0LNaRSVxnCsAlofZMAftuOrtCP+8bPfcsrxKC77b0Fa++W9OjAbRpM8M1vDPk+7iCSZCOHwkVCNZMnA3OAhZv40lZuAM3PMKoEBYUNg0DxVOEqLcfFEmFbcQt5T3eAXn5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227597; c=relaxed/simple;
	bh=2IaHeOK01P5cq2lq++qJVDuEJKeGhlfmZC6KlDh1+es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNhzc5C+Dd63JYs0EjuHe8aIxATZ5PMOaRaVWC+luBePeIAlxh+cUGmvOUw5q8/cT+3Yc0/YzkcJrRAdGcOnR5ICgtcTFcEyJq9rvaw24S6L9/RNQR8IfHg40dVNiedTFNR/cNEcGJmxUR2SiOvVl1PLvHB4l6Cs7qzuP3TDAOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOPZl+i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOPZl+i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D518CC2BD10;
	Mon, 20 May 2024 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227597;
	bh=2IaHeOK01P5cq2lq++qJVDuEJKeGhlfmZC6KlDh1+es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOPZl+i4IMx8wO+UvGkwyPbx/JxfUk9M6P8Fx6+vrfyQ/G3W3raOPETnLOlz2jm1C
	 MYOCgm1Lrr6Vu7ZCsAgzbWM0rv/d0KMSJn6S2nny+0kPxy4LlE2foCK0nBES7cgzSj
	 FVzjoXKgG9Y37G54aC9U/3jHIW9j+FD5/mGPKUIlw0IY8v/WuJpXX+IJlKSRuSVJdR
	 QAUGMOKDO+5ZQ/SbuIJm7wCWkLddQ/pgH3MuZCChZ0Vx1M2vYuiLDJhpiyQFeHqgWy
	 o7Wyg/BOkKKiaSzs5le0weoDeVmwkMSJ3zEs1eYfKnkSqzGEtm5l+uEXC0Aluwk9Eo
	 VDIfaMkVU78CQ==
Date: Mon, 20 May 2024 18:53:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	will@kernel.org, qperret@google.com, seanjc@google.com,
	alexandru.elisei@arm.com, catalin.marinas@arm.com,
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
Message-ID: <d68fe061-867e-4afb-b7d1-b99196a1080f@sirena.org.uk>
References: <20240517131814.719933-1-tabba@google.com>
 <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
 <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org>
 <ZkuKYA6-u-eZmBOO@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gaH3U1DvHLCOCk0I"
Content-Disposition: inline
In-Reply-To: <ZkuKYA6-u-eZmBOO@linux.dev>
X-Cookie: We are what we are.


--gaH3U1DvHLCOCk0I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 20, 2024 at 05:37:36PM +0000, Oliver Upton wrote:

> Wouldn't it be equally valid to just zero the state that will not be
> preserved regardless of whether or not the guest used fpsimd/sve?

FWIW I've had this benchmarked for some implementations as causing a low
single digits percentage overhead on syscalls (as you'd expect there's
additional overhead when VLs over 128 are supported).

--gaH3U1DvHLCOCk0I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZLjgUACgkQJNaLcl1U
h9BGLgf+PuZrbKgsnHxMxyZp8vKvUfLutTmt+cD084Q7DL4eavLjiobQrC7XSR9+
mqPX1yplOO43DadaXT0nhiWHsRoH1p/hDQzFKEXKotO3Fm9P1W0r2/6cuwNG/2iL
8zGsgKQTdOaILRuFYc0nNjz7T2tYHQAbCjdxXpTskUEs8bKRRu4g0PUg/1mBdtDq
T+wN2hJeJrReMwaIWmFJr22ReXdw9363C18CKdqwJjlDEfTb0iOt68gyS9I1YT5n
bckE2ZF39j8fBJVdviGyBDDCgAPAlCaoYI6UOGM//PUVAIN32fN4u71i8h7vO+zl
sVTX5/jv9/s8y8ZJGcE663cwXDEd4Q==
=bloK
-----END PGP SIGNATURE-----

--gaH3U1DvHLCOCk0I--
