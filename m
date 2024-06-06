Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2D39FEF
	for <kvmarm@lists.linux.dev>; Thu,  6 Jun 2024 11:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717674329; cv=none; b=hwl3gQawjfKc06MSmXFfuQBDnHDZDNnWkQwzrskQ1bkfJyd+EmIfoWbF80Cbc2W/+xpHOjj1eAMh86wr9v//w6Km4deAo0Q/DsPFoDenaAslcFWfbCcLD1ErJ2R4pUSdbllOm3qS/z+6kJ69gO0yMkcaT68gXcdITN3j32VU6Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717674329; c=relaxed/simple;
	bh=tApQm0jsKmJ03qHiH0VavM2oRC2xKkZ039CGa/1Fwvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axDXMvupbQQvmTz8TLnGBBDJm0Ij7jnJLSgDqIan+d0wgk7OXd0PxDy9UrdnaIaBhfCDvLN1kzebzhAtyrEPAcWnhyL1jK93hPKaljGpJOtcOQ+MGk6LHJyUrDTY+Dkzw+V8wx8AzLfkgEkg7z5icuW9CbPYM6FRWRkC7pHGNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjQDsXxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjQDsXxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04851C4AF13;
	Thu,  6 Jun 2024 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717674328;
	bh=tApQm0jsKmJ03qHiH0VavM2oRC2xKkZ039CGa/1Fwvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tjQDsXxtVj7iee/Gkrh+o1qk0JrgDm1/giTdPOKYIs8A9fGixSd/0rdYNuY5WkQvX
	 Cd4O3uCorS+6PyTFuRij/xEwoFK9Cf0SWhVFuV2s3xTUfZ0yD23cKJQ7a+fJRUQ2BP
	 ceJVWybYVGH853YGW+MYCb9Bjv8ce2hoZmPem/J1R6TaHFec5IstqQRg3f4HX7bazH
	 v5TT6WcfQTJ8QLJ0CtWniv2YDMBW68DXAx50QyDhzURKxSZaFEui2J5IG6FrVUWS1b
	 hPXupRuOqPJFhT1OUFruhEa8X5YqZL46yYqUqRznTQn/HxxZEOwpS0MArDiLpmy3IQ
	 Kf91NKrd4fQEA==
Date: Thu, 6 Jun 2024 12:45:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
Message-ID: <0e35b68f-8f04-4f92-99ad-7baf60441523@sirena.org.uk>
References: <20240605150312.3684150-1-tabba@google.com>
 <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
 <CA+EHjTx1Z5FyKO-YMPS83whX39eDAE5G6BzPJtpa6Z1kVpXgMg@mail.gmail.com>
 <93b31a5d-28e1-489a-b51d-89fc16ddd0db@sirena.org.uk>
 <CA+EHjTxn49GxBN0BNL+V7mheuxAUS+LtMxNpb0+TWt9q2T8d8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WcAdl2BjmhcwirDE"
Content-Disposition: inline
In-Reply-To: <CA+EHjTxn49GxBN0BNL+V7mheuxAUS+LtMxNpb0+TWt9q2T8d8g@mail.gmail.com>
X-Cookie: Simulated picture.


--WcAdl2BjmhcwirDE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2024 at 10:25:05AM +0100, Fuad Tabba wrote:
> On Wed, Jun 5, 2024 at 5:52=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> > On Wed, Jun 05, 2024 at 05:14:23PM +0100, Fuad Tabba wrote:

> > That was the start of the thought path that lead me to implement based
> > on splitting it out of vec_probe_vqs() like the rest of the code does,
> > the logic doesn't really fit in here for multiple reasons.

> The alternative entails duplicating code in vec_init_vq_map() and
> vec_update_vq_map().

> To me at least, it's straightforward to understand how max_vl is
> computed if we set it as soon as we find it. This as opposed to first
> having the vq bits set in a map, then in two different functions find
> the first set bit in the map, which really corresponds to the vq, to
> then convert it back to a vl.

We need handling in multiple places in part because we do actually want
to treat late CPUs differently to CPUs that come up during normal boot,
even if we can get away with it for now with pKVM due to it rejecting
late CPUs entirely.  The bouncing between VQ and VL is I agree a little
annoying, if you're looking at this code you're familiar with it though.
TBH not having it is a bit of a "did we miss something?" flag.

--WcAdl2BjmhcwirDE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZhoVEACgkQJNaLcl1U
h9CuMAf/TZpxoS4sVJ6dhnFvYTh517AFsy4qta1N7Dj/r4GevQBGAN2pZltMGkaS
7LPT5mLmmzGMBvx/lnR4wkrS9FADFLQwtrZunzH2wyy5+q6SqPzgBXHMcDQRAodK
4GgU5o6zGM7tBuj3mnn3pbw4WzibyiZ3x6bWyqH9xxXKMk5ccyRW8cZA9y4tRFdx
4tq/NdzPUreCNRh5Mwfrdt5jIQcco3B9eLVrjpIdIlHF44Xu95ZM1RCjN22uiB+a
6tu8j22naALjn5Sncf6A8MTLkj+xECTT2qdMVPGTTsZP/pyG3ONSMRm95Gtw24z2
C3m+qB9CG8fwWQevFuJoqJWl6IP94w==
=Dc3a
-----END PGP SIGNATURE-----

--WcAdl2BjmhcwirDE--
