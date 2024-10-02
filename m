Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55701D0DCE;
	Wed,  2 Oct 2024 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884094; cv=none; b=b0JqH4W7ZwGZIjqEWvq7lyaAcMgE6S8b+ea186mNxsSQa4jq9/tZ+cRFs6kqxshPeOtWHQ86Snx8bX9tgyGle16VfiqvmbD5UVAIPv8sPQiiIv4a5vqil1RVSDgG67d48CwbqGuV8baCrjreBQrxBt1Yc8QNyRg97tLZORodH4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884094; c=relaxed/simple;
	bh=7rm0ZZErstTrH9Wflc5dul45MSRZ2U+r7DuzXiQtUTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqoPUcLLxbd6N40Y4RobqmBJyY7bynfWm6ehemzqR3XBVhKX+KjCHTWqbpXOZ3f8UsjDjF/+oO2LP2PlqD1vEcRoirF9ASQOcdi5KWHFiDBm8+j/FrtQ7n8NFvyLQc3B0EBtSgp1clfGHQZnSqXqUAdAg5WdGdYbspA8U88YAFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZzkrSy/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzkrSy/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2D6C4CECD;
	Wed,  2 Oct 2024 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727884094;
	bh=7rm0ZZErstTrH9Wflc5dul45MSRZ2U+r7DuzXiQtUTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZzkrSy/rOb4YltVk2/zkKuzBsKE2Rp0mGCChlVPnQsMg7+c0wP7zmJqjozYHo1dzh
	 0XhvR0VbDBk078IXgTS6kj4oeHDiAFcn129DT1LGUvvBsj9V6OxSQ+G0b1YJlAFtlj
	 pDNJB7MEAWmHFeqphUCyl3qKt3Y+j0CTN2K+2ipk2vTGFwUSBvukZzLMFTe6mhxr6p
	 IcmiZ982nrmL3jrvLLlLo6pB1pani4fr40u1HlTXomxQt+/z5J3zbdxe6uaY/paItv
	 rRrqQm+ns7DkZ3Dheu9VWWn6KTNnE3RT5WyPPeJMDx6JxQ3N56hoPpkGoKW4ZaIbH7
	 XmXBJey1NA/4w==
Date: Wed, 2 Oct 2024 16:48:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 04/47] arm64/sysreg: Add register fields for
 ID_AA64DFR2_EL1
Message-ID: <fe8a2d61-4aeb-4f56-b0d0-90bbfe512c74@sirena.org.uk>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <20241001024356.1096072-5-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gG2tVfVCySMVqyPE"
Content-Disposition: inline
In-Reply-To: <20241001024356.1096072-5-anshuman.khandual@arm.com>
X-Cookie: Know Thy User.


--gG2tVfVCySMVqyPE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2024 at 08:13:13AM +0530, Anshuman Khandual wrote:

> This adds register fields for ID_AA64DFR2_EL1 as per the definitions based
> on DDI0601 2024-06.

DDI0601 2024-09 has now been released...

> +Sysreg	ID_AA64DFR2_EL1	3	0	0	5	2
> +Res0	63:8
> +UnsignedEnum	7:4	BWE
> +	0b0000	NI
> +	0b0001	IMP
> +	0b0010	IMP_WPT

Could equally name that BWE2 since this is for FEAT_BWE2.  I'm OK either
way I think, with a slight preference for BWE2 I think.  Either way:

Reviewed-by: Mark Brown <broonie@kernel.org>

--gG2tVfVCySMVqyPE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb9azcACgkQJNaLcl1U
h9CA5gf/VjvdDGZBLGVqW/uJTCSnns5G7gTG+7EMnA7jOH8QIOqeVy2MFCKL6aDj
AFcJEcIXHbNmEkQkL9BeeeV15DkOutIMpeNZw886SyHpznhadi5QPzRmcMimOmJM
E+zkpSWskoQyDSDVPqhlxD6viOyifeCqPF0HWhs7Ufs7uZz7VlZcWFXa1IXgVCGN
TUBWBzVjCdkyv47ipsdfLR4Oaf3RQp4AY/4w2Szd/h9u4fnfkDIXBlYmADojalJD
6Q3ZB8ot+r+VKLu/hOnsfsGUcDP/TJBonBVHSyWZXUAvkngafy1EhHFGe0vj5h+X
jUIwV6D/5zXaNx34TG87BZFVhKVvUQ==
=9u3o
-----END PGP SIGNATURE-----

--gG2tVfVCySMVqyPE--
