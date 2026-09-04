Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912BC47127F;
	Fri,  4 Sep 2026 11:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522500; cv=none; b=JjZujU/lWVljrX/KS95+QeF6r6cd1GAxEXmIM5qgnQ/Jw6UvIFRwRbf2v/nXLzW5GHh2KrbgXVzPuvSCAjYQUjgE5ysm1nBlC0fH/xFeomPAu+pLH6eIEureE7Zzr8bAZgVDu421+dENPtOlbBj7YvOokJZ3ZIXKri7l+5UbOO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522500; c=relaxed/simple;
	bh=3O4cz71gaWtXJXPf8rBU4vXnPFpk4s6A/WRXiER9Wu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZAvhn9gFsaTsZDT/93nInCQbmHNuYj4H2QEql11RAs8LAckJabE+xQkw5PdECCSprRAcwlQItC15VXa8eBfA3idFe1VM9Gu7W55xto59JrejcMeUdIasHaZGI3WF28xn8CYP8NmNIx2Fu4eVrEhsRxQM9LyoBWziNKl7w0L+e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=makckEP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="makckEP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA31B1F00A3D;
	Fri,  4 Sep 2026 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788522499;
	bh=A1VaT5+aXzWBXQgC6wes+OIeCAuAyOdJThyWuzoyTF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=makckEP6C1X127q5TRByv4U/kpILjwglUJ+wls9bOOO/m89DNV5ieDVtfu/6Z+wPN
	 KWil+ybFOki5BVgTXl0Q7IFbAQo9RaFVPxhjeDy1yKn11h+QZJPNTGG//sQrLUj25d
	 ngY2rwFi9p/vKlEaSNA9LulT2ptLL8ny71NBiWSUBESO4j2ycFm7WQ2gxzZ0hH4ZHF
	 3NpBEOMQkEhoC3NuDe7GkR2nZEg7VAdFqa56wCmRIB3Cj53Yo/j55pYqaMfnUDvHvp
	 vumFDq1haDgzZ90NgoixFGyi51EPMDVtriCYHBotJ7KKvEA5iJx5YuibPKGU1Zggx5
	 AULXjOlUdrcJA==
Date: Fri, 4 Sep 2026 12:48:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="613BWDzmRI5OPN/B"
Content-Disposition: inline
In-Reply-To: <apqrky27mJmUV9UA@willie-the-truck>
X-Cookie: A is for Apple.


--613BWDzmRI5OPN/B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 12:29:23PM +0100, Will Deacon wrote:
> On Fri, Sep 04, 2026 at 11:33:24AM +0100, Mark Brown wrote:

> > What about pKVM, my understanding was that that is very much an ongoing
> > concern and uses the nVHE hypervisor?  My expectation was that this
> > would only ever get used in hVHE configurations when people enable pKVM
> > on modern hardware, actual nVHE mode was mostly just carried along with
> > that.

> pKVM uses hVHE wherever it can nowadays, so I'm fine with only supporting
> S1PIE on hVHE and VHE configurations if that's easier to maintain. We
> just need to make sure that the failure mode for nVHE results in the
> feature being gracefully disabled, rather than e.g. crashing or quietly
> doing the wrong thing.

I figure that if we're supporting hVHE it will end up less complicated
to also enable nVHE, it reduces the potential for having bad or missing
fallback paths for features downstream of S1POE.  It's not like it's a
huge extra bit of code and it seems likely to save hassle down the line.

--613BWDzmRI5OPN/B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqar/0ACgkQJNaLcl1U
h9Crnwf/c7v+uIVW4kufu3SqAqgdSA5F256Do+SueGtzPJunOMlwl/K6F7UUd7nt
EjqfQDbL0r4iYdVmq7StbJMAt9RabzT7cjpMaSnZOdAVImR/B2SGis4Ba+OvmB4e
A44UPMLk33sd/23J4/8cDbH1AGNudVd2BtdHiZvUHL2ILDjngBqKa9iZz6GQJe+J
+ZqrTvoh4Ngu2OQzYXuqXYO5jIZ92Kxs3kITwpLO6YGFQNfJRXWiW63+TZ0nbXdN
KhiJcWvI5WZvaNDjYWPTVGL6tFCGeQEoYAYydx9mdCHAlnwFibT64lK8ZcW6DWoM
mJkE7YyvAxqF0FgonEBB7drvSloOTQ==
=jUX3
-----END PGP SIGNATURE-----

--613BWDzmRI5OPN/B--
