Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57810364E80;
	Wed,  5 Aug 2026 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785939333; cv=none; b=a1Y0SPYiYcerRqXqXiSG3KKuJJxSqVECf5YcAtkL4fsvze81fvxW9AQq0BnSjOc/e0M5wZ+nrUktb+eubI7A0wQdfywpaeWIIxE22LymUS0XLcvC11xMoAoyKeKb2NfB0iFAjrnjT/IMGr1aPKjggWJn/QGgsKIqL8EgZ0gWnqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785939333; c=relaxed/simple;
	bh=zdnpd6AlJPO64lrDWNjsjPQEqz5UBDwbwMTcRyzjSYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTI9FZrznXSBNTtuTdAJQhyjOyosJyNHlpKd6K7YUk691b9r5hmYHkqHFf+US0pHoFTye8Hj39mogdEvHLvXgQvpZSKRctMpRcOBJkYQFqm+WcdjPmIXvtda7MMC/hIue9yDPCKiYNdXTUPjwytzqeKwkGO2sMi02/oIX71xSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foBjS06K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foBjS06K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3071F000E9;
	Wed,  5 Aug 2026 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785939328;
	bh=fxGogtOAm0iALwbFbJRw5wOFGI1RipAb1Xj7B5IQYaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=foBjS06KUc/OFPi+sdmPTIVp3l9Ir5q/92/ETsHgqCpnMciG/3eZ9BGBrs4iSu53l
	 raKRbwjVJWoxZNOHPhjiM0PJXQM4SCSuaE8XHlPYV76ABS2d/1+k24X/6SgTzuAflU
	 wO+bQF89sPcje2uOCCzzEn6DA1Gw/1lpWdhaY0o3H+a8SEiXlIDVtjRpc02M/UDEF7
	 7ytCBne5L3dl32Si3AkTIwf8stlznV1dPP20rMFVaOMNMXYVTMbTO7YpRXt5soZS2z
	 Sh7hP8TcdXx5I4u6ubSkhJJGPgqtaoXOPlyH1i3TdlwMpyYRO2ZZRq7jSoQiT/7J3p
	 u8fVQEpCqwnNA==
Date: Wed, 5 Aug 2026 15:15:23 +0100
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
Subject: Re: [PATCH v2] KVM: arm64: selftests: Check ID regs are immutable
 after a failed run
Message-ID: <d2a0c43e-6ed4-432f-ba08-e4e076d17253@sirena.org.uk>
References: <20260805064740.3013538-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7NKDTjH7y4mykaMJ"
Content-Disposition: inline
In-Reply-To: <20260805064740.3013538-1-fuad.tabba@linux.dev>
X-Cookie: Stop ahead.


--7NKDTjH7y4mykaMJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 05, 2026 at 07:47:40AM +0100, Fuad Tabba wrote:
> Add a set_id_regs case covering ID register immutability when a vCPU's
> first KVM_RUN fails after finalization but before
> KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
> a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
> KVM_SET_ONE_REG on the feature and implementation ID registers, and
> KVM_CREATE_DEVICE for a vGIC, are all rejected with -EBUSY.

> +	/*
> +	 * A PMUv3 vCPU left without PMU init is rejected by
> +	 * kvm_arm_pmu_v3_enable(), which runs after sysreg finalization.
> +	 */
> +	r = _vcpu_run(vcpu);
> +	TEST_ASSERT(r < 0 && errno == EINVAL,
> +		    "first KVM_RUN should fail post-finalization: r=%d errno=%d",
> +		    r, errno);

As mentioned on the prior version TEST_ASSERT() is not good practice for
something reporting individual kselftest results, and while there's a
bunch of bad practice in this file we do also have some attempts at
doing better (although not currently entirely successful).

Otherwise this looks fine so I guess

Acked-by: Mark Brown <broonie@kernel.org>

--7NKDTjH7y4mykaMJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpzRXoACgkQJNaLcl1U
h9DgpQf+NiXNgNz+S2xmmQYAF5oWFhIlgcL04ppAf5m1QioqC9i8YyT6gjbjlEq0
62HwWZO7dqJBj7nvrvvSULN8r9CjoBqyAVqpn/C3s8pULSUph+XA6Psy/+8gL8xg
1Kc/ShsanP4oQylJZBhkA0m/nD86hWIKpCWeRj6ATbIigEISAS+I2h1ccExPK8EG
1HqTFfHnGj2vNxO2P0adUueVr4AOPSPL2uLVqIXEUPbL1h18SljzWBufqq6cAJ6q
lEIHE+hs6N863tRjyY+q0DfISxRKxXk16kw0c8VqXq3sxGZV/Wr7NTGLB5IDzNcZ
udHpg9y7ZM358WfE4TCLov0QiN+kRg==
=KIf+
-----END PGP SIGNATURE-----

--7NKDTjH7y4mykaMJ--
