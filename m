Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1371F481DB
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/O0TjV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6283C433C8;
	Thu,  7 Dec 2023 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701969267;
	bh=6zIqLMJtedLguyiy5DRysQMqiTwGIh1nMitlbqK5xSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D/O0TjV9M9+1LrIwsEIcO/KeO1rjbAL4B0vc4bElkNF+7wz8XUo21zuR+kMWKJ3WU
	 vdnJaPbauhoN2U1ONSO7eaFWhpPmzREMu0G9uJFfundKmyAL3QPro1zDrnMWqSBZE9
	 64+nYgU+HS7F9Iw+MKeGWv+JTdXSC5xe0vGLIY6pHt61apc98dho9fqxSzXyT6UsWe
	 e3nfd3fWPQWgfHY9rlDkIssyA03btbAmATZ7xTOtlIyNIhYRPqM7Q5ht1dyKz8FjI9
	 xbmXHasAL96XEuhcdu2cIZEEF3JDkrDCVNdZu8juZoD8YFsEtN6wZPMEWqwSjoeYvw
	 x6v/Bd8g+n46w==
Date: Thu, 7 Dec 2023 17:14:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 03/12] KVM: arm64: Add latest HFGITR_EL2 FGT entries
 to nested virt
Message-ID: <bbe3b916-9db3-403c-acdf-8472c750bfcd@sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S/T2tH+R+5FQAbhH"
Content-Disposition: inline
In-Reply-To: <20231206100503.564090-4-tabba@google.com>
X-Cookie: No purchase necessary.


--S/T2tH+R+5FQAbhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 06, 2023 at 10:04:53AM +0000, Fuad Tabba wrote:

> Add the missing nested virt FGT table entries HFGITR_EL2. Based
> on the 2023-09 Arm Architecture System Registers xml
> specification [*]. Add the missing field definitions as well,
> both to generate the correct RES0 mask and to be able to toggle
> their FGT bits.
>=20
> Also adds definitions of some of the missing system registers and
> instructions, which can be trapped by the FGT bits.
>=20
> [*] https://developer.arm.com/downloads/-/exploration-tools

That should be a reference to DDI0602 (for the instruction XML) and
DD0601 (for the system register XML) - it's the same content, just a
more stable name.

>  Sysreg HFGITR_EL2	3	4	1	1	6
> -Res0	63:61
> +Res0	63
> +Field	62	ATS1E1A
> +Res0	61
>  Field	60	COSPRCTX
>  Field	59	nGCSEPP
>  Field	58	nGCSSTR_EL1

The sysreg looks good:

Reviewed-by: Mark Brown <broonie@kernel.org>

--S/T2tH+R+5FQAbhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVx/W0ACgkQJNaLcl1U
h9DlXQf9HqWXpZGRVbl3HQSz3GdZuLGAxCmrluHW63HP1z/O6RnolAdP4jwzAJfK
4n6DYWO3TDB7bY6OQPjZOGDfKw1BAz6rsV5sD95j9FMyWPjLeAnvfb5GIcr8KeR+
PvKr8YYOT2EPDE+wujcnpzibaFaDFUKos9yuEOXqJhQmZ2sDbbqe+dahRWso74Ir
JpUFLOhr2j+Mj3/aT+m1QhftT13TEQh10qLWLfifwmkPiiWFnwex5ie0uWeOo+EZ
FvdPXhZGsBUTf6UMetYOp/swXjFdQ3abVG6zCEIAhWuUSWKKdmgBxXCzww5cPSxC
NAeZf5Tkk2soulFnCNvO5pIEOTKv2A==
=6LDc
-----END PGP SIGNATURE-----

--S/T2tH+R+5FQAbhH--
