Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747BA3CAA2F;
	Fri, 21 Aug 2026 12:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787315451; cv=none; b=pSlA8MUyyMV4v9Qe8keTP/XyCAJBxtkhHp+cnvHSYKkZSpWWU6XaamdxdTFWtrOYlbT1H9G89J06keOMAbxm+Xdk70s1AokNyKARP2WitMpz9R/qXqQqh+XtdyrzptxWCKrU3rVBY30zaxoG1/7aMCT5qZnXx8mGmE5tqoZQyCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787315451; c=relaxed/simple;
	bh=RQs2SUHTP9L5agRGkDvOO/AkjWbPpesdA9VBJS+6lnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nS8aaXnfjjvRtWlGXpBmtv/SBrgKVRDxaB4cqg0h269cZ+UgLbvPU710EWPlO1eBoYrM+AvWBR1Q2sj3QB2L6evZJMlHEeFYdEXxc589HTdZ1afUjgf3rHK4znxs8aqVx4LUXTXM9MeIxxkekWvAggMZVr7Gld+COIYhCeRsjsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWavCip7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWavCip7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AC61F000E9;
	Fri, 21 Aug 2026 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787315448;
	bh=wml9GtmjLkoEwpaZ0ookkzC/nT7/APO1rgKTmijjSY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bWavCip7Lx2VQnTOIA6fBLTuwlE0gki9ciaw3JW9ZLLSSubCcmGXIGuuVAdLbober
	 tdLfuEgTjmoypoHDC/XJwphEgk9HceD1a76lQuSl3rGIUakQf6RiFQNHEY5yqu3BIN
	 wNv8IaPe9KsG13if74hmjnqLtX/IUzEETjI2Ex7mSFd+a5037b02tK38MH/kKOCCT9
	 ZExvmYQUIIyk/jjg9oafrDz+h4KFToR3ttqwunpg5i9S+sXf5Xc2qU6rp9LyjrAt31
	 2VhuJ+bf4qFqHtn8uIuLm0Rc6cmfKdgyQz6Ocbibe+MhaF29V24af5EoNfBtUQs9CT
	 DhYyPJgjBL6gA==
Date: Fri, 21 Aug 2026 13:30:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <b15b02be-f1e0-4439-913b-d9803bdbf669@sirena.org.uk>
References: <aoXamcdKoMynTkpX@LeoBrasDK>
 <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
 <aobUGyq8nInJYkdA@LeoBrasDK>
 <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
 <aocOi3wjcliZqoe7@LeoBrasDK>
 <hwz52absjxap7n6olwt3lmjakmtgxxaku5gcofsrcfa45zdygh@dqgylcillnud>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QXlPIPOjLDpcKmaK"
Content-Disposition: inline
In-Reply-To: <hwz52absjxap7n6olwt3lmjakmtgxxaku5gcofsrcfa45zdygh@dqgylcillnud>
X-Cookie: Package sold by weight, not volume.


--QXlPIPOjLDpcKmaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 21, 2026 at 12:39:08AM +0100, Wei-Lin Chang wrote:

> Hey I feel the question wasn't answered completely :)

> Here is the reason for the asymmetric save restore (besides the tcr2
> part):

...

> Quite a few other registers are saved only if guest E2H == 1 because of
> the same reason.

There's a big comment in the code about saving in the E2H case only in
the existing code FWIW:

	/*
	 * In VHE mode those registers are compatible between EL1 and EL2,
	 * and the guest uses the _EL1 versions on the CPU naturally.
	 * So we save them into their _EL2 versions here.
	 * For nVHE mode we trap accesses to those registers, so our
	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
	 * to save anything here.
	 */
	if (vcpu_el2_e2h_is_set(vcpu)) {

--QXlPIPOjLDpcKmaK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqIRPEACgkQJNaLcl1U
h9Drjgf/Vfk6QH5Vi22Te0vQDa4XeCH2ch4K7HUFQutlQ4xTEjHPq5hmy83/CXXx
8CsmOBawMC79a2K3lr9cYQiWufkuEwzafLHmPumfTctLJvIIkfu1iIJel1+Guarx
pOlPJRmPcwYMrjIqg2yFTpK8FlJAyMH/wZrotY3fgZR327dllHXRhWYUfawIP5Bm
qmxLqyITLJu0pj1BC8pObGV1YUVfJFEEUSHmh6/HccTDJyXEPHZ+6NNlPciWD2bC
4+02O/3xV+dduqjZeiyXgYiorZV5+UkYVwhLOuuepZ0SqPxzAciqA7/3AKHbWGKS
1H3+8FzsA/oV9aCUqzsN/uQpzf8VRQ==
=mXCE
-----END PGP SIGNATURE-----

--QXlPIPOjLDpcKmaK--
