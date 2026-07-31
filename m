Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAF029E10F;
	Fri, 31 Jul 2026 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785504713; cv=none; b=CHJs4kALGhuSl34dD+CSWeV1IIpymKpW79hucIB2illwFsIyLIVJX6g+XWZakizEQo8wiz2AkQIcd3wQXYe4v1c26eI/MKQZVFMH97oSEBGc6/N+1QK8eUV//NOE4wj6Z6/xvJDPCMp6EOpGA3yPxjCjR4R3CipWoAKnb8Le8Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785504713; c=relaxed/simple;
	bh=LTGzZuMpDDXt3z2GcTLyG5wT8GGALVJaI/v/rZQ05qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWTmakgTXxiUPYvsPc+MHV5ml35aIzyy6x69Dnnl8+MQMgKOaFsFuCdGLEzurtNJE8nvkYdyyUvpqC5yfFacbh+Kw7NZRSElP06HQXag+mJEGDg6ld1m+TW5UaL5dCU1Z7LX8JM9bTRdwJqfrE6RpwzmwjBG5wOvFDBueco8ftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTLqTaq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTLqTaq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A351F000E9;
	Fri, 31 Jul 2026 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785504712;
	bh=Nwy5LtIJyzLSH49f2B+5SNzBh0CF4ukOlTf0z6WLHGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kTLqTaq93KxTpSRrgOvptgE1T0FTSB+LCEFlps/CLOjIGADuZwILtL96B8Ya6p+7Y
	 S0+5gJSISEEiAWsbX4mdBpzM6fFSRGnyNhCO0f04IP9pYZPAAG9lEgWpFuqOUJaq+q
	 Ykd692B00TPiqmdkceDxg8UPZeIhUnlMqDZH1D0kr+si3SD1EvhOxUTP1SVJdR9UVL
	 HxSTq54csztm0SgP6c/PrnMOTv79oP6BX3TRZJ6zG+kxZdoCn2HOySAYdxFRI2SKrA
	 0NYL8H3FFoOkCHLWZXEIX49IXhVLI0WJuOOaCe2ZO6zR7yBuM8DXqalVhsY82UkLAQ
	 0JRnT7w625LaA==
Date: Fri, 31 Jul 2026 14:31:48 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v17 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Message-ID: <74690e7e-abcf-4e7c-88d0-9212099a9f61@sirena.org.uk>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-10-5e39ca01b14e@kernel.org>
 <20260731130327.71B6E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E+vqQ03824jNIFTb"
Content-Disposition: inline
In-Reply-To: <20260731130327.71B6E1F00A3A@smtp.kernel.org>
X-Cookie: No shirt, no shoes, no service.


--E+vqQ03824jNIFTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 01:03:27PM +0000, sashiko-bot@kernel.org wrote:

> > @@ -757,6 +767,8 @@ static __u64 el2_regs[] =3D {
> >  	SYS_REG(PIRE0_EL2),
> >  	SYS_REG(PIR_EL2),
> >  	SYS_REG(POR_EL2),
> > +	SYS_REG(GCSPR_EL2),
> > +	SYS_REG(GCSCR_EL2),
>=20
> [Severity: Low]
> This isn't a bug, but are these registers inserted out of order compared =
to
> their system register encoding?
>=20
> The el2_regs array appears to be sorted by encoding (Op0, Op1, CRn, CRm,
> Op2). Both GCSCR_EL2 (3, 4, 2, 5, 0) and GCSPR_EL2 (3, 4, 2, 5, 1) have
> CRn=3D2, which suggests they should be placed earlier in the array, perha=
ps
> near VTCR_EL2 or VNCR_EL2.

With the use of symbolic names this sorting is really not at all
obvious...

--E+vqQ03824jNIFTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpso8MACgkQJNaLcl1U
h9BtRwf9EBpLgPwDvrEKN+n8Dg+2t1vscXTvTsqlPMoYzupPdZg3layK+BfGY31i
vujjWYemtdH0CVAygJb1bgCnYoeWeD8fVKxj2QvmPsAOiR2WS3v3t+wIkukckKxA
8HZHhfpqGz/UGoK3YvIT8V17zXAyvtpAMOqlddI9rkpJGTUgljS8WTR+MQh8Di1Z
GJJ/69ayfpk/OD0Vv2a0RDj0pB0u7i3e9mrPuIa4cpPEy0t4vadIi+c+IIvJQ5G0
mb/866UXn2Q3gZXZ3Ru745RZ5eygE8pDyOuxs5Rihy5hbzWUIpV5FG4bSleWNwO1
bYly47+tShxILWz6NvzFTLOo2GUUPQ==
=MFr3
-----END PGP SIGNATURE-----

--E+vqQ03824jNIFTb--
