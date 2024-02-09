Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C8971B3A
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707493332; cv=none; b=onUQ4sQK1UoZG+CdIxAq/Jw6uI5uAEwSxApUvx50O8AvUSq98voT7AlUKvujDtVG9IcUcW4nobE5b1/2OW564BPWimEMium0dc9VtfIelqUQwu9GDbpmiSF2JQmldNOfPWE+xxSvwDqoYhTQh767QWHAY6xhd5TQ8Td0xpznPZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707493332; c=relaxed/simple;
	bh=+bEs+DfKq8Mq+wgYAL/f+WW8DZDrXU4CHn4XQ38sTZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwCjIpQn8L+GJvVs7r5YoCYe+IwGMH0yoV78mNAvkfrOm1ikgftYdwSuPSO3Q2Alcz/3kbLyh0dEdpjU5w6LlBe4DgENN4F7h+3gOqvXmkpey7ukyvF3d6GWsFeSAzQFpLBcRXVmkHHonWtI294KvwvJWFn+wRPfAykPvecq5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUAQV53V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUAQV53V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50933C433F1;
	Fri,  9 Feb 2024 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707493331;
	bh=+bEs+DfKq8Mq+wgYAL/f+WW8DZDrXU4CHn4XQ38sTZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YUAQV53V2Fo51VAmQ9FKaKGxJ82gZBCl6325rRP8kjXHk3pnl119DQ9bkg1sCyzzK
	 a+aV7K+HJXf/qd9RXX+Nhzj9ZtJE5/QXDmKack60mDLo908EUYZvPrnDgMSB3aAvKK
	 RhQuBPJncmUkRUJSCh6o1Uc8HyveZLPr02R9W+xhvp7CZ9QqYAEgZHaM03+wSqyzSN
	 7Kt0LsHUPga6r+fj+z5qEw26XpSYeuWYXpG9U01rfi2WI4+DmQdVeUsHT26S9LdYti
	 dT5P1OVWMLgcBdJha043xVn/jd+u4gN7WlyFo95kmhxeLi/tHjdHw3OFiOhmoEhgYF
	 6ufRsv1oFW1DA==
Date: Fri, 9 Feb 2024 15:42:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1] KVM: arm64: print Hyp mode
Message-ID: <ZcZH0JKqoQbJ/fr5@finisterre.sirena.org.uk>
References: <20240209103719.3813599-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HXFF99BOXES5TVD5"
Content-Disposition: inline
In-Reply-To: <20240209103719.3813599-1-joey.gouly@arm.com>
X-Cookie: You might have mail.


--HXFF99BOXES5TVD5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2024 at 10:37:19AM +0000, Joey Gouly wrote:
> Print which of the hyp modes is being used (hVHE, nVHE).
>=20
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Mark Brown <broonie@kernel.org>

> From what I could tell there isn't a way to tell which of the two modes w=
as
> actually booted in, and this could be useful for looking at log outputs.

Something like this would be helpful catching errors getting test
coverage.

Reviewed-by: Mark Brown <broonie@kernel.org>

--HXFF99BOXES5TVD5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXGR88ACgkQJNaLcl1U
h9Dalwf/XD7w86f/pjlmWp+kvOZMvPlxVP6WaDjIAExfWpgP5gRQ27fjZuCpww46
AO6+0P2v4JvBxw+WwtwqxfY00AAuVnYEhJwGvwtGRjOEb1mdfA355w/MGTzaNA+J
BdS2zx8Cree8//eOi9EFx6N+MZqsqFT6G6ucSD6Pq1l/Fm+SehhIc4Cjjb1bcINK
xvpOc2yDAGAfQ+s/yoXjDmaWyXjoya57rVkdNmjYeEcB2yiMroVXu679DUfKigOW
lNEKsLbrhQw8e/m0l8eV+//eIkVC+cM9zvCxIa510q8dWI1et0DMUAzAtWg+dMxE
TFQlcnWRrhVx7v+LU+s9yCagxnnHAg==
=eheI
-----END PGP SIGNATURE-----

--HXFF99BOXES5TVD5--
