Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44A107BF
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 19:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374BCC433D6;
	Mon,  5 Dec 2022 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670267036;
	bh=ElWImseXnCKCUqRGElNw3z8mIAd2iPIFbjvL7PDyqXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LXVQwXReHJnOHYyfFy2+ULch1ohTUfbiKJAxaFarh9lEhvIzZmKLoDkB/LAv2KiKW
	 QHm7n3pubOMr+eXuLspwDD4lD3YrUBvf+VFSjpe3ItqJy2qhJ0MxIRnIBVKp+SXu2V
	 53USY+PwtdxWAlzn0VUM3rz7Roj3oItXsD3ZjiffwnwAomd+l5DymVB8kkn+hrliNt
	 k0Uto3t/ZNilqFKpUbrJ4gLHb8y7nK0ck3TcKJeyGO+09CLJka1SXboxpJHNg2n2u1
	 Mrl17lTF1jt8C4i1Q1AvjD5sQaKpCfffHWcpsSlotYi2M1H7320Lu5aKFSOFq7HyuJ
	 Mcl2XM9F0ZW+g==
Date: Mon, 5 Dec 2022 19:03:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 09/14] KVM: arm64: Hide FEAT_NMI from guests
Message-ID: <Y45Aluq2zJoQ828W@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-10-broonie@kernel.org>
 <86pmcxlo7z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uMgfBnj769AQ4B8P"
Content-Disposition: inline
In-Reply-To: <86pmcxlo7z.wl-maz@kernel.org>
X-Cookie: If it ain't broke, don't fix it.


--uMgfBnj769AQ4B8P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2022 at 06:06:24PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > FEAT_NMI is not yet useful to guests pending implementation of vGIC
> > support. Mask out the feature from the ID register and prevent guests
> > creating state in ALLINT.ALLINT by activating the trap on write provided
> > in HCRX_EL2.TALLINT when they are running. There is no trap available
> > for reads from ALLINT.

> > We do not need to check for FEAT_HCRX since it is mandatory since v8.7
> > and FEAT_NMI is a v8.8 feature.

> And yet you check for it in hyp-stub.S after having checked for
> FEAT_NMI. What gives?

Being aware that you have a strong preference for not having safety
checks for mandatory features I didn't add any here but noted it so
people could see why they were omitted.  The checks in hyp-stub.S were
probably written before I'd checked the dependency situation out.

I can remove those checks if preferred but TBH given that the failure
mode in hyp-stub.S is typically going to be to die with no output if
something goes wrong it does feel like it's worth the extra couple of
instructions to double check things just in case, especially with the
virtual platforms being so easy to misconfigure.

--uMgfBnj769AQ4B8P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOOQJYACgkQJNaLcl1U
h9A7eQf8C8GfeXxvjx7hEypOLSK/NymCMBz7O4TpGPwYm6JyQaJD6h+QdAbR6e/A
TBIm+obQEuaBLPQBncOnlcaYwnbktR8mLErJgDT3d2R/1g5isiDWj1NdQypm3Bqh
FJttLBp7EZGwCuZUx/NA87DuUuIThwRZ8LZcL37L3Sn47OBLKtWTcrx5LtY9XD3r
OMpsg9lsXUyj/M1DM8WArNXRukJY92WvEtlJD9irM/cDCOZxOKbgaq+PKD+1oT40
lCxH2WaegA0IlNP2EW5U4upkduTefj6CXzI8+Pj4cfkEeIdqo58iiQR0ZGETMy7S
TIYzsKUfwdoW/2/dPi5tNCjnS1QGgQ==
=R6LF
-----END PGP SIGNATURE-----

--uMgfBnj769AQ4B8P--
