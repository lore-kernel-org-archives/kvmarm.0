Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F0D4EB87F;
	Mon, 28 Sep 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612970; cv=none; b=tfjGQ/+TL9g8dWtIYf79mL6udYWoER0hRiL+w1/MW6KVHzu27s6fxf1l18Hq2+FO46JqcBRpgF8Lx42k3bvZItl/Rdtcii9o+XmQcELO7L+MXLUbgXyHly4IGxF9PR25fZbTjDE+Bylym5D1olGZJ8T5kVpPadje3ZjMmPpu2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612970; c=relaxed/simple;
	bh=jsC7eTXb861JGQRBOV+oF6UcxdvctYqJhowMoD7P874=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYbDYLik+fm7xSflpmFtupEibMVOmZPeekpBPeQEnynuIxx/BLjH+7XqvJcL+5+eai+Hpx/SGcI+r641Q5sykrDxzmEoPatVh85azl6qEtn6JXgkseenIy5FJlZo1MAb8L65wt6Ih3l2a6QXy2kKMxigmG6ICqW/t5TnoGe95hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGNsSm5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGNsSm5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187C71F000FF;
	Mon, 28 Sep 2026 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790612969;
	bh=+K5yiCqW9C+tRMYZ/wwccsdp0OS3k1cMcrj4lVdzjRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DGNsSm5CeSch8qKbicKiPS+/iTe9NVwwVAY1o2qvMrigSCn7ZW5izpAY4X8yUhJlZ
	 XC5f77ZgevAcosylEbZnqnE9p612ztQWIkhempJZQH1ec+eXBPIA8N6ZqwLKjhgvvd
	 jUFyuiU1lCHqyrcRATKg+IzIqMYNTYvPMjR3klJaqD2ABO4G84iRb91Hago/EJW9cr
	 YeLcZXBw6k4lGXcpKbwrOa6lSCiDyAs111UWnGibka9Gu+1tE9KGfdon5JFh8oPWq5
	 2cZyNrh7hTuu/TNWld91/aVkopMYRMuTz1hZnPRbBD4753VRHPGsVaEZ3ECk3DCVsf
	 izAy266OL5oQg==
Date: Mon, 28 Sep 2026 17:29:24 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] KVM: selftests: arm64: Report set_id_reg reads of
 test registers as tests
Message-ID: <0cd3acab-b974-41e4-a4a5-639ddadba1d7@sirena.org.uk>
References: <20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org>
 <20260901-kvm-arm64-set-id-regs-aarch64-v7-1-7b065b0bda9a@kernel.org>
 <arqE3CNeYyQpgcMf@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fdLDzAIjJR2VDlrJ"
Content-Disposition: inline
In-Reply-To: <arqE3CNeYyQpgcMf@gremlin>
X-Cookie: All is fear in love and war.


--fdLDzAIjJR2VDlrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 04:26:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 07:50:01PM +0100, Mark Brown wrote:

> > +	switch (id) {
> > +	case SYS_MPIDR_EL1:
> > +		return "MPIDR_EL1";
> > +	case SYS_CLIDR_EL1:
> > +		return "CLIDR_EL1";
> > +	case SYS_CTR_EL0:
> > +		return "CTR_EL0";
> > +	case SYS_MIDR_EL1:
> > +		return "MIDR_EL1";
> > +	case SYS_REVIDR_EL1:
> > +		return "REVIDR_EL1";
> > +	case SYS_AIDR_EL1:
> > +		return "AIDR_EL1";
> > +	default:
> > +		TEST_FAIL("Unknown register");
> > +	}

> I guess these are for GUEST_REG_SYNC() registers, etc. that don't appear =
in the
> TEST_REG() list?

Yes.

> > @@ -828,7 +872,7 @@ int main(void)
> >
> >  	ksft_print_header();
> >
> > -	test_cnt =3D 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
> > +	test_cnt =3D 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
>=20
> I guess because you made things use TAP now?

Yes.

--fdLDzAIjJR2VDlrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq6leMACgkQJNaLcl1U
h9BjmAf/USPitIAZrXSGRtz8RmYTAZ6Zu7zIOqOnzA05aYcufhrgg0JlTCO5i2jF
WUsJEsqePHFiy+W/ydFn7+BZ1hDHABtDvR3k08GrqNyh1zquMnDvPqqppNs0ZHDo
YdYrGjdQF+ujDqk+ZgYwflBO37HWmvceyR/kwjImXyoVo7OP0yrAJIvkUo1CATB6
CtpOujxpIounDRqj7/nvCL6u9n2lfuNXGm4zfpLpNsxw1lMBuMS+ahe5laA6wcx5
XO56EdJkdk8rxJYq5wvq/6AzLFRxJeIS/J82wtz0x53Ljq0IiqFTxmQ33Y9+85kS
6vt6rGEnMmQvzFPK1aSrnqpQlzgwmw==
=1OOp
-----END PGP SIGNATURE-----

--fdLDzAIjJR2VDlrJ--
