Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69517475
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 18:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F911C433EF;
	Fri, 17 Mar 2023 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679076178;
	bh=ay6vdzshzTvkvPnkQLgyr6NoTiGKUM0JSkY7VNB2hB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kzcFTDIfhbzcUAmPZjSrcTGun2xm0wG7ZGHknXbM2a2d8tup2nxoQ7ZIo5r48urzA
	 /C2KKD2lRCz1BrxC/Lr/LkH/KS3D3kdWqJ66gWX1eRlE5OCMVaKyV1VxpkI11SLCon
	 7kBZ4cmVw4xDl6NdktFoc528CzkwNJFU0do15IJiyEEM5ayW2Kmf6x2M2T80GovGpq
	 CunPn9n/qgyGA7zc6aXqBzEsqckW7XFJ4Fj9XU0lc6qkq5OQfEbq2IoPJJgCDNI92B
	 rxOX/woYRqTU+c6GBXJOtzT6pyBYfxpiUszaxawNhaI/f36K1AkpuyJa+xnm880FUb
	 glv2K9Stx+o6Q==
Date: Fri, 17 Mar 2023 18:02:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <e989a716-c69e-4151-81ad-1852386480cb@sirena.org.uk>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
 <20230301-kvm-arm64-fgt-v1-2-cfdf71ac67dc@kernel.org>
 <867cvfyclz.wl-maz@kernel.org>
 <855e60de-56c0-4500-a8ce-d79ffb0ed19d@sirena.org.uk>
 <87zg8bgw85.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UZ9DRb5QNvpcypOD"
Content-Disposition: inline
In-Reply-To: <87zg8bgw85.wl-maz@kernel.org>
X-Cookie: Life is like an analogy.


--UZ9DRb5QNvpcypOD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 04:48:26PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > That's an awful lot of registers with the fine grained traps, and when
> > extended to cover HFHxTR2 there's a bunch of RES0 bits intended for
> > future traps.  It feels a bit unmanagable.  I'd have expected something
> > more along the lines of "enable all traps other than...".  The pattern
> > seemed to be more to have an explicit initialiser for the bits that are
> > set (eg, with CPACR_EL1) which was why I didn't put anything explicit.=
=20

> "an awful lot of registers" is exactly 3 registers as of ARMv8.8/9.3
> that have a disable-trapping-when-set pattern. Maybe more in 9.4 and
> up, but if people can be bothered to write the tools/sysreg file, they
> can also document what gets implicitly trapped.

See my patch on the list for generating the FGT registers, HWFGxTR are
now fully utilised as of the 2022-12 (and we also have HWFGxTR2 now
which is mostly RES0).  The register set for the base register is:

+        * ACCDATA_EL1, GCSPR_EL0, GCSCRE0_EL1, GCSPR_EL1, GCSCR_EL1,
+        * SMPRI_EL1, TPIDR2_EL0, RCWMASK_EL1, PIRE0_EL1, PIR_EL1,
+        * POR_EL0, POR_EL1, S2POR_EL1, MAIR2_EL1, and AMAIR_EL1,

I'd strongly expect the pattern for HWFGxTR2 to be 0 to trap, this is
the case for the few bits already defined there with the rest RES0.

> This also outlines that ACCDATA_EL1 gets trapped while it wasn't
> explicitly trapped before, and that we don't have a handler for it.

Note that it is currently explicitly trapped with no handler given that
we initialise the HWFGxTR registers to 0 by default in the architecture
EL2 entry code and then only ever modify individual bits, there's no
change introduced here.

> So we need an extensive documentation of what the 0 value covers, no
> ifs no buts.

If this is very important it does feel like we might benefit more from
collecting all the information on all the traps in a central place with
pointers out to where things are managed, knowing where to look and
tracing back where values come from is often much more of a hassle than
knowing what the value means.

(I have already added the comment locally as above, this is more a
separate thing.)

--UZ9DRb5QNvpcypOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQUq0wACgkQJNaLcl1U
h9BkJwf+ImhB5Zt6ZEMcGHPEGXnirBxH8ysEihq9DgwTtb7zQhYA7K8MNpYRvlav
xaYIiWcqHS+6lwkUsUI5Zerw5qJeBXwQ663nW6HNVm04IoUBPcWtoXA89Y1vYzz5
PXLVIJFyDgYlT9rAzCLVQNUODmc3KZOpuwfwW+Z0DG6qArx6679omDOLNT79S9/B
U/9uPpGMrP4aaHPTZtOXMBu6a/dPgToMN2ntRcEWfqJy6YMM4sgdqCCjSvb8Notq
CIWv2p9BTggnBE6Kf2t1yLIjWTeglwhF3zBXGXBg/oJEK16bfSRve4XaGxJPwmA9
k7sS0b7Q1aUPu48uCNml86lH/8VGVw==
=8caX
-----END PGP SIGNATURE-----

--UZ9DRb5QNvpcypOD--
