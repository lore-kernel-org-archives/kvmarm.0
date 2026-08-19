Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487023A83AC;
	Wed, 19 Aug 2026 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157967; cv=none; b=bHLfZMVoJj5W6iHpztwjMWk40Id41L6udnh855kQM/eDMwOGa1B/7/hR8NTZE3fdsiDWoOe1HsgIPZ8cBFECHSA6WgJm3CmHiHOdUaFF55VBhVVWZ+E/owlzpW0xW18bLIkspsS1SYl4hrSsW+Hbgs1hT/dQn0/PdasfuM8PsaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157967; c=relaxed/simple;
	bh=IUmhn09vg1A+FjwptisXhPlfmzytaS0bRtSkorh0bqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSLStfPEY8vhra5mjL+QMMgGMretPSls/mkR/OMF0v2IxdQrvpYCHhcYgJ0RJYFXjLclG+dwNsY7OarBGRHtlri8BBXnqubp4J0lDp30OPoS/KOVfs4ivpe/nCi9sjIgXyOFPbeQF+SjAaMLZROv9bTmi8tHGBz0cO8Zn6hrKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6XU6SjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6XU6SjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E283D1F000E9;
	Wed, 19 Aug 2026 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787157965;
	bh=CTifcNr4LKctsAM4SMxsssPmhWjX8dsPgZMHxI2Vljc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K6XU6SjJEqZOn++A5CEJP1XEh70wIlhZncBG9/McLETQ44Tp/E87sg1NJeN8LIcKh
	 9LeizfBbjQ8zIKz7RKZV11UFQCHHoO4HacbQizZKCuSMEKVGpbd8v0A00V3kN6lK0f
	 abv2c69ZnzZJEKfi12TnYolNjiIST3Ufh01WpBqZMJMgyecK7g7ptBtjsfBwrtEv7x
	 AI6dWb9WT5+1oAHiGSPHhzjRTCma4bd9chUUw7JHaixQ+9cBc/RlFHUnMfMepcz+4O
	 r6OfY27+KR2uHulOubDC1tSeSl4C64mOaFrMd3OElL7t3llZjsnd53Lj8fTG8men/j
	 i6eLfj0PLchMA==
Date: Wed, 19 Aug 2026 17:46:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
 <aoXamcdKoMynTkpX@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bWH43D23LJDpXW5I"
Content-Disposition: inline
In-Reply-To: <aoXamcdKoMynTkpX@LeoBrasDK>
X-Cookie: Allow 6 to 8 weeks for delivery.


--bWH43D23LJDpXW5I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 05:32:25PM +0100, Leonardo Bras wrote:
> On Wed, Aug 12, 2026 at 08:12:02PM +0100, Mark Brown wrote:

> > In order to allow guests to use GCS we also need to configure
> > HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
> > CHKFEAT will report GCS as disabled.

> It is zero on reset, and keeping it in zero disables GCS in EL0&EL1, so=
=20
> unless we are in EL2&0 (HCR_EL2.{E2H, TGE} is {1, 1}), we need to enable =
it=20
> so EL1&0 (guests) can have access to it.

Right.

> > @@ -77,6 +80,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu =
*vcpu)
> >  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
> >  	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
> >  	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
> > +	if (ctxt_has_gcs(&vcpu->arch.ctxt))
> > +		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));

> Out of curiosity here,
> Why does the saving of GCSCR_EL2 depends on ctxt_has_tcrx() (and E2H set)=
,=20
> and saving SYS_GCSPR does not? ...

This is just because there isn't a preexisting ctxt_has_tcrx() check
already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
was a request to make this explicit in the code to try to optimise
things a bit.  The compiler should skip over both blocks at once if TCRX
isn't there rather than having two separate tests or static branches.  I
didn't add new checks where there were none since I expect that to be
unhelpful for code generation, you'd get the reverse situation and emit
two checks.

--bWH43D23LJDpXW5I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqF3ccACgkQJNaLcl1U
h9CcQQf+IxvaF1y9eqa1wPv0kD6ec4r4UKmxZU1Sj6EfStbT+DJpeDDZmbR5wLHi
UIbnCP1BlGVPGIw8QfCpH7x1W3Vk397dUmfHNuEv/HACcnIe7J+3TMA3I0bSD49i
eY7wVTezjJGRBNMtLzFVT9Ed1mK7iZ3xeD2oU7ii0abLeBMmEwuQyvroT6nLqa6I
hmtlWxH5Ps5ol3qaxoD+w12M6YlkXLucm5OgMZ+gpQM0JuQaxOb2UUxBb64PhcH2
0cdjq7xLFg2kz8kdcitYNVmbE34x/2ZJfg4RSV0AT4B5D6Mst3zXJLI8gVcWjO7e
hZdv8j5JdWYVkbXUdOYTVL0HppvTgw==
=FnPL
-----END PGP SIGNATURE-----

--bWH43D23LJDpXW5I--
