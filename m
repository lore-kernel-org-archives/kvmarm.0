Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3CB291C;
	Thu, 22 Dec 2022 11:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB3EC433EF;
	Thu, 22 Dec 2022 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671709534;
	bh=Y1cUmhwFo68wOtgbAIPgTlOJqv2cgBsiYek52x4QyLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NhqH8gIh8S0yGDM0PVbhOtJk43xinTwAfGKXCt8ddSLPmt7TbaegxtQ69r2Ninb0G
	 H6lLZtScQoHkXCoSnWhj4xCI155ft3FBmzyIp7g0XS2ahTd+Wpe0zxV5QVau5vXc9f
	 ErCMQIKyIy5cbddGIYhY0eeKn23yGov6apS7m2sM4yWKx2QwMJZ2ZVIOB2vxSgAGzq
	 f7+dj3ldV4IRrBgKKUIt25Bx+PMpfRf28oNs+MzQNFRs6C3h5EyHSPd9SBiwPBFDrk
	 YNOV3uMOZRcymr51KlhoTLIXCXfRM6PdRmHACURz5FcjGFLOjTyuRz1ZVWhf3jQTB2
	 IVcoNEFhXp6pA==
Date: Thu, 22 Dec 2022 11:45:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v4 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Message-ID: <Y6RDV/mQ2mo+/YFk@sirena.org.uk>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
 <20221221204016.658874-3-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8fq1k0An7gXXTJSP"
Content-Disposition: inline
In-Reply-To: <20221221204016.658874-3-akihiko.odaki@daynix.com>
X-Cookie: Yes, but which self do you want to be?
Message-ID: <20221222114527.wEQ8KaeTgSW3wMMt5251emMWSetlIhpLBIjQcHVsnno@z>


--8fq1k0An7gXXTJSP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2022 at 05:40:11AM +0900, Akihiko Odaki wrote:
> Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a.

Might've been worth mentioning the multiple layouts in the commit log
but not a big deal.  Handling them does seem like something we can defer
to followup work along with improving the tooling:

Reviewed-by: Mark Brown <broonie@kernel.org>

--8fq1k0An7gXXTJSP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOkQ1cACgkQJNaLcl1U
h9CUewf/XdZaVW2Uv/Z3iqOKHr50VNgD1bhn33H2JxeBdFCuW9DEeqk+UmT9OAn1
/M6ad30jxa09jOzWoXjzXnYv+0C8j3PbqHq2kSzC3STG+QNbXfBjsvd1tZaOJatS
RRAB64oajyZnJJ3M8Tz1Nw43kLLOajfnGUBrIuGS0PIncg6MwVHkoL2bLNdaSlIE
/ExWW/i18Y0Q2ac08HqRWdwxCvlYDz09+2ErTO5Y1tfgpMLFwT+4mzGGgIJj+xTO
08pzg4SobMMhopkHAeDlaX8WeAOaGqWRbAObM69IhckyHp9Pb0J9cAbPeTfIY/WU
JtFMeiXboDywUYGBM7B+6pt8N4r5Mg==
=0KQ7
-----END PGP SIGNATURE-----

--8fq1k0An7gXXTJSP--
