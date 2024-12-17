Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD923DE;
	Tue, 17 Dec 2024 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734449528; cv=none; b=Ruq+dTktSrPXJDwhRF+ZncgpZTaXyY01bku3IFeIN9ZzKEgngrOrFW17mgavEtN44q5MLwVqpPonxxlQM5/ftavGfyEEQRKom8YEPcy5fRDZz+kuREIJL+Fwhm7qzlQTmnfIoAotZtSXAjpQmbv6qcK5gZlaGmffsxQUwPGgDMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734449528; c=relaxed/simple;
	bh=VNdS8C7T+jc6Z+1WXA06O4uZglTbKaiGuklo+JyL5uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1q576Ahoa6+QluCVfhI7QD3owieYNJrJ0DatxV1LYmKw0HPKNaJ34SfDx0hV0l3/v/T8FqrNnIJGDsK+0G5WNpc0u2wDK2ofTqYhoRe2Iwv05WQz8svD27ydFn2cj0QYawlaIjfwZpNWMU+JlILlN+mvND3VNz2YwlvtdkZNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTFUHCE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTFUHCE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44013C4CED3;
	Tue, 17 Dec 2024 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734449527;
	bh=VNdS8C7T+jc6Z+1WXA06O4uZglTbKaiGuklo+JyL5uE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gTFUHCE00yur8UAgdzHnNcwi/0X9XdKxFt0CHqCDLlGsCUng1eFvyOunlxGAlCQ+A
	 NqA7RB5N7CnRA7Xu/QQk/PnexrM+HWhdogWRI1lJw5bW/qZ82Dsu1FTjbLCwRb7ywx
	 3iQWpCHD6vBoXcrL4gfLmQ3+lhmtlvlx8x6MNTBDTy3OEiumGsN48mrLL4PhhTgk+9
	 mrKZNK0bGKGn+nBN0EYqOwHkVF8iZ3HmtckIijEee3rkL7LdbCcHyGvLdjsJa9+bRd
	 l7PkxUXwHK7NQDg59GlClsKFcHjpzs3TlHJn8rGowBvq3ZhoxSLfIr+St0qwtvEBD+
	 /AX+ZifMZoC5A==
Date: Tue, 17 Dec 2024 15:32:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, ryan.roberts@arm.com,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
Message-ID: <88f15900-03d2-49f0-bc44-7ded076d9a42@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-19-anshuman.khandual@arm.com>
 <20241216231505.GA601635-robh@kernel.org>
 <0b8a055f-eab9-4b44-baac-ad25756dbbfd@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Yu3fCeulO66Lix3+"
Content-Disposition: inline
In-Reply-To: <0b8a055f-eab9-4b44-baac-ad25756dbbfd@arm.com>
X-Cookie: The sum of the Universe is zero.


--Yu3fCeulO66Lix3+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 10:03:10AM +0530, Anshuman Khandual wrote:

> I am wondering how this did not cause any re-definition warning ?

If the redefinition is identical to the one that was already there then
the compiler will usually not warn.

--Yu3fCeulO66Lix3+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdhmXEACgkQJNaLcl1U
h9A0MAf/QvtVkjC9zldXDgdlYsDu0STRvGbwDmC7CqmD860xMuOC+z7Gm0jDpIpV
Zg9WpeVaK51NOo7hzNkN3v00mH2sIZI5+S5h+uPERrS7nxOQO1PhQNBlERxzM93m
5umg9GSVRm++4ginwxk6BrD70VeNTXXGSMoeVpG/JodFCd1E5vqm+pK2sVM+40HG
+W0vMnWTDgot0LTwo2382Zq/9Rc+O9zYdgAe0qmB6ZDB0Dw3fZVdD9mHmBGk0TVr
0X5xc1/NBR4KaP/dRO2sDI4REicFM9gqT5CB/79gNnp0Hm2nXK9B+gIA2DLCR95J
eGIKCA31D2t52hR1hdN0ghEa7ckxYg==
=nc2H
-----END PGP SIGNATURE-----

--Yu3fCeulO66Lix3+--
