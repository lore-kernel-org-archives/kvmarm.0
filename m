Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C842581228;
	Thu, 10 Sep 2026 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789064837; cv=none; b=fyuCk/XgAPl1RFFiTrZe7G5A7MDccGHNhNW/50bFQ5A9chMyuRO+/297Wi116Y7Fi9oU0R589oXbZxgqGbH7FMWt6NaxI6ec2BHGoewz2LsiO4wQc7WP4wVh8X3w7vft/th3aXHEV97jK6p614gR3dJvE396mVKFqabSwgUGqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789064837; c=relaxed/simple;
	bh=0vSSK6WtZcqb8rqy3KXVn8UAjYLUA3dmOt/ccxEkfaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkzF5HebdHS2gM7rm6jr4FaJKf2UqimGEF3ecm4OouJvjtIOGHDcByxpySGpHupy0GH/4BnLBm/Mwbw2LrfrE/OHyYyP0gnyycvlAb52/WmZXaOujYvX/B679ag5rfFh8K4M8WAYiaqGKrcwxY36qjsQy7GHAw2ZBqW+NLCTo3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qk7KxeSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qk7KxeSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4479F1F000FF;
	Thu, 10 Sep 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789064825;
	bh=rJEbK5R1WMsCi1nd/mRBsbp9pSddhLoBEvoJ7QLGHGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qk7KxeSx4uvkLCv5EeZBxst1H3lFla6vYtW3mfBIN/ntg3xWvV4+ALHhihLBVJW84
	 l5L743pb8D46lzF+2y+aVkLTFg+EoTCGGur2ngbLicR9pPqkKR+/Aw7sYpVSHYm21B
	 3FUbEVANYOxK33ScP7RA60AOB7dklm9RJZL+PCWxedHqRzOJulxdYUZ3sZfbm1CYei
	 urfAs5wiab9lW4v6yYiflU73tesgPEL6J958KjbxqLN2MIls+OVoLuC977fpdYB4Wd
	 CKoeFc75QURRkaNNGsPKo9GYAoytZAgB/QiIEmh6tCthprwJZs1/vcDwwl3eepGfVN
	 3EAonEaQkI8kA==
Date: Thu, 10 Sep 2026 19:26:59 +0100
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
Subject: Re: [PATCH v20 14/14] KVM: selftests: arm64: Add GCS EXLOCK
 exception emulation test
Message-ID: <da1439eb-8205-4ba5-b37b-7a9aa37e1701@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org>
 <aqLm3qT755sXH_D9@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="noepJog2/w1KCDNh"
Content-Disposition: inline
In-Reply-To: <aqLm3qT755sXH_D9@LeoBrasDK>
X-Cookie: Gravity brings me down.


--noepJog2/w1KCDNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 06:20:30PM +0100, Leonardo Bras wrote:

> The part of re-running test_udf_exception() with HFGITR_EL2 set, IIUC, it
> that part of fine-grained traps. It seems correct, although I am not seei=
ng
> any tests of the EC syndrome being 0x1A to make sure it's in use.

Now that I look again this isn't actually effective anyway, we would
need to run the guest code at emulated EL1 which for something that's
basically just a double check.  I'll just delete the extra runs.

> There are also a lot of expect_exlock being used as an int, even if it's =
a=20
> bool. I understand the idea of summing it as we expect it to be 1 on true=
=20
> or 0 on false, but is it really ok?
> Maybe we could change it to int, so we just set it when we enter=20
> test_sysreg() or test_udf_exception() like:

> -	expect_exlock =3D enable_exlock;
> +	expect_exlock =3D enable_exlock ? 1 : 0;

The conversions between int and and boolean values are part of the C
spec and widely used within the kernel, we don't need to open code it.
A zero in a boolean context is false, any other integer is true.
Similarly false in an integer context is 0, and true is 1.

> If I got the workings right, and both above suggestions (0x1A and=20
> bool->int) are either fixed or considered not an issue, then:

Thanks.

--noepJog2/w1KCDNh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqi9nIACgkQJNaLcl1U
h9B1MQf/T+g3mumUq6R/pCYVf789O/A9BQML6kVM8EHo36BqOjIxaTpfnPmlzx4c
F+R+JPonB9oWkR4f7+ax2L+fJGEgpqs/OVHyz58kjCV/hVD1GE9arHmxpV9rPP8p
sTdEYzjlE5agRfMMubKb/8gC8oQz3lQxG1fcc+uB3vLFKT6Z4KOF4dFGXTkCAbRv
tDxRV/cCzbHdXFewljSN6SNmZT1nBr1CeZQ1E73xt3bUjeogKyQo65BjWL5/2P4H
NZQv9owBjkyqpILZ9vErEKiTYCx7GZuMJsW55uBrCpT2pFnMBYLDoFIaCMxxy5L5
3v8F6UFz+BmF8qZMOG6r5+bCVKwH4g==
=Ndxb
-----END PGP SIGNATURE-----

--noepJog2/w1KCDNh--
