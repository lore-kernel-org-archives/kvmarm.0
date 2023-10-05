Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB94D273C0
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMJLX4Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E67C43140;
	Thu,  5 Oct 2023 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696514582;
	bh=RaU8PyS3Juh4uPmlquRJ62Q+vaLeeK+Z3T1wFe01crc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HMJLX4Jwhiykgs4Cq+f3yLOA9BsMfok4LpMhVftEUKIafUFAvwkDxsVx1chffBReC
	 Jqbo6eRegYDlntHTOonvkXsyRc9Ai+zLJt/JOUFzJUciUBSjTbiVspTN409EtQMcIM
	 Oq069NykAKgV7OfpeSO2d/PWls11uvY1sFsUx1tludYcBtcMAalrgAdFTL/g4GwvlU
	 seIOpTs/gCoWeypK162fftUEfPcxhVwzs19R6/MPygyf9KETrz9L257lk6PBLbIUCP
	 u6d8+CCYmk2Hr1a4PcK1cMUAEjMnmfgOIIQhYz6dEMSZ0p6PPgGpd0OzrFFODc6Nk4
	 kiKBvIRDB5obQ==
Date: Thu, 5 Oct 2023 15:02:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, oliver.upton@linux.dev, shuah@kernel.org,
	will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/20] arm64/sysreg: update CPACR_EL1 register
Message-ID: <f7b73c66-f73f-48a8-b93e-81a06f7c2ee0@sirena.org.uk>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-3-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VCdXJZMZf3fTQbCW"
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-3-joey.gouly@arm.com>
X-Cookie: Avoid contact with eyes.


--VCdXJZMZf3fTQbCW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2023 at 03:01:05PM +0100, Joey Gouly wrote:
> Add E0POE bit that traps accesses to POR_EL0 from EL0.
> Updated according to DDI0601 2023-03.

Reviewed-by: Mark Brown <broonie@kernel.org>

It's also up to date with DDI 0601 2023-09 it seems.

--VCdXJZMZf3fTQbCW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmUewg4ACgkQJNaLcl1U
h9Az5wf+LW2neVBVQtzKINBTCYISrlW0ST22ksCmpQjJy1GF3WT7U7uhTKweuk6n
KXrPF96SPQMMOvFvoeigaLUtzjOiINuHvSGi7q7q7rWTorfVDY4QnXqltawuG6tg
QEj31Rp9EHyqTBapdsrSuw3p0OCfBgmL1oyPCTc/ClN6A0yVZCT6F47mUgXC/0zK
VzJcszQMWR6AjMO5femeB8CqLaGEqG2WN61Dkj+qjwejvtnSXGfDMxSAu/PYcsE3
jqg+bVpmL2rRzyrKSsbI0OsPF0sdpFTVrDmPZ2oy51fe9OE/zbjODLNMxvVvNKG0
7gQ1i/DzGPKrT2Dtb8l9dN/0EIRRdg==
=DVPv
-----END PGP SIGNATURE-----

--VCdXJZMZf3fTQbCW--
