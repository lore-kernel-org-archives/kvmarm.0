Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A70D426694;
	Fri,  4 Sep 2026 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518011; cv=none; b=ecjxazqHXsTyfy//43XEi3OMlT6cCpJV9mdvE+aRSk1e1X+OMnNODv6tP8LmHj/s/i0HeiNBEj2aSdVLODCRGc3DjG9b2ydt5pZgfvHIN3BzYnJbel9QxBScoJwMYlntoJE5spC4KrxEh2f4VRBpAx5ba9wa0X89wHd+y3EP3iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518011; c=relaxed/simple;
	bh=um+PdFFJR98kQldzpxMzgk/ZDhAliw12h80hk8FMLrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONysmmYHY/8IhygTRQ9GTCy09ExUTGZjOSP8BO1smSbwt3F51jHn2YSelcRhjPg7g5rBoBDTq9epDKsxEgBwV7xr9qTmBNrkCKw1tF68EbF54Txno0lpVy5sxyeSh02R1cbIC02CTnbWmRxASlA2Ceya9/DbPz8qUNWm4JaAW1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFuGwZ4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFuGwZ4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F61F00A3D;
	Fri,  4 Sep 2026 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518009;
	bh=KA6Z2/LU2nu5o8uMhRKWPli4CzL+4jTmOudkvcs6Nvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kFuGwZ4htkAaxQDnVGD3u1NcaOHnoTNSbBzIBHfIMlM/r81LttdcFdSdVzog56lgC
	 F4LfKaclWVS6r3c2xzyeHkHtEQs6HlmLKPN3ypnJF7sNqMavkmSuBFAOF+eyT50rR3
	 YtOnugjv7rNuykj+n4ws9+JmNHXzHUPIc+5qLfuYwMaddkG21QUsqJmI1gTmuDZel5
	 7YYHe7FyCz6n6eSjUXRsKbKBAYF2vwPhgJbWspmLOa3zK2RbzQDA81OGjfrlneGgAh
	 o1qV/uUMw7SqQNOuPxtqYjbSGAXaT7DR7xRkJiyt/Kvd8zPsOpJNLhCjWqS4xyqx5q
	 O4YjNEQ/ZFv8w==
Date: Fri, 4 Sep 2026 11:33:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SRGhXbx+xRQ2WZrs"
Content-Disposition: inline
In-Reply-To: <86pkyt4gvt.wl-maz@kernel.org>
X-Cookie: A is for Apple.


--SRGhXbx+xRQ2WZrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 08:25:58AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > When FEAT_S1PIE (stage 1 permission indirection) is supported we
> > currently enable and use it in the hypervisor when running in VHE mode
> > but not when running in nVHE or hVHE mode.  While systems with
> > FEAT_S1PIE would normally use VHE users can configure them for nVHE or
> > hVHE, for example in order to run protected guests.  Enable FEAT_S1PIE
> > with nVHE and hVHE.

> No. nVHE is dead, and I'm not adding support for random stuff that
> appeared over 10 years after v8.0. If you have S1PIE, you have VHE.

> If you force the kernel to run with E2H==0, that's your own problem.

What about pKVM, my understanding was that that is very much an ongoing
concern and uses the nVHE hypervisor?  My expectation was that this
would only ever get used in hVHE configurations when people enable pKVM
on modern hardware, actual nVHE mode was mostly just carried along with
that.

--SRGhXbx+xRQ2WZrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqannMACgkQJNaLcl1U
h9ClCAf/VHBLEA44WZBa2i3kDIYbv8kQYBTPQtGFRc4TgF8ppyYGd/1uG1a4oLwT
OnnTBuAmQtfxIYsQaUpK48EjYRr+nqWVn7prOwftXyzvFeNaWchCJwjYNMjfndHc
qBQZkER5xOLeQ52Np/XMF0UarDT0VGkZinLql+a6bVd6VEYiYsvCH3dUs6GQ1ACM
7+XetScfgfE95q1hBBiwz5nqaNWyrPE3omzHq8yLZ5ZVDG7S7QcG8PUsBrRUKmFb
ppwT6bR9zQwshxF5OBkfp7uKA9t6h2+ueCp8LErLEx1KyiOy63w1TSpkCgKxyuMw
n+x1qZTqmQx95z6mQSHoijN5M1/3uQ==
=+aEE
-----END PGP SIGNATURE-----

--SRGhXbx+xRQ2WZrs--
