Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACA83C25
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 11:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28616C433D2;
	Tue, 13 Jun 2023 11:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686654228;
	bh=YnMdriFhR0QLK6Wr4HwnKvTCrkhUnKOohsa4d+Pwns0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/V9x4jC59Qd+RqLIO8G2UUptpHxW8R5iFT6MSVK70D67DxzPh1JhxUconq49vHWl
	 MIkv2exk+6ufOtQGL5RgOyYZJlB1EIfEuE9XwXS+kAUBaGF9p5vaB7AurBHQbrCGnc
	 +Vkn/hluGl0m8pz5e4TgIZG6LWIUn9hxJc9+16nOThe+soeTbGDsD5+q3cG5H60Q3T
	 9aaDA1c4xlZlvnTN6AKQj3yoVvHgo8DEF49RXPSRksvmGrnJEuUAtENDDTrGHszyrd
	 PetyCgrhcJm2WjQO6tvFIiSjHNQLPs7T6i0keK2kTcWHUNB8uj5OYz3J25+fy1iPFs
	 V05vfkMA0iODw==
Date: Tue, 13 Jun 2023 12:03:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 12/14] arm64/sysreg: Convert TRBMAR_EL1 register to
 automatic generation
Message-ID: <7d84c1be-db01-4890-b90d-78d600382cb0@sirena.org.uk>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <20230602062552.565992-13-anshuman.khandual@arm.com>
 <8a352dec-9655-4e7c-ba35-1c48e154bc71@sirena.org.uk>
 <4fec9cf7-b4b6-c5c1-7db5-493240c54ef1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+1MUGCqGsULEzIf5"
Content-Disposition: inline
In-Reply-To: <4fec9cf7-b4b6-c5c1-7db5-493240c54ef1@arm.com>
X-Cookie: Made with real ingredients.


--+1MUGCqGsULEzIf5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 13, 2023 at 09:31:13AM +0530, Anshuman Khandual wrote:

> +Enum   11:10   PAS
> +       0b00    SECURE
> +       0b01    NON_SECURE
> +       0b10    ROOT
> +       0b11    REALM
> +EndEnum
> +Enum   9:8     SH
> +       0b00    NON_SHAREABLE
> +       0b10    OUTER_SHAREABLE
> +       0b11    INNER_SHAREABLE
> +EndEnum

Sure.

--+1MUGCqGsULEzIf5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSITQ4ACgkQJNaLcl1U
h9B6mQf7BQTf1ld8cXz4BGi4QoEeyPp0ksRvEy5L2e2x5oIfcJvFbn7wRGZnpwQb
8c92AfbnTa7p1CjaT8D4u99W+8rizPIuugKYuHQZ8Ugb3oFtPeT/xYrtc9AOAnxO
uTO/4MPmr0ZeBa1+NX8fQllPStpKviXqlx22PFZM7jf/cY3WIipoG52Zp2ygChTY
8j/JSqpMfJQAmzil31nOQTfikpBFOFd+7EBaEsL0/Athi0Veq16ve9PtQLeMWxvq
GtE/P4JsF/69PkIP3wY21sY+/3/LCHw9axPrpFf56wjM8r7my349U4zkf/FnXtRy
kvlmdVw929GCFRiIsdKU33TL/a+ufw==
=1AW3
-----END PGP SIGNATURE-----

--+1MUGCqGsULEzIf5--
