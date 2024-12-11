Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6381DDC2C;
	Wed, 11 Dec 2024 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733934503; cv=none; b=PfrYFcEf16LeffSjq8btuuep2kfGpIHBipg5Fubl2beDcQh2t264HAFLmwfAGQcut0f2ImKairk7noIAef5oqPRyt6Ewi6HNGDbI3bkXnCv97ZO1D2WVuAvTVZaCtlPslxZ9WFUYf0PPj7GY44rrahc7o18i8qMtyH503NVSkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733934503; c=relaxed/simple;
	bh=LXPkCuR2SivnRYq9dCkjsf2KZvGLOYoks6cx+5KrVNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+adJxnWRqzJl3f18ZFIoCeUd0duPg1xb5MR6ddbXpKoswkJ59GSy3p6cENNtaJ1v3yg0jyqPxSZ1anWsbbMBdhyUiop2dgCsRVrvGup+6Q5iWSfqw2oeSH4Kih9Q6HE0zCgyERvF+XSxk1nRMrGzG5cjIThlEbNY9ZOBYpKccU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/6Dagzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/6Dagzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94745C4CEDF;
	Wed, 11 Dec 2024 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733934502;
	bh=LXPkCuR2SivnRYq9dCkjsf2KZvGLOYoks6cx+5KrVNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K/6DagzcvgXPGBIjb2VKXo5Vd8TVb2h1SAsb2coJAuauL0I658hRF/AzJdyz48E8P
	 1K/CnVd+HuPTKt3MQkX58EdS+Bh3LX5JcgRSTN0phemolAyHs/DJ4F85mbJWxRugN1
	 oEDBhekCL491PJ74fmsNYkY4Yn2holKMFnBPC5LwI45s+C02d33+2wuzJplt0iFHD6
	 Dc2N2yCquH//fIvkOMHXVGZEAofYIAtuguXiiAkrTECRHH09TIzwyBArW/mZsU2nGG
	 xu8zW4wKPDP/H4wwacscWTNaTtPQW3Ycks7C+3RGTzF001nmUCjb5fPwqjfdwE0EZz
	 cMA3o+jQ/xKhw==
Date: Wed, 11 Dec 2024 16:28:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 02/46] arm64/sysreg: Update register fields for
 ID_AA64MMFR4_EL1
Message-ID: <f27091f1-879a-4434-8124-2d1e27241078@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-3-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AuImAyBVAiYKZd95"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-3-anshuman.khandual@arm.com>
X-Cookie: Every path has its puddle.


--AuImAyBVAiYKZd95
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:27AM +0530, Anshuman Khandual wrote:
> This updates ID_AA64MMFR4_EL1 register as per the definitions based on
> DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--AuImAyBVAiYKZd95
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdZvaEACgkQJNaLcl1U
h9Dt8wf/Xkj06W8/tQXbtUdCh+cZdMzvCYsmFjs77GpeWcGAMwMMXAakKXLvdIaZ
Y8MeZMkUNJbkjjQHFfvq769HABUCe5pvxstBlcm5RwkLw779YKyPfHhKBj804gnP
ygoSQuth62S2cQ98ZxCS0X1uKsLuMO7bufZc7FH8OeBCBSY2pm9TnqAMbnpXyb01
/0po6atZiUVhyFENAG12VmiVbyFN2xH5ePDRmvwV6OlGLkuHfnxYBbnxhyTDhwp7
24tWFW+aSQKpCHgfwIndNpqkXtdEFjc+LE8S4T1i1KEd877lYfPn5oe39LeEZCou
FvWw3dF3ew82JkVHikP0R6DqLMWRhg==
=jJAi
-----END PGP SIGNATURE-----

--AuImAyBVAiYKZd95--
