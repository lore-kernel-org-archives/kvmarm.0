Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3561914F74
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 17:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B938C433C8;
	Wed, 12 Jul 2023 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689182147;
	bh=2GZcAoZZs9XSUhBkOEEmvBIoJDe2zSkFaPKg/zRHvro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkS2dE1+AQcKamcN7+S7rJhnpUUvgjaCYKsCsQnkM8pBX7CMmZBP13qAMxRUxJhXU
	 KHLVpg5Iczz6JCoJovVKFcE8l4HLcJJkntfWO+3n3BIvlIt3X7nIVOOtvl/dedArOm
	 Xm9nRyepQJC8d81B1FufLcVF4C6WaLe+oKlI/ZHBzKCPbgSCTbwjOf5GuQbDC9pJW6
	 cyVEEJF5KAU7QQSZWcaBMAy3IK2S9GOOLVzLnzfUdtxCMpi5S5/Eu6jvXFQOnWjpO/
	 OJmuspEm9qPwarGlpvMYEm1XLfQcfJwdfIzinkyDpkhXjZiodIpcyABPNWedTWMKFb
	 tz5vMQ71wms2Q==
Date: Wed, 12 Jul 2023 18:15:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 14/27] KVM: arm64: Restructure FGT register switching
Message-ID: <b9ccca23-65d5-4ed1-976e-63d51e3457e3@sirena.org.uk>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uax271UvUuZ6reIi"
Content-Disposition: inline
In-Reply-To: <20230712145810.3864793-15-maz@kernel.org>
X-Cookie: Dammit Jim, I'm an actor, not a doctor.


--uax271UvUuZ6reIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 12, 2023 at 03:57:57PM +0100, Marc Zyngier wrote:

> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.

> +/*
> + * FGT register definitions
> + *
> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> + * We're not using the generated masks as they are usually ahead of
> + * the published ARM ARM, which we use as a reference.
> + *
> + * Once we get to a point where the two describe the same thing, we'll
> + * merge the definitions. One day.
> + */

What's the issue here?  The generated definitions should be aligned with
what's published in DDI0601.  That AIUI exists in large part due to
concerns people were having with the amount of time it can take to fold
new features into the ARM, it's official.

--uax271UvUuZ6reIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSu37wACgkQJNaLcl1U
h9AYqAf8DEH1RPGHTooJDamkR9FOixaE+WoxaCJRSdYO4st8H6LzheCU+krnC940
p9mS+KjOtd6mKJY4lTeLNRKnwXBLu7dkL3j2XiU5Stvbl744X3oA6Oz2wvm1X/Jb
7+67lAYlDskApavjkusZ0CVB8DWZpfC5fr6EpcTeRKmheBIPhr+lab/CIaW1unMw
5cq9rYNiB4gpZYzOGxdZTs+0VJ+BTmRR24PT4pENYYAnVendQFNKaNIwCd31uGC6
8wNvHbuw4zJeeu4PwUMhBP4wG1qJwY3SK67kpILxvs2Zk0UMxLR2pMrwLvToUdog
cZZ9cOixaEkcm1IG0ikM0R8gq8BZVA==
=vSrY
-----END PGP SIGNATURE-----

--uax271UvUuZ6reIi--
