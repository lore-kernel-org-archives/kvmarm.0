Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014E43EDE43;
	Fri,  4 Sep 2026 13:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530057; cv=none; b=ewgJhaHRbyo/msc37pABCfBK9Zdx21GmpQBllYVIa6w6Uea3fdU6gBQblrAHl++KWdV3V0HJRrkFHiMJYHZ5m9BIb53EafiPwNZSK/te1J+b38qr2lfva6TwGee1ZDJbgLHkCTD4hgAK9E117bcuwJ5CMdfhr5u3Ft6ydMSnacc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530057; c=relaxed/simple;
	bh=7MnOCOoccYNN9liJj+oDsXMNgtsf8zUHVcY4BoPfYKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ogu1Bz870h+gRWqO9epE+SLmWTpzfEAS+Gy43CoOQpeuenohJTlzpOjY94xnwd8SS+EQk63gWABTOh/uZIdWTS33VVJDiTy4EnNEGEumRXNoMjxIkf1Klr2zQAMZFTTSojLPF82QvsCEHLwdKFdJ2DslqtetLwwn0ABDqckVIkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mm9Z5z9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mm9Z5z9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5C51F00A3D;
	Fri,  4 Sep 2026 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788530055;
	bh=7MnOCOoccYNN9liJj+oDsXMNgtsf8zUHVcY4BoPfYKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mm9Z5z9yzbdEbPnHuhM4YdBzxDvSpMOpAViKv7ZilL88h+7bYAlw9C2LataeP+rsV
	 wEs5o9UpuY7q5lW0EkKcQ+SxXMDaW+E6LDbsLxQytYjCWJpi05nTq5lj4zIYT43DmV
	 iZImGxwyJYChrCuuccYOBMF0VAx5UtC9ynNXwraE0mvYuk12nWEgwUIDIPBhnFCT1S
	 re9GeK3EomXHmqMWg0lXfuHuxTA9Jrkl9bFlbt4wF9FrRp0ivEiuwo61krFVbDsCs5
	 koHpAkAC0WsBoW4xVE3VaPjCbuKpPIYJzhK1/lKI7ZmkNjbh9xIdgYiE3oAi93sXmy
	 2fj9OvzyRVePg==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id CD82FD8C0E3; Fri, 04 Sep 2026 14:53:27 +0100 (BST)
Date: Fri, 4 Sep 2026 14:53:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <aprNV2HLQL9ByIcy@sirena.org.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck>
 <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
 <87y0dh40bv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="21/OxgG6ehADjl2k"
Content-Disposition: inline
In-Reply-To: <87y0dh40bv.wl-maz@kernel.org>
X-Cookie: Orders subject to approval.


--21/OxgG6ehADjl2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 02:23:32PM +0100, Marc Zyngier wrote:

> KVM with E2H==0 has reached its architectural peak years ago. We're
> not adding anything to it anymore, and all new architectural bits
> require running with E2H==1.

OK, so you're OK with a hVHE only version of this then?

--21/OxgG6ehADjl2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqazVIACgkQJNaLcl1U
h9Biugf/eVNsyfMbo8kEv74/T0H2F1alqOYWFZhkSjSESmjQpgaVM6aBPxcpl5Vr
ISD4qEFjzVB6IkpZHkDHuI15y/5Psk/27dIuT8iU3yz0eMWv5nQkVDFSwVgj4x4i
GCpIKfx+VcMogifojtAxoKlXjIBYgjYGryM9LooxH4/Xea/J7dpEyMge+HDQhVtp
kJOy7mhpTdu9y+UFEj6g2PN5zSXJHzMbsWWcnbqF+Lp8O6m8NC1Z++4S7cLUaygF
tlW/Umd4bqA/1Rq3d4gTFoaHhhHs2Bnr+02vJ1dOBGW+8C0uK92MtFvEyUrritWu
qsHkzSB/NQQHri54914dhFyB3B+4kA==
=u0ZY
-----END PGP SIGNATURE-----

--21/OxgG6ehADjl2k--
