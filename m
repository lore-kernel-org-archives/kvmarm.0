Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2CB3D0D4
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUEihZN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1324C433C9;
	Thu,  7 Dec 2023 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701968774;
	bh=/OCqyJoOUdVdBS5k0fOMHohch+S6weVag+qSoOd2u3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LUEihZN2RRpS1lHOHlKDJq3pkyKI6cfsJAP0QXNZXoosxuFE1NrQnvJ/OxgCbUxmB
	 ifMccI7vfksREajcOz6/dXQ7gfb9QowmRZr2m1pM0R2tFUEojfAavFIP8Ga4sAcxkR
	 pphHIg2NvMLDu74dLPNTQj5w9yhDW2AlgADOzWdvopnjaZzi6HHW9DIc4o9I+PeDIe
	 830yBQ+DnNVZ+G5lSavFIqhGcLAmac2AAaBaU6lXC9dGBossjmhtk4RKqX4Gam7weD
	 dH2yrn28kWctm1f+Bhy1qJQlzwor3t6lljgKtMsvQuAb23BPSf11KG6qJqLBz3NRjr
	 udBeNoqM1WlhA==
Date: Thu, 7 Dec 2023 17:06:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/12] KVM: arm64: Add latest HFGxTR_EL2 FGT entries
 to nested virt
Message-ID: <13427a09-025b-414c-adad-6a13c58df54e@sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AAKN/JLufpJmZ7x/"
Content-Disposition: inline
In-Reply-To: <20231206100503.564090-3-tabba@google.com>
X-Cookie: No purchase necessary.


--AAKN/JLufpJmZ7x/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 06, 2023 at 10:04:52AM +0000, Fuad Tabba wrote:

> +#define SYS_GCSCR_EL1			sys_reg(3, 0, 2, 5, 0)
> +#define SYS_GCSPR_EL1			sys_reg(3, 0, 2, 5, 1)
> +#define SYS_GCSCRE0_EL1			sys_reg(3, 0, 2, 5, 2)
> +

> +#define SYS_GCSPR_EL0			sys_reg(3, 3, 2, 5, 1)
> +

Unless there's some complication with representing them (mainly register
layouts that aren't representable with the language or *very* repetitive
blocks of registers) we should be adding any new sysregs to the sysreg
file rather than manually encoding them.  We're trying to move things
out of sysreg.h as much as possible.

For the above you can pick up the patch from my GCS series:

  https://lore.kernel.org/linux-arm-kernel/20231122-arm64-gcs-v7-6-201c483b=
d775@kernel.org/

> @@ -412,6 +423,8 @@
>  #define SYS_PMUSERENR_EL0		sys_reg(3, 3, 9, 14, 0)
>  #define SYS_PMOVSSET_EL0		sys_reg(3, 3, 9, 14, 3)
> =20
> +#define SYS_POR_EL0			sys_reg(3, 3, 10, 2, 4)
> +

This is in Joey's POR series:

  https://lore.kernel.org/linux-arm-kernel/20231124163510.1835740-2-joey.go=
uly@arm.com/

Unfortunately I'm not aware of anyone having already done the rest.

--AAKN/JLufpJmZ7x/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVx+4AACgkQJNaLcl1U
h9Dpegf/TLbl9lmX641xE+jfpA+UeXJxw8WbOZLMIA1clIBgSYm3ThYBkOHE5Xu4
KwICUwVEG3ol8Tq/ax2PR7eUWVHNaJiblqqC4ooVYVWu1Ep2tm3AUqNvBuQRgqdl
4C4pEmLwUTNVR4XI2Od5fx0fTtO+I2BlubHpmBL5LKwgwWzNNtZubTJx5f43PA2i
0FkUee1raQHm9ajc4J+I8vTz8pgMlS9YFTEFosOlAKz+1EPVdoU7Hf2ymnGbVmdV
imnXk9Yjj3eOskejcAqNkdzaoGG8wH9qrwdYPeLmDn992OMA4BUDx1iIeUz1H9oP
2ypvVXDGxjloVJke7l4cpIRd0UYo8Q==
=0vQ7
-----END PGP SIGNATURE-----

--AAKN/JLufpJmZ7x/--
