Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13D610B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAZibPng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F29C433C8;
	Thu, 14 Dec 2023 10:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702550786;
	bh=fvcIaz/o6l7V5+3cQCm6opb1Hs/eXB/QMXOH6MB9u9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sAZibPng/8VbgAjjrJNfyCdzveAhzskYgNyX72WVWbKG6anN9MyauNO8Ff7/9gCgf
	 mgLtjUdN+4/yOvMF8YnxUNEEpAFjUFzU/0FHmC5XYySggjwKNDwSIrAeP9bt3VUqJC
	 d0FSH3kaqOg8neglLyYaQ42y0i7X9S0Yxdv6BQhxN8RfeJrg2JLIPvOqEz9AWk0tyU
	 BySP89XH1Q4WuF6VhY78v9D/Hhg2vt4r8Fcxxpx5kUg/5Op6PA8oVSo76XN8lMWpMM
	 h3Zxq2cPbiw4+DueE+98hmow0JVzqpyCeABUKjFUdkqFlvHX5P+31vdzRPij55kfq2
	 qMNI8ewAo4vvg==
Date: Thu, 14 Dec 2023 10:46:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 02/17] arm64/sysreg: Add missing ExtTrcBuff field
 definition to ID_AA64DFR0_EL1
Message-ID: <bc735ea0-80ae-4c50-8cdb-98db1abd61d3@sirena.org.uk>
References: <20231214100158.2305400-1-tabba@google.com>
 <20231214100158.2305400-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WQ1HdTszyCohK+oJ"
Content-Disposition: inline
In-Reply-To: <20231214100158.2305400-3-tabba@google.com>
X-Cookie: Preserve the old, but know the new.


--WQ1HdTszyCohK+oJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 10:01:42AM +0000, Fuad Tabba wrote:
> Add the ExtTrcBuff field definitions to ID_AA64DFR0_EL1 from
> DDI0601 2023-09.
>=20
> This field isn't used yet. Adding it for completeness and because
> it will be used in future patches.

There's also updates for PMSVer, PMUVer and DebugVer, and the addition
of SEBEP and PSSS.  The changes here are fine though

Reviewed-by: Mark Brown <broonie@kernel.org>

--WQ1HdTszyCohK+oJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV63PsACgkQJNaLcl1U
h9BFhQf+JihZwqpfvQHZbgR+QpWI152YieQlesG5ucqJiu3nvRZD2zMkdafHE8l1
7JQHRRwlmc7PgRc6OWTwT+QQ5Xd7Nu+/hs2ZEueYrjqCAWnUB8ExHVOTePQ2Zkb4
CuX/Nuuy9rpVQ5wz0OXTTGi00OSFpiSgnouNXtkt//WhgIZR6Box7IslqOYnCfpF
9pU2x+5RMd6sQru0D0fFshTujYBf1w8aFxiYbtcnNWQKYRGwxJJCCtdswIzJp2Gy
8A6aiamzJHzSgwM4A7HHxaiMiEGWWNvbyi4g6LADCeNnYQXVfpRRqsuaFWUlijOo
4VPbuSAGn7jIvA6mkJt08yhMUfgWlA==
=ApHS
-----END PGP SIGNATURE-----

--WQ1HdTszyCohK+oJ--
