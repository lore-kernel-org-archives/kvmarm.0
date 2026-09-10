Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D7847DD63;
	Thu, 10 Sep 2026 11:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041305; cv=none; b=WQ2xjJ7gSjC70d/NFs3HBYJINEsjZ9Eh2ZOo9tB/1b53Jyo11c7M8iMvul6IWSUQXi+pwCrJAuAX44oQslXbdplYRdpyHlFx1Er/hoKzDPLoicW3l6ogJoRtZUpRDqykgMI8ck174TMsUgKxBn1GktU7GPPj5dRqlfdWWwOOnpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041305; c=relaxed/simple;
	bh=+ZqHmy06NA420lWJ/kGBbAb4WZXxTgfB7KLb3uy3Re0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHMP5EChCE6kofHodrX+dvRdMbQrf+I9HpD93U15UBS+xhJLsywOvfovDz5b6/NF3m59acH0pUvZRhcopAOXWcM3fCKkbJwV2ZveiyaA26qVYz1DqfjtOFzE80dyssKDiq4fhiFZC01Qx/4Lc8xbVpdHWrFNGKHYVC7rJidTxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6eNZ+sX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6eNZ+sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301CC1F000FF;
	Thu, 10 Sep 2026 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041303;
	bh=DsIKaXsbd3oQK51GUuuShGYl+ZCD6Zk6ICZGAE3/Axc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h6eNZ+sXw4AWxpLP3I4e+pMa5MNo4FUv4VC0feJItgCsK126jpBMVC8weELoNkxTF
	 zQxWJHQzRu0pJwXOStLezi7jxyaWzHEQS/I1dPRQpClnXukfBc4Oc5sM06LYwZOE9o
	 CLLLwFY11oZY3ww6MdO6/P9nDC73ki677zjqW4upfgcAQ9WXkm765BVaborzOKLK3v
	 6/LsVfSoQ2aSa1dYT9B0fGXkBnf06J7900Rm9CCnOhFLhZhEAKDG1qNDmhtNcB8vui
	 YhW4K7YjtuUvT686IpXcuSFllFZRFDmhLiV4aDP7V/0xf+dW/Lhh0Y+N8NgLHDsT5g
	 mToSmHbES1Z+Q==
Date: Thu, 10 Sep 2026 12:54:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v1 2/3] arm64: sysreg: Add TCR_EL2 to sysreg
 infrastructure
Message-ID: <01b5d61c-6a73-44a8-9ce0-8d42c4c193c1@sirena.org.uk>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
 <20260909222015.3046432-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Wmlp6y25lOXpLuhH"
Content-Disposition: inline
In-Reply-To: <20260909222015.3046432-3-weilin.chang@arm.com>
X-Cookie: Gravity brings me down.


--Wmlp6y25lOXpLuhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2026 at 11:20:14PM +0100, Wei-Lin Chang wrote:

> Convert TCR_EL2 to the sysreg infrastructure with data extracted from
> Registers.json of the BSD licenced AARCHMRS
> (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

Checks out against DDI0601 2026-06.

> +Enum	13:12	SH0
> +	0b00	NONE
> +	0b10	OUTER
> +	0b11	INNER
> +EndEnum

Could do NS, OS, IS but that's bikeshedding.  Either way:

Reviewed-by: Mark Brown <broonie@kernel.org>

--Wmlp6y25lOXpLuhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqimpAACgkQJNaLcl1U
h9Bt2gf9FCYK8yras4jKlP43pB+Zz0Gc3a2rukrzjFvszpCCCjYRFWmOl2K20HE6
bRdz1EUVYc16pxo1iZVXDlXnnimRCV/Db0GD1K6N+cMOXhIQpYBp39MHN0adDoJM
rB132cjtaeO4sTWSI8819q6+salvcjSlXhvbl5/TNj0cY3DDfBwHhAOaSFAGYvLW
jSO4bT1Q1yGiczf2Vvt1Li1oPb/77YNDlqAS1ZIv0Tf/801d3NlpKcqUKap0Oe5g
pOiEyKo40Ccyn91u4tjL+oON95n2FE/E4eYMaVmbmEoJhwTyOs4kqV5tAh61Y5Z2
fYrVWaxzsMHx8NKfJIXyyF0koWk73g==
=iUKZ
-----END PGP SIGNATURE-----

--Wmlp6y25lOXpLuhH--
