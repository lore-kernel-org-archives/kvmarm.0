Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23C3FC5A5;
	Tue,  4 Aug 2026 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785860107; cv=none; b=EEBLugoy1pXadeWbDRJf0OXN9JAqio/TmaTuaosDdsM8xCUOC2oNvLCPwaXPdsglat0V0oLw87aXXR4v9hTQCUCie/vWmSUs/smfmTzF889e0/LrjePh1Wxvswd4zltH8qvCCNQuUzaJDiEqWqhrRaia5nBCJ157qI3In9TeYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785860107; c=relaxed/simple;
	bh=mKbS+xV0NoOxRJWW/irUOwQqWhIbuGOH3J027GO6NRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0S++KtoM1QvJjV7m0FEIVweprDRy2ZldTr5C2Dit9R29XN7j5szG0XcSBtfuAWo3Z9EyGFc1m52G8XiDJkmI8O75rjikkjn51NnHH5tenl96KnMZP+rvCteITK3qAcRyPoxQZCSqbIfMeDxEI3sQk8j5SfMyyh1wZhbge4B7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4WnSWwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4WnSWwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399BA1F000E9;
	Tue,  4 Aug 2026 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785860098;
	bh=Mt1p7cYUcwFEhnFIxwVKkIVqx6h14n8GPYfKX7AMCk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n4WnSWwXTxjDbdY+W5tlD3UsY0AXM9s/hRQivDOmNsdYxTnEzRuhW5q4ZU4eIQLxw
	 DLWIQM3bXIY01GnCguAeUJwcrNJhtLFxMRLF3NlXYG/cZ9GxV73f+9NrBBhx5fWpaT
	 +z95qn+ic/x1dsrxDHmUnoHn6yzucBGZ2CSwa2ZVVh8NwX2RTrZ76qKGGI6HMUM53d
	 7QI5ZaabGzYDAf7s/BAPl/oQeTgQ40JJ+ZDhbEC4ucL3Ybnew+sM7S7QWE/g8Yf00L
	 g8iSz4otsfnrkUG1OiPeMezDrIipXA460me6Sy5Oh4V/AX7lqvmwNaf3ZFpEOpaIML
	 vtKwJgnMrgT0g==
Date: Tue, 4 Aug 2026 17:14:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Check ID regs are immutable after
 a failed run
Message-ID: <599f665d-7474-4f17-a044-cc92b03d02aa@sirena.org.uk>
References: <20260804092421.1728880-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z3phxlZuUwtCbrTU"
Content-Disposition: inline
In-Reply-To: <20260804092421.1728880-1-fuad.tabba@linux.dev>
X-Cookie: Biz is better.


--z3phxlZuUwtCbrTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 04, 2026 at 10:24:21AM +0100, Fuad Tabba wrote:
> Add a set_id_regs case covering ID register immutability when a vCPU's
> first KVM_RUN fails after finalization but before
> KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
> a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
> KVM_SET_ONE_REG on an ID register and KVM_CREATE_DEVICE for a vGIC are
> both rejected with -EBUSY.

> +	for (int i = 0; i < ARRAY_SIZE(test_regs) && !found; i++) {
> +		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
> +
> +		reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
> +		val = vcpu_get_reg(vcpu, reg);

If we're doing a focused test for the specific issue there's the VM ID
registers as well as the general ID registers and adding an irqchip.

--z3phxlZuUwtCbrTU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpyD/sACgkQJNaLcl1U
h9C8YAf9EMhSIgloBjFk+gFUs12O/TATm4DfMhGeRfvlcALpkawfiIyC1MQxlefq
sd3bgUKbBuOBqRBXBOY/KJoMZzRiK5QWJWTyGMaaDwRKB4uvfg6P1V/VKBY0qhGv
BXnks4iZ70/1K8Fv//PxG8WwePOAcBgDKKXbopoyKEQa7ZQ2JzbF6+m6lxm6nBTV
OuNxcLLG7ZpmcSoO3F2Iu3TfUD2ltq6LP1IrfjW0V+7zmy/X79L7d9P+lCZVL+WR
zj6xNQDWt7KrZMxlgRplUkgEVSh2CmZAjWu70kGyqyaBjqmaalu2Ge6zNlyH7WpI
D6VZ1lYs3eQsU7wZ2jSpX0fv2924RA==
=45sn
-----END PGP SIGNATURE-----

--z3phxlZuUwtCbrTU--
