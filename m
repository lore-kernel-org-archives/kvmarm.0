Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF121B9B46;
	Thu, 12 Sep 2024 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726156789; cv=none; b=OB4fCbN4Cwg+aC0lG1C0Xacz9hdU0x+1gw6AF4F7pRhbrM09EFnRIr9M9uTqYwsr/8QzZB6ltaPaMoKmo14+8tunn7oCAUSl4rTefAV2Zwxdmr8YQxv1M+JqNwFoV7ms5zf+vy4zoV/sayoIHBf6r0cn0Fa5MZmnAYDyZEdVCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726156789; c=relaxed/simple;
	bh=10XQZp334ICfGIzjTHfIhZ69Z8yK42Sp65d2sy226x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAqDAfCkkLAxG/M1Pkc7kSExmhKfZu0jFVtxutYMccPQ5h1lIHNm6nZUCs+kSTHZQ6qmevOwNubKpmU2Qzn3xgOSn0XnQtDnBFkCi7CGXoJhYadyolMvxYgwJz/0l1sUxuS/E/rcSNdOxmrVomuCUTQIYN/v0fbtM4h0N5s7CnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bH94ytom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bH94ytom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5B3C4CEC5;
	Thu, 12 Sep 2024 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726156789;
	bh=10XQZp334ICfGIzjTHfIhZ69Z8yK42Sp65d2sy226x8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bH94ytomvyNQnybKtJYaHhAVZKfX0VxSX4I7s45aEdiBRi8C2/4EBdNAC4V+PPoxt
	 Ot54cTYJvx9l+Tx9SjtHr/25AgzWKD9ci83JM08JZVv0wW/kT7WgdxHD3NwJchMiqk
	 7NXlDbuwY7MbS3O4yQRzXOyeyRnqOB8Kag6BZyfoAkMYoUg+k5zDCENKG20RmDZfjS
	 5CrL2q4wmATMY9dDR9I6PnlIYwvItNiCIH18hvgTya5gnTFIXBk4EnpUfNGmvKCVoT
	 ugJaUI2yAyEDsj0bj/OVjWpi0HYwPvC89TF9bfWVQKv/8MLe5XrEOxsJsSfoqO11jj
	 FT4L8f6PiamwA==
Date: Thu, 12 Sep 2024 16:59:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Fix confusion in documentation for pKVM
 SME assert
Message-ID: <3e5253f2-ea69-4ae4-833c-0627b410e815@sirena.org.uk>
References: <20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+zXfBMQstQ6Z1UEz"
Content-Disposition: inline
In-Reply-To: <20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org>
X-Cookie: Happiness is the greatest good.


--+zXfBMQstQ6Z1UEz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2024 at 02:33:03PM +0100, Mark Brown wrote:
> As raised in the review comments for the original patch the assert and
> comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> disabled in protected mode") are bogus. The comments says that we check
> that we do not have SME enabled for a pKVM guest but the assert actually
> checks to see if the host has anything set in SVCR which is unrelated to
> the guest features or state, regardless of if those guests are protected
> or not. This check is also made in the hypervisor, it will refuse to run
> a guest if the check fails, so it appears that the assert here is
> intended to improve diagnostics.

This hasn't had any feedback for a whole release cycle - are there any
issues with the patch?

> Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Faud reviewed it during the prior cycle.

--+zXfBMQstQ6Z1UEz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbjD+8ACgkQJNaLcl1U
h9Bb3gf+MQZdJ0f4YsuOTSEO/+jdqHESFHKG/LBJhBkskYCnDDu5xzs5v/ICLZ+y
nXlhI6KR34Jux8pGsfe1N8qZhUCdLrFjchv58/T3aRv3wtJMb70E57fHn45LSIdI
spn3yJ9Pifjb4fhEj5S7vNvIAoLzPiBeC9WbQ5lc4yYk5UjB4p2ve4kDRplzMRKQ
ytfxfdGRSBvUB/61JOb4RCqET7oM03KLOSKE+LWh9gxpPT6j+40YUoVih/WCeXK9
s50hKPdifEK77Nm0Au1huDadMixBYj88veZxXSovvFx+k7IBvVrD+aevVyzprp7J
jfQwupRHjunFgAU1CQHorZZxmgqUPQ==
=hzB6
-----END PGP SIGNATURE-----

--+zXfBMQstQ6Z1UEz--
