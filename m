Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615E31547E3
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176800; cv=none; b=JoZNcDcQiQD0Nl1NgfZYgiBhjHGKFGwPbq2Omw8wsPwTe2ciErpWkeLSYGAe5TDKMs8l2kkWHUZCKkUDyO9kDwQ4yMxl80sZOnUORHwHs9zMipUKV/nAxBC3rAAD3zCsJq5M0NUQ7cXYHX4Gn+OfvyOz1p7MquZ7xxrB5vISraE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176800; c=relaxed/simple;
	bh=UkdUQEPRT6i+uYaYiBtXiQpMuazGQOuxcBrbiT0G75k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9PcsFgh+cMnO+7kfSfY4D/AFX29w33e78TkIoawD8VULvMcqWrIq1au7zjn6YsCUcS9nho0sLNq2wsE8DGZdympgAQzbGCHdDS1e/zfXVQPzk2+uXPwJuPW7gpvw0iucz1jTkeVPTvzKS5a2ZRJFqidMqa8s/DgTiwsoVDSJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuzifQjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuzifQjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C22C4CED2;
	Mon,  6 Jan 2025 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736176800;
	bh=UkdUQEPRT6i+uYaYiBtXiQpMuazGQOuxcBrbiT0G75k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FuzifQjTQOs1u1UrAgrBNuZt+jDfroiJRBhZHjDsp8pnecPNE187xQcU18Es8aPHJ
	 F7x5K3fqndbEPi1HLBklJDcbrkec8A1qFParGUziTh1dX9Zkc/4CkPXA1VhPNyqFFG
	 ZTSbGtPk2v6zRK1bq8JDhDEYwtq2TbIzQSCxp0CJsHLF3AT9mQpGWO3e4XcF4lZZOi
	 gI660hmJ9zoDoTWv+JFvQWP2QxqqZpNfCFkGoTptilObuoKNecei3MndNLaDHPomMi
	 JuYJak83wgku4GUXV41XqCxF1/XjQqL0aSyoWH/DTxTmxawJhkI0l4FUSZY8J3CKcE
	 ir11btL1tkdhA==
Date: Mon, 6 Jan 2025 15:19:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] arm64: Add basic JSON register parser
Message-ID: <63543c41-607e-45cd-9266-a60838ff233e@sirena.org.uk>
References: <20250102144339.1564778-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tGudmCzAGUiaRC50"
Content-Disposition: inline
In-Reply-To: <20250102144339.1564778-1-maz@kernel.org>
X-Cookie: Do not pick the flowers.


--tGudmCzAGUiaRC50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2025 at 02:43:39PM +0000, Marc Zyngier wrote:
> We currently populate the sysreg file by hand from the ARM ARM,
> resulting in a bunch of errors being introduced on a regular basis.
> While there is an XML dump of the architecture produced on a quarterly
> basis, the license that comes attached to it excludes any sort of
> open-source usage.

=2E..

> I completely expect this to quickly rewritten by people who know
> what they are doing (I don't) and improved as we understand more
> of the data model.

Thanks for jumping on this so quickly. =20

Reviewed-by: Mark Brown <broonie@kernel.org>

to the extent I understand jq, and it seems to be doing sensible things
for the registers I've tried it with.  This is going to be useful for
getting started and it's helpful to see the feature dependencies.  Like
you suggest it's a good basis for further development, even if we also
get some other tools that won't stop this being useful.

What I was thinking with this stuff was to use something like Python and
parse the files into data structures in memory before outputting them,
then we can hopefully use that for things like diffing two architecture
versions while handling cases where we've intentionally diverged from
how the architecture describes things.  It'd be nice to have something
that'd go through and check for updates to registers we already have
mapped and provide an updated sysreg file.  It might however just be
easier to use something like this and then work with sysreg files using
text processing tools.

--tGudmCzAGUiaRC50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd79JsACgkQJNaLcl1U
h9CsDQf9EI7wJLaFHE50fuo8Q0mRKjG1NhLb++/W8L9uDimppvyXkjI97a/+gF99
UmA72J0MhrV7PkP2zkZN9+htNH8JxngA5nZ8wVV6mU+zVtQE5bjcG+KPfZC6sTw2
009e9Fn/E2Lzv+zRuByHwcv9U6bh/x1hI66aCqe5XmGgo877Ty19TuHHWqk5EiKO
BLHCmoho03JJKqQBHwiuW09LWPGSKJaOxXeoIS3cuaPPT6BqyOfQ0pJVWYXT3J/p
7gmsCwD5aUt1WUJAVV6OsCBptNKL521EmXu/XgqGaYDA0ob8InyTC3v/nhAd8+7w
Ec10RQbziCCknYNhcAXVnm2wezX7HQ==
=fiYP
-----END PGP SIGNATURE-----

--tGudmCzAGUiaRC50--
