Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2341760
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734634173; cv=none; b=LJqfhnDnN5N+s1YNbIiOzJNoZlcfsB9vifaii+oqei6nY/fUm4EvVgrUimWL1G3Uru6S2nMF2rdWh11RLxosKA//JrjaLmkB3QtWi/AJfNggBEcVJ6TL8kUgZlgqmYgLKTrSMv351j1p1ZRYEDk71Ys9U2h+iUgDhrmkW8g3NUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734634173; c=relaxed/simple;
	bh=/FLWDTPFbLG9DG5vzOMUOczrPmOEfAof7+piK4UuRCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NY0fdbxE7KvVp2aycZzgL/H2N5yKNvNQHH0N1VsrayuoMQQ5d78iC+/G7Ek2e5tHiTPr6SAey8GhLd6MYaLzeO0qYF1nrz8xXXgkgv9609EbbpOBMIhh82Qmlv0bO3kZsh6vGYMI1MFdU4IQOdE34AtgWoplcTHQ82j3tdULyhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCzzr4TX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCzzr4TX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D969C4CECE;
	Thu, 19 Dec 2024 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734634172;
	bh=/FLWDTPFbLG9DG5vzOMUOczrPmOEfAof7+piK4UuRCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TCzzr4TX35E/WB6YctHhMiH+VIJfPOGsEVrrnIIUz+m4ocaKkh57u4JuiNAfiCfa4
	 /pbe5jcnXJAmpWs0dlBZdDzF43U2KEAMFajh5S5QipBJEhZIXAbPSeH8ONlW3Hd8wu
	 Thpx3+mzPCjyg+BvF2ZEI4U77k5vVZ5jWlOkZ9h+Fic28C1bphU5KcfXn62kPdHKS6
	 VxvG+lLl7ZHntOGQgweR+6jxFYzfYHzRoHuPbmixq435nm5AMt5eipV54NBHr4o7Cr
	 jVSzLl3HNzyQGDq78RlwW+sSuDMqrWTkkZBl6ZdJMmEs7YMTHFk4UdCIrQkJ94Fopm
	 IIAks3/lx7kSA==
Date: Thu, 19 Dec 2024 18:49:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v2 2/4] arm64/sysreg: Get rid of the TCR2_EL1x
 SysregFields
Message-ID: <53a95b37-0b46-4ec8-bad6-a431f81cdc44@sirena.org.uk>
References: <20241219173351.1123087-1-maz@kernel.org>
 <20241219173351.1123087-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a+0hFz7K0adwt5ZB"
Content-Disposition: inline
In-Reply-To: <20241219173351.1123087-3-maz@kernel.org>
X-Cookie: You have taken yourself too seriously.


--a+0hFz7K0adwt5ZB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2024 at 05:33:48PM +0000, Marc Zyngier wrote:
> TCR2_EL1x is a pretty bizarre construct, as it is shared between
> TCR2_EL1 and TCR2_EL12. But the latter is obviously only an
> accessor to the former.

Reviewed-by: Mark Brown <broonie@kernel.org>

Sorry, I thought I'd sent this on v1.

--a+0hFz7K0adwt5ZB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdkarcACgkQJNaLcl1U
h9Auugf9HdJD/xc50mrg+8pmJHd5i5jsUnscG2fMzBioJ6tkmETXISrPkaPiAmgv
OnJhO1CFYvP4eHa/OSBoh6+8SIDVyIxS20q6wNphB4TmkcEu4jDKa7zJzcYCanuj
0B/9kq0uuVOajjg/5Fsx0Gtw9u1a28YJAjt3GlP7tHQXLnGt1ao0D8jr00kG7bvn
12zTsJ2gSJ9+/3X82hM08l91I7LFICIH0MQuoE0cJJkqWg9RBEqZP5OjWPtQ3pF2
NxPgnyt2N1sJbksED6M8V/Bmt2WBcgslnSQ98Gf/9YB8MndEDO+hj4N+nK1xpnQA
f6pBzicIWev9whRTmkmhIVNloAHO7A==
=Wlkz
-----END PGP SIGNATURE-----

--a+0hFz7K0adwt5ZB--
