Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9C6125C6
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb2hd8/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28900C433B7;
	Thu,  5 Oct 2023 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696514628;
	bh=HKEZ6beykV1U+Zd/ammwjoPfpwchP/HWcBClUf6tGDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tb2hd8/59F3EGqO2PeHBLPnaUltp9QPbpc/YPVoMYRWuz2nADY1Qy7vrrpl2mRQIb
	 f7RKpsRwB703gUz4fXn9ci4U6kC/HA9L0PdP2haH5FL0kpbEeol771Rz7LfjJixADQ
	 SBQGyDdywWTFiD07O6nSvbdGBojyvdFXrxHRI3E+jCg8QDvSE260E7KQ+5rMdxJ1WR
	 vcBGE6aoVS9BTuxHxrRCOo2koE2Mz0kaHLEotZ1f72utflOgkfEl44ixmXWIz87r+q
	 4VvjohcEn4Ary/q//s3QWLYCOpjgFIa08gGZYCA5qLYieMXrrC15Ed8ZdJ0dmzzBAs
	 0UT+YStWRnkJA==
Date: Thu, 5 Oct 2023 15:03:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 01/20] arm64/sysreg: add system register POR_EL{0,1}
Message-ID: <f38e79f6-6438-4b0c-a657-480ed0479f98@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-2-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e6yvKGWcAk0ykRJu"
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-2-joey.gouly@arm.com>
X-Cookie: Avoid contact with eyes.


--e6yvKGWcAk0ykRJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2023 at 03:01:04PM +0100, Joey Gouly wrote:
> Add POR_EL{0,1} according to DDI0601 2023-03.

Reviewed-by: Mark Brown <broonie@kernel.org>

--e6yvKGWcAk0ykRJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUewj0ACgkQJNaLcl1U
h9ADfgf+Ki6+gWK2XcfP39+dtpYe/a8jjwMcGAUdiVwp0vcPomk15O6tivRlxM0O
5hqF6Ljm/V/CmnvDDwP/KhIKEGthRALQ21F5y4wQl32IAP1thaJIgxWxOW5NFpi2
o7YCJ5TdJRxV+hX7ElE8FDddzwgBmQnfgbq2KG/8GSRF7WnRKkA7ET/DfArqPsmr
2A6u+iFklSjTovg9ilQ8WnUmiDh75lFy6fKx9hKPqAxZgFWXQ0KHhO+M3NltqzXO
CBPuRl1pFsh+IY2cgsuiHSGutcX31GnOG9OQlX7iQJ79uksPAS1ErCCYhZtuJ3h/
2yloNgPkQagISx3bXbOVavzFuwjwzg==
=EdOr
-----END PGP SIGNATURE-----

--e6yvKGWcAk0ykRJu--
