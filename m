Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B31A14F9F4;
	Mon, 13 Jan 2025 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787752; cv=none; b=JIqnB80W2Qg/rLLUrZ5G1rxnvu7JJBAAaFj/AWuWANQPRrty1WJy8J4PVA+5R5aFpkvsAFTVh9mAbqk8KFrSuC1w4P7UWTszEbGLaOLMKufQ/DrgPY5K5e7ZkTaChEm1AzPDJPbgTnjp57bxauUEIvTug9qIBcpp17HGp0aIBBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787752; c=relaxed/simple;
	bh=s19CEAGQjEkgbjrj5F4lWFyemfQPSIUWWA4sTAuxhsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYkLzuLu2Yln68IqoFiQ6EV5WWkhZN9i+MJ+41ZXAeh3kZuDpy33yJJzolb9MLuqeEy/dXJ9loUb+W2w+pIIh753kYiqsZ5KT3jFfouJycq2Yr99/Li+VFL9DCAIdWsdaFrdwsz0ATotmtaLnP7OKT+3JlcSUpZnStxhefA6vYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tEwi4e/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tEwi4e/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C24DC4CEE7;
	Mon, 13 Jan 2025 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736787751;
	bh=s19CEAGQjEkgbjrj5F4lWFyemfQPSIUWWA4sTAuxhsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tEwi4e/vhIgJghd19EYbuksAW5q7HTkMSpVJoP8VYVt4QwFqUvCsB16h5YKrhi1Fa
	 hP1cHUEbGqrQLgQk9JUMNSegzdy3HeVY422dvAT09HKHI2QvKT9gUY/KZWGRvKX6vO
	 Ali6n7kZZsQ6NfiCslHqyGuPaLwei2YF48oxiwEGH86kyTI3Sds4aQUS0RZr1esKsJ
	 8qKTqw5ozxd1roZwm+FX7wWfWAuk1Zfc4PLYrozGPA7m+3l8mYGiNT4nIGqW/aWWz9
	 1QRw2jGsgnqhdmea39B2Q+QDaHD9K0AxizCBwLwTv0SoI+RUV9SW88GSsHiVT5knas
	 gr00pN0aXqWKw==
Date: Mon, 13 Jan 2025 17:02:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: James Clark <james.clark@linaro.org>, kvmarm@lists.linux.dev,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	coresight@lists.linaro.org, James Clark <james.clark@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
Message-ID: <996c7843-7f51-49a0-9122-e688e37f9902@sirena.org.uk>
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org>
 <87frloqjso.wl-maz@kernel.org>
 <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org>
 <86jzaywtea.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MSJwDqeLzComXiFD"
Content-Disposition: inline
In-Reply-To: <86jzaywtea.wl-maz@kernel.org>
X-Cookie: You will outgrow your usefulness.


--MSJwDqeLzComXiFD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2025 at 04:49:49PM +0000, Marc Zyngier wrote:
> James Clark <james.clark@linaro.org> wrote:

> > I think it's ok if it avoids review comments that new entries should
> > be sorted. Or maybe we do the opposite and the comment should say this
> > file is allowed to be unsorted...

> The better option would be to add the comment *and* sort the file.
> Leading by example has some value, it seems.

Yes, please.

--MSJwDqeLzComXiFD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeFRyAACgkQJNaLcl1U
h9AcyQgAgEUDp38F8GdJqjTrHtAkDZHEDq6Yrc4P5vWgzbfg2Q7T8jVrvvlzHwe3
S9SGQlI85G6EL33/wiWUUNEuz77CoeS/ZkF0owwRpN43isyMHsZKKsrs2lK/sVEJ
gF4Irn9vAAA2WsG4UY8DgzF0qcsAcIxv1u7/NQL2EYF+1OuQWfo9ymVjpDrVhpvP
fxBKS2qbVqqY5cxbXPlgRJtl/3UVAfnwMliD5FsrphywxOszezOv9WdHZMbztWlS
KXBhGuWBx8Nh1mTjD4Uo3zWHKDwByKW+kTjvaDfN3l0s1obv4UQqf3COc46533b5
Lb9Nd03wMIJQNAzGPdjooGJWRVhfeQ==
=FrjU
-----END PGP SIGNATURE-----

--MSJwDqeLzComXiFD--
