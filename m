Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1CF15C99
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 20:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD76C433B5;
	Mon,  5 Dec 2022 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670273541;
	bh=fhtuKrKeylfRZqROvlIzJUqwt+rxgcDBajtohkwUijg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WJrZZlTia13a/wajtZV9G90f7WJ6tA+B3h1V+mXlufiYDH8/4ekIIUq1JLPqLq+vb
	 iel5k2q0B2n/n/WdjnWt/M0LNv/wUvzzFtsE8TGVeO2nvJmHkdHjVPWqGhtXnNH00S
	 o0zJIXaM9PVI2Or/jm2L/pzndx1eJeQ9G4FlaxRAD8aoXsZZetRm+dVeVltuX2EELc
	 E2pmpvcnfuBHGaagUHLm9sA8m3u/wDWBgd/GxutiSWY7MK4DWmlRdhMq2Y424I7Hjw
	 nxuYjWXSIE7x6MNHyCLD2VUGFCG90neW8MUSMlZai3+pmDlyQZcp81Pi93VPDZxoQ+
	 u/kwKPQI/PjvA==
Date: Mon, 5 Dec 2022 20:52:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y45aAOYXqYQB+oHb@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
 <86o7shlmb2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B7iIh0TWRFobH+EO"
Content-Disposition: inline
In-Reply-To: <86o7shlmb2.wl-maz@kernel.org>
X-Cookie: If it ain't broke, don't fix it.


--B7iIh0TWRFobH+EO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 06:47:45PM +0000, Marc Zyngier wrote:
> On Sat, 12 Nov 2022 15:17:04 +0000,
> Mark Brown <broonie@kernel.org> wrote:

> > As we do for pseudo NMIs add code to our DAIF management which keeps
>                           ,
> > superpriority interrupts unmasked when we have asynchronous exceptions
> > enabled. Since superpriority interrupts are not masked through DAIF like
> > pseduo NMIs are we also need to modify the assembler macros for managing
>                  ,
>=20
> > DAIF to ensure that the masking is done in the assembly code. At present
> > users of the assembly macros always mask pseudo NMIs.

> In patch #5, you say:

> "This is not integrated into the existing DAIF macros since we do not
> always wish to manage ALLINT along with DAIF and the use of DAIF in
> the naming of the existing macros might lead to surprises if ALLINT is
> also managed."

> It isn't integrated, and yet it is.

Ah, yes - the note on patch 5 is a bit bitrotted now.  I'll update that.


> > There is a difference to the actual handling between pseudo NMIs
> > and superpriority interrupts in the assembly save_and_disable_irq and
> > restore_irq macros, these cover both interrupts and FIQs using DAIF
> > without regard for the use of pseudo NMIs so also mask those but are not
> > updated here to mask superpriority interrupts. Given the names it is not
> > clear that the behaviour with pseudo NMIs is particularly intentional,

> Pseudo-NMIs are still compatible with the standard DAIF behaviour,
> where setting PSTATE.I is strictly equivalent to setting PSTATE.ALLINT
> when you have architected NMIs.

> So I don't really understand your concern here.

The existing code is fine, the thing here was that unlike the C code
there's no matching management of PMR here where we're adding management
of ALLINT which might raise alarm bells for the reader.  I'll reword a
bit.

> > @@ -131,6 +145,10 @@ static inline void local_daif_inherit(struct pt_re=
gs *regs)
> >  	if (interrupts_enabled(regs))
> >  		trace_hardirqs_on();
> > =20
> > +	/* If we can take asynchronous errors we can take NMIs */
> > +	if (system_uses_nmi() && !(flags & PSR_A_BIT))
> > +		_allint_clear();
> > +

> Same remark about the ordering. Also, we don't check for PSTATE.A in
> the pseudo-NMI case. Why is this any different?

For NMIs we're making it track PSTATE.A so I wrote things that way to
make it clear that this should be what the end result is.  I've already
got a change locally which makes this even more explicit by having both
the set and clear cases rather than just only the clear cases.  You're
right though that we should achieve the same effect by restoring what
was saved in regs->pstate which is the equivalent of what pseudo NMIs
are doing so I'll change to do that.

--B7iIh0TWRFobH+EO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOOWf8ACgkQJNaLcl1U
h9AU9gf9Hl1l46LgRtzhhpr07CpYkKAk8Mz7+52CNWUVsg5zz+i3w72RyYnuVAnl
ZvjmE4cNsxVJDpPSUL12xw3q8YQIMpvCdqOK9y3HHEdqcS72C8fC6lt0STzLX5hp
Z7RQrRnnYbdfgTXPpJLHKCvBr235UjzipUsgp+VC4Iud1PUgKz1xkPYhMFsPoZeK
mPjIAKqfdy4JqCQ/eSF6gUbvUME5fIUEI2QayWQdvsN6TSH9ow9L8NV7b6YJQQaw
blMIpI4kSBFfb6Gk38zHvtekAk/JDq1KayHR8xeSrBccacwmZCGgjSftrtjOOJvD
zw7Icd0TQI6/KjYEtkbfubXhjRBUQA==
=IvI0
-----END PGP SIGNATURE-----

--B7iIh0TWRFobH+EO--
