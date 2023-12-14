Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE07F3C47E
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0EK1eld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC8C433C8;
	Thu, 14 Dec 2023 10:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702550972;
	bh=py4xQEfE2DeQPN5lAk3G1wfEvxip9OKJ62dYERpBsnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V0EK1eldHuJhG7UanASa2j6NN1aTkmEXpixQMlsMxRURIqctMPn3SL6C6NjDyi/ri
	 NqsjIlyW9Ah8ZhHrzP2NqjtDlsRJE1fQP8S/tHPPJyC4ve3O1WCbW7Ktuw+qfENazO
	 MH5dKD1oxgLFWapOlWl0kCtLOWqGRFKzVV5eGEa6e82KzDHwxLxv6sgcZqKiIKtg+W
	 ZE+9PzHjFQ5yb+SzQVxyD53xHseyUZAqRvrMu+jFq0mXozqCWn39dzd7FR7Y7Bkdvd
	 S8mhq29qYRWH9SSgPaigVmjxC3nqPPR3kNwsFtote+tgEO94iXEpyNiEp81vfRsA85
	 FfE8+cQR4m84g==
Date: Thu, 14 Dec 2023 10:49:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/17] arm64/sysreg: Add missing Pauth_LR field
 definitions to ID_AA64ISAR1_EL1
Message-ID: <6e14b02c-93a7-482a-9377-3afaa57c2dd0@sirena.org.uk>
References: <20231214100158.2305400-1-tabba@google.com>
 <20231214100158.2305400-2-tabba@google.com>
 <719d323f-787d-40c3-8fbf-6496411ca6fd@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yph08nADB4JXeoLn"
Content-Disposition: inline
In-Reply-To: <719d323f-787d-40c3-8fbf-6496411ca6fd@sirena.org.uk>
X-Cookie: He who laughs last didn't get the joke.


--yph08nADB4JXeoLn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 10:42:12AM +0000, Mark Brown wrote:

> This is fine in so far as it goes, though it does make life slightly
> easier to do the whole register at once.  There's also a new 0b0010
> value in SPECRES here, though not worth making it a blocker:

Sorry, was looking at a draft version there - this is fine as per the
current docs (as is patch 2).

--yph08nADB4JXeoLn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV63bUACgkQJNaLcl1U
h9DnwQf/UTu2xT1tT6jmUo0bHEwk4pyW0qy/uzk+o6n4BlY6C+xObAhS082wumdE
c8bfhhRVQKwqyLJzwiIUcVCa7eTOc4B8tEjFtMkg5igabmAjFNzT3n97ATWvHhDO
u6W+VM7C6wECmuySnlh1sIk4GLryyPoydaChkzJKcE/y5DhW8ckYNfIEfVCOwvGz
ttIM6PZXO22WkLGGAGxDhohvmkVc5Mn64BQgaZU9AvNQwzPFDPi0gLcqTPX79ELU
wJ7ihPR6ofCPuVlNxtabWa3iVMQa0OYYpqwal9DEydAaNWzgwmQjeZVx8hNs1JCM
lwvd95Ly44iUrK4B8ewx96+QByohdA==
=V22t
-----END PGP SIGNATURE-----

--yph08nADB4JXeoLn--
