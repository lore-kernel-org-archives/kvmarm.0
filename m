Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D82837F
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4aaJY7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBBAC433C8;
	Thu, 14 Dec 2023 10:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702550531;
	bh=lr27gyeZb5cOfYJnWD1sP235FKPk23zrDWGW8QkYc3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k4aaJY7La7g9nnYq4lEjaEyDe+KmwIerB9fhcxmFya7/CyWAVd6hEo2hAba91O/1U
	 bUhAhEzramJGby1tBUr/12gEXFCa88VJyNWKtXn6LjThfyenJ6on5kZNRxZvW/ZFLk
	 7jTyt5CkVS0VD9+D2phYhBuEOV6G679ghFlb78WErxEvirJ8cXpjIJjW+pZf099h61
	 aLa47j7l2PCte21RPtHAZCSdwfDKCVIi9PLMfZoJiA3TavsEAiscJkN9MNrC43ZTPz
	 3sELrdOWGHrBm/kGHJ0HsPpD1uVMPOsDQf6Bx8ridFqnAoIgHZtKIQJwcXzW96gIN8
	 gNcrxMcEXSamg==
Date: Thu, 14 Dec 2023 10:42:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/17] arm64/sysreg: Add missing Pauth_LR field
 definitions to ID_AA64ISAR1_EL1
Message-ID: <719d323f-787d-40c3-8fbf-6496411ca6fd@sirena.org.uk>
References: <20231214100158.2305400-1-tabba@google.com>
 <20231214100158.2305400-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9FmDBF5a1pmFb6FT"
Content-Disposition: inline
In-Reply-To: <20231214100158.2305400-2-tabba@google.com>
X-Cookie: Preserve the old, but know the new.


--9FmDBF5a1pmFb6FT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 10:01:41AM +0000, Fuad Tabba wrote:
> Add the Pauth_LR field definitions to ID_AA64ISAR1_EL1, based on
> DDI0601 2023-09.
>=20
> These fields aren't used yet. Adding them for completeness and
> consistency (definition already exists for ID_AA64ISAR2_EL1).

This is fine in so far as it goes, though it does make life slightly
easier to do the whole register at once.  There's also a new 0b0010
value in SPECRES here, though not worth making it a blocker:

Reviewed-by: Mark Brown <broonie@kernel.org>

--9FmDBF5a1pmFb6FT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV62/0ACgkQJNaLcl1U
h9A9ewf/bMfhrQVtheoc/MQQw3FvTKYyRO4fw5DTEQgn7jcyatME9Ss10DEmzpHH
WxjCCJJ6r9AhlkL1nz2R7/XNncOzSztR0EksPPOfrR3sz6k3MYSsCIHAJ8Mnu/7h
6Vqi816uR9P5VOCaVaZG9Rp55nqP1i+M9ZKlVJRqyxGLnw4Yt5C/HRkeJzt9MrP1
MjgbKHGt3nIMf+sy9o7sOS1/1jLxmpmLWcjsU8nyLL9IFf+uIqR7ReOVnneIhuQD
m2d6ijGIwfnTI69lEIglsPROm4Bs2cSPiV7kPsflPExPqDjnm1VY/97gKwo0WlvK
pGL1TSA+aDxwXoTIxa7j5s2V4NsN5Q==
=LGJu
-----END PGP SIGNATURE-----

--9FmDBF5a1pmFb6FT--
