Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BB76F2F2
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717429954; cv=none; b=Q1Cbz2nUbCno95G37Pxfk9QvS+YBjqdoRq/pD9gxaIrnUXK9YTFdqhGqowIOavihmOdI6+nGP3caVv6wDL7AqJerTcOCFH0tRn29B0G7vWW6MTx1g8l2wTfS2XtkS9G1M0MggEiZkahWoKcpmXnKbeo14ifLIFS2f8mYZtxB09M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717429954; c=relaxed/simple;
	bh=QqQTNj20ySOU2HIOFRbla2Zdycb8bxy0wo6B150r8+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eggW5acCMd5YjVm7PGuD5gmrtVZ1dYEDNousJxkkn1+Q/2CKQIlSav5DmLKA5AZ7RBLx5cw+Q+K7x+m7zOeRgL41A2lJFSHL3tiAgBHzzAAVQvLr+VxRBCfxyu0F2z32Bp0Xr4vu+E2/GQEn/pwOsZiLhNGWyNk1FF9jCdKMao0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qINereOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qINereOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B639C2BD10;
	Mon,  3 Jun 2024 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717429953;
	bh=QqQTNj20ySOU2HIOFRbla2Zdycb8bxy0wo6B150r8+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qINereOD2P+S11msJum9WI6VYNZrq2303IruAkuDhYMKd3mwNEK3Kf0uGUzhWBVTW
	 UkkAaSDYRr1cICm932bgGdbTrQyTm1d37dC3BUL+QxjJJ6N2yu3ZfRXOEp+1GqS3e1
	 YOpzSlIezOUEBiM2h9thG2oRM/GUhhYzYb+9ahGTW3D/4LaQ+kKhiGeKXg89e1mkjF
	 rdlJKnVNrTdd6Zy9klduRo+Vk+99okjfDAqBZuicsoZw8lUDBrGq2N1Dz7wJAi9/sL
	 Wl6oJyIf9PU9mECtXHMi1RjDpt0X3uh+G4C4pURzHL75gOPEekWoliQ6kFq7oDH4PZ
	 hF1hm1xcu/BsA==
Date: Mon, 3 Jun 2024 16:52:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 6/9] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
Message-ID: <728c100c-ea38-4802-832d-04521821d169@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gaoct9zOdsi0v7by"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-7-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--gaoct9zOdsi0v7by
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 01:28:48PM +0100, Fuad Tabba wrote:

> +static void fpsimd_sve_flush(void)
> +{
> +	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
> +}

My previous comments about this being confusing still stand.

--gaoct9zOdsi0v7by
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd5roACgkQJNaLcl1U
h9CeKQf8CSjO/8LLzHvjMRPqsGUf66ditOlGpYvM3+qQZw5jG1m/Msf318W9Kg5q
fN5gm3g3EfxdmbZENGGmbmIqXyyXrNRhFTLuJGTO/+yrwhji5mKgsmXxpQ7+swX7
FJLFli6nex9+XdSvyxzUzv6+czhh0bH3FRN5+VfCLzSWhWugJOT9LrLB46vKdFg5
cZZrJIhCyDSjbNIH3KMzwi2ctYt3FGYvwrKbGsbhwOHy3czMDuOKzP1evPt+AZ4p
/yJODzQcMJj7iLfKzn//OqbLU71UkErUeXTcnkWf+I827zrOgc/JMi+j8bKma90m
bcz4cbet+O8lApXUlNuN9s+Lqsuflg==
=WsUd
-----END PGP SIGNATURE-----

--gaoct9zOdsi0v7by--
