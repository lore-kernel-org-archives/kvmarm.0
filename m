Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D04E3B6354
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779812908; cv=none; b=hUmv86ESn1p5NSjXOussjgPgBIsGV0QiFO7uVQJTtpesV84Kob85DPWEp5pmrw91V7MpwC7xAknRKqqjvt3NmcYPBHudr0iPDP9ftibtljQ/ERJphwtFi+2ec1LtObQN2a2G/S9H8ktozp59xHu3p+ts06luwL98RBsLu7/Hh4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779812908; c=relaxed/simple;
	bh=QhyvTXim6xv8G2Igvwb88jl5G7F7RAfl/WzY91sASGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETERSsVG8C2eqbR7/Dsdfg7G24ItDQaEf2dA4PoU+rmfuIi+5ztdkdUUm1DYq1dqwibQLncVFqgSG3DooCuIsuLf+fIIlFJokI6IfTJRlsZFoHwFmupy1SqMA9JIA3inoFqS0xHzxr609nEr13RJnjhWs4WhCWW7/sePrdulvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPdZliYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPdZliYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEA01F00A3A;
	Tue, 26 May 2026 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779812906;
	bh=10CV05B4Bf60Y+fl91AsN6EkMAQfJuECfWP5Qoqx3dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FPdZliYwuVlDWy6WguEg5j7Ifi+sw6SQH+mdJ62hz5/5PnobN4qqNIt2oxAK2x+Y7
	 fnq2jy8k+4CUP1NimKrHrNIvdC34p3j8KV6khuzhBN1CYolTty7nrPgRHUmGlTziLz
	 r95NV0dHvXFwwDlxj4ZGqMGFeBn4uX0ogkCsF61sGTzxDpmwNNTNy/6TDflqzmdtJI
	 JwO6ySo6VJLSYwP/gAA343CAkDkedXKyFr6h6XmJb5VHMhLYyYSyyjkeranT7XsiNP
	 kp8FsbIoAb9vNyDjHN6TQeY7vXKIXFvFf+bPWdFFvOyrVlFNz2YHkE+AR66uY8tG+W
	 hY0xGsOoRyGrA==
Date: Tue, 26 May 2026 17:28:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 11/18] arm64: fpsimd: Split FPSR/FPCR from SVE
 save/restore
Message-ID: <0b72df66-2914-4537-811e-2080e0a7ce6c@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-12-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Mfin5GylmbypkmA0"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-12-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--Mfin5GylmbypkmA0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:49PM +0100, Mark Rutland wrote:
> Regardless of whether the vector registers are saved in FPSIMD or SVE
> format, we store FPSR and FPCR in user_fpsimd_state::{fpsr,fpcr}.

...

> Note that the SVE assembly sequence for restoring FPCR uses an
> unconditional write to FPCR. The plain FPSIMD assembly sequence has used
> a conditional write to FPCR since 2014 in commit:

>   5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")

> ... but this was not followed for the SVE restore assembly implemented
> in 2017 in commit:

>   1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")

> ... so I've assumed that this doesn't actually matter in practice, and
> implemented the C version matching the existing SVE assembly.

> For the moment, fpsimd_save_state() and fpsimd_load_state() are left
> as-is with their own logic to save/restore FPSR and FPCR. This will be
> unified in subsequent patches.

There is a possibility that it only matters for older, FPSIMD only CPUs
or just that nobody got round to benchmarking this on physical CPUs with
SVE and in fact a similar optimisation is also useful there.  I'm a bit
wary of dropping the optimisation without any verification of the
performance impact, but equally I'm not aware of a specific benchmark
that showed the impact or even if there was one in the first place.  The
changelog sounds like the optimisation might've been written based on
inspection alone, I don't know if anyone will remember more than a
decade later.

Having said all that given that a conditional update is simple to
implement in C it seems safer to add one in the SVE path than to drop
it from the FPSIMD path.

--Mfin5GylmbypkmA0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVyiQACgkQJNaLcl1U
h9ADfQf/e+eVCysek/Rk2yi/gjzQrzmJD/scHCF/WIVmFPhoPMHVpAMAoBCemkrN
rscyp8YRk+C7EWrLEsIImV85M8hnqCGrsV0kFPTS8d7TDhjcblV2jTyGrHT5Z35p
T2Of9t9EPEyPq2pMVgjO7L17PzlKenBUVL9HEBqhEumPFE7GuWPWLAHr27ZwkfM7
ySJl1QL/2nMjVMoSehbb1MADUX7CkEKF+G8TpEbkElUtGE74VxVmfseDG78O43Dj
AMOCsO+4VQ4o+/ZPz6hjtWEhq/bdLY5BKeTc4+dXgbuzaMKBKzqzT+ZWKWBhjYas
uLiJpyzi8VVmDJuS0JOxq1sA7wshnQ==
=lmvM
-----END PGP SIGNATURE-----

--Mfin5GylmbypkmA0--
