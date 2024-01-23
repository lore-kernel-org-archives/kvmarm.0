Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6380020
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706031749; cv=none; b=n+NLnGDNEM+sIeEnMmW6iduujGRYhwZU5YoIjIn+0WLRcJ/ik43XVGtXQXIXoWrvyjZiU0Gm4RyfzaNn1CmOqh+HS/dmh5jeF4HnUF2xZdgCWHERqFH/lH/tg8Sm4Th27qv6CcAI3lSCEsgNiyZGaY9mIO8niXN3+IobK/jOcnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706031749; c=relaxed/simple;
	bh=fhUL4FiFMrWOe/VQO5lFiy7nE9tY51HFggrcHQpD91k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQKl2wT+zNKVAAfIAMdlNaHdM6HnAQnYGFAa4G1ClM/lFK+Y+U+cdHZLTGO73pDJaF8IlOjLKr81v6Rhkjp+wzYNNX/GxKpyyjX1s5ZjbyvFqtetwqpZz87WWhGeTD4YlxN/ctYb2h313upUeR7GofW0We+dilPHceZwX5we8DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mD2ToyrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mD2ToyrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B593BC433C7;
	Tue, 23 Jan 2024 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706031748;
	bh=fhUL4FiFMrWOe/VQO5lFiy7nE9tY51HFggrcHQpD91k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mD2ToyrSTmsnUp2JzuoVQF1q1AfEDuV9zx2Ix/WTOsqmd9NC7qGWcEtEkH8B3SvFj
	 0o0EUvQY3rmYL9lHDWFDVfn00ERGObNQLE7ktaK3wto/xxK0g28yFWBWVijnTbgOX2
	 2leU2zijQ2daHwYlTzcRLNoUQFA0j2hljrdS8qvqjx4r21pGDf6hDO26rGH1+NUbLv
	 9kczzhG011PLY0tyBASulEwYo4k23lN3UoB7HriNU6XO6qvlsLlYCiN1T11hSqXgWB
	 Xr7raqCeBT/Exm3zqypiFOKQd6My86gqoy/+TJn5TryNjriG0I6ShPCV3yUcRc7uDA
	 K46o1798k3tKQ==
Date: Tue, 23 Jan 2024 17:42:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 08/25] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
Message-ID: <e17ba6f6-6fdb-48c1-8805-7de9b8fd65a9@sirena.org.uk>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-9-maz@kernel.org>
 <20240123141433.GD1283334@e124191.cambridge.arm.com>
 <86jzo0853s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qPZdOc7rTX6ZmmkQ"
Content-Disposition: inline
In-Reply-To: <86jzo0853s.wl-maz@kernel.org>
X-Cookie: Stay together, drag each other down.


--qPZdOc7rTX6ZmmkQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2024 at 03:03:03PM +0000, Marc Zyngier wrote:
> Joey Gouly <joey.gouly@arm.com> wrote:

> > >  	case HDFGRTR_GROUP:
> > > -	case HDFGWTR_GROUP:
> > >  		if (is_read)
> > >  			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
> > >  		else

> > I guess you could rename it to HDFGxTR_GROUP like for HFGxTR_GROUP but that
> > means changing all those tables, so I think it's fine.

> Not just the tables, but also the arch/arm64/tools/sysreg, which
> distinguishes between HDFGRTR and HDFGWTR. I'm pretty sure it isn't
> worth the hassle...

Quickly checking the current definitions in the kernel there's
differences between the traps (eg, HDFGRTR_EL2 has bit 63 PMBIDR_EL1 but
that's RES0 for the write registers and there's others).  Some of them
are just no write traps for read only registers but some it's not so
immediately obvious.

--qPZdOc7rTX6ZmmkQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmWv+n4ACgkQJNaLcl1U
h9AFUgf9GFkCQghVP/62QIk6INn4LxyxqJ+9K/Kbd7C5K6ncJm9CN2chZ8EErW7x
STRvS5FJKBWMBxTjSozzuaVvO8mK8X+QKTNqzgaPaLhdbXuKDqDCcfB08UZuc0yc
n9v+xOBR8SOWU4d415HJVoBUUZwtz2mVKVUYRK1brbBZOROKeodzKhqIQ/jY5pGU
k47LefHiWgJkIzRIJWyr9Q86FIeqqTa+MQAGIkN0ni3+dlDrcQ2sth+ao5Sk9P0J
nrokZnG4FZ/vAkHXvFvvISKvMBXaNOZVEDjYe1YQLZOuiAqPNfcvl9g38g0VGH87
JhcUGY/nZuOBAZu6+mMiZLhtm2+FdA==
=gyiC
-----END PGP SIGNATURE-----

--qPZdOc7rTX6ZmmkQ--
