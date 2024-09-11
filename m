Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256B19C56A;
	Wed, 11 Sep 2024 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726061597; cv=none; b=cExWqrGJ9hvAXQ8qphCj4Br6QbAT/uJeacQ5WTl6kjaUTQCAiog4KICc/K6JGVzQkOtZG+bZhqs5g80kvEr6+qc3Ld+7vp2yKgfdwDCwxREz6hmk1AR3u2NXATT+jWFnD+NozQ0LWLr5inL1eVzExvBmL+Pa0JsEyoC+xNHdMnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726061597; c=relaxed/simple;
	bh=2lv+5lYhuzm+zQ4KqafRaZzkxiF73mW2eFCeH+hVYc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSGGl9N3mEer6gnvXSSpt0pkKj5ZHRgXBxAolJLV4jk+TAPNDusXMnJomtF7AFx8rPM01I8mIC4I90UKpn89f+CKlIIduw5+85Ec9o2mapOq7HW7gIt0SEUHPLeWxcOmu4WYFfIZ8bMjqES0ibzZxK2iqzncNyLbq5XYhxc4f9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boYdHUbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boYdHUbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20613C4CEC5;
	Wed, 11 Sep 2024 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726061596;
	bh=2lv+5lYhuzm+zQ4KqafRaZzkxiF73mW2eFCeH+hVYc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boYdHUbu5J7IYfb3nkoBj5iuaT7RH3UghaPvZKU7l3OwD4f3hSf5DpiV0Izp+jXSp
	 bZBFkrbbl+H/bNHlQLgxzPP+JAtGtOsqfrKqmtg6jcvt3utSCGZjXg3JU8I7uJpO1h
	 3MDWVDzozhSolR5gQX7y2cVBZcogTl8eTPlqfhrZ9M8JMYghgrxaObHHUW6Z2D57uh
	 5r5gb13oiWGklC8ukUa4r+zfjvsO7TOQuouOt+MsKoa7kuxu2FN79UfLSakuoXc1NO
	 0vaXbdPEZkpyxk61F2w5QwNg0C0Eb3GYlq2k+x9SIAqcRZsW3lJrDqNX1gkmj/PwuO
	 t3iNub38Y9ZVQ==
Date: Wed, 11 Sep 2024 14:33:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Constrain the host to the maximum shared SVE
 VL with pKVM
Message-ID: <c504578e-a00a-4f8b-a7bd-329fac45aa5f@sirena.org.uk>
References: <20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org>
 <CA+EHjTzk6_hWFnrEiJVYZnY41qGORL7NQdV6S+cobDy+UcAR-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WUyamLlzWbeu17yh"
Content-Disposition: inline
In-Reply-To: <CA+EHjTzk6_hWFnrEiJVYZnY41qGORL7NQdV6S+cobDy+UcAR-Q@mail.gmail.com>
X-Cookie: No Canadian coins.


--WUyamLlzWbeu17yh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2024 at 01:02:16PM +0100, Fuad Tabba wrote:
> On Tue, 10 Sept 2024 at 21:26, Mark Brown <broonie@kernel.org> wrote:

> The crash is triggered by arch/arm64/kernel/fpsimd.c:487
> (fpsimd_save_user_state(): if (WARN_ON(sve_get_vl() != vl)) ...) ,
> which ends up issuing a SIGKILL.

> The easiest way to consistently reproduce the crash is with a host and
> a guest both running the sve stress test (the one in the arm64
> selftests).

Hrm, I'm not able to reproduce that...

> I think the issue is that this patch doesn't cover all the cases that
> are setting or assuming ZCR_ELx_LEN_MASK as the vector length.

We can't ever assume that VL is ZCR_ELx_LEN_MASK since that might not be
physically supported, and hopefully for a symmetric system the number
read back from RDVL should end up being the same.  Though trying to make
the change you suggested *is* triggering something which is fun.

--WUyamLlzWbeu17yh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbhnBUACgkQJNaLcl1U
h9B1hAf/du/x+QIH2lgq6henkrAWEvsLEHjzVm13lpNiqsq4RofNNu92Gs9aNBrP
Vi3z+djDRcqJ2OqREdlWoCh6R0pRykFGghy3h+1FD7uieMFuexhj6uriHQesu43i
eJRWWAXIWQjyUyBSdRLg2CLQp2HdS9IifZUjMuBm9/TsXhF9pOkDC4Cp2Oqxt/8D
qN/57WsWJhQevmOw3ovbiHpw3fLmM0A7k+39p11sqbmJJjG9DYxXnqmpBKE1g57G
AAYYa3FONI/yHpe53CAnRF73uDfZiLlWodYyyPWl7aeMRRZsj4Py6qnAyfXom9gM
0otTPcsZfY894vc31qv3HezDPTG3cg==
=Hk4P
-----END PGP SIGNATURE-----

--WUyamLlzWbeu17yh--
