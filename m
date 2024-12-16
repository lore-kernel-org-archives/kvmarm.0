Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AD4137775;
	Mon, 16 Dec 2024 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734361961; cv=none; b=ipkf27Vlp+M620u2v10ibEg+ju21NL5fllMr1i+qW9YKrcRqG8mRpn7tljWB5wR2hYllwnnDpMGJxGBfX9Lc6urz/7mEIkXlG/8RoKbvs4B5H/tOmMakNKcFf01p4wRp2fyln7r3TdoTg0dVX9MY+ZPKampqxknUGLCBQvZcXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734361961; c=relaxed/simple;
	bh=wICNgf+IR97xFy25oLTLwYecGz7p9oalZishcLcdo4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoyoVVP5Vw+6ZQ0DUFPRcJ2bFXUHMor1hoAg9FRxu4ivsYI4QFDjb2sXHHBV+kaV2De5ALZkYSWMGvt1nqfbjuLmRTfNzG+aN9OKW3b6NOXFRL2GLCNbAT8tK7FOMtwRORVSqDvzV7jVmFJvg1+KJ25Ht+jcClB5fQ3oNTjBsZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otuodDfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otuodDfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38A9C4CED0;
	Mon, 16 Dec 2024 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734361961;
	bh=wICNgf+IR97xFy25oLTLwYecGz7p9oalZishcLcdo4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=otuodDfADecik5dK4A+tvJlOPIlqUWxqN82gnV2UUQLF2EID4UGmWjZlMD9HWIY1D
	 Fchlfp0Af3b4L18QVne282kKyeBqiPkAMXZyLyysO726seCflHNOTQMocYTA24YSse
	 sh6FTadku2KIEU8lgEAWYIPE0vi0/HCbdoR7qVQwzqZStEAtZgV7p29UbStvU+sacX
	 YsQeyrxrxRN+6uzooFaNlaBckOtCP38KhI7KNQD0nVhP4WeRILvxemZv5kk2JV8eNp
	 dSz7paiM4H/y4tq3dQMlbDHHdGdJxKvr4NYYlD4VQ0re2qaCyCbJG5rLDeU55NOwXB
	 ZDmW8v19na22A==
Date: Mon, 16 Dec 2024 15:12:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 04/46] arm64/sysreg: Update register fields for
 TRBIDR_EL1
Message-ID: <1c1c9117-e2b2-49e7-9bdb-7ac6a184d7fd@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-5-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7ZdiaP7+I8rZlyon"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-5-anshuman.khandual@arm.com>
X-Cookie: Be different: conform.


--7ZdiaP7+I8rZlyon
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:29AM +0530, Anshuman Khandual wrote:
> This adds register fields for TRBIDR_EL1 as per the definitions based
> on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--7ZdiaP7+I8rZlyon
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdgQ2MACgkQJNaLcl1U
h9CPyAf8DgQ5EoPnHTekTgf01FLNQxvy+tdd5SLWHfOh6ppF6KvXlm0TcSi5PgAu
aSCjY9LePmuBhI1O1TwEhN0z+/n7UyXrVNMYRDuV4H0JlUBMgPra1udLCQY1OlXu
G6IKghirOgsOKT4kZop/A/6MXyE3hrdMlYUjieSRAW0f9K+MKLyEefLkGbXYVJIq
Hy+7fdr0rKP0ObUy6a53c5qpU3WqlGbBA+6MHT/CfyIM3wnWSdAD0hfxIbdqFnRh
qm4dB5ri8k5XGzemPWwLnjIEjIaPCXkPCBm+JaZd4M++U4JG849hB6zzAFr7V4Dy
L1f7nGYmPjNsp0HCoNLdxsrdhQBNog==
=7nTo
-----END PGP SIGNATURE-----

--7ZdiaP7+I8rZlyon--
