Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FF137775;
	Mon, 16 Dec 2024 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734362237; cv=none; b=KqdoTpTa2wG232uAkp4M0dKdz5CuQWeO+sNg6JSR8ih1gtXKbLWG4iKxPt2XOodu8h+0+16JT4HW0MkZLwdIIS2/HoScIF4eatLvw7lQHY1AwKtezdKvCixV4j2z7gT5bKsTYBzyFi7GPZiWPYegFjGwdbyyl9qLUOd90eaUK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734362237; c=relaxed/simple;
	bh=4JsiBQZM3JoW4LS4kKv+6GCIOBTm+9qFs1+V83GVDEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2r8ZlRk5Wru0uvAA7J/Vhgojhwr0g4rluW9uvVuFuhHaUbMUR973VIVmOv959S1cQQcvNknzbgFxI9TKTDGl67HfSPHT6UwQmsoj1mnq2ARsL8Gd5jIx/tkoFZHEB77zMlPUk5ChHARRxsQ8iuMFLZyVuVc4cGTtXmM9VY3hVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jphz7nSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jphz7nSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B25C4CED0;
	Mon, 16 Dec 2024 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734362236;
	bh=4JsiBQZM3JoW4LS4kKv+6GCIOBTm+9qFs1+V83GVDEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jphz7nSY5kfiVqUjBmYHcaoAzxwdYOujihN6UScSdXLVrgI59Y7bsWV0L5Upcvilh
	 MsPaFdOpvbYo2smFOaz/7pD5/zhEkBO/5ieC2gFbfBMZwrPgfQta5IwgCqHVjOMj+/
	 aYCcD3y1koznHBsz/GIcmuRw3ytkCPXP3eJJIz9UPBstnMwZ6xH+AyXI1tn2Cdq39x
	 hD7osbhdWcLvlZZPGljyHQq/0u6Dxvypl6sq5EIX+AC/yf04XgXr3tAXO3c/BW93XS
	 pnFmEyTBLjXUS174NNdZ9RdHllu88nyOzSHWB5wHmDq1JRRhgKzvHQIxbFzy+ZUp1p
	 mmIJpgeOXr63g==
Date: Mon, 16 Dec 2024 15:17:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 07/46] arm64/sysreg: Add register fields for
 HFGITR2_EL2
Message-ID: <a953ea06-af70-4fe4-a4c4-0a4e87aa88cd@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-8-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y5iAGL54R8A4spMz"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-8-anshuman.khandual@arm.com>
X-Cookie: Be different: conform.


--y5iAGL54R8A4spMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:32AM +0530, Anshuman Khandual wrote:
> This adds register fields for HFGITR2_EL2 as per the definitions based
> on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--y5iAGL54R8A4spMz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdgRHcACgkQJNaLcl1U
h9DJPgf+MpiiCWY7iBGxX6+TU5DxbG+SW++WJE8bgS2sL0s5nfRQYCbN1wVrq+ma
7e3cNEmGuQBHiIz6tPCTxZCdM0ahpk1MSUq6ga9LYYaKJDIv3Ued1xriHv4i6w89
Kdt8AmurobdHLQc2jwGkICNYe6NzUs1XKDsBRZA0GPjHuqsYrou986XTuxSMEwk6
i7fwKgDcRrZd1LL8Y3s5vsMqMO+yLX7dYKKhhPxTqiV7xyhKNlC08A99npkIMk4u
5LgY0fhlwqAVaEG8Fa+pi2Izf9X24/wPyz6nd/Ns3L0iJf1t3unwJjyBi5NKR3+9
ouUPgTnRgYX1JM25IX4wgmMEYiEW8Q==
=nx3K
-----END PGP SIGNATURE-----

--y5iAGL54R8A4spMz--
