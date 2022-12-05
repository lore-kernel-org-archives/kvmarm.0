Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8B315C83
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 19:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FD1C433D6;
	Mon,  5 Dec 2022 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670268726;
	bh=9CnHmINLwUwFVW5vwib1lecyWslV/WF46W+aAbbY5Fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QxYbNrYuTe2qiXVXb0jG0YQSHeQR0Jxl8fNh+yUnlY7mFVDNd79NUqxIUZQePAtgv
	 wPjepuUSiXeFXkxm+lAPg9D7ntK0EDsGRCt3tnxFyXWB0vyZkW6NzTTJmDKAdRSGO0
	 nQLECS18uAX2miJ2zHtxH0JQIo3GJX6RcipnMMN3RIZ51HGHLN3L3vsAbqsFCfjGGz
	 rcWgup6EXgVLmHP48tKjZoeQDCg70vj9iAoQdkz28+kxpdGXu9nWKlRG8qgURTSt+v
	 QykXxnfQBKvtCj/oP3O5oehalTxb7q1jGsl/STieHWpdG26dch6OUabMzZ7vZaFwxl
	 UtfuDbkUy3nxQ==
Date: Mon, 5 Dec 2022 19:32:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 08/14] arm64/cpufeature: Detect PE support for FEAT_NMI
Message-ID: <Y45HMaXwUcSHEplv@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-9-broonie@kernel.org>
 <86r0xdlodg.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JxYSsaiqUzbyilFy"
Content-Disposition: inline
In-Reply-To: <86r0xdlodg.wl-maz@kernel.org>
X-Cookie: If it ain't broke, don't fix it.


--JxYSsaiqUzbyilFy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2022 at 06:03:07PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +#ifdef CONFIG_ARM64_NMI
> > +	{
> > +		.desc = "Non-maskable Interrupts",
> > +		.capability = ARM64_HAS_NMI,
> > +		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,

> PSEUDO_NMI uses ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE. What is the
> rational for using a different policy here?

I couldn't identify any issues that the kernel would have if the feature
was present in the hardware but unused so I didn't see the need to be
additionally restrictive.  TBH I'm not 100% clear why the _STRICT is
there for pseudo NMIs, it seemed a bit out of scope for this series to
try to clean that up though.

> The whole thing is way too restrictive: KVM definitely needs to know
> that the feature exists, even if there is no use for it in the host
> kernel. There is no reason why guests shouldn't be able to use this
> even if the host doesn't care about it.

> Which means you need two properties: one that advertises the
> availability of the feature, and one that makes use of it in the
> kernel.

To be clear I think what you're looking for here is a capability that
omits the cross-check with pseudo NMIs rather than something that's
strictly checking the hardware (so ID register overrides will still
apply)?  I've done that locally, my tree currently has capabilites
HAS_NMI and USES_NMI.

--JxYSsaiqUzbyilFy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOORzAACgkQJNaLcl1U
h9BwkQf/YpN9KFkad/ukpfEAjti3rWgQZqO67313c2237y9LuzW3ehQd1O5oovAg
Zi6pYl/KtiAOs1arpTdqKNjjsk1cRKjBC7Kb10vg4SjtLg3elD1Ogp+ji2NUerME
s/FkCz3UeGw/qd0fqNCBhV439hORNR9oQTxWnjND/fCbRFRFgDKjsI3LxB2kBbrs
+ZvMvGVpMI21KB1YS+t/SUOnre9EItpFkHQ1oONVdS/j7mgATmimg6RMVbcYR0tB
kJ484tV5MY/ySfdjZBnzpoFNTDEBLBV02u3q6obo4GQmXGaVcT5WEXPrnrffClNt
wh1h3pxGFLC6EmwhixeiCVPlBLrorQ==
=/513
-----END PGP SIGNATURE-----

--JxYSsaiqUzbyilFy--
