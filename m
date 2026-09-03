Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEFA3F327A;
	Thu,  3 Sep 2026 19:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463385; cv=none; b=itB18XVHyL0n/og2ms4tNa+MU2Blwk7CD1T3y9x2JpviUtMnsZ2A52Vo73NvNgpve0JkKRyhjKqs96ZkLx45Uu0KRwaCBZJFkFb/W9nwRIblgnSI25xvyTmxCfk+gBsIKvWWN4imBhrTk7Flev61yEbQ9KmkLc9zCFfI56sRwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463385; c=relaxed/simple;
	bh=zIdl91D6ORDkwpknscGEnctFl/pfmgtgzsITEqhGiQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcU7iLjxl9VQO8v9AYetg5NrlLFPXukf4SndnVHMfL7KOqpJ4UEVuvQ5UeLTZ2V/OSor7FnrMp2GNVcxvXk3Lr9QbfvErhZKafM57TIccsDk1Ijx/c1inYWS4Kko9/vf08dJOMX1BXQ3dsHdbvR2SGfAl4AAAWSZemJskTnMsck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eq3mLAaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eq3mLAaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19591F000E9;
	Thu,  3 Sep 2026 19:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788463370;
	bh=jFhzBS1p0lG2LruR2+BckK4vK7HH/sYYjUOds7nc9Hg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eq3mLAaSPB4voJ6QGMp4RvSKhHlOJf6YwvpgZNNfizpXsS+y28EGwwS+nWLA69TkI
	 cvCYG9yS9003xf6MHKDIi4aCU2fgwe0+adOLOYZ4LIuAhr0D/l3QLIuX5nyZ1eOPp9
	 +Qz5OT5oAPUHtxQVXZX4+MroNEgtD/TH84JQDRhCDjJy6JGa9jJNhLl08L5bF7mvS2
	 XTFl5L6VgFwIUWHMkapMqfUldN6ytTGMKnuBUi1OHBFv7CiG8bihCcSHDjtooT/ya4
	 KOtsIHfq1w+k48H1i7JX92j4EkvBHG2eg8Qk8fSSmt1S1o7yRNPsxktXgV6VRKmE1k
	 v1uW997Z9wDlg==
Date: Thu, 3 Sep 2026 20:22:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <2dfd8a6c-42c2-466c-b3d6-2313466fc3d5@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org>
 <apmUQETDlhTIuJIY@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ug4ID8koTk9HgjR1"
Content-Disposition: inline
In-Reply-To: <apmUQETDlhTIuJIY@LeoBrasDK>
X-Cookie: One picture is worth 128K words.


--Ug4ID8koTk9HgjR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2026 at 04:37:37PM +0100, Leonardo Bras wrote:
> On Tue, Sep 01, 2026 at 10:47:04PM +0100, Mark Brown wrote:

> > +	return vcpu_read_sys_reg(vcpu, GCSCR_EL2) & GCSCR_ELx_EXLOCKEN;
> > +}

> The above perfectly translates the GCS part of IllegalExceptionReturn().

> It's a nit, as I suppose there should be no compiler warning on that, but
> the function should return a bool, and the last return line returns an u6=
4.

> Maybe adding a "return !!()" would be better?

There's no need to manually do translations like that in C, the
conversion of 0 to false and any non-zero value to true when an
integer is used in a boolean context is in the standard.

> >  	 * - trying to return to EL1 with HCR_EL2.TGE set
> > +	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
> > +	 *   to return from ELx the same EL.
> >  	 */
> >  	if (mode =3D=3D PSR_MODE_EL3t   || mode =3D=3D PSR_MODE_EL3h ||
> >  	    mode =3D=3D 0b00001         || (mode & BIT(1))       ||
> >  	    (spsr & PSR_MODE32_BIT) ||
> > +	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
> >  	    (vcpu_el2_tge_is_set(vcpu) && (mode =3D=3D PSR_MODE_EL1t ||
> >  					   mode =3D=3D PSR_MODE_EL1h))) {
> >  		u64 mask;
>=20
> In IllegalExceptionReturn(), the GCS-related clause happens at the end, a=
nd=20
> here it happens before the TGE one. Could this cause any weird behavior i=
n=20
> the future?
>=20
> I get that by doing like this you don't change the last line of the "if",=
=20
> but I wonder if that could change anything.

Given that we take the same action regardless of which or clause
triggers I can't see how it would matter.

> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -383,6 +383,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *v=
cpu, u64 *exit_code)
> >  		return false;
> >  	}

> > +	/* Push GCS exception lock failures into the slow path */
> > +	if (kvm_check_illegal_exlock_return(vcpu, spsr))
> > +		return false;

> >  	/* If ERETAx fails, take the slow path */
> >  	if (esr_iss_is_eretax(esr)) {
> >  		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))

> IIUC, this function will be called on the __kvm_vcpu_run_vhe() inner loop=
,=20
> in the cases where the guest exited due to a eret.=20

> What you change here is that in case of an illegal exlock return, it goes=
=20
> out of the loop and return to host kernel, probably to deal with it in th=
e=20
> mentioned slowpath, the same way the ERETAx entry does.

> I don't question on this being needed.=20
> I would just like to understand why this is needed here.=20

> This does not seem to be related to nested, as this is called in=20
> __fixup_guest_exit() and not in fixup_nv_guest_exit(). But would not=20
> hardware be responsible for cheking this, then?

The code is here because it's part of the ERET handling, this should
only happen for NV as we're not trapping ERET instructions otherwise.
We need this because ERETs from vEL2 are handled in software, modulo the
NV3 fast path mentioned at the top of the function.

--Ug4ID8koTk9HgjR1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqZyQMACgkQJNaLcl1U
h9BdlAgAg/vm1pIuWe7qZ9b1noGxbfdkaFbNZ5SWt0N2KK6/8F2UJ+y4v6tqMYHT
t9NxEVNZfiIM79x7fKbEreG/OCRWjFAwNUkteyWYMSBLgog/YebnvlrQL66Mop2c
yL1p6u2l571tA7lZbMEm98HmiT0fttx91f6r2DjLTag8vb4a9H75pHXd3s0kxW8f
XOwJv8lPIPOkuO0SG8moVB708PvGoWjYxp9Ncks34vNor2Yxy9XsgS+NzHC+Cs2P
8eiv0xN8E8FQWxx4lbRolJPXxbEActI9PsOmHwlMnIL0QhEbI73X6T+XIr0ljsEH
H0mA/3kr2QoXIEKU0nwXo8JzIh20qA==
=6Xn8
-----END PGP SIGNATURE-----

--Ug4ID8koTk9HgjR1--
