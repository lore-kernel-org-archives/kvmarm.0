Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84B1ED55
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 15:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88D2C433C7;
	Thu, 13 Jul 2023 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689262520;
	bh=z0Yd3Vo1zn6fEDsSX4cscR2k5sdUq6P85YDxr6njCvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gf+moHw5aw6+njI6wsTDjSB3+4ASacqsnx5o6t1Dss/ODQOxYtKrvZnKGSHfj/Hd+
	 LPaBO1wWL8S6+kELQoN0dT3MhKqH9SKIv+1/9eZ2OyEaxKSn2OlFuQr3kj/VrFAB81
	 k2UpWYPQdWwReuY0JSKsR5TMmEuCYbKo8T3gJoy+bnAZhEM11+j0coJbZg1r1enyCg
	 Hs6ygguACYuQPhmEUdabNuRVMosDPtwRH56fwW4SMHCxOloTQI93k+6Rrpf/J77zLs
	 kWwdwr/t+BOQ5TbKh/KOpmmKcs71vx+At3fcE1vcgIFclHU5JJO0cBYLJxtQU5e+zm
	 a0nrxCFhSFRHQ==
Date: Thu, 13 Jul 2023 16:35:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <91a2f572-9d66-4790-bde2-6d11c4a20e9b@sirena.org.uk>
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
 <740731b6-5f3f-7acd-6d9f-8adfcef833ab@arm.com>
 <9dedca62-7821-461f-805f-9550b17efd48@sirena.org.uk>
 <86ttu7vnsu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A1m/kpJ2kGU5E1sP"
Content-Disposition: inline
In-Reply-To: <86ttu7vnsu.wl-maz@kernel.org>
X-Cookie: MOUNT TAPE U1439 ON B3, NO RING


--A1m/kpJ2kGU5E1sP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2023 at 04:22:41PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > This series is probably moot given Marc's nv series (or at least needs
> > another rework) but could you expand on the issue you're seeing please?

> You're reading EL2 registers from EL1. What could possibly go wrong?

Ah, I see - I lost track of what's run in what context here and also
hate tests that need kernel command line arguments.

--A1m/kpJ2kGU5E1sP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSwGbIACgkQJNaLcl1U
h9ANkwf+Iead2DrTd5BGDbwGaD8uPxkZngEGqaw7E9zrwmII9MkyZGLBWu/FfILK
mNZXGNXnwH8AjyuDcu9Che3H2aSNCEK/JNWEvoLB6Omh7uhxqYVVVAbir+RC45si
+jAbge3zy7v+23B2YODjjJMjht7Y6qbg9JbtTYgG4S+pKINqCW0/Lhn2ci4jNJrz
RSRoKb+89pWzcIIe7fCGWbrXiw8tf+sFxiMgNccgF9GMiiCFBR10GwNTyRdtoVBY
ONKy9O0weAW+7yriZl/Vb6vVyGzbUd+9hgmsyI52dY7y19sv77sXgU0MNc3qFroa
eyeasFmsL0mKPkkLYUc4QBw1eHNvcA==
=nDND
-----END PGP SIGNATURE-----

--A1m/kpJ2kGU5E1sP--
