Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038AD20F7
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 13:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4508C433C1;
	Wed,  7 Dec 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670419464;
	bh=/7vZz6ZyY2XfkHgpo+GevZ/jY02E2KbPkuDOwp5ezCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfA/iZctFvWY/ZFCsPFD1a7vfCbcrDT7rinAqo7I+E/h80Uv64ghy/cuLr1YYc7c7
	 8o1g1KDs1sNjCtYIAAnB+vBrtPIz/iwCiVM2eKqKqs6xt779DTdc0h2u9QDIiXIzIt
	 b6W9trBcz6+AV8jpeKaBhTMS3tmiLShwFqyHa0DWZ7adYEEpJ4DLR5H5Ftyw3helU4
	 KmfdteUKW3uJydka478RDfHeR8fqS0cKdqpHOzJv2Ry3iYE8jgGJ2hc2X/69hP+y6L
	 f/N2fuXLxtkI8rsIyVsgqvK+GaNkO+fGeVTwB4Y91E/nKpQO1jrY6FTKyWpxMpUMgB
	 P0MYPM8CQGw6A==
Date: Wed, 7 Dec 2022 13:24:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 12/14] arm64/nmi: Add handling of superpriority
 interrupts as NMIs
Message-ID: <Y5CUA+yZDn5wqHQF@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-13-broonie@kernel.org>
 <86k033lblt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xYeMH8Qodw+sKYZC"
Content-Disposition: inline
In-Reply-To: <86k033lblt.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--xYeMH8Qodw+sKYZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 11:03:26AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +int set_handle_nmi_irq(void (*handle_irq)(struct pt_regs *));
> > +int set_handle_nmi_fiq(void (*handle_fiq)(struct pt_regs *));

> I'm not overly keen on adding hooks that are not used, and I can't
> really foresee a use case for a FIQ NMI at the moment (there is no
> plan to use Group-0 interrupts in VMs when the GIC is enabled, and the
> only interrupt controller we have that uses FIQ doesn't even have
> priorities, let alone NMIs).

Sure, I don't care either way - I wasn't sure if people would prefer
symmetry/completeness or minimal usage so took a guess.  I did consider
that the FIQ user might decide to implement NMIs on the basis that
they're easier to use than priorities but it's five minutes work to add
the API back when needed if that does happen.

> > +			/*
> > +			 * Any system with FEAT_NMI should not be
> > +			 * affected by Spectre v2 so we don't mitigate
> > +			 * here.
> > +			 */

> Why? I don't see a good reason not to mitigate it, specially when the
> mitigation is guarded by cpus_have_const_cap(ARM64_SPECTRE_V2). Maybe
> you can explain what the rationale is for this.

Any CPU new enough to have FEAT_NMI is architecturally required to also
have FEAT_CSV2 since that's mandatory since v8.5 and FEAT_NMI is a v8.8
feature.  FEAT_CSV2 means the hardware doesn't need the mitigation, and
we check for it in spectre_v2_get_cpu_hw_mitigation_state().  I was
trying to thread the needle between doing it for a combination of
symmetry and defensive programming and people seeing that the test would
always be false and should therefore be removed, especially in a hot
path like this.=20

--xYeMH8Qodw+sKYZC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQlAIACgkQJNaLcl1U
h9AiXAf/RXNVUxd5RPPLkWaRp+6iTKzl6+f7vm3fFdds81eH9m8Hd/6MGloDsiZj
hVkglwwxVFH1QB+vqiXAx3WUyjjtiFlfjZxUuxVnUdoyg3ZzsGvhmLH6Md22FRBz
0EBqqbrJVgonk+LClTqRxRWcFQRYM8mbovRTYlTlE6QbsXTRtuhjj0vwqrdtEH4a
himcGhXlV/Hs/HcfR3TNsbUB6jqg6CJl5FSuyTJ+hBfv9J7VGdGLqtVtA2GfVDr+
9yuVn8ySbcl9UhCATlgBmZMKEOtapKuIlsanRiDWQfOhPETXXo5iNakM6dXsZY3X
cJIyX1MAybrcPIPs2stHPcSEQ3rjuA==
=cYeY
-----END PGP SIGNATURE-----

--xYeMH8Qodw+sKYZC--
