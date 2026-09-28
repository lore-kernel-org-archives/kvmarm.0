Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF274EDCAE;
	Mon, 28 Sep 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612586; cv=none; b=FUcR6YRE17E3so5X8CrqvN7dzAk8mOtK6Qev14xRmmzlqLgfzVIbQ+ju9lMyKDLu7pntgt+FE5ETgb07afOJIYvwca2ZhoVrhsct17DFDfbf2qq0hKlPe8Pjf+RSOiSftbA9rNk4Nsr0JQrwbwxbARo2wzdDfhasAjjhYs+AqCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612586; c=relaxed/simple;
	bh=mKhdntCBuVlgMeNm8tbQb7Cnj6P4iyCp83pUTrwurPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlYhgtrbx0XG4RYb+FyFO2xfprFgvRMxlfeMtcycXirfNBW5zPFNiQ0qHNhvKHNMnbPxloS85Aqb6CfckU1JDG+fSVHILe6HZye2Dsq6hyNIaw93KGYoCf/FPIVkZDO8f1cD2gjzhoLuGYrz2CLo3hVQKJ3o+OxNPdNV0+PyZoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URguE6+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URguE6+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC6B1F00893;
	Mon, 28 Sep 2026 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790612584;
	bh=mKhdntCBuVlgMeNm8tbQb7Cnj6P4iyCp83pUTrwurPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=URguE6+ZiJyeNC5QdcF7Gts/ltH2DJ1Qu7uSOCowGgCEcF+9C4KLrt51H2aotox5c
	 cftSFvdc4aM96MQdsnRiHz8jfHhRtXQN8CuW76NXeXfkXQ+lDNFafy2obZFJ6IZmbh
	 fWKv9kHbiVy6wLNYNRi7EFaePBs5HWNZDagIAfCUbo8J8Yph3pbiEx8h6AbgVtuNoG
	 hReNO+zzzOI2P8iaXL///tviM8wsR7A4ObwmHP3Df2zhNFICi/E2w+dxkmV0IMrYr1
	 0hsvzcKC/oF5vyxX/3Ad+PVQ/muGvnEe9xFhcEUipJ1KSfd9/SEan4DMwqV4t9ULUi
	 fSeReojSssX5w==
Date: Mon, 28 Sep 2026 17:22:59 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: arm64: Block ID register changes after we
 rely on the values
Message-ID: <09970eae-2283-44a9-bb47-6c6f459d71a4@sirena.org.uk>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-2-a0ffa06fa872@kernel.org>
 <arpsY1oqmhvxRVpj@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uxnxKIWYwbBSuLhy"
Content-Disposition: inline
In-Reply-To: <arpsY1oqmhvxRVpj@gremlin>
X-Cookie: All is fear in love and war.


--uxnxKIWYwbBSuLhy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 28, 2026 at 03:36:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 07:18:49PM +0100, Mark Brown wrote:
> > In commit c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling
> > over to FGU infrastructure") a check was added to suppress duplicate
> > recalculation of FGUs based on a flag KVM_ARCH_FLAG_FGU_INITIALIZED. This

> Just for my understanding:

> FGU = Fine-Grained UNDEF -> if feature not present really act as if it's not
> present, don't just not advertise it.

> And that's about ensuring RES0, RES1 handled correctly?

That and registers that are just fully UNDEF.

--uxnxKIWYwbBSuLhy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq6lGIACgkQJNaLcl1U
h9CieQf7Bv8OrYHwyTU+Q8U2Ii8RoH7Y81j3ZZymc25xk67FyvKWoMlm90kSNr7m
b2KvlUUujGzbrKqVYvyDLVGokWSypH8rJYoe5kzxiWxXaVb07D6L7uqWagY4JFjq
uWESs4XLJrP3W2oOW+Mx/SSMTbVfep5+/WPaLY67zM1Lx67q3hS2mj5n8l6GQOcr
JGR0DpX/8oxXJi7Q6VMY5wxNB0ElSPVnh39qfQPz9obagNaBlg6OEWoEHAZdThLD
FDsuqz96LmeRxRlG/v+mF/8Oa5HoZ2F8usmq06X5GcbK8mfhAun/BL3tY4zARSdY
sLLmnysxOOkZIv2VS7BT1jG/oR8lPA==
=ZDVc
-----END PGP SIGNATURE-----

--uxnxKIWYwbBSuLhy--
