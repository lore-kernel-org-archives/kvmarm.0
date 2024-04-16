Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172351E87F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264588; cv=none; b=SmUHYNqmaggCg6aEdJq4TMq5gVcI7Msx9RpLahvAtgG/Bjx9Ok/V6xNUdta+t8SjIv6EyzOOKyd6HEj4Cgy5DKHUapywCvVatLE71z3xHEO7z0mf5PL7aifIK+AavCS7kyBHKp4EMB3ag5FlQCgZriN5wqwkkHOZDh8eTlwcFeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264588; c=relaxed/simple;
	bh=dJ5wSzGc8PKWU8o0LW2i5pG8lEpHz3BPrmtnZ2F9cTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OvSTGrhDOamcEXrWXA7qR4s2W3u93lglxQP286t1z7pOkGhUrG03XaJ0k2CYUprLrZ+9PN//hzrlcmYcx+4ORKNyw4St+uqCLS9NHY7kG+NfWR/weprhzBFeoUiZAGHvtqvJ8jD0Fm8TFoWDoPXW8N4jPgcwuOZWJox04WLEpaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKJfHooY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKJfHooY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D82C113CE;
	Tue, 16 Apr 2024 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264587;
	bh=dJ5wSzGc8PKWU8o0LW2i5pG8lEpHz3BPrmtnZ2F9cTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKJfHooYjgs9XHIcSMApApG3MuuyENX4sY831s1HonfOaItFA3W4P0CYLrgYZYVys
	 T/x6BUEIFewI8RYDBk7lOFEvefzd6MKxsF7/QDkl7noR5z0TfPDJdvfTh0k7XuRF8C
	 MI8laWThg/DfR7bZDMvUE8WAyLBC6X+unpfx0eajWJRYgEhu/p0/5xBcOW2aA0uDvS
	 VwCKvj082YCI0H8Q6YkVBPoIs/0ifQZFa1g+js8FAUB05Jo/OfjEoU5qFSb7iO2YOW
	 ELMeYLgGb4recM4Pk/TGDUkf2fOvNPNT49DCWR/quCG7DCmOogIEkjRltC5JR9IBJf
	 rrV0sodNsm7aw==
Date: Tue, 16 Apr 2024 19:49:45 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 44/47] KVM: arm64: Remove unused vcpu parameter from
 guest_owns_fp_regs()
Message-ID: <Zh5Xya2+8pbyqj/l@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-45-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="12mXJWKqWK1BnFqt"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-45-tabba@google.com>
X-Cookie: You might have mail.


--12mXJWKqWK1BnFqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:56:35AM +0100, Fuad Tabba wrote:
> The host state is not per-vcpu anymore, and therefore, the vcpu
> parameter isn't used.

Reviewed-by: Mark Brown <broonie@kernel.org>

--12mXJWKqWK1BnFqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeV8gACgkQJNaLcl1U
h9DQLwf/YTduM8scBDeLzcXPynp2VYD0ZRHvJOkzMeXIKyjHsDPqDZJTSslSJwcU
Wyvk3p6ybSlF/veEnUaqLBKpufYcBEM/BNwDJ0vV0gVJR5a2JOD49skrgekMWwtV
DFufvsNS1hT2iqusFyD0k9Yfi1fs1tDvujy0t6BPgll9Gn2C2gJb2P4so6K45qvF
sH4dRoK7Gzmc1oSXHprus0BJD7dfINYg9xaSqyuN6ox9owb3lC16nAh9C/Pzs3WI
ppkPOR3p5X4hrxPkQy4qivoEEP33UaS+iRHKG66Lc3d1m27T6ZuAqTP6cEuvoEdh
Bl6Jo3cIXUoPguY6nn72E9fmH0IiZQ==
=rE0f
-----END PGP SIGNATURE-----

--12mXJWKqWK1BnFqt--
