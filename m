Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0298BF1
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 19:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1529C433D6;
	Wed,  7 Dec 2022 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670441604;
	bh=/P17nlRmgvBJKJxfV2H+5Rbzhc1x7ttFhafH9JLiJHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qh9srOxHPDZZDLufOFvigeIsSKH5zCBslNhkEYB9OpG+d/ki1tN4BMwUxwylw2mTp
	 yHzjERK+b+NJgEmrA05+5/wAglRvjGWrw+lSxesBNfysQQKgQpyRhF9NPXY7PdunF9
	 EcDcY0P3q2hW9CRV6xMdJQ/FBbfjRSaLU9T7Tnc852anBvRD1Qtu+2ENXYKG3STIBu
	 rrbrhFjkBf3Y7BCddG7VarGQFcsoABfIc/wUePcZfdbpSXNHRgdtkTCqS8BVac34AL
	 KzlRSHMRDpVdd1zc0eqZKIMC8N8AoIUNhtFJ8iz7+vZq5IDQlqDF11DFfqPpFxM1s4
	 14orVmRPWpn1A==
Date: Wed, 7 Dec 2022 19:33:18 +0000
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
Message-ID: <Y5DqfrC4a6EpiCk7@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-10-broonie@kernel.org>
 <86pmcxlo7z.wl-maz@kernel.org>
 <Y45Aluq2zJoQ828W@sirena.org.uk>
 <87y1rjrq7z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ca8WrCrP803q/7Al"
Content-Disposition: inline
In-Reply-To: <87y1rjrq7z.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--Ca8WrCrP803q/7Al
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 07:03:28PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Dec 05, 2022 at 06:06:24PM +0000, Marc Zyngier wrote:
> > > Mark Brown <broonie@kernel.org> wrote:

> > > > We do not need to check for FEAT_HCRX since it is mandatory since v8.7
> > > > and FEAT_NMI is a v8.8 feature.

> > > And yet you check for it in hyp-stub.S after having checked for
> > > FEAT_NMI. What gives?

> > Being aware that you have a strong preference for not having safety
> > checks for mandatory features I didn't add any here but noted it so
> > people could see why they were omitted.  The checks in hyp-stub.S were
> > probably written before I'd checked the dependency situation out.

> > I can remove those checks if preferred but TBH given that the failure
> > mode in hyp-stub.S is typically going to be to die with no output if
> > something goes wrong it does feel like it's worth the extra couple of
> > instructions to double check things just in case, especially with the
> > virtual platforms being so easy to misconfigure.

> I'm not hell bent on it, and if we can spot the issue early, that's
> fine by me. But let's then disable the feature if the implementation
> lacks some essential dependencies.

> A simple check on ID_AA64MMFR1_EL1.HCX when detecting FEAT_NMI should
> do the trick.

Hrm, we should really only check if EL2 is implemented since that is a
valid configuration in which HCX is moot, and there's a case for only
checking when we entered the kernel at EL2 since otherwise any traps to
EL2 are not really our problem and I can see why EL2 might not let EL1
know about the feature even if it really should.

--Ca8WrCrP803q/7Al
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQ6n0ACgkQJNaLcl1U
h9A0tgf6A15gl9aduRNIodKhlIcvLI1r8+ZTUkeCdhB9z/J4WglFF3LWO7GcFDpX
8GoB6rroKFD567IBLZFEf1qKoM5a5mZmedHm/BtRxtraaUXwo3vZPv30tP1PsStU
2T7R2HKBdtVu399cIOLsrj/MWxL2ECiMw6X2QaXHHlzt3ZAM+eaI/RnGkFYjCPer
Yhm+d0BeKCyE4LvFHpcHkpWpoz+Hr/x5OTyM2qKkWwFU/cuVDtNJJ/W/qYr/xUKU
I4bLdtklH+KnQo1tvRIVFojReyMN8slvsb1jAA58V2A+tMMf3BRreT+60M8dzaD+
JphthDd+hgmi6VS3nWoPUKtZn+oRRQ==
=yacl
-----END PGP SIGNATURE-----

--Ca8WrCrP803q/7Al--
