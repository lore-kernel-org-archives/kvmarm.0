Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B543B6125
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2ABC433C1;
	Mon,  5 Dec 2022 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670260303;
	bh=wJ30bBu+F+rfUL3WWPJjpWX0odW0blGMLJXDiQoW2ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SyRgePp2Uy3sLwns6Y078t10bXzrPSdx7JOBirXa8EheGa4el/uMLxY9ASetIutAd
	 xyaSQtfR6AyYe3rrEcCqR+S0bJBpg5r/pmF+9F2/zToOwmXpFpKmvOoyCWiS0XRIqy
	 gRZcnAKDhPU/7j3E/f5nULIEjEZD71jYqmYxWHW5i93fSr0BB8tx5QHHElkyw0PSsT
	 biq55lHur397J5ME/rSojiUOqPJ+Tv/u2PJ0LnJ0QNHukCECEU9GfA8K6kL2MYf2Gh
	 3USKaxBssWe3cXeRm9hNO3oyABk2oZwtohsPLu+SMu/6JCsiOZXhdyq5UzsugO6GZQ
	 vdCd8cNO2rGRg==
Date: Mon, 5 Dec 2022 17:11:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 04/14] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
Message-ID: <Y44mSokVwLHbGdN7@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-5-broonie@kernel.org>
 <86wn75ls9u.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UWTkWf/FMyNjyfSY"
Content-Disposition: inline
In-Reply-To: <86wn75ls9u.wl-maz@kernel.org>
X-Cookie: If it ain't broke, don't fix it.


--UWTkWf/FMyNjyfSY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2022 at 04:38:53PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> >  }
> > +
> >  #endif

> Spurious change?

Yes.

> > +++ b/arch/arm64/include/asm/nmi.h
> > @@ -0,0 +1,18 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */

> > +static __always_inline void _allint_set(void)
> > +{
> > +	asm volatile(__msr_s(SYS_ALLINT_SET, "xzr"));
> > +}

> If this *really* must be a separate include file, it should at least
> directly include its dependencies. My gut feeling is that it would be
> better placed in daiflags.h.

Yeah, I was swithering on that.  Some versions of the code have had more
in here at which point having the separate header made more sense.  I
think part of the problem here is that we should do some combination of
renaming daifflags.h or layering an a more abstracted API on top of it,
putting things that are not DAIF into daifflags.h doesn't feel great.

> > @@ -126,6 +126,8 @@
> >   * System registers, organised loosely by encoding but grouped together
> >   * where the architected name contains an index. e.g. ID_MMFR<n>_EL1.
> >   */
> > +#define SYS_ALLINT_CLR			sys_reg(0, 1, 4, 0, 0)
> > +#define SYS_ALLINT_SET			sys_reg(0, 1, 4, 1, 0)

> This only covers the immediate versions of ALLINT, and misses the
> definition for the register version, aka sys_reg(3, 0, 4, 3, 0).

That is already present upstream, we only need to add the immediate
versions which the generated header stuff doesn't have any model for
yet.

--UWTkWf/FMyNjyfSY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOOJkkACgkQJNaLcl1U
h9DjAwf/d09aro0sIQ5Q4tFNdia3NX9QgwG01nawg22I2HthvjFfkrIuKBEp6LRF
Utfmpjt4mL17ZhUgkrbp0SEwUvcP7u/mHeMYEc7GtzCCZUp5Catec5gZtBa93VfL
Nsy4lCtqir4TMHxQ66f5yuxWOwUB26tx4eV7/UQ/NtmUupOjMR/mL/p2iwTGUyI5
D/8FQiUzG6ur3YflTdfF4Ae6isSv7WQ5J2/upT1pbLIWgCJryf7ce7bH7rLdXeoa
mjQSPtUatdqeKZaL7YnaD26zYusJwoaWGzFeqesBEeeeGiVQ5Wk+OeeR8SfL3rzw
8qZq6UiNHlZV7tH0iPjmFbcd4L9scA==
=9qwR
-----END PGP SIGNATURE-----

--UWTkWf/FMyNjyfSY--
