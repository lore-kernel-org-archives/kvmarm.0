Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D29B36495D
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780414256; cv=none; b=jFXgYdqh/5ezMZJEpoc+AGZ/D0rE5OzbawZhnx7i7PKHTc7Z/dF7iauVbOWDlAqpC8Acv2OiY+2UmiVFCXw/UN60rqO8xdzi3vXOk1vSqCrqczeQxukWCZNlCvU/++L60AYQ9v1MdLtFLZmZNOjUu1xQtPcrnGbMHtxK5vFYe/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780414256; c=relaxed/simple;
	bh=0w9bwNHa2UecZxB2XFhlAwGJoeNBsQInIIZ5ceAdY8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osqk8XvTl4eoSBZHpF19W5ZCqQvC4mzBW4vnZ0hgQmT0FA7ldYAIKV73GLaUqIx/ZoZ4cGbW7yrMy42+UWyntkYgcQCNxkEBzOYoC4PDK7+IU0Xx2o8lG4GMf+9EE6/0bCDNZvEqQzmWrPqoEZAg7mO4/BgMbLZ01eNJBA8pGtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl7N9Yn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl7N9Yn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CB51F00893;
	Tue,  2 Jun 2026 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414254;
	bh=0w9bwNHa2UecZxB2XFhlAwGJoeNBsQInIIZ5ceAdY8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yl7N9Yn8hC36PKtqcw73mNk27lUf+Rc42GyAKT207hsRa3Imn007N/QobCMsp1FwO
	 rsvg9MH3xqSgXePkFNw+CGKUnVk0viythKJl4vwU32IqRMScKkODMtv/IFwqykvEVK
	 gObX6UOo98QNuG0jOqJUm4W8UYU4pDYvwtq8IzRcSpeGlFLaCROijnl3hinyRllBuv
	 03RYubSF4LZEdmk+OPv1HobcFL4WuGOlp0wUxEprcxZNLR3KaCg18GOjU7u7zPVvhg
	 qd/6iF06QpEZ+R3P+UUNlB5AhIlIbRQV0PnSqy8gEYl7Pmcw13PBfuPlfxgtMdNeU2
	 dthyommoVrcCA==
Date: Tue, 2 Jun 2026 16:30:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, vladimir.murzin@arm.com,
	will@kernel.org
Subject: Re: [PATCH v3 17/18] arm64: fpsimd: Move SME save/restore inline
Message-ID: <8dbd6e01-d6bf-441f-9ea2-15bb947f6d94@sirena.org.uk>
References: <20260602151150.925126-1-mark.rutland@arm.com>
 <20260602151150.925126-18-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LATmKv9d2Fyh2kDV"
Content-Disposition: inline
In-Reply-To: <20260602151150.925126-18-mark.rutland@arm.com>
X-Cookie: The wages of sin are unreported.


--LATmKv9d2Fyh2kDV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 02, 2026 at 04:11:49PM +0100, Mark Rutland wrote:
> Currently the SVE register save/restore sequences are written in
> out-of-line assembly routines. While this works, it's somewhat painful:

Reviewed-by: Mark Brown <broonie@kernel.org>

--LATmKv9d2Fyh2kDV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoe9ykACgkQJNaLcl1U
h9BOGAgAhXrneuUEueUUahSkK2Hk1hnf2xL4+ZlC7J7dS3wWunVywLYRWuegAV4C
BVYSH7LDgQpzslyJWIMvCwRA3CEP9unid3cwH3wsZhV4DrbsplYxOkIuV0wzfyK5
Ic4hC0J2KQJM2G9Ruv+V6Z9dP1hcSEa+fCuAv1PdovPHAksV2dLfLyykm06QKBkp
/u2S1ZKiQB7TrPDOVfSO9yss2r0PxjECPT+837FEpWsmDQ9zx63yKK7kf+lvr0Fm
qrcsXTQZsFXXSoTMHGJ0JSMT5iHHSiS1cfhpGShWBLKfAy8BzehhOtO2eOGydQmy
9xQn3HY755u4HQtSF5CylCGnbEbgXA==
=nDAt
-----END PGP SIGNATURE-----

--LATmKv9d2Fyh2kDV--
