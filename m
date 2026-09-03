Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E24FECCD;
	Thu,  3 Sep 2026 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468760; cv=none; b=fJnYzuzgzXbNzsifLByNrSqWeVNj2HJ+YZjOTwxP7lpHPrYtgKEWx+4DiDuwh5iWy9neIhFNpjhdsHG5TP2TOURy4t2ihva9DjUcTHpzekT2v/QVYfIgDezyQruyCH4KPuCyBavQ+Np3MEKfz0neEJF13cd7t+NNvvLjsL4gCH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468760; c=relaxed/simple;
	bh=dBZx/5TmNAnkduMjh1UcTzxesGmjDXOANosYgLsKvPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYvAdujBb3LlxpGAIX0ifsM1BmbcUIjmhJCV+4k50e2XYY/DkFsTNSwul1lCskNJhJyrsWpJoNk6SQJytt9FAmBuQ5s6V+Euyverq3AZvRckFrjP2Yzwx1w0txCnuPcjgapN6NdWZrye03stF3zBsoIiwAuOL/f6mRqwdLdcQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nB/FEiJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nB/FEiJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368D1F000E9;
	Thu,  3 Sep 2026 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788468757;
	bh=dBZx/5TmNAnkduMjh1UcTzxesGmjDXOANosYgLsKvPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nB/FEiJqkpHK1N3H92xfIy700HdmhJUQKLxIYwEYMsszR5vSt4VYdsw283/uEjlOg
	 RTv7cHY6OVkv1E/I/hf8ZQ/WDjjxLeTxEpu7PAcrB2WOkzpmUajGI33wy/Q08GJQmL
	 /zcUauYC5EuCNt0HJdxvSvNx5GnYU1G3wqzvOIgrW2v3Oe7B0qJ0hBAW0zFD8oSSDQ
	 MjTgNA+bEhfZclKvbpGERr2SzNiLvYBMPu/kJ5yib7YvBRwj46yoDCHpE1JSU8Uy3T
	 oEfQLqJkf+QG0mLj39lUhTXqe5TTJXK0uUtxkBzjih0oVJ0MLdaRpIkT0JdBRy8YKI
	 R0LlOPg/B0INQ==
Date: Thu, 3 Sep 2026 21:52:32 +0100
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
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <06c7edc2-d000-4fd6-9568-a692f61dbf90@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
 <aphSYqKrgUq5Qycu@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="R4LfhzhDcG0c3nsQ"
Content-Disposition: inline
In-Reply-To: <aphSYqKrgUq5Qycu@LeoBrasDK>
X-Cookie: One picture is worth 128K words.


--R4LfhzhDcG0c3nsQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 02, 2026 at 05:44:18PM +0100, Leonardo Bras wrote:

> Reading this patch, it feels like it should have been two different=20
> patches: one for adding the registers to kvm infra, and the other for=20
> loading/saving it in the code (with GCSEn). If you later decide to split=
=20
> it, feel free to add my R-b in both of them.

This seems to be a fairly standard idiom for KVM feature serieses, and
there is a competing series length concern.

--R4LfhzhDcG0c3nsQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqZ3g8ACgkQJNaLcl1U
h9Dm3gf/dktFZyCaPM2JTPMAToRowclYvGxtdCMiMDHpBMNRouJADsGcjPKIE/JV
eKzl4K6qmaVS3h9+/KQfh8n8rkk6cLBzTrsCw+Jt0UCmA3fzcfgfaDHKN5modVGC
rc7lOxVAzXAEQeJLBi/lzY9o04K5eBxOEiT0vFUu4KODs83al43Jsj4CP7T3QvBd
YPGgF7WREduHPBGd+2KJXoAUEv6gJEfz6yuqjM6NNOEhKUEqv2evqJz+HU3qpYEc
oOiyx1YggFsHUhcpB6XvxmGQMVrdPMbbIyECF/gbRSpJW+xI2yiNHeMpvJuMuPH6
ET5clDzcTa27EQCPCmaGCkRM3SEM+w==
=bULZ
-----END PGP SIGNATURE-----

--R4LfhzhDcG0c3nsQ--
