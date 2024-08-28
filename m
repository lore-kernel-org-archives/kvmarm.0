Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94B319FA94;
	Wed, 28 Aug 2024 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724857840; cv=none; b=gsrUJXpdOrQO1OGMiC85KvO9KR9LbYgwHX/e9S6/oKk/3/05NlBhaU2La6yU0TKH9wR+1QZQVs+PSXKjNstXKEa3WHs7Iwda7Vet+AGkDbAZBqoXG/7UU+3TqXTVXZgfYmMXKFGJ23OOzbsvxmrjiW5bEoVQuIgl+etOsp4R4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724857840; c=relaxed/simple;
	bh=biJYQeVgYUWBWA89iydoCExb8DsITDohv2E4/d/wiAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohgHZu/ojmgJb0lquwcUvyIVn0IvXZORFMSz4gwxFg2HZfZH6nDNL1sMUIw69xIoY50NmpNzpl47Bhi/yZPppGH+x0TkBRhvqnuheNwH684trhDxW67Fk23g2pKBVsmA1Q+U0yWE1l4K+6omB16QYyY+2jWF/hlCWLWIDJvPhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiGS8aL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiGS8aL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4060AC4CEC1;
	Wed, 28 Aug 2024 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724857840;
	bh=biJYQeVgYUWBWA89iydoCExb8DsITDohv2E4/d/wiAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LiGS8aL55y9eA9nBTQFsTJDjmoJEJwIBE0mhM5nDmRbGOt9InuYjer0KBYriDsQDe
	 lz4w2c2cQWAFgzzK/+1t0zoGmRS73ydmcDH4gUdkom3SgHIhRuC9PhVlG0b9cdRzDK
	 3DTW8IwFZMeume+mQM4lX2sBlSIEKHMFO8KxOdTjuUvVGmFLFV5vlP2xzPu+uhVMop
	 woV7x0yiTofOfcHjBYm2SRbGMDCzk8gQtUMfpkqM+I5XGVmgGKQFlEWD4Ep86wPFYh
	 tX05N4zD31uEtNvJEOY4PJK/JA17EeDS1v8ufHlA3OoM0yXwEIEN01pXb4pDeNicTJ
	 o3EEcCzavdoDw==
Date: Wed, 28 Aug 2024 16:10:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Control visibility of S1PIE related
 sysregs to userspace
Message-ID: <41dd2283-d5d8-4171-980d-6385f8b62f68@sirena.org.uk>
References: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
 <86ed6ixa32.wl-maz@kernel.org>
 <e123ee24-2a0c-4ab3-8dc3-2906bf96f38d@sirena.org.uk>
 <86cym2x7cv.wl-maz@kernel.org>
 <5304749b-04c8-44f4-b4de-b2d0cef61169@sirena.org.uk>
 <86bk1lygm1.wl-maz@kernel.org>
 <ZsdZohZhre-fRmUv@finisterre.sirena.org.uk>
 <861q2gxxjr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1rSZ6Ar8gPde4zlM"
Content-Disposition: inline
In-Reply-To: <861q2gxxjr.wl-maz@kernel.org>
X-Cookie: You are number 6!  Who is number one?


--1rSZ6Ar8gPde4zlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 22, 2024 at 06:44:08PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I haven't done an audit for fun cases to see how viable things are, for
> > the EL2 cases I'd just have an encoding based check for EL2 rather than
> > explicitly enumerating the ID register for each EL2.  That seemed
> > quicker and less error prone.

> Sure, you can do that. Or rather, you can do that *right now*. But
> that's not what the architecture says (there is no statement saying
> that Op1==4 for an EL2 register). So the forward-looking way to do it
> is to match the full encoding of a register against the properties
> that define its existence.  Anything else is a short lived hack, and I
> don't care much for them.

Oh, well - I had thought that was a case of me not having found the rule
rather than the rule not existing given how consistent the scheme is
currently but yes, if a rule definiteively doesn't exist then I agree
that making one up in software is a bad idea.

> > The other cases I'm aware of are more along the lines of features
> > restricting the values other features/idregs can have (eg, for SME the
> > information in ID_AA64PFR1_EL1.SME can also be gleaned from
> > ID_AA64SMFR0_EL1.SMEver).

> Well, they don't quite advertise the same thing. If you decode the
> feature specification, you get:

> (FEAT_SME <-> (AArch64 ID_AA64PFR1_EL1.SME >= 1))
> (FEAT_SME2 --> (AArch64 ID_AA64SMFR0_EL1.SMEver >= 1))
> (FEAT_SME2 --> (AArch64 ID_AA64PFR1_EL1.SME >= 2))
> (((AArch64 ID_AA64SMFR0_EL1.SMEver >= 1) || (AArch64 ID_AA64PFR1_EL1.SME >= 2)) --> FEAT_SME2)
> (FEAT_SME2p1 <-> (AArch64 ID_AA64SMFR0_EL1.SMEver >= 2))

> So SME isn't really advertised in SMEver, SME2 is advertised in both
> (and it is enough that one advertises SME2 for the feature to be
> present), and SME2p1 is only advertised in SMEver.

> That's what we need to implement. Yes, this part of the architecture
> is... interesting.

Yes, it's not a 1:1 mapping but you can for example identify the
presence of ZT0 via either SME or SMEVer since either implies FEAT_SME2
which like you say makes things a bit interesting.

> > For those I'm not sure if visibility checks
> > are the best approach, if we should audit the registers when starting
> > the guest to make sure they're self consistent or if we should just pick
> > the most directly relevant register and rely on userspace to enforce
> > consistancy.

> We definitely rely on userspace to enforce consistency. If userspace
> messes up, it's "garbage in, garbage out".

It's definitely the simpler approach.

--1rSZ6Ar8gPde4zlM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbPPeoACgkQJNaLcl1U
h9DVFQf+L7g1Fnx28SJ8CXg4j4VzDz02YsJdysHKApdq4H3hbNdZtKDVB3TmPckY
hIdozWJbyvZi/4cvIvgakCWA965qujkaoEhsqfrP5GnjjwKB1vx1WiK/3sax2nxl
PaNPBpfW6aKNLXurN+H/NATYLXFn+bdMaMrPoDF8sc5k7FpyGiIf+ei839MAYdou
L3/2YsPB9XjmvA4gCAa2xKPGIVdPpVnydjB6vzDukFsZkLivXIDWQgKlrDo5gYDh
POKHTC9TzURjRbKqlGCGaBbIDEKbfVv8Ghxit7fdh/uEyMY+EZKDNWBfm3W6jngh
eMKSGmn8bEes97+p5N7MpJd2sDzkTA==
=8Tbh
-----END PGP SIGNATURE-----

--1rSZ6Ar8gPde4zlM--
