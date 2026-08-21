Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696BB278161;
	Fri, 21 Aug 2026 22:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350777; cv=none; b=SUj1lrK+g5o7OlWVmnKxRQDouy4k/Tzo/ZGEG3MsFflENVQ0ibwNMzJmv1WrcfWSwi5/e4RUepSecwQqAokgNOxfddUhUlp71mq52ugiFFpvhFxiHGMw6+h+QzTwxp6c6CDnKD1gwDPwmyNAylniMYf9/JsT5AxTG85oPfGDPcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350777; c=relaxed/simple;
	bh=SbOCa5zYZ4ZuB3iUIKfbTvFVZOt3JZcU/D61cVRUvXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqRRZa2nkftLoVtVrUIAH85kAmuj3l8wD4hUUaT0mG8yTfVt3Sus5AaSXLBf0EhCUd56SsnEfg7a8ZyW+U5n6YgBZsw3NsLnetOxYCNDv04qsgp/HzYJ3K4gV70mrMmVhUV/p7r5G4K4+Sp63kD6/s1nKrymFuDLsg+NfcCgpB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmAsk+SS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmAsk+SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE52F1F000E9;
	Fri, 21 Aug 2026 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787350776;
	bh=0NeHBJUd51yUtarGVxbHliftzknjEZ2v7UACWXEhCdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZmAsk+SSUHDa7FIVusSqVMl28Vnrrjcs9YyxiPH2/vuDK3RQT7DL/2d6lIKLnpK2T
	 VQoX+P/voxQP5Y5DapVxuSUAL3z6z/Nao/VRmnOTUOaIgmcUCTpUNvsDblcJiQyEtQ
	 tXL/MDjl9MQLO/inaadHMNglRayg4DU4K+iJ1aVDEYAlT0rFWfYM8o5rc9Rvdg+G00
	 JzuLyTltWLp6Ta1TXHZ8SrIxAda4enCwzjA/tY1LsUt0QfoqbhXJEZgTH752He90yu
	 RRvwfEY2gMRd/J/ZC1w11UEHIrG3qJ+N+iTNO88F8As4wMBVWz4EGbq3Wr9jwb0NKr
	 LZxQitHNf6cAQ==
Date: Fri, 21 Aug 2026 23:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
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
Subject: Re: [PATCH v19 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <02b970b2-dbd9-490f-bfc0-be10708e0f9b@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>
 <vdmz43ogvmwu4liilfqzdrgsf5v765bucl7mybhfdxj7yrywkd@5mssukdegdwg>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h4LzlXfWWvj49V3N"
Content-Disposition: inline
In-Reply-To: <vdmz43ogvmwu4liilfqzdrgsf5v765bucl7mybhfdxj7yrywkd@5mssukdegdwg>
X-Cookie: Package sold by weight, not volume.


--h4LzlXfWWvj49V3N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 21, 2026 at 03:32:58PM +0100, Wei-Lin Chang wrote:
> On Wed, Aug 12, 2026 at 08:12:05PM +0100, Mark Brown wrote:

> > +/*
> > + * A subset of the pseudocode ELFromSPSR(), validity checks are
> > + * assumed to have been done in code that is not GCS specific.
> > + */
> > +static inline int exlock_el_from_spsr(u64 spsr)
> > +{
> > +	return FIELD_GET(GENMASK(3, 2), spsr);
> > +}

> It feels a bit odd to me to have this function named exlock specific, as
> it's just spsr_to_el, right?

As the comment mentions it's not quite that - ELFromSPSR() in the
pseudocode has rather more going on in it that I'd managed to convince
myself wasn't relevant in this specific context.  I didn't want to give
it a name that would cause someone to think it did the full thing and
trip them up using it in a different context where those things do
matter.  I do agree that this results in awkward naming.

Please delete unneeded context from mails when replying.  Doing this
makes it much easier to find your reply in the message, helping ensure
it won't be missed by people scrolling through the irrelevant quoted
material.

--h4LzlXfWWvj49V3N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqIzvEACgkQJNaLcl1U
h9BZIwf/ba+nE8Vy9gULofY3/WFN8ZxH4XRxW6e/DbaSGPJBBf2HHUHVp8/s5DLk
oZUJmCtk/wioY00bc1GOA6wZ0tK8mPMpqB1suUh2OfsA39XPZc3uSIaP3Sc74Mwq
9h3hysTkO/9Ne86KmOkBq2Plkjc3M1fZok/SEgdkXW0mw5q3bfczzS9J+XaUZzN4
4liLWN5tx1n5E7tFE8f9UTU17cufCZGuCCWjOhBXR0iilRj6uvenzU1ioVpi7Z3g
HDT/zdt1sylOzCwoKOWPe8mK0EQfTZSRgpJowSWzBhoPq4+VR3VmOd49XeFy+vzC
uld3QEPfmTg0AP56dErhncG/Q2yZ8A==
=qOw0
-----END PGP SIGNATURE-----

--h4LzlXfWWvj49V3N--
