Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236CD3217;
	Mon, 19 Dec 2022 15:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F88C433D2;
	Mon, 19 Dec 2022 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671462096;
	bh=fQl1soAH+o/N3eRgAlLaFBBRGKmW0pCblygzAUxFLhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RuF7hpTGX6ovJF1sDqwgwDqlX+NbPx03E0AlfdEpQnD1CC6DONwyiX0yVBHHfX1A+
	 Ybc/kDFaL7J9Sn/F1a5Ygr7pxVzGibqWKwTT163pbYSwhr0gCFvAbZC1BV2ZfMetgS
	 hHa1D6lR79/h6do8DW49tp3oNUChL1oj9Io9VURkXhcX1f+SuJh/vKXORVNv7S27L2
	 Bf3m9YPAn+zixdMXR4HUk7L9vnTXp7uh6nFZnlva1iZJ/vl2axero30DaCCWOWtpu6
	 JFnk1+juW9TTx4TZaYGAKxhpLqysiE1QxDd4gq9fdLsL17C8ioLaBjWd3HLY2sBG3X
	 hkgqyzaRCCuIg==
Date: Mon, 19 Dec 2022 15:01:29 +0000
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
Subject: Re: [PATCH v3 2/7] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6B8yQxR3wP6VUbW@sirena.org.uk>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-3-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bs4hCqutwxbx+i3f"
Content-Disposition: inline
In-Reply-To: <20221218051412.384657-3-akihiko.odaki@daynix.com>
X-Cookie: I brake for chezlogs!
Message-ID: <20221219150129.ffbHqEP4srpc_MOelalg6a2-t38NpxDrSXTl9fAR65w@z>


--bs4hCqutwxbx+i3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 18, 2022 at 02:14:07PM +0900, Akihiko Odaki wrote:
> CCSIDR2_EL1 was added with FEAT_CCIDX.
>=20
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Reviewed-by: Mark Brown <broonie@kernel.org>

This matches DDI0487I.a.

--bs4hCqutwxbx+i3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgfMgACgkQJNaLcl1U
h9BkKAf+NPos2o6mLgjoG89mZgkmPOF4TShAObGH5JrXHGyhZnj53UB6vh9JI5tX
6uz/oVmHC1btr/6CqnoISLk/Rt7cd4gjgZ8DScJ9ZZV3tIzgbPxIvE4ONDMT9h9O
Diy71bwou0xCYa1fURWOyeIt3T6yn5AiZsnqvf0v9nDZlcTG2h7lJBnnxTB4z+L0
yGXYWtl968mWkyTDQ4sgYbaumdP6x/iDwNLAGEo7f/g0Pzpxd+ODSaykBrFBhTV5
2zHafaqPrR0Ty9eke3BLDlWYLcIPK5WfNq/+WoG2vxWuzhVy6yEEDZL/AGGyI1DL
Rrt+To8Eqxx7xA9zDDg48XIODFIzdg==
=iHBD
-----END PGP SIGNATURE-----

--bs4hCqutwxbx+i3f--
