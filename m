Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7B813665B
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 18:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736186814; cv=none; b=gUkgVRqyib/+OPEkYRk8BfvlHXsbx8s6SAjkAKHxlsTOVTSROuD2uTzgDfnG1pXgv0dsigsWzcZxiCrokyh+ZyFWeMBkNb1BiYXrmyxD5JruLXJ0Kk080+rVU1xdYp5M8BSGzvAQ8SdVyI2uuVS7QUlc24UXxxw/8j62YKZNrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736186814; c=relaxed/simple;
	bh=IYBstVCYrspgWhZSdpjgcQcvE2+H3d+Eb8ozdPQwSSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dttyvfOM0i0QWKraMbzRKtgJICHWjDfAFzkXnjbiFZ3+fKLJyyaA34AE3EOfppBsgBqq8gS1y7cJI11L2wb2v7xXOJwpqUm+ulfry8oceFeELENmusr+I25MNtxDjwztKLJ98EuRkupNxvR/+FLmervSU4KzscvO44+V4+XJU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIIpyGYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIIpyGYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4346FC4CED2;
	Mon,  6 Jan 2025 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736186813;
	bh=IYBstVCYrspgWhZSdpjgcQcvE2+H3d+Eb8ozdPQwSSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WIIpyGYg4A0HSXK+GbaXaVsI7rlmV0ozDlF6Uji2MoYBbeY53IbCAbjABtlxuA71m
	 RrFVPwDkpoHaHT7BTIJL7ruVIy964XL03t8P22IJn3ZhWtsoO1wMh+FleuJYbTpxkX
	 et6dswvL7KrgmABKFEBnUt2h0HNjCXAkfdWcU1V3TBv+u5tmV/hmMgxHTPEEEkJhpm
	 PcMGpzTwnJrvJrmfKPVNTUhyncASpV2TYDqipsDk20jjo/2NjWd1DkEhDZhdfvO9Ko
	 iR9TQw4XSIV3wDmzyHLtWDrCQrvFVpdY0CN7H1aeULUiouaPRhfgYQWgH3scfe69ic
	 SF0pmz3l16ZDA==
Date: Mon, 6 Jan 2025 18:06:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] arm64: Add basic JSON register parser
Message-ID: <467ffed2-933a-4f45-8802-3b799dfd6753@sirena.org.uk>
References: <20250102144339.1564778-1-maz@kernel.org>
 <63543c41-607e-45cd-9266-a60838ff233e@sirena.org.uk>
 <8634hvq50l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PQfbZOQezoF/RsuD"
Content-Disposition: inline
In-Reply-To: <8634hvq50l.wl-maz@kernel.org>
X-Cookie: Do not pick the flowers.


--PQfbZOQezoF/RsuD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:30:18PM +0000, Marc Zyngier wrote:

> The moment you use a general purpose language, you end-up reinventing
> JSON in another way, and I didn't have the courage to do that. Also,
> jq feels like an exotic mix of functional programming and Forth,
> something toxic enough to be irresistible.

Yeah, it's super neat for the inline processing stuff.

> Mark Brown <broonie@kernel.org> wrote:

> > then we can hopefully use that for things like diffing two architecture
> > versions while handling cases where we've intentionally diverged from
> > how the architecture describes things. It'd be nice to have something
> > that'd go through and check for updates to registers we already have
> > mapped and provide an updated sysreg file.  It might however just be
> > easier to use something like this and then work with sysreg files using
> > text processing tools.

> My current plan is somehow different: extract all the trapping
> information for each register handled by KVM, and *automatically*
> generate tests that check that KVM is doing the right thing. Or rather
> convince someone to do that.

> Then get rid of all such manually implemented tests from the kernel,
> once and for all.

That would be awesome - there's far too much stuff needs typing in
there.  There's a bunch of these places where we either already use
register data or could use it if it required less typing/verification to
do so, the ideas I mentioned were just the first things that popped into
my mind.  Having a reliable machine readable data source for this
information is going to be *so* helpful.

--PQfbZOQezoF/RsuD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd8G7gACgkQJNaLcl1U
h9BrgQf/bv5vWOvyO9cU7dNIbkh1TXkpAgkTON9IqDitBobS4uT9In8Kp5yTUbgs
4B9Tly5vaLM1hfCCU8Nyy/UnPqqG8gKyS330oSkdHsBa1nr5n5aJXcgXqRznrj1E
/kWGSiG3QXPNwe69C3GL2E7FY8LAu0dMCKAL1IBlpz8nV/rhak5yR4f6gNxinn5O
BDO6JwH/UFIO3KctwS1nrX9cRCeXpRs6NAA5dnlSz0a2udt3rxRuTatn7GSzt/4u
lfnEsI/+3A4cBPBFHx22t7MpeiJutrHWAoraKuM2LDm0mpqEomutaJKqXysiqA7Q
vZPXjHfAKBklRMThzbMMnwG8B/XicA==
=/UTO
-----END PGP SIGNATURE-----

--PQfbZOQezoF/RsuD--
