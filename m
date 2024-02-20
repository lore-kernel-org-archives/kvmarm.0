Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595D8762FF;
	Tue, 20 Feb 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708445585; cv=none; b=pS3AELXLuP/nvxcf1pVjFCPM36LVq04v0YTEJyeuGHM11jIWjafhOZVK81lYtHSHzd4ujy7GDBeCShqbHxlE+SWjSydhdIwuvPC+vzpS6VCKF6kcihM1PbREaP7pB3t6NL/tEmtXIERqJyhu8PeIODuJYgFggHtHB/cgtVEO1sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708445585; c=relaxed/simple;
	bh=VqdCwO3+E3d9NBVuA51i45E1PK9MUVcWSQcl2BCjsG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOk+1OvY5CW8j2/DFz47qFwhKhBPV1zUK95SvK89khVm7G2SVpyvc0qTJtuIAEmCQLOa5vrLbLrOXIMdRB/qt7HJJ2Q0FupIaC6cw/PPc/Er1puMQ+6H+4GObjwHJJtwbqqw2lDiGGDIxliVdOF9ScnXhPK6VNJxcQlojWfjZaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8PYkhVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8PYkhVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0569CC433C7;
	Tue, 20 Feb 2024 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708445585;
	bh=VqdCwO3+E3d9NBVuA51i45E1PK9MUVcWSQcl2BCjsG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8PYkhVgA9egBuJON9/6dcPc6ZNjxHpocTSwza/RXWq28e9dkN47EO2XXB1ju2CBn
	 l3evZef/wulyJ8zXdxRolfXs7xt+EV9dVECPCVs7ebLRQGLqrceb+cKKU2H6PlCala
	 s7tbw2RQ1CvCySixV6f9MwUcMhd4IxxeTlecqv3z4zu14Tq66Z0v8Vx6uAPQ4SaNQD
	 fEoEB6Dms0ipz6ecU8kPKjOxei9iQ8WH2Xtw0vLjvMpwmBSQm24TDzbRX1LC1CP9Fb
	 W7QgHXHySRXLKXtS4/f9q26CtrdMJt6/P9DUiNhY8sKXE3Ng5EjuU17U3CW3kfgStB
	 /qpOi6UFCGnUA==
Date: Tue, 20 Feb 2024 16:12:57 +0000
From: Mark Brown <broonie@kernel.org>
To: James Clark <james.clark@arm.com>
Cc: coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, maz@kernel.org, suzuki.poulose@arm.com,
	acme@kernel.org, oliver.upton@linux.dev,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Andrew Walbran <qwandor@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] arm64/sysreg/tools: Update tools copy of sysreg.h
Message-ID: <3bfe4365-bbee-4a25-9d12-3bb2b72a36da@sirena.org.uk>
References: <20240220100924.2761706-1-james.clark@arm.com>
 <20240220100924.2761706-3-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mzztJpuIQwlCoF6B"
Content-Disposition: inline
In-Reply-To: <20240220100924.2761706-3-james.clark@arm.com>
X-Cookie: E = MC ** 2 +- 3db


--mzztJpuIQwlCoF6B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 10:09:12AM +0000, James Clark wrote:
> Created with the following:
>=20
>   cp include/linux/kasan-tags.h tools/include/linux/
>   cp arch/arm64/include/asm/sysreg.h tools/arch/arm64/include/asm/
>=20
> Update the tools copy of sysreg.h so that the next commit to add a new
> register doesn't have unrelated changes in it. Because the new version
> of sysreg.h includes kasan-tags.h, that file also now needs to be copied
> into tools.

Acked-by: Mark Brown <broonie@kernel.org>

--mzztJpuIQwlCoF6B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXUz4gACgkQJNaLcl1U
h9C+MQf+MdNjVHtSmMoT68nOk7ZP//AYH4CpbBmQyFiRnkfJOYIKcCd8ALZmdOBr
h5WFuk1zmdBVYH97xTSg1rzD3gpDAaBAihwsQIycO62/71qBmQuBths4gEvTHR6E
fAz5ScJycLCBabEsh5qbZZmx6fUCK1S/NPO6n7pi2cRwxgFsteuZRJrP4Kh+jbdy
4dHhoVylqEzPoDZCmGt8k0wrFKwx369Lt4Y0gulWGNW5gM550a/dbYZzWpssK7ZL
Uu7qwVgo9YPi3sPLWaaY+eGNT/ldB5RZcfDHeOSpoyNEDo0OkiixZDDofn65w+wn
vzr/xvh6fTJdd3qOPf4LoRoXSNAAww==
=mMBd
-----END PGP SIGNATURE-----

--mzztJpuIQwlCoF6B--
