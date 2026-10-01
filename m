Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD5492E4F;
	Thu,  1 Oct 2026 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856489; cv=none; b=Rv+Uj0nfJ0ZpEY7vETcOSdBTBVzZsNNcCRItebS/Bn8ZGAbt9MHyA+vcWnHFvBGZsR7SZHrmG//PAPli2m6E/Pxm2faYgV0FC6RmE+ayncLaELHNHKPWCVTPpzOqzy+PMtV8A3YCEz2gBNI24ZjJn1WBx5SdESipylUA3Qqf39M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856489; c=relaxed/simple;
	bh=IhmtRORkFrvn34IwwPfpohsJrntWTzXRh67fyKrxa+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lx7hTvmdl5fxy5uAG7ezLfRzMl7Hkkp2Z1d343ngt2yIUMzA4dmB1UBWA2AT77+kGaiNJLzcELkQtSR3L5CgjoE2Ue8rdoGb2trODeFtx27oqEp9f+Y20CQnbLa+AbF87LeWVDOUhVGtLkC2UuGcu1vBbOJTWZ3r/okicU7/qS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kf30x+mW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kf30x+mW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25671F00898;
	Thu,  1 Oct 2026 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856478;
	bh=IhmtRORkFrvn34IwwPfpohsJrntWTzXRh67fyKrxa+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kf30x+mWYVi6x3ahp7wyZAPGLzt8Kn3UUvAB6NzOZq7cQZt2o74EytRnUM2xT96dG
	 0lu5VT0/R/CdrWmOf+ewpfDFVmR9w7bDWl/bagPGvzI8R4hvicYmYwjNTkYrN75koL
	 jThzR5U4M/ziR590a5KJXXtPbrrTqgV54vbb9IJ/cYHB/Ccb1SiOQ4LE0+QQeYkLrc
	 UMmw5rofd5DmVaNYglHLiiX2CJQ3GOEvRn5UO0JL3lhHLpPoexWq4bDVPvbiRSj2Tz
	 FVR9ZypYraPUXw+ItjAWqF42MqkeDkahj6Qm01mP+cyIxnV6qzmzaD0CbKGw5loQ/Z
	 gJoGVpdVlL2sQ==
Date: Thu, 1 Oct 2026 13:07:54 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <4ac3c797-04ec-4873-90c3-f3b015bd9fb7@sirena.org.uk>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <20260930220551.014471F000FF@smtp.kernel.org>
 <ar47ZOMYvcxlbwY8@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YnWPJcZx56n4iCG9"
Content-Disposition: inline
In-Reply-To: <ar47ZOMYvcxlbwY8@gremlin>
X-Cookie: Do not stamp.


--YnWPJcZx56n4iCG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 01, 2026 at 12:25:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 30, 2026 at 10:05:50PM +0000, sashiko-bot@kernel.org wrote:

> > This regression allows KVM to configure traps based on S1PIE, disabling the
> > trap for PIRE0_EL1, but skipping context-switching the register because TCR2
> > is disabled. Could this allow the guest to directly overwrite the host's
> > physical PIRE0_EL1 register?

> Isn't this just a pre-existing issue and the one addressed by [0]?

> https://lore.kernel.org/kvmarm/20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org/

> I don't think it's related to patch 2/15 in any case.

Yes, it should be due to that.

--YnWPJcZx56n4iCG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq+TRkACgkQJNaLcl1U
h9BbSwf/R2HKUzJcHsD/BX7ks/VcA0aNkRKJBZgQD80g2hinHpmZgsu4XEWHLqzF
B58HdFdOXsXP2oQWrWYhJzrgaBxzChULWSrAJc6/Zo47smvdN6t4vtTtOlpN91CY
FAbY0jB7ir6VMaKvQl0ALFVP0kLPtf65Kl1wT/HGFmW6xqa6iJhoIQ3FL31pXtVC
bl6iEtlj+Iksao9tq/XIbkHPP/qQnSEIu2Iw1c2eCVSYlVNTSvX/2t3KBsqtSGN9
Hz3NcNgP2zY+0xDe681IjEOp+nm0FjaytjQHO2Oft2jTYbDKmkHiu7KEgOiKWybl
chLP+TwNY4iz7lI5bxRMyawFJbTbJw==
=ELuq
-----END PGP SIGNATURE-----

--YnWPJcZx56n4iCG9--
