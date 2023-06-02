Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7255A8466
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 11:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77ECC433D2;
	Fri,  2 Jun 2023 11:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685707105;
	bh=Pli+dpEm8XbqDMVH3Q838FRR+WhJt8VVaxKShlXYZz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eDz/0yFT2mHq9wmsAp9vgYoKITJV9iC/Tfvr8QbM+tgJnBk3wed45iCCO9ItFdz/l
	 fJSpRwzkFQpOb8Dvhd2qnXyZdA/QlAnyyjw6/5p08H4msqW6Jb4GTY/4CuX8UDJPJo
	 mbMThn0QEqxXT/C5GwTfoqZJlG0sGRpGz9fS/1ynLEKCZ1UjvOMlhvXuGHRGE/ENeS
	 KJliN5uZyevOLh0JchYyEaxXngitLhdCvtIGFescv4tULxCtRrvQqRtkA10OtTnTb8
	 p2dunJ6id/sGfcxnCLlftmSyOwcLyzta+q6ybC6jHaL7QGpLRr1OtT1NIzRW42zHKt
	 JjGteoSzgzM2w==
Date: Fri, 2 Jun 2023 12:58:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 09/14] arm64/sysreg: Convert TRBPTR_EL1 register to
 automatic generation
Message-ID: <0873b03d-1486-45fa-bc0c-cd8da2b7a599@sirena.org.uk>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <20230602062552.565992-10-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j1DfidqfahbgmVW7"
Content-Disposition: inline
In-Reply-To: <20230602062552.565992-10-anshuman.khandual@arm.com>
X-Cookie: War is an equal opportunity destroyer.


--j1DfidqfahbgmVW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 02, 2023 at 11:55:47AM +0530, Anshuman Khandual wrote:
> This converts TRBPTR_EL1 register to automatic generation without
> causing any functional change.

Reviewed-by: Mark Brown <broonie@kernel.org>

(these reviews are all per DDI0601 2023-03).

--j1DfidqfahbgmVW7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmR52VoACgkQJNaLcl1U
h9ApPgf9E4WyohUEmJ6sRrp5jhxxGsAFr3Y6Zl3K1F60YQ8+8A36/buXzqPScDrD
YOQNpXieixEM33OMHm69733GPxtqjIy6djElA9rA3Oixka3ej58tXIC47ihcvUJm
5E3IKTUZ/4o+CAMMxsIgYVbtwTcDj9Mfh0co6uE0cBsmB4iahhFOtbeGMpINCr5n
Ki1biS5HKZofGgSvM4my9tT8BzjYjhI6K2rMy6p+zVAgIWjCV4NArABCHZdiuZnI
YGTYOCU4VJdbwluBduoZKH/+U2Aap5lM8AZwomrHozM3soHUfzCRGO4ucWr2+YsQ
Q7ZPsNbapQdsH7cgDDzmIcStXJIrgg==
=/hlq
-----END PGP SIGNATURE-----

--j1DfidqfahbgmVW7--
