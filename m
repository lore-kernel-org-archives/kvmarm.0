Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F452E054;
	Wed,  9 Sep 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956260; cv=none; b=s4VJI0jQ4YSdk/6FfcnD/YGsAKkHzd5lLd8WdkKyI5IrorPXO451Cdufu8gJR/njasXVQRTu0ysfeoZ8a7AhuuVH/0sn4a4GX+J1mXIhBozVSID5bKCdHM/vVgjS+5owfbRIFksRwd6VpOgzpr+lzhKz0az0UukJaXIFjU+fwcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956260; c=relaxed/simple;
	bh=uLcy+jggp2AjWvoSKdjgh2Z1kpnBks6fQKrmv0yE+jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpPSy10EeTMiyuplcM+0CrymslNLVJsbGfKVbalWtP+9++gp4TAXievulgKr+o6KZMfiMm6xCMjaFSH9MRr4XvBbT0sWZfcvvp5U5TntqKZwkdyZF7HczqN6WC622K64kksKGM6rf9YPyW69P5qZx33X6NIwMHTiCB9hzpfvIY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtsvA6WM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtsvA6WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440B21F00ACA;
	Wed,  9 Sep 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788956258;
	bh=prvGSj+fZwUA3hFUhb/5k8cPZC64I4Fvs/1jMwi2UW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XtsvA6WMsvy+Wz3Bt8v0Bdxjg2HPd0rypeZl5SXrxIgVGRT8K6jgPwU4m3cVxZQCm
	 oDHPAIyVoAmgXZ2TE3fA4kJ6ndh5z9JktCCvs4KjO1tEYAW6pGXuzIsYs8w0lJ1Jfs
	 dTN05KtGiIFCChfQdHpdwje0Sqx/jEgvapZmSgZBO1fsEswuEZ4eNL8jxNmbkuOCtK
	 XWO33Mz1fkPNI800PG1f336LFJCdQiU/bTlnmHer56LSvMWwS+soEyRVm8Une2MAq/
	 +mnQ3QKlY7Jql7clJFLnSDTMpFzj7QKxKPCxDsXElcKUkhzXnBqS/GZgyJhbl2zBj1
	 9n+FrZQWu0TqQ==
Date: Wed, 9 Sep 2026 13:17:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Enable S1PIE for hVHE
Message-ID: <e3c716c2-66ef-4dd0-bcae-6df4ff814e48@sirena.org.uk>
References: <20260908-kvm-arm64-nvhe-pie-v2-1-79e42d28cc08@kernel.org>
 <861pb24v45.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MuKrjLDOhzI+PFOi"
Content-Disposition: inline
In-Reply-To: <861pb24v45.wl-maz@kernel.org>
X-Cookie: Postage will be paid by addressee.


--MuKrjLDOhzI+PFOi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2026 at 10:44:26AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > hVHE.  Enable FEAT_S1PIE with hVHE only, hVHE is used for protected VMs
> > but there is no real use case for nVHE mode on hardware with this
> > feature.

> That's not the reason. The reason is that there is no nVHE-only
> hardware with PIE, and that on VHE-capable HW, nVHE and hVHE are
> strictly equivalent. Therefore there is no need to add support for HW
> that does not exist.

Right, that's the reason why there is no real use case for nVHE on this
hardware - even where S1PIE capable hardware can run nVHE there is
always a preferable mode that delivers the same functionality.  I'll
make this more explicit.

> > This should have no practical impact other than causing any unexpected
> > encodings to map to no permissions instead of their default
> > meanings.

> What default meanings?

The meanings that are defined when S1PIE is not enabled.  I will make
this more explicit, or given your comments further down about not
sharing code possibly just renumber so it's not a thing any more.

> > +#define KVM_HYP_PIR_IDX(uxn, pxn, dbm, ap1) (((uxn) << 3) | ((pxn) << 2) | \
> > +					     ((dbm) << 1) | (ap1))
> > +

> This is not what these bits are called. They are just PIIndex[] bits.

I was trying to make it easier to map thing between non-S1PIE and S1PIE
encodings, I'll rename and add a comment to help people follow when
updating.

> > +alternative_if ARM64_HAS_S1PIE
> > +	/* S1PIE is only enabled with TCR2_EL2.PIE if we are running hVHE */
> > +	mov_q	x1, KVM_HVHE_PIR_EL2
> > +	msr	REG_PIR_EL2, x1
> > +	msr	REG_PIRE0_EL2, xzr
> > +alternative_else_nop_endif

> > +alternative_if ARM64_HAS_TCR2
> > +	ldr	x1, [x0, #NVHE_INIT_TCR2_EL2]
> > +	msr	REG_TCR2_EL2, x1
> > +alternative_else_nop_endif

> S1PIE implies TCR2. Why the additional alternatives?

That is true but TCR2 does not imply S1PIE, I wrote things this way so
that TCR2 is initialised even if we end up on a system where that is
present but S1PIE is not (or S1PIE is present but has been disabled by a
command line override).  This is during startup so it seemed reasonable
to write things in a straightforward and easy to read fashion.

> TBH, I think this is completely going the wrong way. Why can't we
> write this as a discrete enumeration of the permission combination we
> support (all 3 of them), and map that to the correct index?

I was deliberately following a similar pattern to that used for the host
kernel, intended to minimise code changes.  I will rework so we have an
alternative path for S1PIE rather than trying to share.

--MuKrjLDOhzI+PFOi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqhTlwACgkQJNaLcl1U
h9DVCAf9FkLa9EZrlgi6pdkBsc+Zaeb31MjhKkDCcZjLX6spejzs3GGxFnfz3gax
Rn3YMBzXTz0oB5cD9/nP0lAzr99Eq+HdHKbToBocm/U4R8eYZkWRN3flhnfkgRwN
izCAbdK0aAMowX4UGyWPEfVtC71PNTkBegLTTfbChDRmEAmKv8LYSmFjaXywjmkd
IMAecl+BnE8W2lMVDYVNvSJ4YO4dD1d/csfbixh1E87XeuyvOusrjAmbvvIENl4D
9zC7/g8kwJBu4wGn5Jww2sjtWz0ou8oJKQMzQ1TvgcwTXec4YQebamZxFEaTB1fc
dIT1nVqkE5JKtDXKVqmQBX72EOhrcA==
=xhkR
-----END PGP SIGNATURE-----

--MuKrjLDOhzI+PFOi--
