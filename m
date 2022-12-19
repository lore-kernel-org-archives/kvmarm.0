Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619CF3217;
	Mon, 19 Dec 2022 14:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0526C433D2;
	Mon, 19 Dec 2022 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671461455;
	bh=QxVPwZP8m+jsCHTTeqcdIpyCXjsptf4gIKs8BSGJBL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fly9y9GIhJwybfs+jroXKqdVzCJpHS4TqdxKwymyTZFKCIMk0mi2eb8IXsa1IZUFB
	 7+N+Hv2jidaCNb+0CgIDr+p5cXuRXnCNPRwrY3Lad7uXROxpPf2m0t0wvJ+JEYoktP
	 jUoI2CdzAkou6aamyEzAUZPpNMsY8icPDBWhpyL0SASaXMFRNrbrfHoOVFypoR6loJ
	 ZQDnsNIP2VEhwT+0l0Kro4cXki1gCwCE3zegD+ucmls7eITliIHHuWXq7cZsK8yisN
	 4uWwNj4weUVrPQXC0R2wpDweNqgjFdQK+JYM9wF5u6M3Utnyhs5KJhr0SK7qJd30Jg
	 KKM2Kjx3NLJ8w==
Date: Mon, 19 Dec 2022 14:50:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6B6SNADJQkNRoLO@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
 <Y6BjQiR5gUhIAyIS@sirena.org.uk>
 <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mYp6zYSC3VWc2bxT"
Content-Disposition: inline
In-Reply-To: <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
X-Cookie: Pay toll ahead.
Message-ID: <20221219145048.ciaKZTCbnWhupJo88pN7UkWvjBdlz-mlZVdSeN0hECk@z>


--mYp6zYSC3VWc2bxT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 19, 2022 at 02:47:25PM +0000, Marc Zyngier wrote:

> Since you're reviewing some of this, please have a look at v3[1],
> which outlined a limitation of the sysreg generation tool as well
> as a potential fix.

Hrm, would've been nice to be CCed on stuff for the tool :/

--mYp6zYSC3VWc2bxT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgekcACgkQJNaLcl1U
h9ATOwf+M1ng9YlS25c373o/kUeoQ5yAyHdggFm6EfdGWuWfd556L8Rr9T/1HCUR
mFg67pwzlcmhBwX/BHbdjzAjYWvNmP5LzKO7G46uEksPmxNc4WCriBBR8jlsOvR1
dj0JsWF58BWDZg8jcnuotHTUNcDvU5RfLG8T9jcmN4dUXOz0xa/fh02oQfnbr8vE
f4jcRljPZGpF6pWNdAfKDJSvjrSq5QBU1gwo88nKXnuY1gq3GI6aLNFun/CP4iVm
1msraBt+TC6A2S09vcA6jaGW2bfgZGmWIS27Y3ZN+IzNlwKZ1YfsezF4EiLk/BmG
OeaDj3aqNy6h8EgioVkCGVZ8EyRisA==
=epbW
-----END PGP SIGNATURE-----

--mYp6zYSC3VWc2bxT--
