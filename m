Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B04763F1
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264502; cv=none; b=TYb+xmj1dHCJt9DU6D9x6cE4VDBu5BGVgUYdbxvdUZUuvLJ+QENUfku/fKD48xT3feHBiwHsL/xQGYBHGcQkLYerqE5ry0Dx4LBdh1kEPViwLDbltUZyD0u4394ZYMSWzTg/7+ScVCoJ4BY3NP7n0rVs8VKmZ2TBoOLzNwKTOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264502; c=relaxed/simple;
	bh=Y36EazgQ46VtUFCglrAma7UCKV7NrZCiYTM6X+J5rtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5irwD7jCYE2JAadiDYnZVpsdG3C+fKf2VEWtRDO90k3kWuh3Ezz1HkIYryGwDSM3KV4mHD66E339wqnPpwamKo1g4FhvzBG534fjVwM9bWPVQhm5MngaiEZwQ1OkX2owX4XZ/rl1VcNRG+HUQ9CkM1rqYCriNK0avckOSpNFf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXXP0ib6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXXP0ib6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C7C113CE;
	Tue, 16 Apr 2024 10:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264502;
	bh=Y36EazgQ46VtUFCglrAma7UCKV7NrZCiYTM6X+J5rtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qXXP0ib619dHAad2JXzxLcSokB1n3/rJFqcOYdBetUAivr7JWaAdzSbbPOP1IN+jf
	 /2HuYP623fxSpU80id5f/KI5JUH6Vkglo7E5HxnVa+Cc9jXOMqM/3myUffU8mMqvuW
	 vTF5zws9ZWf4a9rkeJG0NeMKU1DlH8VLHrBK2LLwf1L22kAWf4I/xOL3yJTrgb2ze4
	 0DadGkBx0q6eMiTIJ2VU+u0L/YElluu7MmayPQrAPVNDiQuq9M8pkCKlNcpdZp59CI
	 XR8m6cQIqIGl+8KKchbbda2TnoHoK3T0sBrt1O+m59/sC0P/sCYh+4v1bREXSrrc4n
	 +bERyE3RYziMQ==
Date: Tue, 16 Apr 2024 19:48:19 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 17/47] KVM: arm64: Refactor calculating SVE state size
 to use helpers
Message-ID: <Zh5Xcy0rBdFl/0zX@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-18-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2zlIgskVRJHup2wX"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-18-tabba@google.com>
X-Cookie: You might have mail.


--2zlIgskVRJHup2wX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:56:08AM +0100, Fuad Tabba wrote:
> The main factor for determining the SVE state size is the vector
> length, and future patches will need to calculate it without
> necessarily having a vcpu as a reference.

Reviewed-by: Mark Brown <broonie@kernel.org>

--2zlIgskVRJHup2wX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeV3IACgkQJNaLcl1U
h9DCbwf/Sd04qv6E1QG3MThWZMVQafX7J5rI851cFWaRnjfs0xSqUq0qg/9tJFD/
S0hQw3kVd48C3YJ6QVAouPIrr9q3a/vcMukvQsg/cefbd7vjDCAKJNWOXTlLx3tr
RuD9164WS/KDuUyhu8uODcei4lkYmxA2a0Ms1cHF7KrYaVhupoN6B54zd+Ms6glA
BB3vXcJZWHbvVufOfIJsg7bqr/ak9EKfB0cJ+smOXB/bWLVCl9sSbsU7gY4MRWN1
PzIPLzf9lkXQ4icNIu6qP/Kn4RMSZ5lkQ+uowzsCDeFpaZhlrLV4rLEMXSF1kYmv
pBqYmRKEwdJ2ZrgcRgHPLskedm36Gg==
=mcAa
-----END PGP SIGNATURE-----

--2zlIgskVRJHup2wX--
