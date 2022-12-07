Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EF2102
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 14:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA4DC433C1;
	Wed,  7 Dec 2022 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670423971;
	bh=E78vMHkoSMPFasx1z53USjf8IRKFRvnUdO10OQzVHXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgyqDidEeumrQy9041IYjVOrs0DiRfIEvnsvrlRCGd/VSoGVVSlqBKfVu9dNXvasT
	 U7OL5qlqs5z59x6zl1KTswd6drldPWp7uaUm/L66+tzxv04cgdJwyiSkCbt8ueJc7v
	 PBpcfSv9G4WpQiJByihskAm+2VPOuPPKHdr08G8hUlo7oPhnEZjDvenQXOudYBnjY7
	 hW+dAi27qW4vZinblQVztHEAq0ocZXro9gPrF0+Z1aDwGcAPk+KPZghLaO+sOb6+dk
	 psxQ01hxF+vjTf82gRhQvmhkn6Sa7hC95gk/3wzGiMmadLWVSdSlm17kowOcO9c9Y5
	 Esg84esXH8NVA==
Date: Wed, 7 Dec 2022 14:39:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 1/3] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
Message-ID: <Y5ClnlHz5Spp0rUy@sirena.org.uk>
References: <20221206131144.115774-1-broonie@kernel.org>
 <20221206131144.115774-2-broonie@kernel.org>
 <86fsdrlaz5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9xMNqXO+4emnkAAw"
Content-Disposition: inline
In-Reply-To: <86fsdrlaz5.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--9xMNqXO+4emnkAAw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 11:17:02AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +Sysreg	ICC_NMIAR1_EL1	3	0	12	9	5
> > +Res0	63:24
> > +Field	23:0	INTID
> > +EndSysreg

> This patch should stay with the GIC patch adding NMIs, really.

Given the textual conflict with the ISR patch and the fact that the NMI
series needs both anyway it seemed more productive to just carry them
both in the cleanup series even if this one isn't immediately used.

--9xMNqXO+4emnkAAw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQpZ4ACgkQJNaLcl1U
h9DDuAf9EEIXMGqZXicvJIh93OO5SRcO2cOYjIezma0HnXRLJav8HadyNn9t5kPj
KL73pmjirtZNzsku6BwhqerDdAA4jTQ+eOl+gxPw1jP69lrTCqyWelXzPQQgj9vm
BIwHn2ihg+5OuN5GVJtR5p6R1wIN2yjX+YhG2l4RcChVASUm75hFs6JodZmmyhnX
nmplF2p8yApPaLPrJBWtT1diznBPOeHLC7CTEnwWahyLPOuutVShcoQVbP0CGBs3
xPheJbGqC9kH32lpEvGswjh0Lb7kNickQH9740FydXGEvzVazWOB3lqFTkj4AQ1J
nU43ARB+5/D31iX0Yg4PdexFqiAXvg==
=CrT1
-----END PGP SIGNATURE-----

--9xMNqXO+4emnkAAw--
