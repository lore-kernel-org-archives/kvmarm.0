Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E218BF1
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 19:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3460AC433D6;
	Wed,  7 Dec 2022 19:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670442141;
	bh=iRAbXOcrhjROaOaIrUBq711kZIh9jmGIK5WOvdHRYko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/VK9v2aTCrcFb4jcw59qXSCZXga5CU32GcRV2pvXE8eEzgU9EJO2WyCq7G9ypvnQ
	 pj0NH6ElxnmP8Sg4i70saTVm0ThJP0l72G/c8/xImTbZGBV+/gmp6aZWHusKS1c3nf
	 Mwj0IQW+sDk8l88MqxqMEW78iGzQQxz26sHL7KupzviX1r49wpqrlq4FpvVftapOhW
	 69Gg11cghJRfnZ9NmQyeImhvUaqfB1eGmZoT6MGSHYYoBSG4qoy6vSj/Dfg75DQ/dU
	 UkDtEHYbXLARhzEMyTWKajBFHj28X9Rue+Q0hdYTkf1yv5n6ZtBf2aEwk7JKRQWr9u
	 Q0I+GBoKP4TBQ==
Date: Wed, 7 Dec 2022 19:42:15 +0000
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
Message-ID: <Y5Dsl9ayeu0Zru9m@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-5-broonie@kernel.org>
 <86wn75ls9u.wl-maz@kernel.org>
 <Y44mSokVwLHbGdN7@sirena.org.uk>
 <87tu27rpis.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zrIBSTA3QKe821Fv"
Content-Disposition: inline
In-Reply-To: <87tu27rpis.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--zrIBSTA3QKe821Fv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 07:18:35PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > > +#define SYS_ALLINT_CLR			sys_reg(0, 1, 4, 0, 0)
> > > > +#define SYS_ALLINT_SET			sys_reg(0, 1, 4, 1, 0)

> > > This only covers the immediate versions of ALLINT, and misses the
> > > definition for the register version, aka sys_reg(3, 0, 4, 3, 0).

> > That is already present upstream, we only need to add the immediate
> > versions which the generated header stuff doesn't have any model for
> > yet.

> Ah, missed that one, thanks.

> Out of curiosity, what is missing in the generator to deal with this
> stuff?

We'll need to teach it about registers that don't have any bitfields
defined, at the minute it requires that all the bits in the register are
specified but these don't have anything to specify.  Instead the value
written is part of the register encoding and can they only be used in a
MSR with IIRC only xzr valid as the source register.

--zrIBSTA3QKe821Fv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQ7JcACgkQJNaLcl1U
h9BcTQf8CwjOAj1ZpTAjyGkpWwlz7pYRRkIKQVn2G2njKfQMJ0Tj/KxCjpWuuc7X
G5X1jIRjmf1t4kiRrGugJLKs6nkY3nMUil+yY2gJjAmQF6Tp8axlCTfOR5jJxxxZ
nP6qAA1jfMGWfx7GZYrVVS0EQl+e/F9VC+MTH0s6dvyZjaJgjMa8EXJlYZBzOFHu
RBe4lVxmmZaH62eeH/QpFx0A8WTXP0UF3gNNdYL/Z9dd9rDCzAcoRCgbLphulRQn
NEFY9CRm8oPd364XthKvpBSOl3CvfRk9k0WGiPX50IzcxmG2797xWxb6bwjWrapi
UwERTAWcs3J8qyHU18Yu2l+ucnIDXg==
=dTmk
-----END PGP SIGNATURE-----

--zrIBSTA3QKe821Fv--
