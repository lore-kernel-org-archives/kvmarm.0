Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6121382
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 14:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8475AC433D6;
	Tue,  1 Nov 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667313016;
	bh=3LAJDs979R00Ilp45b0EmBktYqQOpB3tKEAn3nqXH+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzwVNlPo2X0ZQXG4axJRPfCip4oWF0q5g/a0wwbVvlp19gqJTiLKvPb2bl/WM/fBf
	 0n+gb8inkhXaNuN4RR7iTRAQExuyf4h1mt6xFPWQN0xUgz951jAF4sXxjbqsypx2oE
	 OVQiOn7bGd5cSF/p3sSO/VZD8rVkrkrhaJ8cs7KBV5Ox9SpOwc9RnikfpmkA07QymB
	 A/ttWkI/IsaCU1LMoieXE4sFzy+U8gwiTTw3KiZ9Fcy9iz0dTP3Yz+pTaLSZOOseXH
	 BMB5H/pcM+xmZt5c4Cr2xRoHDCPh6TbD9rqM2bhG484LUh8ZRAxUbsK12l/LtGTEwR
	 tXcGxTrPy9afQ==
Date: Tue, 1 Nov 2022 14:30:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Trap access to SMPRI_EL1 and TPIDR2
 in VHE mode
Message-ID: <Y2EtcQSnu5R/Frhj@sirena.org.uk>
References: <20221101112716.52035-1-broonie@kernel.org>
 <20221101112716.52035-3-broonie@kernel.org>
 <86bkpqer4z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SakqH1ZP7qWQfyDo"
Content-Disposition: inline
In-Reply-To: <86bkpqer4z.wl-maz@kernel.org>
X-Cookie: Do not write below this line.


--SakqH1ZP7qWQfyDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 01, 2022 at 01:33:16PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > -	if (cpus_have_final_cap(ARM64_SME))
> > +	if (cpus_have_final_cap(ARM64_SME)) {
> >  		write_sysreg(read_sysreg(sctlr_el2) & ~SCTLR_ELx_ENTP2,
> >  			     sctlr_el2);

> I still question this. As far as I can tell, it only affects the host
> context (HCR_EL2.{E2H,TGE}=3D{1,1}).

> This is outlined in the description of the HFGWTR_EL2.nTPIDR2_EL0 bit:

Oh, I see what you meant there - I was purely focusing on the new code
with the fine grained traps, not the existing code.

> So I can only conclude that messing with SCTLR_EL2 is superfluous and
> doesn't affect the execution in a guest context.

Yes, if you look at the pseudocode for TPIDR2_EL0 that's the case.  It's
either EnTP2 for HCR_EL2.<E2H,TGE> =3D=3D '11' or the fine grained trap
otherwise.

> > +		/*
> > +		 * Enable access to SMPRI_EL1 - we don't need to
> > +		 * control nTPIDR2_EL0 in VHE mode.
> > +		 */

> This comment is factually wrong.

Bah, I fixed one but not the other sorry :/

> Date: Tue, 1 Nov 2022 12:19:51 +0000
> Subject: [PATCH] KVM: arm64: Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE
>=20
> The trapping of SMPRI_EL1 and TPIDR2_EL0 currently only really
> work on nVHE, as only this mode uses the fine-grained trapping
> that controls these two registers.
>=20
> Move the trapping enable/disable code into
> __{de,}activate_traps_common(), allowing it to be called when it
> actually matters on VHE, and remove the flipping of EL2 control
> for TPIDR2_EL0, which only affects the host access of this
> register.
>=20
> Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running gues=
ts")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>

--SakqH1ZP7qWQfyDo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNhLXAACgkQJNaLcl1U
h9AZmwf+N1nF+pmaVTPljAPEIm4DDRTBMXDEH0Ypx4lq4ugpz+j/dSra11ucYvbL
i7ePrcuyLFHyhONPPFspFlfaTu9fO5laFRCTi8pLu8OH2kEAsiITWgrWaSVNRzd7
btOxblRhE3FeBXkfaeDpHNwcXL90PrqAjLWz5zXz+LzpRZvNwifCBkCstkPdd5lB
/SetA9yvyrOHBmtiqFlf48Fnls2ny4yhCTIsVeSpN6KLV6mq8CnlaPjcrcFtOrm8
k8IFXxrAmDQGG+YCfKQl1yIiii8p6h5iFTy0A9xHA4/5TrdhW1vM12nv3FBpXcno
+9QIzr0upuTU5YhTPfHm9UqJI3h1gg==
=G3hK
-----END PGP SIGNATURE-----

--SakqH1ZP7qWQfyDo--
