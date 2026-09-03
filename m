Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35134C9A6;
	Thu,  3 Sep 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452440; cv=none; b=awfXpXMRHfQ214VaUu/8ak84nixwkEYRzsJxFtG+j7sZ8UmJt9+Nm+CJSpLcSK/Yw8vH27GNirFj0MvQYLNAQQ+H5pHK9tyCPbXkCDQye7a2qc0UaSArrhUWOatR4GILAfCCKKhzBpm1lU24peWzB5msnQswhBdv9RrN74eBtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452440; c=relaxed/simple;
	bh=DqRZUDEFKru5IvtuOoKPEWDwRzk1HsN9K+ntlbLAl0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJvQu6LDSAU0Opf3dLJs9q8+jY7xyFXB7ePScNweDl6AF7A5dP8pwMOJpbIK9Yv7OaXeuXw5lHUdTb2Rbg4x8Ssfk8liN2/nZaqhmaz91zGT6bAfp9VdXAZaGzTAwOwiHsO390oXR+w8IrB9FX035U83uEyT3l7xn7XfKJRHg88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JHSYT+Gv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHSYT+Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3921F000E9;
	Thu,  3 Sep 2026 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452438;
	bh=VSLTX2bHv/0VjH84x9GECXxs329plv3yZhSR8Ismajg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JHSYT+GvWm0P+dkLw1CyNPLznI8s+3xaExoLRmN6IOA8imtmumSXFdgiD4v5f0pF1
	 atwkkMYt8GH3a2wxJHQslk4zEkhFaiczCXLEPAe/QMaDPSWYiZXEm+3U78/rsKlDZ1
	 lqz6vFqpZzL9a93yXW1bw3Je16AwSUJpI5DCaWTLbOj1l5NlMpQNNkJ7svcdLuVBQc
	 2DyltC3ievBsnfUuSfYn/FhFVwK3eGydAe894A4Qvs5nXUY5O9+mJKAAAJMMwxr6fK
	 o3vYDAFLRlcXvk20Oz+Ad0amNdXkzrfv0l1antCCk1Y/T7bWsBFZd3Y7OVOFzXil43
	 fuoDqLeKJkETA==
Date: Thu, 3 Sep 2026 17:20:32 +0100
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
Subject: Re: [PATCH v20 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <0c1c0d26-4e96-4076-8863-b4e871e38e67@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>
 <apmDRXBvS-XOi1NJ@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1FpyWFQbSeHo2hc0"
Content-Disposition: inline
In-Reply-To: <apmDRXBvS-XOi1NJ@LeoBrasDK>
X-Cookie: One picture is worth 128K words.


--1FpyWFQbSeHo2hc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2026 at 03:25:09PM +0100, Leonardo Bras wrote:
> On Tue, Sep 01, 2026 at 10:47:03PM +0100, Mark Brown wrote:
> [...]
> > +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> > +	if ((mode | PSR_MODE_THREAD_BIT) !=3D target_mode)
> > +		return 0;

> "Higher" is mentioned here, but the comparison is a "!=3D", so I suppose=
=20
> here we trust the fact that we always have "mode <=3D target_mode", and o=
nly=20
> 2 possible target exception levels (EL2h and EL1h).

> It's a nit, but maybe a "<" here would be more clear?

Sure.

> > +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> > +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> > +	// exception level.  See ARM DDI 0487 R_WTXBY.
> > +	new |=3D compute_exlock(vcpu, mode, target_mode);

> Same nit: am I really setting one bit here? or could be=20
> more stuff depending on the parameters? Having an "if (cond) new |=3D bit"
> seems more clear to what is being done, without needing to read the comme=
nt=20
> above.

The goal with the comment is to explain the rule that the code is
implementing in a style similar to all the other field updates in the
same function.

--1FpyWFQbSeHo2hc0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqZnk8ACgkQJNaLcl1U
h9CuIgf/XRruPIDXIBcedIfznjWLTr7snIOwP3v7dpemoskRUGLV1cqWrxGj9SI6
9ltAHKeDvbyTDBIj+gqwpX2VANkvIteA6Wdrdy+XXL06WSwa0vtzhqLctFaKPP+s
zXyLQSQ52mA5I0Jeh4Eg174P/mV/wmLLBAyoIgJipMFVIpOyiK1OcoyyKEoEzOOZ
srsrDLlBElA+3QUIa3Xai01sDhv2IjcxcUmYHK0bb8EkxLp7RRJJ4bsdCO7dhmR+
hMQlgzqjsAjQZWARZ2CBLnqbG93bkiRwjh++7TtL7av6I1MzMJxvQJoGrkAESGEU
KZRhEuEtKRL2vGveBdnyyQw3MrxxVA==
=gUoM
-----END PGP SIGNATURE-----

--1FpyWFQbSeHo2hc0--
