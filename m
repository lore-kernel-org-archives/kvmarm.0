Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C153B95E7
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814398; cv=none; b=h7id+xH+7lpygHW7QegzUROshop86tFvaDkMkGSIcqMqknqekq9HtqZCFt09RLOfLgy08B8MhO5uII0Bs1tHIRF/kGhW+iDwq5g92dt9oS5wPwQaVqYz1QOlGOj+wFuQzzVmyK67zokJzqwzf++vbLY2FdVmwgRRkyvHbW+gpHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814398; c=relaxed/simple;
	bh=jK9jcFq1vc07ukH7wHSulTaGgBefpAjVxgzyk1JHzbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8FIVSBb4qoeEdsjZkD+Gt/UDuAg01jCBuDRCUJ+KRNXv97UOmcP8EzHpRmhaQrp4XjTsvbsSOPrdLWgz2SYs3q0lo1LzlzT5l/6TERMXJkCJzgQk1sMIm/F/RMO0+ykgyxxv5DLnzeKwxss3T19JmiysM88Aee9Z8AyOkKUCpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6xB2+c7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6xB2+c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7F71F000E9;
	Tue, 26 May 2026 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779814396;
	bh=jK9jcFq1vc07ukH7wHSulTaGgBefpAjVxgzyk1JHzbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W6xB2+c7RYJyl40lpiS2IpzQY8q5QSb62k/MClm/j5R71ayZ1/45QmedNZeON1GtG
	 TUXkU1mrZQrY6IyvDUeqC/vUW05ALiyAV8Xk7S4AzoiUKGwNDk0hy6pKbxWq4RunJ1
	 C1bgGWkfNXgfMlql0YyjIPB6hYpitwMXZs448wlaZLNHDpVURg9qsqpufRruYs4ASS
	 Giv6/68wVItfOIp6SZDUnoxoJaty77KrkE3g2WKSfLltKlt58RjPd0LJYcyN+VwnuD
	 tx0wfspqBg/x3AUf8rAUtoskrq+pf8Vapjjhe/b0lPcqQ0CgF1TnyFGPtNWJ8Cq0PE
	 W+UktFjGYAE+Q==
Date: Tue, 26 May 2026 17:53:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 13/18] arm64: fpsimd: Use opaque type for SVE state
Message-ID: <5040107f-dd52-4021-a93c-1440325fe033@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-14-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qLyeM/IcLOyxcZsW"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-14-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--qLyeM/IcLOyxcZsW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:51PM +0100, Mark Rutland wrote:

> As the SVE state size can vary at runtime, we don't have a concrete type
> for the in-memory SVE state, and pass this around using a pointer to
> void. The functions which save/restore the SVE state have a very unusual
> calling convention, expecting a pointer to the FFR *in the middle of*
> the in-memory SVE state, which is also passed as a pointer to void.
> Passing a pointer to the FFR also requires that callers find the live VL
> and perform some arithmetic, which callers implement differently.

...

> Improve this by adding an opaque 'struct sve_state', and consistently
> passing a pointer to this, performing the necessary offsetting *within*
> the save/restore functions.

This is much more ergonomic:

Reviewed-by: Mark Brown <broonie@kernel.org>

--qLyeM/IcLOyxcZsW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVz/cACgkQJNaLcl1U
h9D4tgf/XYMJ18LR7+UOUtuyLBF35gpK3kMYzRv8PyJ7gD/VV/VZpxES43FguMmz
2oVFV2Kzdl2pUo6tvqe9OV71SC5I07Mek0ZZy3JG89GnEGZd/a1kCuXCvahz8WMc
jx0bBCtqH3Y4rSTXyNtqtvHxghCxKcmyRpSQ2ohGsOcII1u2oq/m6GILNxuBl3Xh
g22UUTV8grDSENv6cA3YU7meK7P0j2yQbg+9Me6wgmCzVNne4nUSNbvmYl3ImOel
PoaUMhylg5+CjPP3vIShRYXPNMJVQ3/jRP2sHTTfcAHOy2CUe17EL32HX3LRg1yK
jQZi9jwxgxrZox8rl4Kd9dYxuEPeOw==
=vK/5
-----END PGP SIGNATURE-----

--qLyeM/IcLOyxcZsW--
