Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5488C4C89
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE35C433AE;
	Tue, 23 May 2023 08:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684831149;
	bh=Oxg2q75s2/zytEn//kA1T8P8jfYGJX4fm7zdbpXI1So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YPvfG4LK/8erWPIeDmltUeyeQJLDeMTTgm0zh+1fp5kKZ/wZUZByjsvGFbOWhrWF2
	 dcLAjrahAi5fr7s98/28LWsVhEua07mnSVttMyVD6Q7lbaUZ2HtW39WsWW1R8SH5cc
	 coqqzNR4Z/4tTYagkRRhHmuLe44QZN0nBdxhGxgL/4D79fWhfzpyCTqq7T9+SX7gsC
	 PdiZxygjs/ijsVOO4GDkHiRtY12/tltwgf4klt1rXe61uL52Y7D7ow96bfwV1lHO0A
	 TQMbYb7pLps/+P33T6AG0KcCtUOzLAuidVa7mYiNYM0xN954DdioSx3pykUziXBuPT
	 TyrhVruuOItmA==
Date: Tue, 23 May 2023 09:39:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 5/5] arm64/sysreg: Convert OSLAR_EL1 to automatic
 generation
Message-ID: <806fdf76-53a0-4ee5-8b57-e7ae7ee80f69@sirena.org.uk>
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
 <ZGx1jT4nQ9HEVWSE@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GY06EX/bWV8Ev7NQ"
Content-Disposition: inline
In-Reply-To: <ZGx1jT4nQ9HEVWSE@linux.dev>
X-Cookie: Beware of low-flying butterflies.


--GY06EX/bWV8Ev7NQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 23, 2023 at 08:13:01AM +0000, Oliver Upton wrote:
> On Mon, May 22, 2023 at 05:22:44PM +0100, Mark Brown wrote:

> > -#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
> > -#define OSLAR_EL1_OSLK			BIT(0)
> > -
> >  #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
> >  #define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
> >  #define OSLSR_EL1_OSLM_NI		0

> Should the OSLSR_EL1 definitions be rolled over to the generated scheme
> as well?

It should at some point but it has a field with non-contiguous bits
which the tool doesn't understand yet so it can wait.

--GY06EX/bWV8Ev7NQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmRse6UACgkQJNaLcl1U
h9APgAf/cGnnDxyCsCqfTldJEdy3NBTacODKqVRleuOcGMEYBVySTJl8hbrtmKuk
W40ZQzG9i9F6rIitsDQwmlzyzBKYLTiRmfS0AcnIyV315QoRYw4hDe+LeHqz0Pb6
RPJaidZhbDT75qga8FJ77whi1tI4INLRKVzCWU5qyMNj7I1uUeunyZ5QY60tOUjj
FYd7RJF7TDFdKmxz+N3oH4U9BAsDd4EkDhQE7YVnP80PF5rxrZVFP3ThQ7ihtKZy
VQfErsB7VoZGL6Uma7b5WeRkE5tl4uSZyG8bM39SGMBEkhxR5K0Cn7Yo9gqtCouX
pHvdboMpSVe0faicAqaVNaxrhU6WAQ==
=tUlP
-----END PGP SIGNATURE-----

--GY06EX/bWV8Ev7NQ--
