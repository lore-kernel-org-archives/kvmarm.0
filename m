Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5F014A619;
	Mon,  8 Jul 2024 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720462340; cv=none; b=PN3XsQZSBAMvaBeRZTgBJhoZzxrmgRqkCirNYyTJBvGBJWhaQIeHO+VCEMOZR/xF6LLjGacf8ydr8yjRjSsmECRmSTVxE0gYJ5X0MKldvfL3LAi+87zUEePvKCylre/xaU9AcOpf/w4D60kThmwSjWLCL7QRSrXXFrn5+zIEE2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720462340; c=relaxed/simple;
	bh=dfSIIph8640L3j+F3/oXa8l7Q2U92Wp9f8ImyBywmYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv3Oory4YEZCaPozaT2vRjj5Qi3OnqTHahcPbYulx23BZRG1FmKcVTwk5Oivj6meAzUbdc0tNyEXIvSSn7HrAvaph8UQEhL66YwVYf8iPkicaGfo+I4TDWVN6PbgZVzaHAaBoYHg+LrdAs8dH4eAMdyJwoC7TMaQ10N6WTX1JFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQ3mpz7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQ3mpz7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBCEC4AF0B;
	Mon,  8 Jul 2024 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720462340;
	bh=dfSIIph8640L3j+F3/oXa8l7Q2U92Wp9f8ImyBywmYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EQ3mpz7Fy6DgD3i9V4i0zppZ+ackgDpWqyIQKkX7aSAbBsoamrRivjgQOJQ3wLJpr
	 /SHi7maFX9flEGWHyVlpSPvK9I7+bAW1GGAldhC1uVoC+4jfFh0fqGSdrUiwLzA+U/
	 n1ogQlpHtaq/eJX1DrFGssQAxSFr7Aes9UrUnZNsvD0rpaM/e6djEet0LZLF0vsjuV
	 jtD4tacO2yTGag2G6DwhfOZefXQ+bUX6DO12HXhuRf+WUrbA5/ZemsD9XWJ1M9VLId
	 OyDu60R14KiR3z0gdoGedU/Iyl93vpmd1qUJx8jtUPlA8XzSLHc/Z/HU89ChsAvXcG
	 Q8XToVZSl0RQg==
Date: Mon, 8 Jul 2024 19:12:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <69e0d4c2-b222-43d0-b95a-686fee465f79@sirena.org.uk>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VcXe+ClQvdjQIrFK"
Content-Disposition: inline
In-Reply-To: <ZowGFl/1AEuevh96@e133380.arm.com>
X-Cookie: Many are cold, but few are frozen.


--VcXe+ClQvdjQIrFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2024 at 04:30:30PM +0100, Dave Martin wrote:

> One thing confuses me:

> The host could never use over-max VLs except in non-preemptible kernel
> code, since code doing that would be non-migratable to other physical
> CPUs.  This is done to probe SVE only, and the extra bits in the vector
> registers are never used at all.

> Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
> just as regular KVM does for the guest?

> (I may be making bad assumptions about pKVM's relationship with the host
> kernel.)

That'd be another way to do it, constrain the VLs the host can set - I
assume there's something about how pKVM or hVHE does things that makes
problems for that.

--VcXe+ClQvdjQIrFK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaMK/0ACgkQJNaLcl1U
h9CcgwgAhKlyjxfW4+Ot8Z919qxzzty8vnvRjVgxKSOxN6kdpVj78smo3R328/AB
/Igx4H5XbmzGy9rwYdhvU63bROvvArzVgXvn3Z4tDe2ievCsLmsoHrSBHHOwwW5q
5YqQm22MhwJ2l08axfuboCNqNa3MPijtXIsZyLkwBvHtZrd52XVZoCimv58rQ6ya
gnihvtDJlXM/BPJ5cgWJuZtTJk7+0k3ETjMBHvQxV6ar7P6g/UCd2h7F3nM/N9wE
i1kURSEgR0l+fT/hBxI63bj2IZFOpdNz0ZZM+LB5NKp8rUK4OPMQdIP9azNVDTl5
VpsDwosilUyFpFHHLiTZvQH1PF2Yow==
=Y2Yf
-----END PGP SIGNATURE-----

--VcXe+ClQvdjQIrFK--
