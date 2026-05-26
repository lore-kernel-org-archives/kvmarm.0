Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C43AFAE1
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814450; cv=none; b=VvKsVflfV+2i3QG7hSODKgzaDyRQPvXviQ4O4gLpVS4ngrzgpFT7qMJDjH8hEBv0PZQIALGp7fLoQsf/efdtvY5Rky+0OSDGEeeDKivJ1kcyCYwhjEyBaSjTdNrl7e3QlO8hkkzIlANFwneiT9YSrmwQg1QAp/2T2TAAMu3CCpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814450; c=relaxed/simple;
	bh=Um/Huw45Fb95EMWsThYxwZA99mym7pzLBXcKZEuyxZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVioHGFocj9R5pZbrNtILoO6DptO1bNk6tEA7r4xtMuG3KnOABcQaxetPLDIF9JPMWAU4Xo48vihTGLAwiEonTV0hnHRBiqsbQfUD6HTLfyOC6OWKfEZJ/36hI5kgmQmReyitsv9/r3KSQl/7iFE+uenUAEq9E9QjKHnNRKaMrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1/TG0ED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1/TG0ED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802721F000E9;
	Tue, 26 May 2026 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779814449;
	bh=2IIlpLx0gVxMf1NX1FfVzjs2W/yK8aRs/Ll1LDgBL2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1/TG0EDeggoAqtI2uQdIQ66PF4Rn5aFdPojqDn6eD1yqtrYN1Ou+8Zd3bLftyXbh
	 88fNbWbnDfpyoN6WdL9yNiyB0VzqmtwY4uqpUIiqNMpjByeFkzBxgo50FQavPObmfU
	 AuVycqk7LXr6aB1lw+MsEXbwjujjsRNBOfZ732STmtxjIaimXf9Z5HmnA5Gj5dlf2j
	 cBQ9SlOVA6UGCWesn/FvaNbTGvFnmUN2wi+3NBeyPGnrSNwnyJxWZ3idMDZfZFJNi1
	 7KRTCJwUzhOXjHCMU4GaH6R1xXyxXed5B+/BitTBRiU8AK3oBvyCo0DkJ794L1+mTM
	 CANxyZiwlCvBA==
Date: Tue, 26 May 2026 17:54:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 10/18] arm64: sysreg: Add FPCR and FPSR
Message-ID: <ab133439-fbe6-43aa-915b-3c86903dadfd@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-11-mark.rutland@arm.com>
 <458fcb4c-46a9-49db-a179-9081d7d50dbf@sirena.org.uk>
 <ahXPqSPB5CEUbRdz@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qOEWLsYDc6kbwQtt"
Content-Disposition: inline
In-Reply-To: <ahXPqSPB5CEUbRdz@J2N7QTR9R3>
X-Cookie: You are fairminded, just and loving.


--qOEWLsYDc6kbwQtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2026 at 05:51:53PM +0100, Mark Rutland wrote:
> On Tue, May 26, 2026 at 04:55:44PM +0100, Mark Brown wrote:

> > > +Field	30	Q

> > DDI0487 M.b and DDI0601 2026-03 both call this field Z.

> Sorry about that; fixed locally now, and I've double-checked the rest.

Yes, I'd also checked everything else - sorry, should've mentioned that
it was only that field.

--qOEWLsYDc6kbwQtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoV0CwACgkQJNaLcl1U
h9COlgf0CGry2Yvb0LukONvwzgnJ8onH91aYm0sqTr9N0i70Yj58xnyEoKc5CkZU
4vRvoOYL+lVJSb5gGfSuBOkUjvH3ixcEZPr75PLo1vjsS6tNGnUBhVPwI4jc2J68
1qbuP0UIhfk75E368Ydm0Zqn0tyBlqtrfORmlNCG2s1cL9xCpewf9ck1WhE4wLwx
wy0+TQzSu8ZtrxY9IVZx5ARcgeHyYr4AQlPMHD3T3JaUxzgxvmfmGu6Yy+P7sf0v
WiI1XeOWlYGZH5+emnwHMFq+0gdUuOIPl8nWYUD56pMrlOVevetZgLRu0E0N29wH
zoDzFkwTTgHGcnHPBD+DgvZiUtFd
=KwTI
-----END PGP SIGNATURE-----

--qOEWLsYDc6kbwQtt--
