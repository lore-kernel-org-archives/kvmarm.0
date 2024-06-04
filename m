Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA618F6A
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717510045; cv=none; b=iRhF8pnxyGOgEvSb2FTX/0cijGWZhhr2sdVTmf3W7PTtNxQ2Et3Ak6xS6qj7iciJDvSR0dTenn4nBdzCwM+FenIlr1oXSWudqG5go7FCPfELvXTT5DV34DQcYWqFBdShj4SUGbTmj5vbQN866QUWjcIsUnpcTjlstj06X4jdQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717510045; c=relaxed/simple;
	bh=ErgkA8r25v12NbiYSZLonWCBbuaJrBuLjZ22rQEhMow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ln25J8EyH4pIbG6Zp+2sLFmHTaCc0U2Xliu1mBvHXcrM97QSw7hcqPhDNpyckEJ6YtFeIcN0uHuKX6F3eMJM6uz50b5OI1yAM28X3GODoWIlBycnq+QwjpaEYNPErVypVna5sRJqKShRXP3FaUZCgsXTar/PyhrhvCLw5UQpJ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqXdxMZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqXdxMZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC9C2BBFC;
	Tue,  4 Jun 2024 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717510045;
	bh=ErgkA8r25v12NbiYSZLonWCBbuaJrBuLjZ22rQEhMow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RqXdxMZVi0tbWstA6BnDhiaWHv6rnm+E+2+q0PmDmFif1mYCi2F1qZ/p/1MHlDQXm
	 BEHxDpxxoGbBeqUCajXSg19lltqFpxM4n1+fAdQzOmNa23LsHHIC8cTCHS13OG6Q3W
	 bz73Xh0CWVqiZK5EaaFgWFLuTA7H3T6U1sAWP/5skQEoNlPptlrYhTtWO4YaU8RfK8
	 SbIr0xhm2cBsXVxVsiFINA2sNin+EUwtfOCTUnyT32Ra0s+KFKrhhSLYWjws6thKQQ
	 dywYjqYD4ywp7MCP2cFWloh5MY3btjn5mVhf+xXQdpvJqqyXOIcPp6bYnYwQPjMCd0
	 Vu4Q1BYs0/UIw==
Date: Tue, 4 Jun 2024 15:07:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 6/9] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
Message-ID: <5e20596f-b9d3-4b01-ad3c-638dd1fa076b@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-7-tabba@google.com>
 <728c100c-ea38-4802-832d-04521821d169@sirena.org.uk>
 <CA+EHjTw6ybZ8+YuRjmRcpm7rC_aHPn7H1V4cejrN1Zo9njhbGA@mail.gmail.com>
 <e8e7928b-9f79-4015-a144-fade7ac84c6e@sirena.org.uk>
 <86ed9clsqz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0A+LqQROufs2S1wt"
Content-Disposition: inline
In-Reply-To: <86ed9clsqz.wl-maz@kernel.org>
X-Cookie: Is it clean in other dimensions?


--0A+LqQROufs2S1wt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2024 at 02:52:52PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Tue, Jun 04, 2024 at 01:03:07PM +0100, Fuad Tabba wrote:

> > > You suggested inlining this, but since this is static, I think the
> > > compiler would do that. Even though it's only one line, it maintains
> > > symmetry with fpsimd_sve_sync().

> > The reason I was suggesting inlining was that it removes the need to
> > name the function.

> You're missing the point.

I think not.

> The name is important, and the current name is correct. We use *flush
> (resp. *sync) for operations that need to happen before (resp. after)
> the entry into the guest. This is consistent with the rest of the code
> base for most of the subsystems KVM/arm64 deals with.

Hence my suggestion to add documentation to the function to avoid the
risk of surprises, the above text explains the motivation for the
suggestion that Faud is responding to.  Either approach would work.

--0A+LqQROufs2S1wt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZfH5UACgkQJNaLcl1U
h9DjyAf/by9Fp1D0zGrrZ/fYO8ZnwI18cF7W1LfDUCGNXYA3BwqB9eeL25TC9Ahg
QlTfz99nTwiCyU4ToX1pEaeUXZy/yFD6iZAcGSvNwF17oVzG1HMGStqPxoBXm2Fb
Yj+lITllRDbG/q+C+HOeT8MmnFT4QpbPtoXPwG3AaRLO0Q3cXeuCADBvstMC3Nsi
onwHFb4s9OKxt08nUNSXIOYveCjWACAsot5TQh6c408xN1P7mSwZsQ9bBTAunRUa
2VJWlPgbjqN2lcHhVrxilEqXEv+DXaPHSZcHdqcwFL/eP0bJX8TIjn+9Kx2ta/RS
YZfvA7fhim0mZkHQavoiOaOHhRHglw==
=jAG7
-----END PGP SIGNATURE-----

--0A+LqQROufs2S1wt--
