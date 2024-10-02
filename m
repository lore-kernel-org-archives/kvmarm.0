Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9011D1E66;
	Wed,  2 Oct 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727885356; cv=none; b=D0unObyKE8tZvlDyPbrND/nq2grQ5aGLeBgkgQEU+TxbSfdwsYs2S3zPdAeksFHWGVc56w7845dcEzilGsFSfMQLPLfTcSzHsmQwD1KwSuggowelQepvnsPixVnLmYxrSxgPlfl37MGzs1aTSa2ACUBm7HLxscdPTOmBU4dCOSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727885356; c=relaxed/simple;
	bh=NnPPh84H6rriMYyIgEGnLPj+0FNAGeC7blVrVx+XsJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeP0L+MXwi1JOnNUAIM51OUdZz9x+mZi3ZByFTehSb6kBRJefBo/fR5CbcYexsCbs2yYK+hT2bLef0f5EfmJ+R6jsYX4Ixiukrzc8JBhKhcRY4pYVIFwOWES2NqGFu51GWEk/LWI4bgwt+3iMB1UvN8r3x8qGUpC8/xGrF0uq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7gh3qGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7gh3qGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5328DC4CEC2;
	Wed,  2 Oct 2024 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727885355;
	bh=NnPPh84H6rriMYyIgEGnLPj+0FNAGeC7blVrVx+XsJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7gh3qGWy/SjdGthuuySx9dGx5h00u952VV2Jz0TtrkDA1Uhssj+pjfjI7oaCBYk6
	 Z6TbcKyJ6+bAiNrjrtQZGfuod/gRerry5x/i5lRDNU3pDbz6/cMVokd8lJOVfOefhg
	 2x5lk9DQk6tIln4oka/jeC28XLn+MmCd2hbEuoE32gHnLdWEOCKR0mrAdxXhhleZMU
	 096wFx9DR5QRMAA+srci6zR24dDH1hWFjMAqtcm7NSb8fADhg7mvLETJcwtVaVt1jN
	 j5m20lQGRYhOMfWYrMTKnbc7pyX5rCvxx7YBP2d6vlKgHiOOhp1kr/GIOFxlrTmvKh
	 zUDYHRKx/csxQ==
Date: Wed, 2 Oct 2024 17:09:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 06/47] arm64/sysreg: Add register fields for HDFGWTR2_EL2
Message-ID: <7447d3b9-fb94-439c-b3bd-d714aa9b40a6@sirena.org.uk>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <20241001024356.1096072-7-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qgxCz6UQnfGfz0wo"
Content-Disposition: inline
In-Reply-To: <20241001024356.1096072-7-anshuman.khandual@arm.com>
X-Cookie: Know Thy User.


--qgxCz6UQnfGfz0wo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2024 at 08:13:15AM +0530, Anshuman Khandual wrote:

> This adds register fields for HDFGWTR2_EL2 as per the definitions based
> on DDI0601 2024-06.

Reviewed-by: Mark Brown <broonie@kernel.org>

modulo the old version.

--qgxCz6UQnfGfz0wo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb9cCMACgkQJNaLcl1U
h9CLzAf/VFc3h4HkrAwq14jODydjqnbWg+QNoDEJJoFRzmds4F7bDpiRg6QT1RUa
EM5aZNFh7y0vfT1LKW3VrQW086TH2eGilLr3bNBBmtIeDXYC5+5WO28E7uS4+f+b
6yyhJL1GRZm44NLA0xlo+QPZf4Wa+aflyeCpNetS++Fn4L1/ilXz5Mleqg0U8+Ys
tfttI4p204NENSAygL+qI3F0A9zx4idSJrHXgl6VLl/kkGHrUmAOf5sxrgYa6dDs
TFmXR9f1dH6NHVvqRZ2dUTNOfucWpyBZ32y+li2iKOvq/Fioa9oQlsOIG2+Cf5Pq
HzgOqfuxKGqRbPe/+7S0Uq1C+iXFig==
=S2uZ
-----END PGP SIGNATURE-----

--qgxCz6UQnfGfz0wo--
