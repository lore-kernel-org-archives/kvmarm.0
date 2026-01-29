Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75A61DF73A;
	Thu, 29 Jan 2026 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704872; cv=none; b=tMP/voGJ/8zGqrrsEJwD2jVH4vQ0sU04Py2yeYP9C58JXTy24+uN616zHkfPLr3VY2F7qU4cTw0yL4EOFxKm/WiuOSkIhbKjoOIOg9ujC2SJdYyb0/icpMHgkJM/4SNt5MnwnwHdUAdJo76zQRx1qUKggCyEct9HE8etgSE444c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704872; c=relaxed/simple;
	bh=zcYhc4E9Y5we1LZNadqpVIred1H/htdcjoFQTrA9p0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABUuFVBJjYUwyazVOWQUeuvqK1Fa2Aq/a9GwzLBVG2yXVkswzFHMGcECzZuGXTopKxewvwZotscv5QFKnMT/e4/ZRSO8v5YwivaGej5V8ppbmkFGaMxGSvaH45AfTgHW3W9yH8/OX5lNquwE2TypEaaO8nUk/v0Dy7bcX8pHNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ulEmku+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ulEmku+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA95C4CEF7;
	Thu, 29 Jan 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769704872;
	bh=zcYhc4E9Y5we1LZNadqpVIred1H/htdcjoFQTrA9p0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ulEmku+Go6b0WZUKmO2rXfq/EdAAnWU9xDDkJwNvrBGhSH9iaUbXaaxV3lK2hTYqz
	 +F2eVVpguOE6p+qUDt0scevvaS6IL5HqC6Ig6SzquPFM3elZSCDcNiaoIayZ0dCiQN
	 pJ2GdRSuNcO1YoszZ9X8DKHDJa9hZdzZJcFyJbqogsyS3A/tnRAfyF4qh0uE4ioMFr
	 HIWj+xu4nQo3Gjzb/SeSk3Bva4DCXzVyR6yJAz07MqAzeRREZhdGwFuVKWiy6dsAkI
	 UChEsqTzfEwkzN+Yce7zftxRM+0o+pUTGJMFprU9C/c9JfG6nn0v3lUiscPqDY/Qs7
	 pn9TN0yjBkGJg==
Date: Thu, 29 Jan 2026 16:41:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
Message-ID: <76bf33a0-968d-4b99-a157-3eef076af69d@sirena.org.uk>
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
 <87343o8jay.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ISN2iHKE8mStxhEz"
Content-Disposition: inline
In-Reply-To: <87343o8jay.fsf@draig.linaro.org>
X-Cookie: You have taken yourself too seriously.


--ISN2iHKE8mStxhEz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 04:39:33PM +0000, Alex Benn=E9e wrote:
> Mark Brown <broonie@kernel.org> writes:

> > Currently when deciding if we need to save FFR when in streaming mode p=
rior
> > to EFI calls we check if FA64 is supported by the system. Since KVM gue=
st
> > support will mean that FA64 might be enabled and disabled at runtime sw=
itch
> > to checking if traps for FA64 are enabled in SMCR_EL1 instead.

> This is conflicting with the now merged 63de2b3859ba1 (arm64/efi: Remove
> unneeded SVE/SME fallback preserve/store handling) so I think this patch
> can now be dropped?

Yes, this should go away in the next rebase.

--ISN2iHKE8mStxhEz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml7jaAACgkQJNaLcl1U
h9DOuwgAhasPmpBc5eULaLz4BwbLAgPXJs1nnK3Uo10v0P6qi43SvtDZav5SiPTZ
ECyUrltHOpSjnbvnEn/i7lOw/lExJCneXkO58pfwuVbCLSdYXjQzCOy1Qau6b0ZA
A9eRgPI2XX+UVJ7+aqYbwrvj1hVab3W7qYM/YL8nNN91Axx1FO3ERpdX9CP/Zxiq
yCW+gCPqV1IeMCGVHV3dU8gZpFm6WXJBokYrFSuoCbKmSQujsYsJba8n1mZORZDf
Y4Af37gikWOQdw+cxZXbsfM9FD5B7OZhxmXFrKp8ZoOSFTUBdTQx1Mb9nKNpL1xE
efmMyBYUlPHYfwuWW7EQyCDOEqk2iQ==
=FKQt
-----END PGP SIGNATURE-----

--ISN2iHKE8mStxhEz--
