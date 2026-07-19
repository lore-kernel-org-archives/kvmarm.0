Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613251BF33;
	Sun, 19 Jul 2026 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784464829; cv=none; b=VdGXVmtciuYND+SnW+k/lHg6gpfhJB7wxrwDIcinR/sqyyI/YSTbcSNy8Hpnd6WOqHl5mjRjStcUeXee1Dt6EL/+zyBddRXOEIHB/MNxO7xIUMhHtOJ96glsBAHxAlfBP1Vf+fnsl0NaZUH8+HswftBBsHS0Fpet5q4qaDnj6lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784464829; c=relaxed/simple;
	bh=QuqBVQP8NJb7wuHdseF3lIkK9eqxxreMGLr5td5Qi0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGGV01tgevEAVqUqNU4SlZwd1JaASq2VJw8rANgqdxMFAYG8NspLjOcbB26+yOe/FI2rstJkrJ86klHrnGDsPNciQ1b3mVsFnqg55htureIqzNljzNvKKem73nDQt2CPoOvktx1cxyzQLNNSyz3sfzHpFDDkiIEOJdxbQf8Nmkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQ6dzc9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQ6dzc9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5611F000E9;
	Sun, 19 Jul 2026 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784464828;
	bh=YOvOB8pIvE3bMR4eqh6BMH0CqqAl676IHewqOrjLT8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JQ6dzc9QYPamUTpUaOaGouWGchnGCu20cdv0d+AyLEkXf3ewVclThnMK0IZuBjccO
	 LuJqE3WfClBs9/2lkIvk/lIVONDGui/UjZcgbW1hvO1onjvJYgLAM0Up4bvIImtuP4
	 LID8WR17HyqbW7r15tlenPh0Uz/lyzeC2KnUUmessRhDB3kHnDtFv2HeeBkpu6WSgz
	 mdfFHC+EbeCbi9vAnFMWeLtCxW6kVCVKUsDerkcC5T8y9tS9jI2AQsMrCSyjpw2pxm
	 lJZ7LhM9YJiuLpO2At8IOi2N8UQGILSqTodkl+LFDoBEwkmy9+Sv9OogHxghMr3UVg
	 7RaAu0g0tN8BQ==
Date: Sun, 19 Jul 2026 13:40:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <18229974-b26d-4eed-82f7-7af7e1c26634@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
 <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
 <CA+EHjTw9rGvQyev-4i7zkO5bPPZKGYn858485dCs8iHmCi0t3w@mail.gmail.com>
 <43f21c65-c5ba-44a3-9741-548390df369b@sirena.org.uk>
 <87a4rnqsuu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OIicqM3g5+ivtiDy"
Content-Disposition: inline
In-Reply-To: <87a4rnqsuu.wl-maz@kernel.org>
X-Cookie: Courage is grace under pressure.


--OIicqM3g5+ivtiDy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 19, 2026 at 09:35:53AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I've gone and implemented the first which will suppress the isb() for
> > current host kernel SME usage, the second two are starting to get more
> > fiddly than seems sensible to do right now.

> I really wish you didn't optimise anything at all at this stage.

> "Optimisation" is exactly what got us into so much trouble over the
> past two years, and I really don't want SME in KVM to follow the same
> trajectory.

> So leave this is a straight ISB, no optimisation. Once you come back
> with actual data showing that this is a terrible bottleneck affecting
> real workloads on real HW, we'll look at it. But until then, please
> keep it as stupid as possible.

I've already left the KVM hypervisor code like that - I only updated the
code here in the main kernel since that keeps the end effect for
existing systems and workloads the same.  I am aware that there has been
a great deal of attention paid to the barriers we have in the context
switch path so I am concerned that other people might have a different
view on adding one.

--OIicqM3g5+ivtiDy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpcxbQACgkQJNaLcl1U
h9DuzAf7BxGM4X6minFYapCsREk9SxuGWXgUZbzaq6n4+zLM/myAGA2hw1BwzRdB
Qv2Iin/BHgelt7fpfJUK+OKlWIfzdPFnUtSytVdER5XMXnEPmwx2bw45YMuwxB4O
anFUbDn7Q013adk1AEy/WAfmNNBooAzV0VB9OmKPqGvyZx92907MoOk8QzMDY40+
Hy0AXBkhXOwXq+MinOQlq+PA40qXfCk1cawPFrmDzWeiDZkDvcAHnS83+nX3v7Hw
izYjvCfY9adu+r7owVAKcP2FVWeoMJ0TFh48efIZmck4HsJmqtiekbGkyXr3Eq60
+Rl8dz5E1e1gxRadq/4qNcvgKUeCkg==
=354Q
-----END PGP SIGNATURE-----

--OIicqM3g5+ivtiDy--
