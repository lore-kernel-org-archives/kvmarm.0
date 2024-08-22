Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE021CC8BD;
	Thu, 22 Aug 2024 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724340646; cv=none; b=Wz/X4evVRnR7WwshZJd8RU4WJ1e67MTddtaiqgQWWkIX9Ud8s2wOn/6OwDGPdC1SN6aQ7cDomFUtjj+/Seo6gxzllyNNlV7SW9YKKKga3jmKx5H0OQ4ZwOKFaf/tFfyo2ko8770K+KU162t8wj/br60oWSZA+GRcl14f4IAa2b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724340646; c=relaxed/simple;
	bh=fNNksmMvTE4gi7kf+4vVKOzJMSoXMkqmsgZJC2iO9OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WY7HDGa5V5gD8iy3iaYAMLvDgOjM9qPlUcd21W55SCmC5D4Z2A+Gih5UxNGpmVj+J3UCGF4asR8RYY7XpZIpbICd/yqZrkmSO7x2fbbD0goeNQ2FS6UVq9t5rdPnaamPup2NnF6rTd16T8xmJ3ywozbOvVq4dgZ50wpmKh6zESs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fep06A+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fep06A+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B9FC32782;
	Thu, 22 Aug 2024 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724340646;
	bh=fNNksmMvTE4gi7kf+4vVKOzJMSoXMkqmsgZJC2iO9OI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fep06A+LAHTRPbgxaF0lCjbSupZId/OTDdQ7NAlMUI+cpCK5V2eCTBJGeesMFAcyt
	 RZC5jGb0rM5hcwQo+SjF003CESqoAvhq8Cfg4tinULmok3imWS+0/Xnd7oOyGy6piB
	 LEuJikNknNRy3jrq8aMZwFTyC3MvGLpB0cfjzzHuQ4YrVkEjPgPUBQTT4Lo1RkACKt
	 q8GjkUPNZBJp9tH8UAMmrFR62iwgaloJecMeEoDN4QrcxFqN1kd8r2k/pE9T/YUXet
	 +caFSS2jVtlaagTZNkt8zj32sRfIpEQ6hcXCJySHn9K5LxAjuEDrrbWBE7rUzG+8PN
	 vyuol8PdN1tdA==
Date: Thu, 22 Aug 2024 16:30:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Message-ID: <ZsdZohZhre-fRmUv@finisterre.sirena.org.uk>
References: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
 <86ed6ixa32.wl-maz@kernel.org>
 <e123ee24-2a0c-4ab3-8dc3-2906bf96f38d@sirena.org.uk>
 <86cym2x7cv.wl-maz@kernel.org>
 <5304749b-04c8-44f4-b4de-b2d0cef61169@sirena.org.uk>
 <86bk1lygm1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IJeBry4BqKF0PMeK"
Content-Disposition: inline
In-Reply-To: <86bk1lygm1.wl-maz@kernel.org>
X-Cookie: Your love life will be... interesting.


--IJeBry4BqKF0PMeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 05:40:06PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Indeed, I was wondering about just adding a description of the relevant
> > ID register field to the sys_regs table.

> You'd need more than that.

> How would you express the visibility of TCR2_EL2? It depends on both
> ID_AA64PFR0_EL1.EL2=3D=3D1 *and* ID_AA64MMFR3_EL1.TCRX=3D=3D1. So it cann=
ot be
> just a single tuple { idreg, field, value }. It needs to be an
> arbitrary conjunction of those.

I haven't done an audit for fun cases to see how viable things are, for
the EL2 cases I'd just have an encoding based check for EL2 rather than
explicitly enumerating the ID register for each EL2.  That seemed
quicker and less error prone. =20

The other cases I'm aware of are more along the lines of features
restricting the values other features/idregs can have (eg, for SME the
information in ID_AA64PFR1_EL1.SME can also be gleaned from
ID_AA64SMFR0_EL1.SMEver).  For those I'm not sure if visibility checks
are the best approach, if we should audit the registers when starting
the guest to make sure they're self consistent or if we should just pick
the most directly relevant register and rely on userspace to enforce
consistancy.  If there's others more like the EL2 case that wouldn't be
viable though and an approach like you suggest would be better, like I
say I've not actually looked yet.

> The good news is that it is a much smaller table than the monster trap
> routing table: it is "enum vcpu_sysreg" plus things that are
> synthesised (anything with a .get_user callback).

Yes.

--IJeBry4BqKF0PMeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbHWaEACgkQJNaLcl1U
h9C/+Af+MbByv1L+B52uADnS67Ec9D2psS91HVogZh0GZYL0ocjeyT8EmRYTTxk6
TXxhFsU6z59ar/tVjgJCKa6q7Z+PpIfVzMCJKoZGoyb+uD/DKZuwsNmbz6CgoGiG
TBG2X1Swevv4+Ab3PoU1fUq+R04wKdwsvo8JjSSJtleok/5TqRdfwlRAR+56kY7l
rg6FZFl4ToXTyVkC74/3d3UvQfxmiuaOeMgDNjnMIJERTn8VAEAIdO6XSe5oid9a
Khe37r9Rm46y68qo8H4lbZYe2PeLe1OEORTFDqHFpIyY7H+n2sxNFF+yNKFEFLwo
Jw9WB1eLRPQzfeApX2HF2+tu5dZkXg==
=/6MT
-----END PGP SIGNATURE-----

--IJeBry4BqKF0PMeK--
